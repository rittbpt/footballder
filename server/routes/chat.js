const controller = require('../controller/chat')

module.exports = function (app) {
    app.post("/chat/save", controller.insertchat);
    app.get("/chat/getchat/:chatId", controller.getchat);
    app.get("/chat/readchat", controller.readchat);
}
