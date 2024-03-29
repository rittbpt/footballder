const chatRepo = require("../repository/chat")
const chatroomRepo = require("../repository/Chatroom")
const userRepo = require("../repository/auth")

const method = {
    insert: async function (data) {
        try {
            await chatRepo.insert(data)
            return
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    insertchat: async function (chatdt) {
        try {
            const data = await chatRepo.insertchat(chatdt)
            await chatRepo.newchatmessage(chatdt.userId, chatdt.chatId)
            await chatroomRepo.newchatmessage(chatdt.chatId, chatdt.data)
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    getchat: async function (chatId) {
        try {
            const data = await chatRepo.getchat(chatId)
            const result = []
            for (const element of data) {
                const user = await userRepo.getinfo(element.userId)
                const _ = {}
                _.photo = user[0].photo
                _.firstName = user[0].firstName
                _.data = element.data
                _.Time = element.time
                result.push(_)
            }
            return result
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    readchat: async function (userId, chatId) {
        try {
            await chatRepo.readchat(userId, chatId)
        } catch (e) {
            throw e;
        }
    }
};

module.exports = method;