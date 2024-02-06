const Location = require("../controller/Location");
const { Checktoken } = require("../Middleware/checkToken");

module.exports = function (app) {
    app.get("/getAlllocation", Checktoken, Location.getall);
}
