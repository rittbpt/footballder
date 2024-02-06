const api = require("../connect/connectMysql");


const method = {
    getall: async function (selectedFields) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM Location`;
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },
};

module.exports = method;