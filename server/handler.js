
class Handler {
    constructor(mysqlClient) {
        this.mysqlClient = mysqlClient
        
    }

    async footballderTest() {
        try {
            const user = await this.mysqlClient("SELECT * FROM USER")
            res.status(200).send(user)
        } catch(err) {
            console.log(err)
        }
    }
}

module.exports = Handler