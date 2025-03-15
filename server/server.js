// Required dependencies
const express = require("express");
const cors = require("cors");
const { MongoClient, ObjectId } = require("mongodb");
const admin = require("firebase-admin");
const dotenv = require("dotenv");

// Load environment variables
dotenv.config();

// Decode Base64 to JSON
const serviceAccount = JSON.parse(
  Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64, "base64").toString(
    "utf-8"
  )
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// MongoDB connection
const mongoUri = process.env.MONGO_URI;
const dbName = process.env.DB_NAME;

// Create Express app
const app = express();
app.use(cors());
app.use(express.json());

// MongoDB client
let db;

// Connect to MongoDB
async function connectToMongo() {
  try {
    const client = new MongoClient(mongoUri);
    await client.connect();
    console.log("Connected to MongoDB");
    db = client.db(dbName);
  } catch (error) {
    console.error("MongoDB connection error:", error);
    process.exit(1);
  }
}

// Firebase token verification middleware
const verifyFirebaseToken = async (req, res, next) => {
  const token = req.headers.authorization;

  if (!token) {
    return res.status(401).json({ error: "No token provided" });
  }

  try {
    // Remove 'Bearer ' prefix if present
    const tokenValue = token.startsWith("Bearer ")
      ? token.split("Bearer ")[1]
      : token;

    // Verify the token
    const decodedToken = await admin.auth().verifyIdToken(tokenValue);

    // Add user info to request
    req.user = {
      uid: decodedToken.uid,
      email: decodedToken.email || "",
      name: decodedToken.name || "",
    };

    next();
  } catch (error) {
    console.error("Token verification error:", error);
    return res.status(401).json({ error: "Invalid token" });
  }
};

// API Routes

