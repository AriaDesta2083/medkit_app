import 'package:flutter/material.dart';
import 'package:medkit_app/components/card_menu.dart';
import 'package:medkit_app/screens/rawat/components/card_item.dart';

class RawatJalanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rawat Jalan'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          CardMenu(text: 'Poli Spesialis Penyakit Dalam'),
          CardMenu(text: 'Poli Spesialis Anak'),
          CardMenu(text: 'Poli Spesialis Bedah'),
          CardMenu(text: 'Poli Spesialis Kandungan'),
          CardMenu(text: 'Poli Spesialis Mata'),
          CardMenu(text: 'Poli Spesialis Gigi & Mulut'),
          CardMenu(text: 'Poli Spesialis Syaraf'),
          CardMenu(text: 'Poli Spesialis Jantung'),
          CardMenu(text: 'Poli Spesialis Orthopedi'),
          CardMenu(text: 'Poli Spesialis Kulit dan Kelamin'),
          CardMenu(text: 'Poli Umum'),
          CardMenu(text: 'Poli KIA'),
        ],
      ),
    );
  }
}
