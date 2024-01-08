const api = require("../connect/connectMysql")
var jwt = require("jsonwebtoken");
const AuthHelper = require("../helper/Auth")
const dateHelper = require("../helper/date")

exports.Register = async (req, res) => {
    try {
        const { firstName, lastName, password, email, phoneNumber, birthDay } = req.body;

        const sqlcheckemail = `SELECT email FROM USER WHERE email = '${email}'`
        const checkemail = await api(sqlcheckemail)
        if (checkemail.length) {
            return res.send({ status: 410, data: "have this email" });
        }

        const encryptPassword = await AuthHelper.encryptPassword(password);
        const dateNow = await dateHelper.DateNow();
        const birthdayDate = await dateHelper.convertdatestringtoDate(birthDay);

        const sql = `INSERT INTO USER (email, password, create_time, firstName, lastName, phoneNumber, birthDay, active)
        VALUES ('${email}', '${encryptPassword}', '${dateNow}', '${firstName}', '${lastName}', '${phoneNumber}', '${birthdayDate}', 1)`;

        await api(sql);
        return res.send({ status: 200 });
    } catch (e) {
        console.log(e.message)
        res.send({ status: 400 });
    }
}

exports.Login = async (req, res) => {
    try {
        const { email, password, rememberme } = req.body
        const sql = `SELECT * FROM USER WHERE email = '${email}'`
        const userinfo = await api(sql);
        if (!userinfo.length) {
            return res.send({ status: 400, data: "Not found user" });
        }
        const checkPassword = await AuthHelper.comparePassword(password, userinfo[0].password)
        if (!checkPassword) {
            return res.send({ status: 400, data: "wrong password" });
        };
        const token = jwt.sign(
            {
                fullname: `${userinfo[0]?.firstName} ${userinfo[0]?.lastName}`,
                email: userinfo[0]?.email,
                phoneNumber: userinfo[0]?.phoneNumber,
                birthDay: await dateHelper.convertdateDatetostring(userinfo[0]?.birthDay)
            },
            "FOOTBALLDER",
            { expiresIn: "1hr" }
        );

        if (rememberme) {
            const remember = `UPDATE USER set remember = 1 WHERE email = '${email}'`
            await api(remember)
        };

        res.send({ status: 200, data: token });

    } catch (e) {
        res.send({ status: 400 });
        console.log(e.message)
    }
}