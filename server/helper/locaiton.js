const axios = require('axios');
const config = require("../config")
async function opentime(open) {
    return open.map(day => {
        const [dayOfWeek, timeRange] = day.split(': ');
        const [startTime, endTime] = timeRange.split(' - '); // ตัดข้อความเวลาเริ่มและสิ้นสุดออกจากกัน
        return `${dayOfWeek}: ${startTime} - ${endTime}`; // รวมเวลาเริ่มและสิ้นสุดใหม่
    });
}

async function changeformat(data) {
    try {
        const result = {};
        result.next_page_token = data.next_page_token;
        result.locations = [];
        for (const element of data.results) {
            const _ = {};
            _.place_id = element.place_id
            _.lat = element.geometry.location.lat;
            _.lng = element.geometry.location.lng;
            _.photos = element.photos;
            _.name = element.name;
            _.rating = element.rating;
            _.user_ratings_total = element.user_ratings_total;
            _.vicinity = element.vicinity;
            result.locations.push(_);
        }
        return result;
    } catch (e) {
        console.error(e);
    }
}

async function getdetail(data) {
    try {
        for (const element of data.locations) {
            const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${element.place_id}&fields=formatted_phone_number,opening_hours&key=${config.google_api}`;
            const response = await axios.get(url);
            const placeDetails = response.data.result;
            element.phoneNumber = placeDetails && placeDetails.formatted_phone_number ? placeDetails.formatted_phone_number : '-';
            element.openNow = placeDetails && placeDetails.opening_hours ? placeDetails.opening_hours.open_now : '-';
            element.open = placeDetails && placeDetails.opening_hours ? placeDetails.opening_hours.weekday_text : '-';
        }
        return data;
    } catch (e) {
        console.error(e);
    }
}

async function getphoto(data) {
    try {
        for (const location of data.locations) {
            const placeDetailsUrl = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${location.place_id}&fields=photos&key=${config.google_api}`;
            const placeDetailsResponse = await axios.get(placeDetailsUrl);
            const photos = placeDetailsResponse.data.result.photos;
            let _ = []
            if (!!placeDetailsResponse.data.result.photos) {
                _ = photos.map(photo => {
                    return `https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo.photo_reference}&key=${config.google_api}`;
                });
            } 
            location.photolinks = _
            delete location.photos;
        }
        return data;
    } catch (e) {
        console.error(e);
    }
}



module.exports = {
    opentime,
    changeformat,
    getdetail,
    getphoto
};