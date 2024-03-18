const Service = require("../service/Location");

exports.getlocation = async (req, res) => {
    try {
        const { latitude, longtitude } = req.body
        const data = await Service.getlocation(latitude, longtitude);
        res.json({ status: 200, data: data });
    } catch (e) {
        console.log("Error service getlocation location", e.message);
        res.send({ status: 400 });
    }
};

exports.getnextpagelocation = async (req, res) => {
    try {
        const { token } = req.params;
        const data = await Service.getnextpagelocation(token);
        res.json({ status: 200, data: data });
    } catch (e) {
        console.log("Error service getnextpagelocation location", e.message);
        res.send({ status: 400 });
    }
};

exports.getlocationdetail = async (req, res) => {
    try {
        const { placeId } = req.params;
        const data = await Service.getlocationdetail(placeId);
        res.json({ status: 200, data: data });
    } catch (e) {
        console.log("Error service getlocationdetail location", e.message);
        res.send({ status: 400 });
    }
};