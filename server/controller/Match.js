const Service = require("../service/Match");
const chatroomcontroller = require("../controller/Chatroom")
const reservice = require('../service/Request')
const uesrRepo = require('../repository/auth')


exports.getall = async (req, res) => {
    try {
        const { userId } = req.params
        const data = await Service.getall(userId);
        res.send({ status: 200, data: data });
    } catch (e) {
        console.log(e.message);
        res.send({ status: 400 });
    }
};

exports.getmatchuserjoin = async (req, res) => {
    try {
        const { MatchId } = req.params
        const data = await Service.getmatchuserjoin(MatchId);
        const result = []
        for (const i of data) {
            const _ = {}
            const user = await uesrRepo.getinfo(i.userId)
            _.photo = user[0].photo
            _.firstName = user[0].firstName
            result.push(_)
        }
        res.send({ status: 200, data: result });
    } catch (e) {
        console.log(e.message);
        res.send({ status: 400 });
    }
};

exports.insert = async (req, res) => {
    try {
        const { matchName, locationId, selectDatetime, amount, Description, statusMatch, userCreate } = req.body
        const data = await Service.insert(matchName, locationId, selectDatetime, amount, Description, statusMatch, userCreate)
        req.body.MatchId = data.insertId
        req.body.MatchName = matchName
        req.body.userId = userCreate
        req.body.type = 0
        await chatroomcontroller.insertChatroom(req)
        await reservice.resave(req)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller Match insert")
        res.send({ status: 400 });
    }
};

exports.getmatchdone = async (req, res) => {
    try {
        const { userId } = req.params
        const data = await Service.getmatchdone(userId)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller Match insert")
        res.send({ status: 400 });
    }
};

