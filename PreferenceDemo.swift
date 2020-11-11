import SwiftUI
import Combine

let titles = ["关注", "推荐", "小视频"]

struct ContentView: View {

    private let coordinateSpace = UUID().uuidString

    @State var selectedIndex = 0

    var body: some View {
        HStack {
            ForEach(titles, id: \.self) { (title: String) -> AnyView in
                let index = titles.firstIndex(of: title)!
                return Text(title)
                    .onTapGesture {
                        selectedIndex = index
                    }
                    .background(
                        GeometryReader { proxy -> AnyView in
                            Circle()
                                .stroke(Color.clear)
                                .preference(key: FramePreferenceKey.self, value: [index: proxy.frame(in: .named(coordinateSpace))])
                                .erase()
                        }
                    )
                    .erase()
            }
        }
        .coordinateSpace(name: coordinateSpace)
        .overlayPreferenceValue(FramePreferenceKey.self, { value in
            let frame = value[selectedIndex]!
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.red)
                .frame(width: 6, height: 6)
                .position(frame.center)
                .offset(x: 0, y: frame.height / 2 + 8)
                .animation(.easeInOut)
        })
    }
}

extension View {
    func erase() -> AnyView {
        AnyView(self)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

struct FramePreferenceKey: PreferenceKey {

    typealias Value = [Int: CGRect]

    static var defaultValue = [Int : CGRect]()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        for (index, frame) in nextValue() {
            value[index] = frame
        }
    }

}
