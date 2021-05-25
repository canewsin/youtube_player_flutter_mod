import 'package:youtube_player_iframe/youtube_player_iframe.dart';

final _defaultParams = <String, String>{
  'autoplay': '0',
  'mute': '0',
  'cc_load_policy': '0',
  'color': 'white',
  'controls': '1',
  'disablekb': '0',
  'enablejsapi': '0',
  'end': '0',
  'fs': '1',
  'hl': 'en',
  'iv_load_policy': '1',
  'loop': '0',
  'modestbranding': '1',
  'playsinline': '0',
  'start': '0',
  'rel': '0',
  'showinfo': '0',
  'cc_lang_pref': 'en',
};

///
String youtubeIFrameTag(YoutubePlayerController controller) {
  final params = <String, String>{
    'autoplay': _boolean(controller.params.autoPlay),
    'mute': _boolean(controller.params.mute),
    'controls': _boolean(controller.params.showControls),
    'playsinline': _boolean(controller.params.playsInline),
    'enablejsapi': _boolean(controller.params.enableJavaScript),
    'fs': _boolean(controller.params.showFullscreenButton),
    'rel': _boolean(!controller.params.strictRelatedVideos),
    'showinfo': '0',
    'iv_load_policy': '${controller.params.showVideoAnnotations ? 1 : 3}',
    'modestbranding': '1',
    'cc_load_policy': _boolean(controller.params.enableCaption),
    'cc_lang_pref': controller.params.captionLanguage,
    'start': '${controller.params.startAt.inSeconds}',
    if (controller.params.endAt != null)
      'end': '${controller.params.endAt!.inSeconds}',
    'disablekb': _boolean(!controller.params.enableKeyboard),
    'color': controller.params.color,
    'hl': controller.params.interfaceLanguage,
    'loop': _boolean(controller.params.loop),
    if (controller.params.playlist.isNotEmpty)
      'playlist': '${controller.params.playlist.join(',')}'
  };

  params.removeWhere((key, value) => params[key] == _defaultParams[key]);

  final youtubeAuthority = controller.params.privacyEnhanced
      ? 'www.youtube-nocookie.com'
      : 'www.youtube.com';
  final sourceUri = Uri.https(
    youtubeAuthority,
    'embed/${controller.initialVideoId}',
    params,
  );
  return '<iframe id="player" type="text/html"'
      ' style="position:absolute; top:0px; left:0px; bottom:0px; right:10px;'
      ' width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"'
      ' src="$sourceUri" frameborder="0" allowfullscreen></iframe>';
}

///
String get youtubeIFrameFunctions => '''
function play() {
  player.playVideo();
  return '';
}
function pause() {
  player.pauseVideo();
  return '';
}
function loadById(loadSettings) {
  player.loadVideoById(loadSettings);
  return '';
}
function cueById(cueSettings) {
  player.cueVideoById(cueSettings);
  return '';
}
function loadPlaylist(loadSettings) {
  player.loadPlaylist(loadSettings);
  return '';
}
function cuePlaylist(loadSettings) {
  player.cuePlaylist(loadSettings);
  return '';
}
function mute() {
  player.mute();
  return '';
}
function unMute() {
  player.unMute();
  return '';
}
function setVolume(volume) {
  player.setVolume(volume);
  return '';
}
function seekTo(position, seekAhead) {
  player.seekTo(position, seekAhead);
  return '';
}
function setSize(width, height) {
  player.setSize(width, height);
  return '';
}
function setPlaybackRate(rate) {
  player.setPlaybackRate(rate);
  return '';
}
function setLoop(loopPlaylists) {
  player.setLoop(loopPlaylists);
  return '';
}
function setShuffle(shufflePlaylist) {
  player.setShuffle(shufflePlaylist);
  return '';
}
function previous() {
  player.previousVideo();
  return '';
}
function next() {
  player.nextVideo();
  return '';
}
function playVideoAt(index) {
  player.playVideoAt(index);
  return '';
}
function stop() {
  player.stopVideo();
  return '';
}
function isMuted() {
  return player.isMuted();
}
function hideTopMenu() {
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-chrome-top').style.display = 'none'; } catch(e) { }
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-watermark').style.display = 'none'; } catch(e) { }
  return '';
}
function hidePauseOverlay() {
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-pause-overlay').style.display = 'none'; } catch(e) { }
  return '';
}
function requestFullScreen() {
  try { 
    var e = document.getElementById("video-wrapper");
    if (e.requestFullscreen) {
        e.requestFullscreen();
    } else if (e.webkitRequestFullscreen) {
        e.webkitRequestFullscreen();
    } else if (e.mozRequestFullScreen) {
        e.mozRequestFullScreen();
    } else if (e.msRequestFullscreen) {
        e.msRequestFullscreen();
    }
  } catch(e) { 
    window.flutter_inappwebview.callHandler('Errors', e.data);
  }
  return '';
}
function hideCaptionWindow() {
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-caption-window-container').style.display = 'none'; } catch(e) { }
  return '';
}
function hideEndCards() {
  try { document.querySelector('#player').contentDocument.querySelector('.html5-endscreen').style.display = 'none'; } catch(e) { }
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-player-content').style.display = 'none'; } catch(e) { }
  return '';
}
''';

///
String get initPlayerIFrame => '''
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
''';

String _boolean(bool value) => value ? '1' : '0';
