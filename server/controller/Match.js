const Service = require("../service/Match");

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

