import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> posts = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      setState(() {
        posts = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan Debug
      home: Scaffold(
        appBar: AppBar(
          title: Text('Consume API'),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Ubah warna latar belakang aplikasi
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                posts.isEmpty?
                 CircularProgressIndicator():
                     ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Card(
                            color: Color.fromARGB(255, 32, 117, 35), // Ubah warna latar belakang card menjadi hijau
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    post['title'],
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255), // Ubah warna teks judul menjadi putih
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    post['body'],
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255), // Ubah warna teks deskripsi menjadi putih
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FutureBuilder<List<dynamic>>(
                                  future: fetchComments(post['id']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final comments = snapshot.data!;
                                      return Column(
                                        children: comments
                                            .map(
                                              (comment) => ListTile(
                                                title: Text(
                                                  comment['name'],
                                                  style: TextStyle(
                                                    color: Color.fromARGB(255, 255, 255, 255), // Ubah warna teks komentar menjadi putih
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  comment['email'],
                                                  style: TextStyle(
                                                    color: Color.fromARGB(255, 255, 255, 255), // Ubah warna teks email menjadi putih
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Gagal memuat komentar',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255), // Ubah warna teks pesan error menjadi putih
                                        ),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                                SizedBox(height: 10),
                                FutureBuilder<List<dynamic>>(
                                  future: fetchPhotos(post['id']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final photos = snapshot.data!;
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: photos
                                              .map(
                                                (photo) => Container(
                                                  width: 200,
                                                  child: Card(
                                                    color: Color.fromARGB(255, 255, 255, 255), // Ubah warna latar belakang card foto menjadi putih
                                                    child: Column(
                                                      children: [
                                                        Image.network(
                                                          photo['url'],
                                                          height: 150,
                                                          width: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          photo['title'],
                                                          style: TextStyle(
                                                            color: Color.fromARGB(255, 0, 0, 0), // Ubah warna teks judul foto menjadi hitam
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Gagal memuat foto',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255), // Ubah warna teks pesan error menjadi putih
                                        ),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchComments(int postId) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/$postId/comments'));
    if (response.statusCode == 200) {
      final comments = jsonDecode(response.body) as List<dynamic>;
      return comments;
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<List<dynamic>> fetchPhotos(int albumId) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/albums/$albumId/photos'));
    if (response.statusCode == 200) {
      final photos = jsonDecode(response.body) as List<dynamic>;
      return photos;
    } else {
      throw Exception('Gagal memuat data');
    }
  }
}
