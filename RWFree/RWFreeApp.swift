
import SwiftUI

@main
struct RWFreeApp: App {
  @StateObject private var store = EpisodeStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(store)
        }
    }
}
