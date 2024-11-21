import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:chambeape/infrastructure/models/users_work_img.dart';
import 'package:chambeape/services/media/MediaService.dart';
import 'package:chambeape/services/users/user_works_service.dart';
import 'package:flutter/material.dart';

class MyWorksDefault extends StatefulWidget {

  final TextTheme text;
  final int userId;
  final bool isCurrentUser;

  const MyWorksDefault({
    super.key,
    required this.text, 
    required this.userId,
    required this.isCurrentUser,
  });

  @override
  State<MyWorksDefault> createState() => _MyWorksDefaultState();
}

class _MyWorksDefaultState extends State<MyWorksDefault> {
  Future<void> _createUserIfNotExists() async {
    await UserWorksService().createUserIfNotExists(widget.userId);
  }

  Future<UsersWorkImg> _loadUserImages() async {
    var userImages = await UserWorksService().getImageUrlsByUserId(widget.userId);
    return userImages;
  }
  Future<void> _uploadUserImage(int userId, File? image) async {
    if (image != null) {
      await UserWorksService().uploadUserImage(userId, image);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Mis Trabajos',
            style: widget.text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 450,
          width: double.infinity,
          child: FutureBuilder(
            future: _loadUserImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: _SwiperErrorWidget(),
                );
              } else if (!snapshot.hasData || snapshot.data!.imageUrls.isEmpty) {
                  return const _SwiperErrorWidget();
              }
              else {
                return Swiper(
                  viewportFraction: 0.8,
                  scale: 0.9,
                  autoplay: true,
                  pagination: SwiperPagination(
                    margin: const EdgeInsets.only(top: 10),
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: Colors.amber[700],
                    ),
                  ),
                  itemCount: snapshot.data!.imageUrls.length,
                  itemBuilder: (context, index) {
                    return _ImageWithContent(index: index, imageUrl: snapshot.data!.imageUrls[index]);
                  },
                );
              }
            },
          ),
        ),
        if (widget.isCurrentUser) 
        FilledButton.icon(
          onPressed: () async {
            await _createUserIfNotExists();
            File? image = await MediaService().getImageFromGallery();
            await _uploadUserImage(widget.userId, image);
            setState(() {});
          },
          label: const Text('Agregar Foto'),
          icon: const Icon(Icons.add_a_photo_outlined)
        )
      ],
    );
  }
}

class _SwiperErrorWidget extends StatelessWidget {
  const _SwiperErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Swiper(
      viewportFraction: 0.8,
      scale: 0.9,
      autoplay: true,
      pagination: SwiperPagination(
        margin: const EdgeInsets.only(top: 10),
        builder: DotSwiperPaginationBuilder(
          color: Colors.grey,
          activeColor: Colors.amber[700],
        ),
      ),
      itemCount: 1,
      itemBuilder: (context, index) {
        return const _ImageWithoutContent();
      },
    );
  }
}

class _ImageWithoutContent extends StatelessWidget {
  const _ImageWithoutContent();

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 10),
        ),
      ],
    );

    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: DecoratedBox(
              decoration: decoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/default_works_image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                    );
                  },
                ),
              )),
        ));
  }
}

class _ImageWithContent extends StatelessWidget {

  final int index;
  final String imageUrl;
  const _ImageWithContent({
    required this.index, 
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
