
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
            userinfo.id = count[0].count
            console.log(count)
            await authRepo.insertUser(userinfo)
        } catch (error) {
            console.log(error)
        }
    },
    findByLineId: async function (user) {
        try {
            const data = await authRepo.findByLineId(user.userId);
            console.log(data)
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
