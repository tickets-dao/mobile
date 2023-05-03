import 'dart:math';

int getRandom(int max) => Random().nextInt(max);
Duration getRandomDuration(int max) => Duration(seconds: getRandom(max));
