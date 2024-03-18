exports.Test = async (req, res) => {
    try {
        res.send({ status: 200 })
    } catch (e) {
        console.log(e.message)
        res.send({ status: 400 });
    }
};