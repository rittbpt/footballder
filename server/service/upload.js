const fs = require('fs');

const method = {
    upload: async function (req) {
        if (!req.file) {
            throw new Error('No file uploaded');
        }
        try {
            const { originalname, mimetype, size, filename } = req.file;
            const destination = '../uploads'
            if (!fs.existsSync(destination)) {
                fs.mkdirSync(destination, { recursive: true });
            }

            fs.renameSync(req.file.path, `${destination}/${filename}`);

            return {
                originalname,
                mimetype,
                size,
                filename
            };
        } catch (error) {
            throw new Error('File upload failed');
        }
    }
}

module.exports = method