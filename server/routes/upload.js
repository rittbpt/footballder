const upload = require('../Middleware/upload');
const controller = require('../controller/upload');

module.exports = function (app) {
    app.post('/upload/:email', upload, controller.upload);
    app.get('/download/:filename',  upload, controller.download);

};