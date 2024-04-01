const MatchRepo = require("../repository/Match")
const locationHelper = require("../helper/locaiton")
const reRepo = require("../repository/request")
const chatr = require("../repository/Chatroom")


const method = {
    getall: async function (userId) {
        try {
            const match = await MatchRepo.getall(userId)
            const req = await reRepo.requestbyme(userId)
            const list_matchid = req.map((element) => { return element.MatchId })


            const _ = await locationHelper.getdetailone(match)
            const promises = _.map(async (element) => {
                if (!list_matchid.includes(element.MatchId)) {
                    const n = await reRepo.rqcountmatch(element.MatchId);
                    element.available = element.amount + 1 - n[0].count;
                    return element;
                }
            });

            const matchs = await Promise.all(promises);

            const filteredMatchs = matchs.filter(element => element !== undefined);

            return filteredMatchs;
        } catch (error) {
            throw error;
        }
    },
    getmatchuserjoin: async function (MatchId) {
        try {
            const data = await MatchRepo.getmatchuserjoin(MatchId)
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
    getmatchdone: async function (userId) {
        try {
            const data_ = await MatchRepo.getmatchdone(userId)
            const data = data_.filter((element) => element.checkIn === null && element.userId === userId)
            const _ = await locationHelper.getdetailone(data)
            const result = []
            const had = []
            for (const element of _) {
                if (!had.includes(element.MatchId)) {
                    const chatid = await chatr.getchatIdbymatch(element.MatchId)
                    const count = await MatchRepo.getmatchuserjoin(element.MatchId)
                    element.count = count.length
                    element.chatId = chatid
                    result.push(element)
                    had.push(element.MatchId)
                }
            }
            return result;
        } catch (error) {
            throw error;
        }
    },
};

module.exports = method;