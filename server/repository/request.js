const api = require("../connect/connectMysql")

const method = {
    getRecent: async function (userId) {
        try {
            const sql = `
                SELECT rq.* , mt.* , user.*
                    FROM Request AS rq 
                    JOIN MatchTable AS mt ON mt.id = rq.MatchId 
                    JOIN USER AS user ON user.id = rq.userId 
                WHERE rq.userId = '${userId}' AND checkIn = 1
          `;

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },
    getbyId: async function (userId) {
        try {
            const sql = `
                SELECT rq.* , user.* ,mt.* , rq.id AS rqId , mt.id AS MatchId
                    FROM Request AS rq 
                    JOIN MatchTable AS mt ON mt.id = rq.MatchId 
                    JOIN USER AS user ON user.id = rq.userId 
                WHERE rq.statusRequest = 'wait' AND mt.userCreate = '${userId}'
          `;

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },

    getbyme: async function (userId) {
        try {
            const sql = `
                SELECT rq.* , user.* ,mt.* , rq.id AS rqId , mt.id AS MatchId
                    FROM Request AS rq 
                    JOIN MatchTable AS mt ON mt.id = rq.MatchId 
                    JOIN USER AS user ON user.id = rq.userId 
                WHERE rq.statusRequest = 'wait' AND rq.userId = '${userId}'
          `;

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },


    

    updateRqstatus: async function (requestID, status) {
        try {
            console.log(requestID , status)
            const sql = `UPDATE Request SET statusRequest = '${status ? "accept" : "reject"}' WHERE id = ${requestID}`;
            await api(sql);
        } catch (error) {
            throw error;
        }
    },
    requestbyme: async function (userId) {
        try {
            const sql = `SELECT MatchId FROM Request WHERE userId = '${userId}'`;
            const data = await api(sql);
            return data
        } catch (error) {
            throw error;
        }
    },
    rqcountmatch: async function (MatchId) {
        try {
            const sql = `SELECT COUNT(*) AS count FROM Request WHERE MatchId = ${MatchId}`;
            const data = await api(sql);
            return data
        } catch (error) {
            throw error;
        }
    },
}

module.exports = method;
