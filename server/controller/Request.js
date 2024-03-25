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
        const { createTime, MacthId, Postition, userId } = req.body
        const data = await Service.insert(createTime, MacthId, Postition, userId)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller insert")
        res.send({ status: 400 });
    }
};

exports.getRecent = async (req, res) => {
    try {
        const { userId } = req.body
        const data = await Service.getRecent(userId)
        res.send({ status: 200, data: data })
    } catch (e) {
        console.log(e.message, "Error at controller insert")
        res.send({ status: 400 });
    }
};

