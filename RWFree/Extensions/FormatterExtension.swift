
import Foundation

public extension DateFormatter {
  /// Convert /contents released_at String to Date
  static let apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter
  }()

  /// Format date to appear in EpisodeView and PlayerView
  static let episodeDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM yyyy"
    return formatter
  }()
  
}


public extension Formatter {
  /// Creates ISO8601DateFormatter that formats milliseconds
  static let iso8601: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [
      .withInternetDateTime,
      .withFractionalSeconds
    ]
    return formatter
  }()
}
