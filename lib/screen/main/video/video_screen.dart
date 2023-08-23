import 'dart:async';
import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_capstone_6/widget/appbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../component/colors.dart';
import '../../../component/global_data.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.id, required this.id_video})
      : super(key: key);
  final String id;
  final String id_video;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  late Timer _timer;
  bool _isPlayerReady = false;
  bool loading = false;
  bool isLoaded = false;
  String bintang = '';
  List _review = [];
  List _reviewList = [];
  List _getAverageStar = [];

  TextEditingController _reviewController = new TextEditingController();

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _getReview();
      _getReviewAll();
      _getAVGStarFunc();
    });

    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  Future _refresh() async {
    await _getReview();
    await _getAVGStarFunc();
  }

  Future _getReview() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.1.3/manajemen_tutorial/api/get_review.php?email=${GlobalData.of(context)?.getData('email')}&id_tutorial=${widget.id_video}"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          isLoaded = true;
          _review = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _getReviewAll() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.1.3/manajemen_tutorial/api/get_review_all.php?id_tutorial=${widget.id_video}"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          isLoaded = true;
          _reviewList = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _getAVGStarFunc() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.1.3/manajemen_tutorial/api/get_avg_star.php?id_tutorial=${widget.id_video}"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          _getAverageStar = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future add_review() async {
    try {
      return await http.post(
        Uri.parse("http://192.168.1.3/manajemen_tutorial/api/add_review.php"),

        // Uri.parse("https://timocratical-tear.000webhostapp.com/register.php"),
        body: {
          "email": GlobalData.of(context)?.getData('email'),
          "nama_dpn": GlobalData.of(context)?.getData('nama_dpn'),
          "id_tutorial": widget.id_video.toString(),
          "bintang": bintang,
          "komen_review": _reviewController.text,
        },
      ).then((value) {
        var data = jsonDecode(value.body);

        setState(() {
          loading = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Review berhasil dikirim.')));
      });
    } on Exception {
      var kWidth = MediaQuery.of(context).size.width;
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (context) {
            return Container(
              height: kWidth / 2.8,
              child: Padding(
                padding: EdgeInsets.all(kWidth / 20),
                child: Column(
                  children: [
                    Text(
                      "Server tidak menanggapi, silahkan coba lagi atau cek koneksi internet Anda.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: kWidth / 27),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: kWidth / 30),
                      child: Container(
                        width: kWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Kembali",
                            style: TextStyle(
                              fontSize: kWidth / 28,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[5],
      appBar: appBar(context, 'Tonton Video'),
      body: Stack(
        children: [
          loading
              ? Center(
                  child: AlertDialog(
                    content: Text('Loading'),
                  ),
                )
              : Container(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),
                    onReady: () {
                      _isPlayerReady = true;
                    },
                  ),
                  if (isLoaded == true) ...{
                    if (_review.isEmpty) ...{
                      Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Berikan review-mu'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              bintang = rating.toString();
                                            },
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                          ),
                                          TextFormField(
                                            controller: _reviewController,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Isi review kamu di sini',
                                              labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: n40,
                                                  fontWeight: FontWeight.w400),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              floatingLabelStyle:
                                                  TextStyle(color: n100),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide:
                                                    BorderSide(color: n100),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                            ),
                                            maxLines: 3,
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Batal'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Kirim'),
                                        onPressed: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          add_review();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Berikan Review')),
                      )
                    } else if (_review.isNotEmpty) ...{
                      Container(
                        width: 350,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Review anda',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                RatingBarIndicator(
                                  rating: double.parse(_review[0]['bintang']),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 30.0,
                                  direction: Axis.horizontal,
                                ),
                                Text(
                                  _review[0]['komen_review'],
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            )),
                      )
                    },
                    Divider(
                      thickness: 3,
                    ),
                    if (_reviewList.isEmpty) ...{
                      Text(
                        'Belum ada review',
                      ),
                    } else if (_reviewList.isNotEmpty) ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar review',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: double.parse(
                                        _getAverageStar[0]['avg(bintang)']),
                                    itemSize: 20.0,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    direction: Axis.horizontal,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  Text(
                                    _getAverageStar[0]['avg(bintang)']
                                            .substring(0, 3) +
                                        '/5.0',
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              Text(
                                '(' +
                                    _reviewList.length.toString() +
                                    ' review)',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      for (int i = 0; i < _reviewList.length; i++) ...{
                        Container(
                          width: 350,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _reviewList[i]['nama'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  RatingBarIndicator(
                                    rating:
                                        double.parse(_reviewList[i]['bintang']),
                                    itemSize: 30.0,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    direction: Axis.horizontal,
                                  ),
                                  Text(
                                    _reviewList[i]['komen_review'],
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              )),
                        )
                      }
                    }
                  } else if (isLoaded == false) ...{
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: CircularProgressIndicator())
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
