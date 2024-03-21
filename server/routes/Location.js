const Location = require("../controller/Location");
const { Checktoken } = require("../Middleware/checkToken");

module.exports = function (app) {
    app.get("/getlocation", Checktoken, Location.getlocation);
    app.get("/getnextpagelocation/:token", Checktoken, Location.getnextpagelocation);
    app.get("/getlocationdetail/:placeId", Checktoken, Location.getlocationdetail);
}
