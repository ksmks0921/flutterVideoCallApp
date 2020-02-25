import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

String strCert = ("""
-----BEGIN CERTIFICATE-----
MIIDBjCCAe4CCQCuf5QfyX2oDDANBgkqhkiG9w0BAQsFADBFMQswCQYDVQQGEwJB
VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
cyBQdHkgTHRkMB4XDTE0MDkyOTA5NDczNVoXDTE1MDkyOTA5NDczNVowRTELMAkG
A1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0
IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AMJOyOHJ+rJWJEQ7P7kKoWa31ff7hKNZxF6sYE5lFi3pBYWIY6kTN/iUaxJLROFo
FhoC/M/STY76rIryix474v/6cRoG8N+GQBEn4IAP1UitWzVO6pVvBaIt5IKlhhfm
YA1IMweCd03vLcaHTddNmFDBTks7QDwfenTaR5VjKYc3OtEhcG8dgLAnOjbbk2Hr
8wter2IeNgkhya3zyoXnTLT8m8IMg2mQaJs62Xlo9gs56urvVDWG4rhdGybj1uwU
ZiDYyP4CFCUHS6UVt12vADP8vjbwmss2ScGsIf0NjaU+MpSdEbB82z4b2NiN8Wq+
rFA/JbvyeoWWHMoa7wkVs1MCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAYLRwV9fo
AOhJfeK199Tv6oXoNSSSe10pVLnYxPcczCVQ4b9SomKFJFbmwtPVGi6w3m+8mV7F
9I2WKyeBHzmzfW2utZNupVybxgzEjuFLOVytSPdsB+DcJomOi8W/Cf2Vk8Wykb/t
Ctr1gfOcI8rwEGKxm279spBs0u1snzoLyoimbMbiXbC82j1IiN3Jus08U07m/j7N
hRBCpeHjUHT3CRpvYyTRnt+AyBd8BiyJB7nWmcNI1DksXPfehd62MAFS9e1ZE+dH
Aavg/U8VpS7pcCQcPJvIJ2hehrt8L6kUk3YUYqZ0OeRZK27f2R5+wFlDF33esm3N
dCSsLJlXyqAQFg==
-----END CERTIFICATE-----
""");
String strKey = ("""
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAwk7I4cn6slYkRDs/uQqhZrfV9/uEo1nEXqxgTmUWLekFhYhj
qRM3+JRrEktE4WgWGgL8z9JNjvqsivKLHjvi//pxGgbw34ZAESfggA/VSK1bNU7q
lW8Foi3kgqWGF+ZgDUgzB4J3Te8txodN102YUMFOSztAPB96dNpHlWMphzc60SFw
bx2AsCc6NtuTYevzC16vYh42CSHJrfPKhedMtPybwgyDaZBomzrZeWj2Cznq6u9U
NYbiuF0bJuPW7BRmINjI/gIUJQdLpRW3Xa8AM/y+NvCayzZJwawh/Q2NpT4ylJ0R
sHzbPhvY2I3xar6sUD8lu/J6hZYcyhrvCRWzUwIDAQABAoIBACwt56TW3MZxqZtN
8WYsUZheUispJ/ZQMcLo5JjOiSV1Jwk+gpJtyTse291z+bxagzP02/CQu4u32UVa
cmE0cp+LHO4zB8964dREwdm8P91fdS6Au/uwG5LNZniCFCQZAFvkv52Ef4XbzQen
uf4rKWerHBck6K0C5z/sZXxE6KtScE2ZLUmkhO0nkHM6MA6gFk2OMnB+oDTOWWPt
1mlreQlzuMYG/D4axviRYrOSYCE5Qu1SOw/DEOLQqqeBjQrKtAyOlFHZsIR6lBfe
KHMChPUcYIwaowt2DcqH/A+AFXRtaifa6DvH8Yul+2vAp47UEpaenVfM5bpN33XV
EzerjtECgYEA+xiXzblek67iQgRpc9eHSoqs4iRLhae8s8kpAG51Jz46Je+Dmium
XV769oiUGUxBeoUb7ryW+4MOzHJaA1BfGejQSvwLIB9e4cnikqnAArcqbcAcOCL1
aYYDiSmSmN/AokNZlPKEBFXP9bzXrU9smQJWNTHlcRl7JXfnwF+jwNsCgYEAxhpE
SBr9vlUVHNh/S6C5i80NIYg6jCy2FgsmuzEqmcqV0pTyzegmq8bru+QmuvoUj2o4
nVv4J9d1fLF6ECUVk9aK8UdJOOB6hAfurOdJCArgrsY/9t4uDzXfbPCdfSNQITE0
XgeNGQX1EzvwwkBmyZKk0kLIr3syP8ZCWfXDROkCgYBR+dF1pJMv++R6UR5sZ20P
9P5ERj0xwXVl7MKqFWXCDhrFz9BTQPTrftrIKgbPy4mFCnf4FTHlov/t11dzxYWG
2+9Ey8yGDDfZ1yNVZn39ZPdBJXsRCLi+XrZAzYXCyyoEz6ArdJGNKMbgH2r6dfeq
bIzgiQ2zQvJlZSQQNiksCQKBgCgwzAmU8EXdHRttEOZXBU3HnBJhgP9PUuHGAWWY
4/uvjhXbAiekIbRX9xt3fiQQ+HrgIfxK3F246K0TlKAR5f7IWAf7Xm+bmz+OHG4X
vklTa6IJtpBvIwkS9PE1H75zm54gTW+GOKoK+12bm4zNZA0hIy9FPVHcvKUTpAJ8
SdGBAoGAHLtJnB1NO4EgO6WtLQMXt7HrIbup8eZi8/82gC3422C+ooKIrYQ07qSw
nBOO/G0OB4yd6vCE2x5+TWSSCYGgG5A8aIv5qP76RP4hovGHxG/y2tfotw5UuOrh
nFWlTP4Urs8PeykvK9ao8r/T8BnPIC16U6ENYvAc0mRlFA2j1GA=
-----END RSA PRIVATE KEY-----
""");

