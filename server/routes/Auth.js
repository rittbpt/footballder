const Auth = require("../controller/Auth")

module.exports = function (app) {
    app.post("/Register", Auth.Register);
    app.post("/Login", Auth.Login);

}