const AuthHelper = require("../helper/Auth")
const Service = require("../service/auth")

exports.Register = async (req, res) => {
    try {
        const userinfo = req.body;
        const user = await Service.findById(userinfo, 'email')
        if (user.length) {
            return res.send({ status: 410, data: "have this email" });
        }
        await Service.insertUser(userinfo);
        return res.send({ status: 200 });
    } catch (e) {
        console.log(e.message)
        return res.send({ status: 400 });
    }
}

exports.Login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await Service.findById(email);

        if (!user.length) {
            return res.status(400).send({ status: 400, data: "Not found user" });
        }

        const checkPassword = await AuthHelper.comparePassword(password, user[0].password);

        if (!checkPassword) {
            return res.status(400).send({ status: 400, data: "Wrong password" });
        }

        const token = await AuthHelper.generateToken(user[0]);

        return res.status(200).send({ status: 200, token: token, data: user[0] });
    } catch (e) {
        console.error(e.message);
        return res.status(500).send({ status: 500, data: "Server Error" });
    }
};

exports.Linelogin = async (req, res) => {
    try {
        const userinfo = req.body
        const user = await Service.findByLineId(userinfo);

        if (!user.length) {
            return res.status(400).send({ status: 400, data: "Not found user" });
        }

        const checkPassword = await AuthHelper.comparePassword(password, user[0].password);

        if (!checkPassword) {
            return res.status(400).send({ status: 400, data: "Wrong password" });
        }

        const token = await AuthHelper.generateToken(user[0]);

        return res.status(200).send({ status: 200, token: token, data: user[0] });
    } catch (e) {
        console.error(e.message);
        return res.status(500).send({ status: 500, data: "Server Error" });
    }
};

