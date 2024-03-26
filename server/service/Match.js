const MatchRepo = require("../repository/Match")


const method = {
    getall: async function (userId) {
        try {
            const had = []
            const data = await MatchRepo.getall(userId)
            const result = []
            data.forEach(element => {
                if (!had.includes(element.id)) {
                    had.push(element.id)
                    result.push(element)
                }
            });
            return result;
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