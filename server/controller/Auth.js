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
        const userinfo = req.body;
        const user = await Service.findById(userinfo);

        if (!user.length) {
            return res.status(400).send({ status: 400, data: "Not found user" });
        }

        const checkPassword = await AuthHelper.comparePassword(userinfo.password, user[0].password);

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
        const token = await AuthHelper.generateTokenline(userinfo);
        return res.status(200).send({ status: 200, token: token, data: user[0] });
    } catch (e) {
        console.error(e.message);
        return res.status(500).send({ status: 500, data: "Server Error" });
    }
};

exports.sendotp = async (req, res) => {
    try {
        const { email } = req.body
        const otp = await AuthHelper.generateotp()
        const result = await Service.sendotp(email, otp)
        if (result) {
            return res.send({ status: 200, otp: otp })
        } else {
            return res.status(400).send({ status: 400, data: "Not found user" });

        }
    } catch (e) {
        console.error(e.message);
        return res.status(500).send({ status: 500, data: "Server Error" });
    }
};

exports.changepassword = async (req, res) => {
    try {
        const { email, password } = req.body
        await Service.changepassword(email, password)
        return res.send({ status: 200 })
    } catch (e) {
        console.error(e.message);
        return res.status(500).send({ status: 500, data: "Server Error" });
    }
};


