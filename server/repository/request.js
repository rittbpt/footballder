const api = require("../connect/connectMysql")

const method = {
    getRecent: async function (userId) {
        try {
            const sql = `
                SELECT rq.* , mt.* 
                    FROM Request AS rq 
                    JOIN MatchTable AS mt ON mt.id = rq.MatchId 
                    JOIN Location AS lo ON lo.id = mt.locationId 
                    JOIN USER AS user ON user.id = rq.userId 
                WHERE rq.userId = ${userId} AND checkIn = 1
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
                SELECT rq.* , user.* ,mt.*
                    FROM Request AS rq 
                    JOIN MatchTable AS mt ON mt.id = rq.MatchId 
                    JOIN USER AS user ON user.id = rq.userId 
                WHERE rq.statusRequest = 'wait' AND mt.userCreate = ${userId}
          `;

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },
}

module.exports = method;
