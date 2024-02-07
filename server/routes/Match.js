const Match = require("../controller/Match");
const { Checktoken } = require("../Middleware/checkToken");

module.exports = function (app) {
    app.post("/getallmatch", Checktoken, Match.getall);
    app.post("/insertmatch", Checktoken, Match.insert);
}
