import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/game/finder/components/background_image.dart';

import 'package:flutter_game_challenge/game/finder/components/item.dart';
import 'package:flutter_game_challenge/game/finder/components/overlay.dart';

class FinderWorld extends World with HasGameReference, HasCollisionDetection {
  static const double kTopGap = 200;
  static const double _kPlayAreaHeight = 6 * 256 + kTopGap;
  static const double _kPlayAreaWidth = 4 * 256;

  static const worldAreaRect = Rect.fromLTRB(0, 200, 1024, 2220);

  final List<String> _itemTypes = [
    Assets.images.duck.path,
    Assets.images.cheese.path,
    Assets.images.cup.path,
    Assets.images.concrete.path,
    Assets.images.gamepad.path,
  ];

  List<Item> collectedItems = List.empty(growable: true);

  @override
  Future<void> onLoad() async {
    final playAreaSize = Vector2(_kPlayAreaWidth, _kPlayAreaHeight);
    _setupCamera(game.size);

    await _loadImageAssets();
    final items = _generateTrashItems();

    addAll(
      [
            BackgroundImage(
              sprite: Sprite(
                Flame.images.fromCache(Assets.images.fog.path),
              ),
            )..priority = 1,
            OverlayFog()
              ..priority = 4
              ..size = playAreaSize,
          ] +
          items,
    );
  }

  List<Item> _generateTrashItems() {
    final double cellWidth = 50;
    final double cellHeight = 50;
    final sidePadding = 5;
    final topPadding = 5;

    final columns = ((game.size.x - 2 * sidePadding) / cellWidth).floor();
    final rowsCount = ((game.size.y - topPadding) / cellHeight).floor();

    final random = Random();

    final generatedList = <Item>[];

    for (var row = 0; row < rowsCount; ++row) {
      for (var col = 0; col < columns; ++col) {
        final xOffset = (row.isEven) ? 20 : 0;

        final targetPosition = Vector2(
          col * cellWidth + cellWidth / 2 + sidePadding + xOffset,
          row < rowsCount
              ? game.size.y - (row + 1) * cellHeight
              : game.size.y + (row - rowsCount) * cellHeight,
        );

        final randomInt = random.nextInt(_itemTypes.length);
        final itemFromRandom = Item(
          sprite: Sprite(Flame.images.fromCache(_itemTypes[randomInt])),
          position: targetPosition,
        )..size = Vector2(cellWidth, cellWidth);
        generatedList.add(itemFromRandom);
      }
    }

    return generatedList;
  }

  Future<void> _loadImageAssets() async {
    Flame.images.prefix = '';
    await Flame.images.load(Assets.images.fog.path);
    await Flame.images.load(Assets.images.holeMask.path);
    await Flame.images.loadAll(_itemTypes);
  }

  void _setupCamera(Vector2 playAreaSize) {
    final gameMidX = playAreaSize.x / 2;
    final camera = game.camera;
    camera.viewfinder.visibleGameSize = playAreaSize;
    camera.viewfinder.position = Vector2(gameMidX, 0);
    camera.viewfinder.anchor = Anchor.topCenter;
  }
}
