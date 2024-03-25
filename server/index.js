const express = require("express");
const socketio = require("socket.io");
const config = require("./config");
const cors = require("cors");
const bodyParser = require("body-parser");
const fs = require("fs");
const app = express(); 
const axios = require("axios");
const server = app.listen(config.httpPort, function (err, result) {
    console.log('running in port http://localhost:' + config.httpPort);
});


const io = socketio(server); 

app.use(cors({ origin: "*" }));
app.use(express.json({ limit: "250mb" }));
app.use(bodyParser.urlencoded({ extended: true }));

fs.readdirSync("routes").forEach(function (file) {
    if (file[0] === ".") return;
    const routeName = file.split('.')[0];
    require("./routes/" + routeName)(app);
});

io.on('connection', client => {
    console.log('user connected');

    client.on('disconnect', () => {
        console.log('user disconnected');
    });

    client.on('chat:message', function (message) {
        console.log('Received message:', message);
        io.sockets.emit('new-message', message);
    });
});

