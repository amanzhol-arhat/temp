import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme.dart';
import '../../../../data/models/dish.dart';

class TikTokDishCard extends StatefulWidget {
  final Dish dish;

  const TikTokDishCard({super.key, required this.dish});

  @override
  State<TikTokDishCard> createState() => _TikTokDishCardState();
}

class _TikTokDishCardState extends State<TikTokDishCard> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    if (widget.dish.videoUrl != null && widget.dish.videoUrl!.isNotEmpty) {
      _videoController = VideoPlayerController.asset(widget.dish.videoUrl!)
        ..initialize()
            .then((_) {
              setState(() {
                _isVideoInitialized = true;
              });
              _videoController?.setLooping(true);
              _videoController?.play();
            })
            .catchError((error) {
              debugPrint('Ошибка загрузки видео: $error');
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. СЛОЙ ФОНА (Видео или заглушка)
        if (_isVideoInitialized && _videoController != null)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          )
        else
          Container(
            color: AppColors.earth,
            child: const Center(
              child: Icon(
                Icons.restaurant,
                size: 60,
                color: AppColors.earthDeep,
              ),
            ),
          ),

        // 2. СЛОЙ ГРАДИЕНТА
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.earthDeep.withValues(alpha: 0.4),
                  AppColors.earthDeep.withValues(alpha: 0.95),
                ],
                stops: const [0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // 3. СЛОЙ ИНФОРМАЦИИ О БЛЮДЕ
        Positioned(
          left: 20,
          right: 20,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.dish.name,
                style: const TextStyle(
                  color: AppColors.sky,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Museo Sans',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.dish.price} ₸',
                style: const TextStyle(
                  color: AppColors.steppe,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.dish.description,
                style: TextStyle(
                  color: AppColors.sky.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('${widget.dish.kcal} ккал'),
                  _buildTag(
                    'Б ${widget.dish.protein} Ж ${widget.dish.fat} У ${widget.dish.carbs}',
                  ),
                  if (widget.dish.tags.isNotEmpty)
                    _buildTag(widget.dish.tags.first, isAccent: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, {bool isAccent = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAccent
            ? AppColors.water.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAccent
              ? AppColors.water.withValues(alpha: 0.5)
              : AppColors.sky.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isAccent ? AppColors.water : AppColors.sky,
          fontSize: 11,
        ),
      ),
    );
  }
}
