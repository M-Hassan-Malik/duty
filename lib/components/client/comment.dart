import 'package:duty/provider/url.dart';
import 'package:duty/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Comment extends StatefulWidget {
  final details;

  const Comment({Key? key, required this.details}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _inputComment = Map<String, dynamic>();
  var _comments;
  final ScrollController _controllerOne = ScrollController();

  @override
  Widget build(BuildContext context) {
    print(widget.details.toString());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      minLines: 2,
                      maxLines: 20,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(right: 40.0, left: 8.0, top: 8.0, bottom: 8.0),
                          filled: true,
                          fillColor: myTertiaryColor,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: myPrimaryColor)),
                          hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                          hintText: '► Type comment...'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Value shouldn't be empty.";
                        } else
                          _inputComment = {
                            "parent": true,
                            "userId": widget.details['uid'],
                            "dutyId": widget.details['docId'],
                            "country": widget.details['doc']['country'],
                            "city": widget.details['doc']['city'],
                            "comment": value,
                          };
                        return null;
                      },
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.send, color: myPrimaryColor),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _makeComment(context, _inputComment)
                              .then((boolean) => boolean ? _formKey.currentState!.reset() : "");
                        }
                      },
                    ),
                    top: 0,
                    bottom: 0,
                    right: 5,
                  )
                ],
              ),
              Container(
                child: FutureBuilder(
                    future: _getComments(context, {'parentDocId': widget.details['docId'],
                      "country": widget.details['doc']['country'],
                      "city": widget.details['doc']['city'],
                    }),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasError && snapshot.data != null) {
                        _comments = snapshot.data;
                        return Scrollbar(
                          controller: _controllerOne,
                          isAlwaysShown: true,
                          thickness: 10.0,
                          child: ListView.builder(
                              controller: _controllerOne,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _comments.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: myPrimaryColor, width: 1.0),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CommentArea(
                                              uid: widget.details['uid'],
                                              dutyId: widget.details['docId'],
                                              replies: _comments[i]['reply'],
                                              comment: _comments[i]['docData'],
                                              country: widget.details['doc']['country'],
                                              city: widget.details['doc']['city'],
                                              parentId: _comments[i]['docId']))),
                                );
                              }),
                        );
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommentArea extends StatefulWidget {
  final comment, uid, parentId, replies, dutyId, country, city;

  const CommentArea({
    Key? key,
    required this.comment,
    required this.dutyId,
    required this.city,
    required this.country,
    required this.parentId,
    required this.replies,
    required this.uid,
  }) : super(key: key);

  @override
  _CommentAreaState createState() => _CommentAreaState();
}

class _CommentAreaState extends State<CommentArea> {
  bool _showReplyBox = false;
  Map<String, dynamic> _inputCommentReply = Map<String, dynamic>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.comment['comment']}", style: TextStyle(fontWeight: FontWeight.bold)),
        Divider(),
        widget.replies.length != 0
            ? _replyMaker(context, widget.replies)
            : SizedBox(
                height: 0,
                width: 0,
              ),
        TextButton(
            child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _showReplyBox ? 'Hide' : 'reply',
                  style: TextStyle(color: myPrimaryColor),
                )),
            onPressed: () {
              setState(() {
                _showReplyBox = !_showReplyBox;
              });
            }),
        Visibility(
            visible: _showReplyBox,
            child: Stack(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 20,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 40.0, left: 8.0, top: 8.0, bottom: 8.0),
                        filled: true,
                        fillColor: mySecondaryColor,
                        border: OutlineInputBorder(borderSide: BorderSide(color: myPrimaryColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: mySecondaryColor)),
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                        hintText: '► Reply to comment...'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Value shouldn't be empty.";
                      } else
                        _inputCommentReply = {
                          "docId": widget.parentId, // for path
                          "dutyId": widget.dutyId, // for name of comment-Doc
                          "parent": widget.comment['userId'],
                          "country": widget.country,
                          "city": widget.city,
                          "userId": widget.uid,
                          "comment": value
                        };
                      return null;
                    },
                  ),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: myPrimaryColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _makeComment(context, _inputCommentReply).then((boolean) => boolean
                                ? {
                                    _formKey.currentState!.reset(),
                                    setState(() {
                                      _showReplyBox = !_showReplyBox;
                                    })
                                  }
                                : "");
                          }
                        })),
              ],
            )),
      ],
    );
  }
}

Widget _replyMaker(BuildContext context, List replies) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: replies.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
              decoration: BoxDecoration(color: myTertiaryColor, borderRadius: BorderRadius.circular(10.0)),
              child: Padding(padding: const EdgeInsets.all(8.0), child: Text("► ${replies[i]['comment']}"))),
        );
      });
}

Future<bool> _makeComment(BuildContext context, Map<String, dynamic> body) async {
  Map<String, dynamic> jsonResponse = new Map<String, dynamic>();
  final response = await http.post(
    Uri.parse('$API_URL/duty/addComment'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: convert.jsonEncode(body),
  );
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Publishing comment...")));
  if (response.statusCode == 200) {
    jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Comment made")));
    _getComments(context, {
      'parentDocId' : body['dutyId'],
      'city' : body['city'],
      'country' : body['country'],
    });
    return true;
  } else if (response.statusCode == 400) {
    jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['error'])));
    return false;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error while publishing comment!")));
    return false;
  }
}

Future _getComments(BuildContext context, dynamic dutyDetails, ) async {
  Map<String, dynamic> jsonResponse = new Map<String, dynamic>();
  try {
    final response = await http.post(Uri.parse('$API_URL/duty/getComments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(dutyDetails),
    );
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['result'];
    } else if (response.statusCode == 400) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['error'])));
      return null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error while connecting to server ❌")));
      return null;
    }
  } catch (e) {
    print('try catch error: $e');
    return null;
  }
}
