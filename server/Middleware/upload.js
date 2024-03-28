const multer = require('multer');
const path = require('path');
const moment = require('moment');

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, '../uploads'));
    },
    filename: function (req, file, cb) {
        const { userId } = req.params; // ใช้ req.query ในการดึง userId
        const ext = path.extname(file.originalname);
        const timestamp = moment().format('YYYY-MM-DD'); // ใช้ timestamp เพื่อให้ไม่ซ้ำกัน
        const filename = `userphoto-${userId}-${timestamp}-${Date.now()}${ext}`; // เพิ่มจำนวนในชื่อไฟล์
        req.filename = filename;
        cb(null, filename);
    },
});

const upload = multer({
    storage: storage,
    limits: { fileSize: 30000000 },
}).single('photo');

module.exports = upload;
