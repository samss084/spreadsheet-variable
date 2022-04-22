const JSON = require('JSON');
const sendHttpRequest = require('sendHttpRequest');
const encodeUriComponent = require('encodeUriComponent');
const Firestore = require('Firestore');

let firebaseOptions = {};
if (data.firebaseProjectId) firebaseOptions.projectId = data.firebaseProjectId;

return Firestore.read(data.firebasePath, firebaseOptions)
    .then((result) => {
        return sendGetRequest(result.data.access_token, result.data.refresh_token);
    }, () => {
        return updateAccessToken(data.refreshToken);
    });

function sendGetRequest(accessToken, refreshToken) {
    const postUrl = getUrl();

    return sendHttpRequest(postUrl, {headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + accessToken}, method: 'GET'}).then(successResult => {
        let bodyParsed = JSON.parse(successResult.body);

        if (successResult.statusCode >= 200 && successResult.statusCode < 400) {
            if (data.type === 'cell') {
                return bodyParsed.values[0][0];
            }

            if (data.type === 'object') {
                return bodyParsed.values.reduce((acc, curr) => {
                    acc[curr[0]] = curr[1];
                    return acc;
                }, {});
            }

            return bodyParsed.values;
        } else if (successResult.statusCode === 401) {
            return updateAccessToken(refreshToken);
        } else {
            return '';
        }
    });
}

function updateAccessToken(refreshToken) {
    const authUrl = 'https://oauth2.googleapis.com/token';
    const authBody = 'refresh_token='+enc(refreshToken || data.refreshToken)+'&client_id='+enc(data.clientId)+'&client_secret='+enc(data.clientSecret)+'&grant_type=refresh_token';

    return sendHttpRequest(authUrl, {headers: {'Content-Type': 'application/x-www-form-urlencoded'}, method: 'POST'}, authBody).then((successResult) => {
        if (successResult.statusCode >= 200 && successResult.statusCode < 400) {
            let bodyParsed = JSON.parse(successResult.body);

            return Firestore.write(data.firebasePath, bodyParsed, firebaseOptions)
                .then((id) => {
                    return sendGetRequest(bodyParsed.access_token, bodyParsed.refresh_token);
                }, () => { return ''; });
        } else {
            return '';
        }
    });
}

function getUrl() {
    let spreadsheetId = data.url.replace('https://docs.google.com/spreadsheets/d/', '').split('/')[0];

    return 'https://content-sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+'/values/'+enc(data.type === 'cell' ? data.cell : data.range);
}

function enc(data) {
    data = data || '';
    return encodeUriComponent(data);
}
