const controller = require("../controller/friend")

module.exports = function (app) {
    app.get("/friends/:userId", controller.getfriends);
    app.post("/addfriend/", controller.insert);
    app.post("/removefriend", controller.remove);


}