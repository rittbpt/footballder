const controller = require('../controller/Chatroom')

module.exports = function (app) {
    app.post("/InsertChatroom", controller.insertChatroom);
    app.post("/InsertPrivateChatroom", controller.InsertPrivateChatroom);
    app.get("/joinchat", controller.joinchat);
    app.get("/chats/:userId", controller.chats);
    app.get("/readchat", controller.readchat);
}
