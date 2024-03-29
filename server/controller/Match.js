const Service = require("../service/Match");
const chatroomcontroller = require("../controller/Chatroom")
const reservice = require('../service/Request')

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

