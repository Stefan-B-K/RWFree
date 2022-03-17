
import SwiftUI

/// HStack unless dynamic font size is XXL or larger
struct AdaptingStack<Content>: View where Content: View {
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  var content: () -> Content
  @Environment(\.sizeCategory) var sizeCategory

  var body: some View {
    switch sizeCategory {
    case
      .extraExtraLarge,
      .extraExtraExtraLarge,
      .accessibilityMedium,
      .accessibilityLarge,
      .accessibilityExtraLarge,
      .accessibilityExtraExtraLarge,
      .accessibilityExtraExtraExtraLarge:
      return AnyView(VStack(content: self.content).padding(.top, 10))
    default:
      return AnyView(HStack(alignment: .top, content: self.content))
    }
  }
}
