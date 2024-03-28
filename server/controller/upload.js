const service = require("../service/auth")
const path = require('path');
const fs = require('fs');

exports.upload = async function (req, res) {
    try {
        const filename = req.filename
        const { email } = req.params
        await service.uploadphoto(filename, email)
        res.send({ status: 200, data: req.filename })
    } catch (e) {
        console.log(e.message)
        res.send({ status: 400 });
    }
};

exports.download = async function (req, res) {
    try {
        const { filename } = req.params;
        const filePath = path.join(__dirname, '../uploads', filename);

        fs.readFile(
            filePath,
            function (err, image) {
                if (err) {
                    throw err;
                }
                console.log(image);
                res.setHeader('Content-Type', 'image/jpg');
                res.setHeader('Content-Length', ''); // Image size here
                res.setHeader('Access-Control-Allow-Origin', '*'); // If needs to be public
                res.send(image);
            }
        );
    } catch (e) {
        console.log(e.message)
        res.send({ status: 400 });
    }
};
