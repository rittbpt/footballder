
const authRepo = require("../repository/auth")

const method = {
    findById: async function (id, selectedFields) {
        try {
            const data = await authRepo.findById(id, selectedFields);
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
    }

};

module.exports = method;
