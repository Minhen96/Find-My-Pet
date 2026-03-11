class ErrorUtils {
  /// Extracts a human-readable error message from various backend error payload structures.
  /// Handles nested maps, arrays, and direct string messages natively.
  static String extractErrorMessage(dynamic data) {
    if (data == null) return 'Unknown error occurred.';

    if (data is Map) {
      if (data.containsKey('message')) {
        final message = data['message'];

        // If it's a nested object {"message": {"message": [...]}}
        if (message is Map && message.containsKey('message')) {
          final innerMessage = message['message'];
          if (innerMessage is List) {
            return innerMessage.join('\n');
          } else {
            return innerMessage.toString();
          }
        }

        // If it's a direct array {"message": ["Must be a valid email"]}
        if (message is List) {
          return message.join('\n');
        }

        // If it's a direct string {"message": "Invalid credentials"}
        if (message is String) {
          return message;
        }
        return message.toString();
      }

      if (data.containsKey('error')) {
        return data['error'].toString();
      }
    }

    return data.toString();
  }
}
