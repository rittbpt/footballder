const config = require("../config")
const axios = require('axios');
const locationHelper = require("../helper/locaiton")

const method = {
    getlocation: async function () {
        try {
            var searchQuery = "soccer field";
            var latitude = 13.846176;
            var longitude = 100.568589;
            var radius = 50000;
            const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?` +
                `location=${latitude},${longitude}` +
                `&radius=${radius}` +
                `&keyword=${searchQuery}` +
                `&key=${config.google_api}`;
            const response = await axios.get(url);
            const data = await locationHelper.changeformat(response.data)
            const data_ = await locationHelper.getdetail(data)
            const result = await locationHelper.getphoto(data_)
            return result
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    },

    getnextpagelocation: async function (token) {
        const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?` +
            `pagetoken=${token}` +
            `&key=${config.google_api}`;
        try {
            const response = await axios.get(url);
            const data = await locationHelper.changeformat(response.data)
            const result = await locationHelper.getdetail(data)
            return result
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    },
};

module.exports = method;