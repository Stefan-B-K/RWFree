
import SwiftUI

struct Episode: Decodable, Identifiable {
  let id: String
  let uri: String
  let name: String
  let released: String
  let difficulty: String?
  let description: String                                           // description_plain_text
  let parentName: String?
  
  var domain = ""                                                   // relationships: domains: data: id
  
  var videoURL: VideoURL?                                           // send request to /videos endpoint with urlString
  
  var linkURLString: String {                                       // redirects to the real web page
    "https://www.raywenderlich.com/redirect?uri=" + uri
  }

  enum DataKeys: String, CodingKey {
    case id
    case attributes
    case relationships
  }

  enum AttrsKeys: String, CodingKey {
    case uri, name, difficulty
    case releasedAt = "released_at"
    case description = "description_plain_text"
    case videoIdentifier = "video_identifier"
    case parentName = "parent_name"
  }

  struct Domains: Codable {
    let data: [[String: String]]
  }

  enum RelKeys: String, CodingKey {
    case domains
  }

  static let domainDictionary = [
    "1": "iOS & Swift",
    "2": "Android & Kotlin",
    "3": "Unity",
    "5": "macOS",
    "8": "Server-Side Swift",
    "9": "Flutter"
  ]
}

extension Episode {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DataKeys.self)
    
    self.id = try container.decode(String.self, forKey: .id)

    let attrs = try container.nestedContainer(keyedBy: AttrsKeys.self, forKey: .attributes)
    self.uri = try attrs.decode(String.self, forKey: .uri)
    self.name = try attrs.decode(String.self, forKey: .name)
    let releasedAt = try attrs.decode(String.self, forKey: .releasedAt)
    let releaseDate = Formatter.iso8601.date(from: releasedAt)!
    self.released = DateFormatter.episodeDateFormatter.string(from: releaseDate)
    self.difficulty = try attrs.decode(String?.self, forKey: .difficulty)
    self.description = try attrs.decode(String.self, forKey: .description)
    let videoIdentifier = try attrs.decode(Int?.self, forKey: .videoIdentifier)
    if let videoId = videoIdentifier {
      self.videoURL = VideoURL(videoId: videoId)
    }
    self.parentName = try attrs.decodeIfPresent(String.self, forKey: .parentName)
    
    let rels = try container.nestedContainer(keyedBy: RelKeys.self, forKey: .relationships)
    let domains = try rels.decode(Domains.self, forKey: .domains)
    if let domainId = domains.data.first?["id"] {self.domain = Episode.domainDictionary[domainId] ?? ""}
  }
}

struct MiniEpisode: Codable {
  let id: String
  let name: String
  let released: String
  let domain: String
  let difficulty: String
  let description: String
}

extension Episode: Hashable {
  static func == (lhs: Episode, rhs: Episode) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
