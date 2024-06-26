var jwt = require("jsonwebtoken");
const bcrypt = require('bcrypt');
const dateHelper = require("../helper/date")
const otpGenerator = require('otp-generator');
const { v4: uuidv4 } = require('uuid');

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
        { expiresIn: "8760000hr" }
    );
    return token;
}

async function generateUniqueIds() {
    const uniqueIds = new Set();
    uniqueIds.add(uuidv4().slice(0, 8));
    const id = Array.from(uniqueIds)[0];
    return id;
}

async function generateTokenline(user) {
    const token = jwt.sign(
        {
            name: user.displayName,
            userId: user.userId,
        },
        "FOOTBALLDER",
        { expiresIn: "8760000hr" }
    );
    return token;
}

async function generateotp() {
    const otp = otpGenerator.generate(6, { digits: true, alphabets: false, upperCase: false, specialChars: false });
    return otp;
}

module.exports = {
    encryptPassword,
    comparePassword,
    generateToken,
    generateTokenline,
    generateotp,
    generateUniqueIds
};