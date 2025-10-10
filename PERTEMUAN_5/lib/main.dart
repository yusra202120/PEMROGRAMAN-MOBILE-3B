import 'package:flutter/material.dart';

// Fungsi utama untuk menjalankan aplikasi
void main() {
  runApp(AplikasiLirik());
}

// Widget utama aplikasi
class AplikasiLirik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Lirik Lagu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HalamanLirik(),
    );
  }
}

// Halaman yang menampilkan lirik
class HalamanLirik extends StatefulWidget {
  @override
  State<HalamanLirik> createState() => _HalamanLirikState();
}

class _HalamanLirikState extends State<HalamanLirik> {
  // Variable untuk menyimpan lirik lagu (pisah bait pakai \n\n)
  String lirikLagu = '''
His laugh you'd die for, his laugh you'd die for
The kind that colors the sky
Heart intangible, slips away faster than
Dandelion fluff in the sunlight
And he's got swirls of passion in his eyes
Uncoverin' the dreams, he dreams at night
As much and hard as he tries to hide
I can see right through, see right through

His voice you'd melt for, he says my name like
I'd fade away somehow if he's too loud
What I would give for me to get my feet
Back on the ground, head off the clouds
I laugh at how we're polar opposites
I read him like a book, and he's a clueless little kid
Doesn't know that I'd stop time and space
Just to make him smile, make him smile

Oh, why can't we for once
Say what we want, say what we feel?
Oh, why can't you for once
Disregard the world, and run to what you know is real?
Take a chance with me, take a chance with me
Ooh-ooh, ooh-ooh
Ooh-ooh, ooh-ooh

His kiss you'd kill for, just one and you're done for
Electricity surgin' in the air
He drives me crazy, it's so beyond me
How he'd look me dead in the eye and stay unaware
That I'm hopelessly captivated
By a boy who thinks love's overrated
How did I get myself in this arrangement?
It baffles me, too, baffles me, too
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 32),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz, size: 28),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Album Art
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE91E63),
                        Color(0xFF9C27B0),
                        Color(0xFF673AB7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 40,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Info Lagu
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Take A Chance With Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Niki',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.white.withOpacity(0.6),
                    size: 28,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Tab Lyrics
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    'Lyrics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Lirik (per paragraf)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: lirikLagu
                      .split("\n\n") // Pisah bait dengan 2 newline
                      .map((paragraf) => Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              paragraf,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
