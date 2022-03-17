
import SwiftUI

// https://bit.ly/3cVlzif
struct ActivityIndicator: View {
  let style = StrokeStyle(lineWidth: 6, lineCap: .round)
  @State private var animate = false

  let color1 = Color.gradientDark
  let color2 = Color.gradientLight

  var body: some View {
    ZStack {
      Circle()
        .trim(from: 0, to: 0.7)
        .stroke(
          AngularGradient(
            gradient: .init(colors: [color1, color2]),
            center: .center),
          style: style)
        .rotationEffect(Angle(degrees: animate ? 360 : 0))
    }
    .onAppear {
      withAnimation(Animation.linear(duration: 0.7)
                      .repeatForever(autoreverses: false)) {
        animate.toggle()
      }
      
    }
  }
}
