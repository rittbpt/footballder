const api = require("../connect/connectMysql")
const AuthHelper = require("../helper/Auth")
const dateHelper = require("../helper/date")

const method = {
    findById: async function (user, selectedFields) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM USER WHERE email = '${user.email}'`;
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },
    insertUser: async function (user) {
        try {
            const encryptPassword = await AuthHelper.encryptPassword(user.password);
            const dateNow = await dateHelper.DateNow();
            const birthdayDate = await dateHelper.convertdatestringtoDate(user.birthDay);
            const sql = `INSERT INTO USER (email, password, create_time, firstName, lastName, phoneNumber, birthDay, active , type)
            VALUES ('${user.email}', '${encryptPassword}', '${dateNow}', '${user.firstName}', '${user.lastName}', '${user.phoneNumber}', '${birthdayDate}', 1 , 'footballder')`;
            await api(sql)
        } catch (error) {
            console.log(error)
        }
    },
    findByLineId: async function (userId) {
        try {
            const sql = `SELECT * FROM USER WHERE Lineuserid = '${userId}' AND type = 'line'`
            const data = await api(sql)
        } catch (error) {
            console.log(error)
        }
    }
}

module.exports = method;
