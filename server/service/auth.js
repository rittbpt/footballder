
const { email } = require("../config");
const authRepo = require("../repository/auth")

const method = {
    findById: async function (userinfo, selectedFields) {
        try {
            const data = await authRepo.findById(userinfo, selectedFields);
            return data;
        } catch (error) {
            throw error;
        }
    },

    insertUser: async function (email, password, firstName, lastName, phoneNumber, birthDay) {
        try {
            await authRepo.insertUser(email, password, firstName, lastName, phoneNumber, birthDay)
        } catch (error) {
            console.log(error)
        }
    },
    findByLineId: async function (user) {
        try {
            const data = await authRepo.findByLineId(user.userId);
            let userinfo;
            if (!data.length) {
                await authRepo.insertLineuser(user)
                userinfo = await authRepo.getuserline(user)
            } else {
                await authRepo.update(user)
                userinfo = await authRepo.getuserline(user)
            }
            return userinfo;
        } catch (error) {
            throw error;
        }
    },

    sendotp: async function (email, otp) {
        try {
            const user = await authRepo.findById({ email: email })
            if (!user.length) {
                return false
            } else {
                await authRepo.sendOtp(email, otp)
                return true
            }
        } catch (error) {
            throw error;
        }
    },
    changepassword: async function (email, password) {
        try {
            await authRepo.changepassword(email, password)
            return
        } catch (error) {
            throw error;
        }
    },
    uploadphoto: async function (filename, userId) {
        try {
            await authRepo.uploadphoto(filename, userId)
            return
        } catch (error) {
            throw error;
        }
    },

};

module.exports = method;
