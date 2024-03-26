const api = require("../connect/connectMysql")
const dateHelper = require("../helper/date")

const method = {
    getall: async function (userId) {
        try {
            const sql = `SELECT mt.*, rq.id AS rqid 
            FROM MatchTable AS mt 
            LEFT JOIN Request AS rq ON rq.MatchId = mt.id 
            WHERE (rq.userId != ${userId} OR rq.userId IS NULL) 
              AND mt.userCreate != ${userId}
            `

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },

    insert: async function (matchName, locationId, selectDatetime, amount, Description, statusMatch, userCreate) {
        try {
            const time = await dateHelper.convertdatetimestingDatetime(selectDatetime)
            const sql = `INSERT INTO MatchTable
            (
                ${!matchName ? '' : 'matchName,'}
                ${!locationId ? '' : 'locationId,'}
                ${!selectDatetime ? '' : 'selectDatetime,'}
                ${!amount ? '' : 'amount,'}
                ${!Description ? '' : 'Description,'}
                ${!statusMatch ? '' : 'statusMatch,'}
                ${!userCreate ? '' : 'userCreate'}
            )
            VALUES
            (
                ${!matchName ? '' : `'${matchName}',`}
                ${!locationId ? '' : `'${locationId}',`}
                ${!selectDatetime ? '' : `'${time}',`}
                ${!amount ? '' : `'${amount}',`}
                ${!Description ? '' : `'${Description}',`}
                ${!statusMatch ? '' : `'${statusMatch}',`}
                ${!userCreate ? '' : `'${userCreate}'`}
            );
            
                        `
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error)
            throw error;
        }
    },

    getmatchdone: async function (userId) {
        try {
            const sql = `SELECT mt.*, rq.*
            FROM Request AS rq 
            LEFT JOIN MatchTable AS mt ON rq.MatchId = mt.id 
            WHERE rq.userId = ${userId} AND rq.statusRequest = 'accept'
            `

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },




}

module.exports = method;
