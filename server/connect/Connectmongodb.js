const { MongoClient, ServerApiVersion } = require('mongodb');

const uri = "mongodb+srv://ritnutdanai:cd9ivlG7okWOrTdf@footballder.imc8lg1.mongodb.net/?retryWrites=true&w=majority&appName=footballder";

const client = new MongoClient(uri, {
    serverApi: {
        version: ServerApiVersion.v1,
        strict: true,
        deprecationErrors: true,
    }
});

async function findData(chatId) {
    try {
        await client.connect();

        await client.connect();
        const database = client.db('footballder');
        const collection = database.collection('chat');

        const result = await collection.find({ chatId: parseInt(chatId) }).toArray();

        return result;
    } finally {
        await client.close();
        console.log("Disconnected from the database");
    }
}

async function insert(data) {
    try {
        await client.connect();
        const database = client.db('footballder');
        const collection = database.collection('chat');
        await collection.insertOne(data)
    } finally {
        await client.close();
        console.log("Disconnected from the database");
    }
}


module.exports = { findData, insert };
