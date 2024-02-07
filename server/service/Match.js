const MatchRepo = require("../repository/Match")


const method = {
    getall: async function (selectedFields , userId) {
        try {
            const data = await MatchRepo.getall(selectedFields , userId)
            return data;
        } catch (error) {
            throw error;
        }
    },
    insert: async function (matchName, locationId, selectDatetime, amount, Description, statusMatch, userCreate) {
        try {
            const data = await MatchRepo.insert(matchName, locationId, selectDatetime, amount, Description, statusMatch, userCreate)
            return data;
        } catch (error) {
            throw error;
        }
    },
};

module.exports = method;