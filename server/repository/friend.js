const api = require("../connect/connectMysql")

const method = {
    insert: async function (userId , friendId) {
        try {
            const sql = `INSERT INTO FRIEND (userSend , userRec , status ) VALUES ('${userId}' , '${friendId}'  , 'friend')`
            const chatId = await api(sql)
            return chatId
        } catch (e) {
            throw e;
        }

    },
    remove: async function (userId , friendId) {
        try {
            const sql = `DELETE FROM FRIEND WHERE 
            (userSend = '${userId}' OR userRec = '${userId}') AND (userSend = '${friendId}' OR userRec = '${friendId}')`
            const chatId = await api(sql)
            return chatId
        } catch (e) {
            throw e;
        }

    },
    isFriend : async function (userId , friendId) {
        try {
            const sql = `SELECT 
            *
        FROM 
            FRIEND 
        WHERE 
            (userSend = '${userId}' OR userRec = '${userId}') AND (userSend = '${friendId}' OR userRec = '${friendId}')`
            const data = await api(sql)
            return data
        } catch (e) {
            throw e;
        }

    },
    getfriends: async function (userId) {
        try {
            const sql = `SELECT 
            u.firstName , 
            u.photo ,
            u.id
        FROM 
            FRIEND AS friend
        JOIN 
            USER AS u ON u.id = CASE 
                                    WHEN friend.userRec = '${userId}' THEN friend.userSend 
                                    WHEN friend.userSend = '${userId}' THEN friend.userRec 
                                  END
        WHERE 
            friend.status = 'friend'`
            const data = await api(sql)
            return data
        } catch (e) {
            throw e;
        }

    },
}

module.exports = method;


