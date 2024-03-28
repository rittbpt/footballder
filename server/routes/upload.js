const upload = require('../Middleware/upload');
const controller = require('../controller/upload');
const { Checktoken } = require('../Middleware/checkToken');

module.exports = function (app) {
    app.post('/upload/:email', Checktoken, upload, controller.upload);
    app.get('/download/:filename',  upload, controller.download);

};