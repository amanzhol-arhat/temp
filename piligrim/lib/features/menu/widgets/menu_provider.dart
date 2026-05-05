import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MenuMode { video, list }

final menuViewModeProvider = StateProvider<MenuMode>((ref) => MenuMode.video);
