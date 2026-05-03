import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme.dart';
import '../../../../data/models/dish.dart';
import '../../../../data/models/cart_item.dart';
import '../../../../data/repositories/providers.dart';

class TikTokDishCard extends ConsumerStatefulWidget {
  final Dish dish;

  const TikTokDishCard({super.key, required this.dish});

  @override
  ConsumerState<TikTokDishCard> createState() => _TikTokDishCardState();
}

class _TikTokDishCardState extends ConsumerState<TikTokDishCard> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    // Если есть ссылка на локальное видео, пытаемся его загрузить
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
              // Игнорируем ошибку, если файла физически нет (будет показана заглушка)
              debugPrint('Ошибка загрузки видео: $error');
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // Метод для открытия комментариев в BottomSheet
  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.earthDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Отзывы (${widget.dish.comments.length})',
                style: const TextStyle(
                  color: AppColors.sky,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Museo Sans',
                ),
              ),
              const SizedBox(height: 16),
              if (widget.dish.comments.isEmpty)
                const Text(
                  'Пока нет отзывов',
                  style: TextStyle(color: AppColors.sky),
                ),
              ...widget.dish.comments.map(
                (comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.earth,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.sky.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.sky,
                              ),
                            ),
                            Text(
                              '✦' * comment.rating,
                              style: const TextStyle(
                                color: AppColors.steppe,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.text,
                          style: TextStyle(
                            color: AppColors.sky.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Читаем состояния избранного и корзины
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(widget.dish.id);

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
            color: AppColors.earth, // Фон-заглушка
            child: const Center(
              child: Icon(
                Icons.restaurant,
                size: 60,
                color: AppColors.earthDeep,
              ),
            ),
          ),

        // 2. СЛОЙ ГРАДИЕНТА (Для читаемости текста)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.earthDeep.withOpacity(0.4),
                  AppColors.earthDeep.withOpacity(0.95),
                ],
                stops: const [0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // 3. СЛОЙ ИНФОРМАЦИИ О БЛЮДЕ
        Positioned(
          left: 20,
          right: 80,
          bottom: 30, // Поднято для учета навигационной панели
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
                  color: AppColors.sky.withOpacity(0.8),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // КБЖУ и Теги
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

        // 4. СЛОЙ КНОПОК ДЕЙСТВИЙ (Справа снизу)
        Positioned(
          right: 16,
          bottom: 30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                isFavorite ? 'В избранном' : 'Нравится',
                color: isFavorite ? AppColors.fruit : AppColors.sky,
                onTap: () {
                  // Обновление состояния избранного
                  final notifier = ref.read(favoritesProvider.notifier);
                  if (isFavorite) {
                    notifier.state = {...favorites}..remove(widget.dish.id);
                  } else {
                    notifier.state = {...favorites}..add(widget.dish.id);
                  }
                },
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                Icons.chat_bubble_outline,
                '${widget.dish.comments.length}',
                onTap: () => _showCommentsBottomSheet(context),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                Icons.add_shopping_cart,
                'В корзину',
                onTap: () {
                  // Добавление в корзину
                  final cartNotifier = ref.read(cartProvider.notifier);
                  cartNotifier.state = [
                    ...cartNotifier.state,
                    CartItem(dish: widget.dish),
                  ];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.dish.name} добавлено',
                        style: const TextStyle(color: AppColors.steppe),
                      ),
                      backgroundColor: AppColors.earthDeep,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Виджет тегов
  Widget _buildTag(String text, {bool isAccent = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAccent
            ? AppColors.water.withOpacity(0.15)
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAccent
              ? AppColors.water.withOpacity(0.5)
              : AppColors.sky.withOpacity(0.2),
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

  // Виджет боковых кнопок
  Widget _buildActionButton(
    IconData icon,
    String label, {
    Color color = AppColors.sky,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.sky.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
