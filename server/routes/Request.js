const Request = require('../controller/Request')
const { Checktoken } = require("../Middleware/checkToken");

module.exports = function (app) {
    app.get("/getAllrequest", Checktoken, Request.getall);
    app.get("/getrequestbyId/:userId", Checktoken, Request.getbyId);
    app.post("/insertrequest", Checktoken, Request.insert);
    app.get("/getRecent/:userId" , Checktoken , Request.getRecent);
    app.post("/updateRqstatus" , Checktoken , Request.updateRqstatus);
    app.post("/resava" , Checktoken , Request.updateRqstatus);
    app.post("/checkin" , Checktoken , Request.checkin);
}