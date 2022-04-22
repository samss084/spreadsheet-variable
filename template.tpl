___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Spreadsheet Reader",
  "description": "Read data from Google Spreadsheets",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "type",
    "displayName": "Type",
    "radioItems": [
      {
        "value": "cell",
        "displayValue": "Read Cell",
        "subParams": [],
        "help": "Returns value from google sheet cell"
      },
      {
        "value": "range",
        "subParams": [],
        "displayValue": "Read Range",
        "help": "Returns arrays from google sheet cell range."
      },
      {
        "value": "object",
        "displayValue": "Read Two Columns",
        "help": "Add a range that includes two columns. Variable returns an object that consists of these two columns. The first column will be used as a name, and the second column will be used as a correspondent value."
      }
    ],
    "simpleValueType": true,
    "defaultValue": "cell"
  },
  {
    "type": "TEXT",
    "name": "cell",
    "displayName": "Cell",
    "simpleValueType": true,
    "defaultValue": "A1",
    "enablingConditions": [
      {
        "paramName": "type",
        "paramValue": "cell",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "range",
    "displayName": "Range",
    "simpleValueType": true,
    "defaultValue": "A1:C1",
    "enablingConditions": [
      {
        "paramName": "type",
        "paramValue": "range",
        "type": "EQUALS"
      },
      {
        "paramName": "type",
        "paramValue": "object",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "url",
    "displayName": "Spreadsheet URL",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "refreshToken",
    "displayName": "API Refresh Token",
    "simpleValueType": true,
    "help": "More info on how to get Authentication credentials \u003ca target\u003d\"_blank\" href\u003d\"https://developers.google.com/identity/protocols/oauth2/web-server\"\u003ecan be found by this link\u003c/a\u003e.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "clientId",
    "displayName": "Client ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "clientSecret",
    "displayName": "Client Secret",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "displayName": "Firebase Settings",
    "name": "firebaseGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "TEXT",
        "name": "firebaseProjectId",
        "displayName": "Firebase Project ID",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "firebasePath",
        "displayName": "Firebase Path",
        "simpleValueType": true,
        "help": "The tag uses Firebase to store the OAuth access token. You can choose any key for a document that will store the OAuth access token.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "defaultValue": "stape/spreadsheet-auth"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_firestore",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedOptions",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "projectId"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "operation"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "read_write"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://oauth2.googleapis.com/"
              },
              {
                "type": 1,
                "string": "https://content-sheets.googleapis.com/"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 04/04/2022, 15:59:37


