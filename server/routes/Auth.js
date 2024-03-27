const Auth = require("../controller/Auth")

module.exports = function (app) {
    app.post("/Register", Auth.Register);
    app.post("/Login", Auth.Login);
    app.post("/Linelogin" , Auth.Linelogin)
    app.post("/changepassword" , Auth.changepassword)
    app.post("/sendotp" , Auth.sendotp)
}