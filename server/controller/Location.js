const Service = require("../service/Location");

exports.getall = async (req, res) => {
    try {
        const data = await Service.getall();
        res.send({ status: 200, data: data });
    } catch (e) {
        console.log(e.message);
        res.send({ status: 400 });
    }
};