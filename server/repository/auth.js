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
            const sql = `INSERT INTO USER (email, password, create_time, firstName, lastName, phoneNumber, birthDay, active , type)
            VALUES ('${user.email}', '${encryptPassword}', '${dateNow}', '${user.firstName}', '${user.lastName}', '${user.phoneNumber}', '${user.birthDay}', 1 , 'footballder')`;
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
    changepassword: async function (userId, password) {
        try {
            const encryptPassword = await AuthHelper.encryptPassword(password);
            const sql = `UPDATE USER SET password = '${encryptPassword}' WHERE email = '${email}'`;
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

            const htmlContent = `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>One-Time Password (OTP)</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f4f4;
                        padding: 20px;
                    }
                    .container {
                        max-width: 600px;
                        margin: 0 auto;
                        background-color: #ffffff;
                        border-radius: 5px;
                        padding: 20px;
                        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                    }
                    h1 {
                        color: #333333;
                    }
                    p {
                        color: #666666;
                    }
                    .otp {
                        font-size: 24px;
                        color: #007bff;
                    }
                    .footer {
                        margin-top: 20px;
                        color: #999999;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>Your One-Time Password (OTP)</h1>
                    <p>Your One-Time Password (OTP) is: <span class="otp">${otp}</span></p>
                    <p>Please use this OTP to complete your authentication process.</p>
                    <p class="footer">Thank you, <br> FOOTBALLDER Team</p>
                </div>
            </body>
            </html>
        `;

            const mailOptions = {
                from: 'FOOTBALLDER <noreply.footballder@gmail.com>',
                to: 'puttisun.t@ku.th',
                subject: 'Your One-Time Password (OTP)',
                html: htmlContent
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
