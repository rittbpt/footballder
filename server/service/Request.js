const api = require("../connect/connectMysql");
const dateHelper = require("../helper/date");
const requsetRepo = require("../repository/request")
const locationHelper = require("../helper/locaiton")

const method = {
    getall: async function (selectedFields) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM Request`;
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error, "error at service getall")
            throw error;
        }
    },

    getuserre: async function (requestID) {
        try {
            const sql = `SELECT userId , MatchId FROM Request WHERE id = '${requestID}'`;
            const data = await api(sql);
            return data[0];
        } catch (error) {
            console.log(error, "error at service getall")
            throw error;
        }
    },


    getbyId: async function (userId) {
        try {
            const data = await requsetRepo.getbyId(userId)
            const data_ = await requsetRepo.getbyme(userId)
            const __ = await locationHelper.getdetailrq(data_)
            const _ = await locationHelper.getdetailrq(data)
            return { request: __, myrequest: _ };
        } catch (error) {
            console.log(error, "error at service getbyId")
            throw error;
        }
    },

    insert: async function (MatchId, Position, userId) {
        try {
            const createtime = await dateHelper.DateNow()
            const sql = `INSERT INTO Request (createTime , MatchId , Position, statusRequest , userId) VALUES ('${createtime}' , '${MatchId}' , '${Position}' , 'wait' , ${userId})`;
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error, "error at service insert")
            throw error;
        }
    },
    resave: async function (req) {
        try {
            const createtime = await dateHelper.DateNow()
            const sql = `INSERT INTO Request (createTime , MatchId , Position, statusRequest , userId) VALUES ('${createtime}' , '${req.MatchId}' , 'all' , 'accept' , ${req.userId})`;
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error, "error at service insert")
            throw error;
        }
    },

    getRecent: async function (userId) {
        try {
            const data = await requsetRepo.getRecent(userId)
            const _ = await locationHelper.getdetailone(data)

            return _;
        } catch (error) {
            console.log(error, "error at service insert")
            throw error;
        }
    },
    updateRqstatus: async function (requestID, status) {
        try {
            await requsetRepo.updateRqstatus(requestID, status)
        } catch (error) {
            console.log(error, "error at service insert")
            throw error;
        }
    },





};

module.exports = method;