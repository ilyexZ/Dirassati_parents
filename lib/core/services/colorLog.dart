void clog(String c, String message) {
  final colors = {
    'r': '\x1B[31m', // Red
    'g': '\x1B[32m', // Green
    'y': '\x1B[33m', // Yellow
    'b': '\x1B[34m', // Blue
    'w': '\x1B[37m', // White
    'd': '\x1B[1m',  // Bold
    'x': '\x1B[0m',  // Reset
  };

  print('${colors[c] ?? colors['x']}$message\x1B[0m');
}
