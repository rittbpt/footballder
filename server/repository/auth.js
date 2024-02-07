const api = require("../connect/connectMysql")
const AuthHelper = require("../helper/Auth")
const dateHelper = require("../helper/date")

const method = {
    findById: async function (id, selectedFields) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM USER WHERE email = '${id}'`;
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },
    insertUser: async function (email, password, firstName, lastName, phoneNumber, birthDay) {
        try {
            const encryptPassword = await AuthHelper.encryptPassword(password);
            const dateNow = await dateHelper.DateNow();
            const birthdayDate = await dateHelper.convertdatestringtoDate(birthDay);
            const sql = `INSERT INTO USER (email, password, create_time, firstName, lastName, phoneNumber, birthDay, active)
            VALUES ('${email}', '${encryptPassword}', '${dateNow}', '${firstName}', '${lastName}', '${phoneNumber}', '${birthdayDate}', 1)`;
            await api(sql)
        } catch (error) {
            console.log(error)
        }
    }
}

module.exports = method;
