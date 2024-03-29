const MatchRepo = require("../repository/Match")
const locationHelper = require("../helper/locaiton")
const reRepo = require("../repository/request")


const method = {
    getall: async function (userId) {
        try {
            const match = await MatchRepo.getall(userId)
            const req = await reRepo.requestbyme(userId)
            const list_matchid = req.map((element) => { return element.MatchId })
            const matchs = []
            match.forEach(element => {
                if (!list_matchid.includes(element.id)) {
                    matchs.push(element)
                }
            });
            const _ = await locationHelper.getdetailone(matchs)

            return _;
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
    getmatchdone: async function (userId) {
        try {
            const data = await MatchRepo.getmatchdone(userId)
            const _ = await locationHelper.getdetailone(data)
            const result = []
            const had = []
            _.forEach((element) => {
                if (!had.includes(element.MatchId)) {
                    result.push(element)
                    had.push(element.MatchId)
                }
            })
            return result;
        } catch (error) {
            throw error;
        }
    },
};

module.exports = method;