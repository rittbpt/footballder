const friendRepo = require('../repository/friend')
const chatr = require('../repository/Chatroom')

const method = {
    getfriends: async function (userId) {
        try {
            const data = await friendRepo.getfriends(userId)
            const result = []
            for (const i of data) {
                const chatId = await chatr.getchatId(userId, i.id)
                const _ = {}
                _.chatId = chatId
                _.firstName = i.firstName
                _.firstName = i.firstName
                _.photo = i.photo
                result.push(_)
            }
            return result
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    },
    insert: async function (userId, friendId) {
        try {
            const check = await friendRepo.isFriend(userId, friendId)
            let data = false
            if (!check.length) {
                await friendRepo.insert(userId, friendId)
                data = true
            }
            return data
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    },

    remove: async function (userId, friendId) {
        try {
            await friendRepo.remove(userId, friendId)
            return
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    },


};

module.exports = method;


