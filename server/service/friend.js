const friendRepo = require('../repository/friend')

const method = {
    getfriends: async function (userId) {
        try {
            const data = await friendRepo.getfriends(userId)
            return data
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    },
    insert: async function (userId, friendId) {
        try {
            const check = await friendRepo.isFriend(userId, friendId)
            let data = []
            if (!check.length) {
                data = await friendRepo.insert(userId, friendId)
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


