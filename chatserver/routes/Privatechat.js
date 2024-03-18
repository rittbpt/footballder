const chatController = require("../controller/Privatechat")

module.exports = function (app) {
    app.get("/InsertChat", chatController.insertChat);
}
