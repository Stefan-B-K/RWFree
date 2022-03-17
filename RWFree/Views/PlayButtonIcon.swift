
import SwiftUI

struct PlayButtonIcon: View {
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat

  let gradientColor = Gradient(colors: [Color.gradientDark, Color.gradientLight])
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: radius)
        .fill(LinearGradient(gradient: gradientColor, startPoint: .leading, endPoint: .trailing))
        .frame(width: width, height: height)
      Image(systemName: "play.circle.fill")
        .font(.title)
        .colorInvert()
    }
  }
}

struct PlayButtonIcon_Previews: PreviewProvider {
  static var previews: some View {
    PlayButtonIcon(width: 50, height: 50, radius: 10)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
