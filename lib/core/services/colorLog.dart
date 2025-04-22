void clog(String c, dynamic message) {
  final colors = {
    'r': '\x1B[31m', // Red
    'g': '\x1B[32m', // Green
    'y': '\x1B[33m', // Yellow
    'b': '\x1B[34m', // Blue
    'w': '\x1B[37m', // White
    'd': '\x1B[1m',  // Bold
    'x': '\x1B[0m',  // Reset
  };

  final safeColor = colors[c] ?? '';
  final safeMessage = message?.toString() ?? 'null';

  // Use stdout.write to avoid any automatic newline weirdness
  print('$safeColor$safeMessage\x1B[0m'); // 👈 always reset
}
