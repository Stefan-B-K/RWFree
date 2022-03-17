//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  
  let sampleEpisode = MiniEpisode(
    id: "5117655",
    name: "SwiftUI vs. UIKit",
    released: "Sept 2019",
    domain: "iOS & Swift",
    difficulty: "beginner",
    description: "Learn about the differences between SwiftUI and"
      + "UIKit, and whether you should learn SwiftUI, UIKit, or "
      + "both.\n")

  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), episode: sampleEpisode)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), episode: sampleEpisode)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    let currentDate = Date()
    let episodes = readEpisodes()
    for index in 0 ..< episodes.count {
      let entryDate = Calendar.current.date(byAdding: .hour, value: index, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, episode: episodes[index])
      entries.append(entry)
    }
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
  
  func readEpisodes() -> [MiniEpisode] {
    var episodes: [MiniEpisode] = []
    let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("episodes.json")
    print(">>> \(archiveURL)")

    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        episodes = try JSONDecoder().decode([MiniEpisode].self, from: codeData)
      } catch {
        print("Error: Can’t decode contents")
      }
    }
    return episodes
  }

  
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let episode: MiniEpisode
}

struct RWFreeWidgetEntryView : View {
  @Environment(\.widgetFamily) var family

  var entry: Provider.Entry
  
  var body: some View {
      VStack(alignment: .leading, spacing: 6) {
        HStack {
          PlayButtonIcon(width: 40, height: 40, radius: 10)
            .unredacted()
          VStack(alignment: .leading) {
            Text(entry.episode.name)
              .font(.headline)
              .fontWeight(.bold)
            if family != .systemSmall {
              HStack {
                Text(entry.episode.released + "  ")
                Text(entry.episode.domain + "  ")
                Text(String(entry.episode.difficulty)
                  .capitalized)
              }
            } else {
              Text(entry.episode.released + "  ")
            }
          }
        }
        .foregroundColor(Color(UIColor.label))

        if family != .systemSmall {
          Text(entry.episode.description)
            .lineLimit(2)
        }
      }
      .padding(.horizontal)
      .background(Color.itemBkgd)
      .font(.footnote)
      .foregroundColor(Color(UIColor.systemGray))
      .widgetURL(URL(string: "rwfreeview://\(entry.episode.id)"))
  }
}

@main
struct RWFreeWidget: Widget {
  let kind: String = "RWFreeWidget"
    
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      RWFreeWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("RW Free")
    .description("Гледайте безплатните епизоди на raywenderlich.com")
    .supportedFamilies([.systemMedium])
  }
}




struct RWFreeWidget_Previews: PreviewProvider {
  static var previews: some View {
    let view = RWFreeWidgetEntryView(
      entry: SimpleEntry(
        date: Date(),
        episode: Provider().sampleEpisode))
    view.previewContext(WidgetPreviewContext(family: .systemSmall))
    view.previewContext(WidgetPreviewContext(family: .systemMedium))
    view.previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
