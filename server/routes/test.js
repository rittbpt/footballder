const Test = require("../controller/test");
const { Checktoken } = require("../Middleware/checkToken");

module.exports = function (app) {
    app.get("/Test", Checktoken, Test.Test);
}
