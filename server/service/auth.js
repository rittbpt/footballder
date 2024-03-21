
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
            if (!data.length) {
                await authRepo.insertUser(user)
            } else {
                await authRepo.update(user)
            }
            return data;
        } catch (error) {
            throw error;
        }
    },

};

module.exports = method;
