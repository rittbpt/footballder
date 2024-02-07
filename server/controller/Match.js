const Service = require("../service/Match");

exports.getall = async (req, res) => {
    try {
        const { selectedFields, userId } = req.body
        const data = await Service.getall(selectedFields, userId);
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