// const Service = require("../service/auth")

exports.insertChat = async (req, res) => {
    try {
        res.send("ok")
    } catch (e) {
        console.log(e.message)
        return res.send({ status: 400 });
    }
}