// Get all bundles
app.get("/api/bundles", verifyFirebaseToken, async (req, res) => {
  try {
    const bundles = await db.collection("bundles").find().toArray();

    // Convert ObjectIds to strings
    bundles.forEach((bundle) => {
      bundle._id = bundle._id.toString();
      if (bundle.tests) {
        bundle.tests.forEach((test) => {
          test.test_id = test.test_id.toString();
          if (test.questions) {
            test.questions.forEach((question) => {
              question.question_id = question.question_id.toString();
            });
          }
        });
      }
    });

    res.json(bundles);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Submit test
app.post("/api/submit-test", verifyFirebaseToken, async (req, res) => {
  try {
    const userData = req.user;
    const testData = req.body;

    // Save the submission
    const submission = {
      user_id: userData.uid,
      email: userData.email,
      test_id: new ObjectId(testData.test_id),
      answers: testData.answers,
      submitted_at: new Date(),
    };

    const result = await db.collection("submissions").insertOne(submission);

    res.json({
      message: "Test submitted successfully",
      submission_id: result.insertedId.toString(),
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user tests
app.get("/api/user-tests", verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const submissions = await db
      .collection("submissions")
      .find({ user_id: userId })
      .toArray();

    // Convert ObjectIds to strings
    submissions.forEach((submission) => {
      submission._id = submission._id.toString();
      submission.test_id = submission.test_id.toString();
    });

    res.json(submissions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Check if customer exists
app.get("/api/customer-exists", verifyFirebaseToken, async (req, res) => {
  try {
    const email = req.user.email;
    console.log(email);

    const user = await db.collection("customers").findOne({ email });
    console.log(Boolean(user));

    res.json({ exists: Boolean(user) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create customer
app.post("/api/create-customer", verifyFirebaseToken, async (req, res) => {
  try {
    const email = req.user.email;
    const phoneNumber = req.body.phone || "";
    const name = req.body.name || "";

    const existingUser = await db.collection("customers").findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: "Customer already exists" });
    }

    const customer = {
      email,
      phone: phoneNumber,
      name,
      created_at: new Date(),
    };

    const result = await db.collection("customers").insertOne(customer);
    res.status(200).json({
      message: "Customer created successfully",
      customer_id: result.insertedId.toString(),
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get customer phone
app.get("/api/get-customer-phone", verifyFirebaseToken, async (req, res) => {
  try {
    const email = req.user.email;
    const customer = await db.collection("customers").findOne({ email });

    if (!customer) {
      return res.status(404).json({ error: "Customer not found" });
    }

    res.json({ phone: customer.phone_number || "" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Helper function for purchases count
const getPurchases = (customer) => {
  try {
    const purchases = customer.purchased_bundles || [];
    return purchases.length.toString();
  } catch (error) {
    return "0";
  }
};

// Get customer analytics
app.get("/admin/customer-analytics", async (req, res) => {
  try {
    const customers = await db.collection("customers").find().toArray();
    const results = customers.map((customer) => ({
      name: customer.name,
      email: customer.email,
      phone: customer.phone,
      purchases: getPurchases(customer),
    }));

    res.json(results);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get bundle analytics
app.get("/admin/bundle-analytics", async (req, res) => {
  try {
    const bundles = await db.collection("bundles").find().toArray();
    const results = [];

    for (const bundle of bundles) {
      const salesCount = await db.collection("customers").countDocuments({
        "purchased_bundles.bundle_id": bundle._id,
      });

      results.push({
        name: bundle.name,
        price: bundle.price,
        sales: salesCount.toString(),
      });
    }

    console.log(results);
    res.json(results);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Helper function for sales count
const getSalesCount = async (bundle) => {
  try {
    const salesCount = await db.collection("customers").countDocuments({
      "purchased_bundles.bundle_id": bundle._id,
    });
    return salesCount;
  } catch (error) {
    return 0;
  }
};

// Get dashboard info
app.get("/admin/dashboard-info", async (req, res) => {
  try {
    let totalRevenue = 0;
    let totalBundlesSold = 0;

    const totalCustomers = await db.collection("customers").countDocuments({});
    const activeBundles = await db
      .collection("bundles")
      .countDocuments({ active: true });
    const bundles = await db.collection("bundles").find().toArray();

    for (const bundle of bundles) {
      const salesCount = await getSalesCount(bundle);
      totalBundlesSold += salesCount;
      totalRevenue += salesCount * bundle.price;
    }

    res.json([
      { title: "Total Revenue", value: totalRevenue.toString() },
      { title: "Total Bundles Sold", value: totalBundlesSold.toString() },
      { title: "Total Customers", value: totalCustomers.toString() },
      { title: "Active Bundles", value: activeBundles.toString() },
    ]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all bundle info
app.get("/admin/all-bundle-info", async (req, res) => {
  try {
    const bundles = await db.collection("bundles").find().toArray();
    const results = [];

    for (const bundle of bundles) {
      const salesCount = await db.collection("customers").countDocuments({
        "purchased_bundles.bundle_id": bundle._id,
      });

      results.push({
        _id: bundle._id.toString(),
        name: bundle.name,
        price: bundle.price,
        testsCount: (bundle.tests || []).length.toString(),
        description: bundle.description,
      });
    }

    res.json(results);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Helper function for test questions
const getTestQuestions = (test) => {
  try {
    return (test.questions || []).length.toString();
  } catch (error) {
    return "0";
  }
};

// Create bundle
app.post("/admin/create-bundle", async (req, res) => {
  try {
    const data = req.body;

    if (
      !["name", "price", "description", "active"].every((key) => key in data)
    ) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const bundleId = new ObjectId();
    const bundle = {
      _id: bundleId,
      name: data.name,
      price: parseFloat(data.price),
      description: data.description,
      tests: [],
      created_at: new Date(),
      active: data.active,
    };

    const result = await db.collection("bundles").insertOne(bundle);
    res.status(201).json({ _id: bundleId.toString() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get bundle details
app.get("/admin/fetch-bundle-details/:id", async (req, res) => {
  try {
    const bundle = await db
      .collection("bundles")
      .findOne({ _id: new ObjectId(req.params.id) });

    if (!bundle) {
      return res.status(404).json({ error: "Bundle not found" });
    }

    res.json({
      _id: bundle._id.toString(),
      name: bundle.name,
      price: bundle.price,
      description: bundle.description,
      active: bundle.active,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update bundle details
app.put("/admin/update-bundle-details/:id", async (req, res) => {
  try {
    const data = req.body;

    if (
      !["name", "price", "description", "active"].every((key) => key in data)
    ) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const bundle = {
      name: data.name,
      price: parseInt(data.price),
      description: data.description,
      active: data.active,
    };

    await db
      .collection("bundles")
      .updateOne({ _id: new ObjectId(req.params.id) }, { $set: bundle });

    res.json({ message: "Bundle updated successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete bundle
app.delete("/admin/delete-bundle/:id", async (req, res) => {
  try {
    await db
      .collection("bundles")
      .deleteOne({ _id: new ObjectId(req.params.id) });
    res.json({ message: "Bundle deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all tests in a bundle
app.get("/admin/all-tests/:id", async (req, res) => {
  try {
    const bundle = await db
      .collection("bundles")
      .findOne({ _id: new ObjectId(req.params.id) });

    if (!bundle || !bundle.tests) {
      return res.json([]);
    }

    const results = bundle.tests.map((test) => ({
      test_id: test.test_id.toString(),
      name: test.test_name,
      questions: getTestQuestions(test),
    }));

    res.json(results);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get test details
app.get("/admin/fetch-test/:id/:test_id", async (req, res) => {
  try {
    const bundle = await db
      .collection("bundles")
      .findOne({ _id: new ObjectId(req.params.id) });

    if (!bundle) {
      return res.status(404).json({ error: "Bundle not found" });
    }

    let testFound = false;
    for (const test of bundle.tests || []) {
      console.log("test_id:", test.test_id);

      if (test.test_id.toString() === req.params.test_id) {
        testFound = true;
        return res.json({
          test_id: test.test_id.toString(),
          name: test.test_name,
          questions: (test.questions || []).map((question) => ({
            question_id: question.question_id.toString(),
            question_text: question.question_text,
            options: question.options,
            correct_answer: question.correct_answer,
            solution: question.solution || "",
          })),
        });
      }
    }

    if (!testFound) {
      return res.status(404).json({ error: "Test not found" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add test to bundle
app.post("/admin/add-test/:id", async (req, res) => {
  try {
    const data = req.body;

    if (!["test_name", "questions"].every((key) => key in data)) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const testId = new ObjectId();
    const test = {
      test_id: testId,
      test_name: data.test_name,
      questions: [],
    };

    await db
      .collection("bundles")
      .updateOne(
        { _id: new ObjectId(req.params.id) },
        { $push: { tests: test } }
      );

    res.status(201).json({
      message: "Test added successfully",
      test_id: testId.toString(),
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add question to test
app.post("/admin/add-question/:id/:test_id", async (req, res) => {
  try {
    const data = req.body;

    if (
      !["question_text", "options", "correct_answer"].every(
        (key) => key in data
      )
    ) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const questionData = {
      question_id: new ObjectId(),
      question_text: data.question_text,
      options: data.options,
      correct_answer: data.correct_answer[0],
      solution: data.solution,
    };

    await db.collection("bundles").updateOne(
      {
        _id: new ObjectId(req.params.id),
        "tests.test_id": new ObjectId(req.params.test_id),
      },
      { $push: { "tests.$.questions": questionData } }
    );

    res.status(201).json({ message: "Question added successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update question
app.put(
  "/admin/update-question/:id/:test_id/:question_id",
  async (req, res) => {
    try {
      const data = req.body;

      if (
        !["question_text", "options", "correct_answer"].every(
          (key) => key in data
        )
      ) {
        return res.status(400).json({ error: "Missing required fields" });
      }

      const questionData = {
        question_id: new ObjectId(req.params.question_id),
        question_text: data.question_text,
        options: data.options,
        correct_answer: data.correct_answer[0],
        solution: data.solution,
      };

      await db.collection("bundles").updateOne(
        { _id: new ObjectId(req.params.id) },
        {
          $set: {
            "tests.$[testElem].questions.$[questionElem]": questionData,
          },
        },
        {
          arrayFilters: [
            { "testElem.test_id": new ObjectId(req.params.test_id) },
            {
              "questionElem.question_id": new ObjectId(req.params.question_id),
            },
          ],
        }
      );

      res.json({ message: "Question updated successfully" });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

// Start server
const PORT = process.env.PORT;

async function startServer() {
  await connectToMongo();

  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

startServer().catch((error) => {
  console.error("Failed to start server:", error);
  process.exit(1);
});
