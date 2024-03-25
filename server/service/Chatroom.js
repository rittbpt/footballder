const chatroomRepo = require('../repository/Chatroom')


const method = {
    getlistchat: async function (userId) {
        try {
            const data = await chatroomRepo.getlistchat(userId)
            return data;
        } catch (error) {
            throw error;
        }
    },
    insert: async function (obj) {
        try {
            const chatId = await chatroomRepo.insert(obj)
            return chatId
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    findcharoomidbymatchid: async function (MatchId) {
        try {
            const chatId = await chatroomRepo.findcharoomidbymatchid(MatchId)
            return chatId
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    chats: async function (userId) {
        try {
            const chats = await chatroomRepo.chats(userId)
            return chats
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    readchat: async function (userId, chatId) {
        try {
            await chatroomRepo.readchat(userId, chatId)
            return
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },

};

module.exports = method;