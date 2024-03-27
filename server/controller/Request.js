const Service = require("../service/Request")

exports.getall = async (req, res) => {
    try {
        const data = await Service.getall()
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller getall")
        res.send({ status: 400 });
    }
};

exports.getbyId = async (req, res) => {
    try {
        const { userId } = req.params
        const data = await Service.getbyId(userId)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller getbyId")
        res.send({ status: 400 });
    }
};

exports.insert = async (req, res) => {
    try {
        const { MatchId, Position, userId } = req.body
        const data = await Service.insert(MatchId, Position, userId)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller insert")
        res.send({ status: 400 });
    }
};

exports.getRecent = async (req, res) => {
    try {
        const { userId } = req.params
        const data = await Service.getRecent(userId)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller insert")
        res.send({ status: 400 });
    }
};

exports.updateRqstatus = async (req, res) => {
    try {
        const { requestID , status } = req.body
        await Service.updateRqstatus(requestID , status)
        res.send({ status: 200 })
    } catch (e) {
        console.log(e.message, "Error at controller insert")
        res.send({ status: 400 });
    }
};




