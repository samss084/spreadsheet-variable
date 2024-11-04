const JSON = require('JSON');
const sendHttpRequest = require('sendHttpRequest');
const encodeUriComponent = require('encodeUriComponent');
const getGoogleAuth = require('getGoogleAuth');

const spreadsheetId = data.url.replace('https://docs.google.com/spreadsheets/d/', '').split('/')[0];
const requestUrl = getUrl();
const auth = getGoogleAuth({
    scopes: ['https://www.googleapis.com/auth/spreadsheets']
});

return sendGetRequest();

function sendGetRequest() {
    let params = {
        headers: {'Content-Type': 'application/json', }, 
        method: 'GET'
    };
    if (data.authFlow === 'own') {
        params.authorization = auth;
    }
    return sendHttpRequest(requestUrl, params).then(successResult => {
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
        } else {
            return '';
        }
    });
}


function getUrl() {
    if (data.authFlow === 'stape') {
        const containerKey = data.containerKey.split(':');
        const containerZone = containerKey[0];
        const containerIdentifier = containerKey[1];
        const containerApiKey = containerKey[2];
        const containerDefaultDomainEnd = containerKey[3] || 'io';
      
        return (
          'https://' +
          enc(containerIdentifier) +
          '.' +
          enc(containerZone) +
          '.stape.' +
          enc(containerDefaultDomainEnd) +
          '/stape-api/' +
          enc(containerApiKey) +    
          '/v1/spreadsheet/auth-proxy?spreadsheetId=' + spreadsheetId +
          '&range=' + enc(data.type === 'cell' ? data.cell : data.range)
        );
    }

    return 'https://content-sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+'/values/'+enc(data.type === 'cell' ? data.cell : data.range);
}

function enc(data) {
    data = data || '';
    return encodeUriComponent(data);
}
