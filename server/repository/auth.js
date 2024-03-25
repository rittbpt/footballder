const api = require("../connect/connectMysql")
const AuthHelper = require("../helper/Auth")
const dateHelper = require("../helper/date")
const nodemailer = require('nodemailer');
const config = require("../config")

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
    insertLineuser: async function (user) {
        try {
            const dateNow = await dateHelper.DateNow();
            const sql = `INSERT INTO USER (create_time, firstName, photo, active , type ,Lineuserid)
            VALUES ('${dateNow}', '${user.displayName}', '${pictureUrl}',  1, 'line', '${user.userId}')`;
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
    },
    getuserline: async function (user) {
        try {
            const sql = `SELECT * FROM USER WHERE Lineuserid = '${user.userId}' AND type = 'line'`;
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },
    sendOtp: async function (otp) {
        try {
            const transporter = nodemailer.createTransport({
                host: 'smtp.gmail.com',
                port: 587,
                auth: {
                    user: config.email,
                    pass: config.password,
                },
            });
            transporter.verify().then(console.log).catch(console.error);

            const mailOptions = {
                from: 'FOOTBALLDER <noreply.footballder@gmail.com>',
                to: 'ritnutdanai@gmail.com',
                subject: 'Your One-Time Password (OTP)',
                text: `Your One-Time Password (OTP) is: ${otp}`
            };

            transporter.sendMail(mailOptions).then(info => {
                console.log({ info });
            }).catch(console.error);
        } catch (error) {
            console.error('Error sending email:', error);
            throw error;
        }
    }
}

module.exports = method;
