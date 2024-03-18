const jwt = require('jsonwebtoken');

exports.Checktoken = async (req, res, next) => {
    try {
        const token = req.headers["token"]
        if (!token) {
            return res.send({ status: 401, data: 'No Token' })
        }
        const decoded = jwt.verify(token, "FOOTBALLDER")
        if (decoded.iat === decoded.exp) {
            return res.send({ status: 402, data: 'Token Expire' })
        }
        next();
    } catch (error) {
        return res.send({ status: 403, data: 'Token Invalid' })
    }
};

