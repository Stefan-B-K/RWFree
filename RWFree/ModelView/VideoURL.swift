import SwiftUI

class VideoURL: ObservableObject {
  @Published var urlString = ""

  init(videoId: Int) {
    let baseURLString = "https://api.raywenderlich.com/api/videos/"
    let queryURLString = baseURLString + String(videoId) + "/stream"
    guard let queryURL = URL(string: queryURLString) else { return }
    URLSession.shared.dataTask(with: queryURL) { data, response, error in
      if let data = data, let response = response as? HTTPURLResponse {
        if response.statusCode != 200 {
          print("\(videoId) \(response.statusCode)")
          return
        }
        if let decodedResponse = try? JSONDecoder().decode(
          VideoURLString.self, from: data) {
          self.urlString = decodedResponse.urlString
        }
      } else {
        print("Videos fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
    .resume()
  }
}

struct VideoURLString {
  var urlString: String

  enum CodingKeys: CodingKey {
    case data
  }

  enum DataKeys: CodingKey {
    case attributes
  }
}

struct VideoAttributes: Codable {
  var url: String
}

extension VideoURLString: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
    let attr = try dataContainer.decode(VideoAttributes.self, forKey: .attributes)
    urlString = attr.url
  }
}
