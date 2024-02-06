var jwt = require("jsonwebtoken");
const bcrypt = require('bcrypt');
const dateHelper = require("../helper/date")

async function encryptPassword(password) {
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    return hashedPassword;
}

async function comparePassword(plainPassword, hashedPassword) {
    const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
    return isMatch;
}

async function generateToken(user) {
    const token = jwt.sign(
        {
            fullname: `${user?.firstName} ${user?.lastName}`,
            email: user?.email,
            phoneNumber: user?.phoneNumber,
            birthDay: await dateHelper.convertdateDatetostring(user?.birthDay)
        },
        "FOOTBALLDER",
        { expiresIn: "1hr" }
    );
    return token;
}

module.exports = {
    encryptPassword,
    comparePassword,
    generateToken
};