import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:core';
import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'settings.dart';
// import 'package:flutter_volume/flutter_volume.dart';
import 'server.dart';

class CallSample extends StatefulWidget {
  static String tag = 'call_sample';

  final String ip;
  final bool flag;
  bool videoSetting = true;
  bool audioSetting = true;

  CallSample({Key key, @required this.ip, @required this.flag}) : super(key: key);
    
  setVideoSetting() {
    this.videoSetting = !videoSetting;
    return videoSetting;
  }

  setAudioSetting() {
    this.audioSetting = !audioSetting;
    return audioSetting;
  }

  @override
  _CallSampleState createState() => new _CallSampleState(serverIP: ip, videoSetting: videoSetting,audioSetting: audioSetting, flag: flag);
}

class _CallSampleState extends State<CallSample> {
  Signaling _signaling;
  List<dynamic> _peers;
  var _selfId;
  bool muteStatus = true;
  bool videoSetting ;
  bool audioSetting ;
  bool flag;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  bool _inCalling = false;
  final String serverIP;

  _CallSampleState({Key key, @required this.serverIP,@required this.videoSetting,@required this.audioSetting, @required this.flag})
  {
    if (flag == true) {
      Server server = new Server() ;
      Future.delayed(const Duration(milliseconds: 500), () {
      // Here you can write your code
        setState(() {
          // Here you can write your code for open new view
          server.init();
          sleep(const Duration(seconds: 1));
          _connect();          
        });
      });
    }
  }

  @override
  initState() {
    super.initState();
    initRenderers();
    if (flag == false)
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    if (_signaling != null) _signaling.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void _connect() async {
    if (_signaling == null) {
      _signaling = new Signaling(serverIP)..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _inCalling = true;
            });
            break;
          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;
          case SignalingState.CallStateInvite:
          case SignalingState.CallStateConnected:
          case SignalingState.CallStateRinging:
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _selfId = event['self'];
          _peers = event['peers'];
        });
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  _invitePeer(context, peerId, use_screen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling.invite(peerId, 'video', use_screen);
    }
  }

  _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _muteMic() {
    // await FlutterVolume.volume;
    
    // if(muteStatus) {
    //   FlutterVolume.volume;
    //   FlutterVolume.mute();
    //   setState(() {
    //     muteStatus = false;
    //   });
    // } else {
    //   FlutterVolume.volume;
    //   FlutterVolume.mute();
    //   FlutterVolume.setVolume(0.1);
    //   setState(() {
    //     muteStatus = true;
    //   });
    // }
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + '[Your self]'
            : peer['name'] + '[' + peer['user_agent'] + ']'),
        onTap: null,
        trailing: new SizedBox(
            width: 50.0,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: () => _invitePeer(context, peer['id'], false),
                    tooltip: 'Video calling',
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.screen_share),
                  //   onPressed: () => _invitePeer(context, peer['id'], true),
                  //   tooltip: 'Screen sharing',
                  // )
                ])),
        subtitle: Text('id: ' + peer['id']),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Group Call'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context) => CallSettings(videoSetting: videoSetting,audioSetting: audioSetting,),
                )),
            tooltip: 'setup',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? new SizedBox(
              width: 200.0,
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      child: const Icon(Icons.switch_camera),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: new Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
                    FloatingActionButton(
                      child: this.muteStatus? const Icon(Icons.mic) : const Icon(Icons.mic_off),
                      onPressed: _muteMic,
                      // onPressed: () {
                      //   this.muteStatus? FlutterVolume.setMaxVolume() : FlutterVolume.mute();
                      // }
                    )
                  ]))
          : null,
      body: _inCalling
          ? OrientationBuilder(builder: (context, orientation) {
              return new Container(
                child: new Stack(children: <Widget>[
                  new Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: new RTCVideoView(_remoteRenderer),
                        decoration: new BoxDecoration(color: Colors.black54),
                      )),
                  new Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: new Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: new RTCVideoView(_localRenderer),
                      decoration: new BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ]),
              );
            })
          : new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: (_peers != null ? _peers.length : 0),
              itemBuilder: (context, i) {
                return _buildRow(context, _peers[i]);
              }),
    );
  }
}
