 JSON =('JSON');
 sendHttpRequest =('sendHttpRequest');
 encodeUriComponent =('encodeUriComponent');
 getGoogleAuth = ('getGoogleAuth');
 spreadsheetId = data.url.('https://docs.google.com/spreadsheets/d/', '').split('/')[0];
requestUrl = getUrl();
 auth = getGoogleAuth({
    scopes: ['https://www.googleapis.com/auth/spreadsheets']
});

return sendGetRequest();

function sendGetRequest() {
    let params = {
        headers: {'Content-Type': 'application/json', }, 
        method: 'GET'
    };
     (data.authFlow === 'own') {
        params.authorization = auth;
    }
    return sendHttpRequest(requestUrl, params).then(successResult => {
        let bodyParsed = JSON.parse(successResult.body);

         (successResult.statusCode >= 200 && successResult.statusCode < 400) {
             (data.type === 'cell') {
                return bodyParsed.values;
            }

             (data.type === 'object') {
                return bodyParsed.values((acc, curr) => {
                    acc[curr[0]] = curr[1];
                    return ;
                }, {});
            }

            return bodyParsed.values;
        } else {
            return '';
        }
    });
}


function getUrl() {
     (data.authFlow === 'stape') {
        const containerKey = data.containerKey.split(':');
        const containerZone = containerKey[0];
        const containerIdentifier = containerKey[1];
        const containerApiKey = containerKey[2];
        const containerDefaultDomainEnd = containerKey[3] || 'io';
      
        return (
          'https://' +
          (containerIdentifier) +
          
          enc(containerZone) +
          stape. +
          enc(containerDefaultDomain) +
          stape-api +
          enc(containerApiKey) +    
          '/v1/spreadsheet/auth-proxy?spreadsheetId=' + spreadsheetId +
          '&range=' + enc(data.type === 'cell' ? data.cell : data.range)
        );
    }

    return 'https://content-sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+'/values/'+enc(data.type === 'cell' ? data.cell : data.range);
}

function (data) {
    data = data || '';
    return encodeUriComponent(data);
}
