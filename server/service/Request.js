const api = require("../connect/connectMysql");
const dateHelper = require("../helper/date");
const requsetRepo = require("../repository/request")

const method = {
    getall: async function (selectedFields) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM Request`;
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error , "error at service getall")
            throw error;
        }
    },

    getbyId: async function (id, selectedFields) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM Request WHERE id = ${id}`;
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error , "error at service getbyId")
            throw error;
        }
    },

    insert : async function (createTime, MacthId, Postition , userId) {
        try {
            const createtime = await dateHelper.convertdatestringtoDate(createTime)
            const sql = `INSERT INTO Request (createTime , MacthId , Postition , userId) VALUES (${createtime} , '${MacthId}' , '${Postition}' , 'wait' , ${userId})`;
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error , "error at service insert")
            throw error;
        }
    },
    getRecent : async function (userId) {
        try {
            const data = await requsetRepo.getRecent(userId)
            return data;
        } catch (error) {
            console.log(error , "error at service insert")
            throw error;
        }
    },

    
};

module.exports = method;