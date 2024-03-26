const Match = require("../controller/Match");
const { Checktoken } = require("../Middleware/checkToken");

module.exports = function (app) {
    app.get("/getallmatch/:userId", Checktoken, Match.getall);
    app.post("/insertmatch", Checktoken, Match.insert);
    app.get("/getmatchdone/:userId", Checktoken, Match.getmatchdone);


    
}
