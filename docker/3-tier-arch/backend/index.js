const express = require("express");
const cors = require("cors");
const { MongoClient } = require("mongodb");

const app = express();
const port = 5000;

// read from docker-compose environment
const mongoUrl =
  process.env.MONGO_URL || "mongodb://localhost:27017/messagesdb";

app.use(cors());
app.use(express.json());

let messagesCollection;

// connect to MongoDB and then start server
MongoClient.connect(mongoUrl)
  .then((client) => {
    const db = client.db(); // default DB in URL
    messagesCollection = db.collection("messages");
    console.log("Connected to MongoDB");

    app.listen(port, () => {
      console.log(`Backend API listening on port ${port}`);
    });
  })
  .catch((err) => {
    console.error("Failed to connect to MongoDB:", err);
    process.exit(1);
  });

// GET /api/messages -> list all messages
app.get("/api/messages", async (req, res) => {
  try {
    const msgs = await messagesCollection.find({}).sort({ _id: -1 }).toArray();
    res.json(msgs);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Unable to fetch messages" });
  }
});

// POST /api/messages -> add new message
app.post("/api/messages", async (req, res) => {
  const { author, text } = req.body;

  if (!author || !text) {
    return res.status(400).json({ error: "author and text are required" });
  }

  try {
    const doc = { author, text, createdAt: new Date() };
    const result = await messagesCollection.insertOne(doc);
    res.status(201).json({ _id: result.insertedId, ...doc });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Unable to save message" });
  }
});
