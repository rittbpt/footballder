
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

    sendotp: async function (email ,otp) {
        try {
            await authRepo.sendOtp(email ,otp)
            return
        } catch (error) {
            throw error;
        }
    },
    changepassword : async function (email , password) {
        try {
            await authRepo.changepassword(email , password)
            return
        } catch (error) {
            throw error;
        }
    },

};

module.exports = method;
