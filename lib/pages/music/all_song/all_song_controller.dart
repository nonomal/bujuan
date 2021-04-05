import 'package:bujuan/global/global_config.dart';
import 'package:bujuan/global/global_controller.dart';
import 'package:bujuan/pages/home/home_controller.dart';
import 'package:bujuan/utils/sp_util.dart';
import 'package:flutter_music_query/flutter_music_query.dart';
import 'package:get/get.dart';
import 'package:starry/music_item.dart';
import 'package:starry/starry.dart';
import 'package:we_slide/we_slide.dart';

import '../../../main.dart';

class AllSongController extends GetxController {
  WeSlideController weSlideController;
  var allMusic = [].obs;
  @override
  void onInit() {
    weSlideController = WeSlideController();
    super.onInit();
  }

  @override
  void onReady() {
    weSlideController.addListener(() {
      if (weSlideController.isOpened) {
        Get.find<HomeController>().resumeStream();
      } else {
        Get.find<HomeController>().pauseStream();
      }
    });
    getAllMusic();
    super.onReady();
  }

  getAllMusic()async{
    var list = await Get.find<FileService>().audioQuery.getSongs();
    allMusic..clear()..addAll(list);
    print("object");
  }

  playSong(index) async {
    var playSheetId = SpUtil.getInt(PLAY_SONG_SHEET_ID, defValue: -1);
    if (-9999 == playSheetId) {
      var playList = Get.find<GlobalController>().playList;
      if (playList.length != allMusic.length) {
        //当前歌单未在播放
        await Starry.playMusic(getSheetList(), index);
        SpUtil.putInt(PLAY_SONG_SHEET_ID, -9999);
      } else {
        Starry.playMusicByIndex(index);
      }
      //当前歌单正在播放，直接根据下标播放
      Starry.playMusicByIndex(index);
    } else {
      //当前歌单未在播放
      await Starry.playMusic(getSheetList(), index);
      SpUtil.putInt(PLAY_SONG_SHEET_ID, -9999);
    }
  }

  getSheetList() {
    var songs = [];
    allMusic.forEach(( track) {
      MusicItem musicItem = MusicItem(
        musicId: '${track.artistId}',
        duration: int.parse(track.duration),
        iconUri: "",
        title: track.title,
        uri: '${track.filePath}',
        artist: track.artist,
      );
      songs.add(musicItem);
    });
    return songs;
  }
}
