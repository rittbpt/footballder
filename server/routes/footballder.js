const api = require("../controller/connectMysql")

module.exports = function (app) {
    app.get("/footballder/test", async function (req, res) {
        try {
            const user = await api("SELECT * FROM USER")
            res.status(200).send(user)
        } catch (error) {
            console.log(error)
        }
    })
}
