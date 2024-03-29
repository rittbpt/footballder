const { MongoClient, ServerApiVersion } = require('mongodb');
const dateHelper = require('../helper/date');
const uri = "mongodb+srv://ritnutdanai:cd9ivlG7okWOrTdf@footballder.imc8lg1.mongodb.net/?retryWrites=true&w=majority&appName=footballder";

const client = new MongoClient(uri, {
    serverApi: {
        version: ServerApiVersion.v1,
        strict: true,
        deprecationErrors: true,
    }
});

let cachedData = {}; 

let database;
let chatCollection;

client.connect().then(() => {
    console.log("Connected successfully to MongoDB server");
    database = client.db('footballder');
    chatCollection = database.collection('chat');
}).catch(err => {
    console.error("Error connecting to MongoDB server:", err);
});

async function findData(chatId) {
    try {
        if (cachedData[chatId]) { 
            console.log("Retrieving data from cache");
            return cachedData[chatId]; 
        } else {
            console.log("Retrieving data from database");
            const result = await chatCollection.find({ chatId: parseInt(chatId) }).toArray();
            cachedData[chatId] = result; 
            return result;
        }
    } catch (error) {
        console.error(error);
        throw error;
    }
}

async function insert(data) {
    try {
        data.time = await dateHelper.DateNow();
        await chatCollection.insertOne(data);
        cachedData = {};
    } catch (error) {
        console.error(error);
        throw error;
    }
}

module.exports = { findData, insert };
