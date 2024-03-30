const api = require("../connect/connectMysql")
const dateHelper = require("../helper/date")

const method = {
    getall: async function (userId) {
        try {
            const sql = `SELECT * , id as MatchId FROM MatchTable WHERE userCreate != '${userId}' AND statusMatch = 'wait'`
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },

    getinfo: async function (MatchId) {
        try {
            const sql = `SELECT * FROM MatchTable WHERE id = ${MatchId}`
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },

    updatestatus: async function (MatchId) {
        try {
            const sql = `UPDATE MatchTable set statusMatch = 'full' WHERE id = ${MatchId}`
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
            WHERE ((rq.userId = '${userId}' AND rq.statusRequest = 'accept') OR mt.userCreate = '${userId}') 
            `

            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },

    count: async function (MatchId) {
        try {
            const sql = `SELECT amount FROM MatchTable WHERE id = ${MatchId}`
            return await api(sql)
        } catch (error) {
            throw error;
        }
    }




}

module.exports = method;
