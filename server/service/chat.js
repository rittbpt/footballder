const chatRepo = require("../repository/chat")
const chatroomRepo = require("../repository/Chatroom")
const userRepo = require("../repository/auth")
const dateHelper = require('../helper/date')

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
                _.date = element.time.split(' ')[0]
                _.time = element.time.split(' ')[1].slice(0,5)

                result.push(_)
            }
            return result
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    readchat: async function (chatId, userId) {
        try {
            await chatRepo.readchat(chatId, userId)
        } catch (e) {
            throw e;
        }
    }
};

module.exports = method;