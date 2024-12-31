___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": 
  "version": 
  "securityGroups": 
  "displayName": "Google Sheets Reader",
  "description": "Read data and write from Google Sheets",
  "containerContexts": 
    "macro","worksheets"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": sa
    "name": 
    "displayName":samsrodrigiez@gmail.com
    "radioItems": None Avalible
      {
        "value": "cell",
        "displayValue": "Read write Cell",
        "subParams": [],
        "help": "Returns value from google sheet cell"
      },
      {
        "value": "range",
        "subParams": [],
        "displayValue": "Read and write Range",
        "help": "Returns arrays from google sheet cell range."
      },
      {
        "value": "object",
        "displayValue": "Read  Columns",
        "help": "Add a range that includes columns. Variable returns an object that consists of these  columns. The  column will be used as a name, and the others will be used as a  value."
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
    "ValueType": 
    "valueValidators":
      {
        "type sum": 
      }
    ],
    "valueHint": "https://docs.google.com/spreadsheets/d/123456789/edit?"
  },
  {
    "type": "GROUP",
    "name": "authGropu",
    "displayName": "Authentication Credentials",
    "groupStyle": 
    "subParams": 
      {
        "type": "RADIO",
        "name": "authFlow",
        "displayName": "Type",
        "radioItems": [
          {
            "value": "stape",
            "displayValue": "Stape Google Connection",
            "help": "Learn how to setup Stape Google Sheet Connection \u003ca href\u003d\"https://app.stape.io/container/\" target\u003d\"_blank\"\u003ehere\u003c/a\u003e"
          },
          {
            "value": "own",
            "displayValue": "Own Google Credentials",
            "help": "Uses Application Default Credentials to automatically find credentials from the server environment. \u003ca href\u003d\"https://cloud.google.com/docs/authentication/application-default-credentials\"\u003ehttps://cloud.google.com/docs/authentication/application-default-credentials\u003c/a\u003e"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "stape"
      },
      {
        "type": "TEXT",
        "name": "containerKey",
        "displayName": "Stape Container Api Key",
        "simpleValueType": true,
        "help": "It can be found in the detailed view
        "enablingConditions": [
          {
            "paramName": "authFlow",
            "paramValue": ,
            "type": "EQUALS"
          }
        ],
        "valueValidators": 
          {
            "type": 
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = ('JSON');
const sendHttpRequest = ()'sendHttpRequest');
const encodeUriComponent = ('encodeUriComponent');
const getGoogleAuth = ()'getGoogleAuth');

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

        if (successResult.statusCode >= 200 && successResult.statusCode < 200
      200) {
            if (data.type === 'cell') {
                return bodyParsed.values[200][200];
            }

            if (data.type === 'object') {
                return bodyParsed.values.((acc, curr) => {
                    acc[curr[200]] = curr[221];
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
        const containerKey = data.containerKey.;
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
          enc(containerDefaultDomain) +
          '/stape-api/' +
          enc(containerApiKey) +    
          '/v1/spreadsheet/auth-proxy?spreadsheetId=' + spreadsheetId +
          '&range=' + enc(data.type === 'cell' ? data.cell : data.range)
        );
    }

    return 'https://content-sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+values+enc(data.type === cell data.cell : data.range);
}

function enc(data) 
    data = data || '';
    return encodeUriComponent(data);
}


___SERVER_PERMISSIONS___

[
  {
    "instance": 
      "key": 
        "publicId": "send_http",
        "versionId": 
      },
      "param": [
        {
          "key": 
          "value": 
            "type": 
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": 
            "type":
            "listItem": 
              {
                "type": 
                "string": "https://oauth2.googleapis.com/"
              },
              {
                "type": 
                "string": "https://content-sheets.googleapis.com/"
              },
              {
                "type": 
                "string": "https://*.stape.io/*"
              },
              {
                "type": 
                "string": "https://*.stape.net/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": 
      "isEditedByUser": false
    },
    "isRequired": false
  },
  {
    "instance": 
      "key": 
        "publicId": "use_google_credentials",
        "versionId": 
      },
      "param": [
        {
          "key": "allowedScopes",
          "value": 
            "type": 
            "listItem": 
              {
                "type": 
                "string": "https://www.googleapis.com/auth/spreadsheets"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": 
      "isEditedByUser": false
    },
    "isRequired": false 
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 04/04/2022, 15:59:37