class Server {
  var clients = new Set();
  var sessions = [];
  Server () {
    _save();
  }

  _save() async{
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/cert1.pem');
        final text = strCert;
        file.writeAsString(text);
        print('saved cert.pem file ');

        final file2 = File('${directory.path}/key1.pem');
        file2.writeAsString(strKey);
        print('saved key.pem file ');
  }

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    SecurityContext context = new SecurityContext();
    var chain = Platform.script.resolve('${directory.path}/cert1.pem').toFilePath();
    var key = Platform.script.resolve('${directory.path}/key1.pem').toFilePath();
    context.useCertificateChain(chain);
    context.usePrivateKey(key);

    await HttpServer.bindSecure(InternetAddress.anyIPv4, 4443, context)
        .then((server) {
          print("Secure server listening on 4443...");
          //server.serverHeader = "Secure WebSocket server";
          server.listen((HttpRequest request) {
            print(" receive request ");
            if (request.headers.value(HttpHeaders.UPGRADE) == "websocket"){
              WebSocketTransformer.upgrade(request).then(handleWebSocket);
              print(" upgrade websocket ");
            }
            else {
              request.response.statusCode = HttpStatus.FORBIDDEN;
              request.response.reasonPhrase = "WebSocket connections only";
              request.response.close();
              print(" websocket connections only");
            }
          });
        });
  }
  void _send(client, message) {

    WebSocket socket = client['socket'];
    JsonEncoder encoder = new JsonEncoder();
    try {
      if (socket != null) {
      socket.add(encoder.convert(message));
      print('send data success , data is : $message');
    }
    } catch (e) {
      print("send failure !: " + e);
    }
  }
  Future<void> updatePeers () async {
    var peers = [];
    clients.forEach((client) {
            var peer = {};
            if (client['id'] != null) {
              peer['id'] = client['id'];
            }
            if (client['name'] != null) {
                peer['name'] = client['name'];
            }
            if (client['user_agent'] != null) {
                peer['user_agent'] = client['user_agent'];
            }
            if (client['session_id'] != null) {
                peer['session_id'] = client['session_id'];
            }
            if (peer['id'] != null && peer['name'] != null)
              peers.add(peer);
        });
        var msg = {
            "type": "peers",
            "data": peers,
        };
        clients.forEach((client) {
          _send(client, msg);
        });
    print("peers is " + peers.toString());
  }


