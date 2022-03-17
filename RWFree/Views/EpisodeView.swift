
import SwiftUI

struct EpisodeView: View {
  @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
  @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
  var isIPad: Bool {
    horizontalSizeClass == .regular && verticalSizeClass == .regular
  }

  let episode: Episode

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      PlayButtonIcon(width: 40, height: 40, radius: 6)
        .unredacted()
      VStack(alignment: .leading, spacing: 6) {
        Text(episode.name)
          .font(.headline)
          .fontWeight(.bold)
          .foregroundColor(Color(UIColor.label))
        if episode.name == "Introduction" ||
          episode.name == "Conclusion" {
          Text(episode.parentName ?? "")
            .font(.subheadline)
            .foregroundColor(Color(UIColor.label))
            .padding(.top, -5.0)
        }
        AdaptingStack {
          Text(episode.released + "  ")
          Text(episode.domain + "  ")
          Text(String(episode.difficulty ?? "").capitalized)
        }
        Text(episode.description)
          .lineLimit(2)
      }
      .padding(.horizontal)
      .font(.footnote)
      .foregroundColor(Color(UIColor.systemGray))
    }
    .padding(10)
    .frame(width: isIPad ? 644 : nil)
    .background(Color.itemBkgd)
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 10)
  }
}

struct EpisodeView_Previews: PreviewProvider {
  static var previews: some View {
    EpisodeView(episode: EpisodeStore().episodes[0])
      .previewLayout(.sizeThatFits)
  }
}
