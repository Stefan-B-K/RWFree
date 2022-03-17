
import SwiftUI

struct HeaderView: View {
  let count: Int
  @State private var queryTerm = ""
  @State private var sortOn = "none"
  @EnvironmentObject var store: EpisodeStore
  
  let threeColumns = [
    GridItem(.flexible(minimum: 55)),
    GridItem(.flexible(minimum: 55)),
    GridItem(.flexible(minimum: 55))
  ]

  
  var body: some View {
    VStack {
      SearchField(queryTerm: $queryTerm)
      HStack {
        LazyVGrid(columns: threeColumns) {  // 1
          Button("Clear all") {
            queryTerm = ""
            store.baseParams["filter[q]"] = queryTerm
            store.clearQueryFilters()
            store.fetchContents()
          }
          .buttonStyle(HeaderButtonStyle())
          ForEach(
            Array(
              store.domainFilters.merging(store.difficultyFilters) { _, second in second }
              .filter { $0.value }.keys), id: \.self) { key in
            Button(store.filtersDictionary[key]!) {
              if Int(key) == nil {
                store.difficultyFilters[key]!.toggle()
              } else {
                store.domainFilters[key]!.toggle()
              }
              store.fetchContents()
            }
            .buttonStyle(HeaderButtonStyle())
          }
        }
        Spacer()
      }

      HStack {
        Text("\(count) Episodes")
        Menu("\(Image(systemName: "filemenu.and.cursorarrow"))") {
          Button("10 results/page") {
            store.baseParams["page[size]"] = "10"
              store.fetchContents()
          }
          Button("20 results/page") {
            store.baseParams["page[size]"] = "20"
              store.fetchContents()
          }
          Button("30 results/page") {
            store.baseParams["page[size]"] = "30"
              store.fetchContents()
          }
          Button("No change") { }
        }
        Spacer()
        Picker("", selection: $sortOn) {
          Text("New").tag("new")
          Text("Popular").tag("popular")
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 130)
        .background(Color.gray.opacity(0.8))
        .onChange(of: sortOn) { _ in
          store.baseParams["sort"] = sortOn == "new" ?
            "-released_at" : "-popularity"
          store.fetchContents()
        }

      }
      .foregroundColor(Color.white.opacity(0.6))
    }
    .font(.subheadline)
    .foregroundColor(.white)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .leading)
    .listRowInsets(EdgeInsets())
    .padding()
    .background(Color.topBkgd)
    .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
    .background(Color.listBkgd)
  }
}

struct SearchField: View {
  @EnvironmentObject var store: EpisodeStore
  @Binding var queryTerm: String

  var body: some View {
    ZStack(alignment: .leading) {
      if queryTerm.isEmpty {
        Text("\(Image(systemName: "magnifyingglass")) Search videos")
          .foregroundColor(Color.white.opacity(0.6))
      }
      TextField("",
        text: $queryTerm,
        onEditingChanged: { _ in },
        onCommit: {
          store.baseParams["filter[q]"] = queryTerm
          store.fetchContents()
        }
      )

    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.white.opacity(0.2)))
  }
}

struct HeaderButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      Image(systemName: "xmark")
      configuration.label
    }
    .padding(8)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.white.opacity(0.2))
    )
  }
}

struct HeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HeaderView(count: 42)
      .previewLayout(.sizeThatFits)
  }
}