void onClose(clientSelf) {
    print('client is close');

    var sessionId = clientSelf['session_id'];
    //remove old session_id
    if (sessionId != null) {
            for (var i = 0; i < sessions.length; i++) {
                var item = sessions[i];
                if (item['id'] == sessionId) {
                    sessions.removeAt(i);
                    //break;
                }
            }
        }
        var msg = {
            'type': "leave",
            'data': clientSelf['id'],
        };

        clients.forEach((client) {
            if (client['socket'] != clientSelf['socket'])
            _send(client, msg);
        });

        clients.remove(clientSelf);
        updatePeers();
  }

  void handleWebSocket(WebSocket socket){
    socket.listen((data) {
      onMessage(socket, data);
    },
    onDone: () {
      Map<String, dynamic> client_self = new Map<String, dynamic>();
      client_self['socket'] = socket;

      print('Client disconnected');
      clients.forEach((client) {
        if (client['socket'] == socket) {
          client_self = client;
        }
      });
     onClose(client_self);
    });
  }

  void onMessage(socket, data) async {
    Map<String, dynamic> client_self = new Map<String, dynamic>();
    Map<String, dynamic> message = json.decode(data);
    //var datas = message['data'];

    print("recv message.type : " + message['type'] + ", \nbody: " + data);

    switch (message['type']) {
      case 'new':
      {
        client_self['socket'] = socket;
        client_self['id'] = "" +  message['id'];
        client_self['name'] = message['name'];
        client_self['user_agent'] = message['user_agent'];
        clients.add(client_self);
        updatePeers();
      }
      break;
      case 'bye':
      {
        var session = null;
        var msg;
        sessions.forEach((sess){
          if (sess['id'] != null && sess['id'] == message['session_id']) {
            session = sess;
          }
         });
         
         if (session == null) {
            msg = {
             "type": "error",
             "data": {
               "error": "Invalid session " + message['session_id'],
               },
            };
            _send(client_self, msg);
            return;
          }

          clients.forEach((client){
            if (client['session_id'] == message['session_id'])
            {
              try {
                msg = {
                   "type": "bye",
                    "data": {
                         "session_id": message['session_id'],
                         "from": message['from'],
                         "to": client['id'] == session['from'] ? session['to'] : session['from'],
                        },
              };
              _send(client, msg);
                
              } catch (e) {
                print("onUserJoin:" + e.message);
              }
              
            }              
         });
      }
      break;
      case "offer":
            {
              var peer = null;
              clients.forEach((client) {
                 if (client['id'] != null && client['id'] == "" + message['to']) {
                    peer = client;
                  }
              });
              
              client_self['id'] = message['session_id'].toString().split("-")[0];
              if (message['to'] == client_self['id'])
              client_self['id'] = message['session_id'].toString().split("-")[1];

              if (peer != null) {
                var msg = {
                   "type": "offer",
                    "data": {
                          "to": peer['id'],
                          "from": client_self['id'],
                          "media": message['media'],
                          "session_id": message['session_id'],
                          "description": message['description'],
                          }
                  };
              _send(peer, msg);
               peer['session_id'] = message['session_id'];

               clients.forEach((client) {
                 if (client['id'] != null && client['id'] == "" + client_self['id']) {
                    client_self = client;
                  }
              });
               client_self['session_id'] = message['session_id'];

                var sess = {
                    "id": message['session_id'],
                    "from": client_self['id'],
                    "to": peer['id'],
                };
                sessions.add(sess);
              }
              break;
            }
          case 'answer':
          {
            client_self['id'] = message['session_id'].toString().split("-")[0];
            if (message['to'] == client_self['id'])
              client_self['id'] = message['session_id'].toString().split("-")[1];
            var msg = {
               "type": "answer",
               "data": {
                    "from": client_self['id'],
                    "to": message['to'],
                    "description": message['description']
                    }
              };
              clients.forEach((client) {
                if (client['id'] == "" + message['to'] && client['session_id'] == message['session_id']) {
                 try {
                       _send(client, msg);
                   } catch (e) {
                    print("onUserJoin:" + e.message);
                 }
              }
              });
           }
          break;
          case 'candidate':
          {
            client_self['id'] = message['session_id'].toString().split("-")[0];
            if (message['to'] == client_self['id'])
              client_self['id'] = message['session_id'].toString().split("-")[1];
          
            var msg = {
                "type": "candidate",
                "data": {
                    "from": client_self['id'],
                    "to": message['to'],
                    "candidate": message['candidate'],
                      }
            };
            
            clients.forEach((client) {
              if (client['id'] == "" + message['to'] && client['session_id'] == message['session_id']) {
                 try {
                     _send(client, msg);
                 } catch (e) {
                   print("onUserJoin:" + e.message);
                    }
                }
            });
            }
            break;
            case 'keepalive':
                _send(client_self, {"type":'keepalive', "data":{}});
            break;
            default:
              print("Unhandled message: " + message['type']);
            }
  }
}