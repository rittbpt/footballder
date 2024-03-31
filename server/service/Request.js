const api = require("../connect/connectMysql");
const dateHelper = require("../helper/date");
const requsetRepo = require("../repository/request")
const locationHelper = require("../helper/locaiton")
const MatchRepo = require("../repository/Match")

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

    checkin: async function (userId , MatchId) {
        try {
            const sql = `UPDATE Request set checkIn = 1 WHERE userId = '${userId}' AND MatchId = ${MatchId}`;
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
            return { request: _, myrequest: __ };
        } catch (error) {
            console.log(error, "error at service getbyId")
            throw error;
        }
    },

    insert: async function (MatchId, Position, userId) {
        try {
            const createtime = await dateHelper.DateNow()
            const sql = `INSERT INTO Request (createTime , MatchId , Position, statusRequest , userId) VALUES ('${createtime}' , '${MatchId}' , '${Position}' , 'wait' , '${userId}')`;
            const data = await api(sql);
            const amount = await MatchRepo.count(MatchId)
            const countrq = await requsetRepo.rqcountmatch(MatchId)
            console.log(amount , countrq)
            if (amount[0].amount + 1 === countrq[0].count ) {
                await MatchRepo.updatestatus(MatchId)
            }
            return data;
        } catch (error) {
            console.log(error, "error at service insert")
            throw error;
        }
    },
    resave: async function (req) {
        try {
            const createtime = await dateHelper.DateNow()
            const sql = `INSERT INTO Request (createTime , MatchId , Position, statusRequest , userId) VALUES ('${createtime}' , '${req.body.MatchId}' , 'all' , 'accept' , '${req.body.userId}')`;
            const data = await api(sql);
            console.log(data)
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