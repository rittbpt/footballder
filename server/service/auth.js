
const { email } = require("../config");
const authRepo = require("../repository/auth")
const { randomUUID } = require('crypto');

const method = {
    findById: async function (userinfo, selectedFields) {
        try {
            const data = await authRepo.findById(userinfo, selectedFields);
            return data;
        } catch (error) {
            throw error;
        }
    },

    updateprofile: async function (userinfo) {
        try {
            await authRepo.updateprofile(userinfo);
        } catch (error) {
            throw error;
        }
    },

    insertUser: async function (userinfo) {
        try {
            const count = await authRepo.count()
            userinfo.id = randomUUID()
            console.log(count)
            await authRepo.insertUser(userinfo)
        } catch (error) {
            console.log(error)
        }
    },
    findByLineId: async function (user) {
        try {
            const data = await authRepo.findByLineId(user.userId);
            if (!data.length) {
                await authRepo.insertLineuser(user)
            } else {

                await authRepo.updateLineuser(user)
            }
            const userinfo = await authRepo.getuserline(user)
            console.log(userinfo)
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
    uploadphoto: async function (filename, email) {
        try {
            await authRepo.uploadphoto(filename, email)
            return
        } catch (error) {
            throw error;
        }
    },

};

module.exports = method;
