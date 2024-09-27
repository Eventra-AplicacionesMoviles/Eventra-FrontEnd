import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class ReviewEventPage extends StatelessWidget {
  const ReviewEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Reviews',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFFFFA726)),
              onPressed: () {},
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 10),
              _buildReviewCard(
                  context,
                  'Emma Doe',
                  '10 Noviembre',
                  '¡Una experiencia inolvidable!',
                  'assets/review_profile_emma.png',
                  5.0),
              _buildReviewCard(
                  context,
                  'David Smith',
                  '13 Noviembre',
                  'Gran festival con un par de detalles a mejorar',
                  'assets/review_profile_david.png',
                  3.5),
              _buildReviewCard(
                  context,
                  'Carlos Miller',
                  '15 Noviembre',
                  'Buena música, pero algunos problemas logísticos',
                  'assets/review_profile_carlos.jpg',
                  4),
              _buildReviewCard(
                  context,
                  'Laura Jones',
                  '18 Noviembre',
                  '¡Fue un festival lleno de diversión y entretenimiento!',
                  'assets/review_profile_laura.jpeg',
                  4.5),
              /*Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Escribe tu reseña',
                      style: TextStyle(color: Colors.white)),
                ),
              )*/
            ])));
  }

  Widget _buildReviewCard(BuildContext context, String name, String date,
      String comment, String imagePath, double rating) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(imagePath, width: 80, fit: BoxFit.cover),
        ),
        title: Text(
          name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RatingBarIndicator(
                    rating: rating,
                    itemSize: 18,
                    unratedColor: Colors.grey,
                    itemBuilder: (_, __) => const Icon(Icons.star_rate_rounded,
                        color: Color(0xFFFFA726))),
                const SizedBox(width: 5),
                Text(date,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Column(
              children: [
                ReadMoreText(
                  comment,
                  style: const TextStyle(color: Colors.black),
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: 'show less',
                  trimCollapsedText: 'show more',
                  moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
                  lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
