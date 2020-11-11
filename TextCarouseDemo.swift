import Combine
import SwiftUI

struct TextCarouselDemo: View {
    @State var offsetY: CGFloat = 0
    var cancellable: AnyCancellable?
    let publisher = CarouselActionPublisher(count: 3, animationTime: 0.25)
    init() {
    }
    var body: some View {
        Group {
            Group {
                Text("基础")
                    .frame( height: 18)
                Text("性能")
                    .frame( height: 18)
                Text("赛道")
                    .frame( height: 18)
                Text("基础")
                    .frame( height: 18)
            }.offset(x: 0, y: offsetY)
        }.onReceive(publisher.$carouselAction, perform: { (output) in
            if output == .next {
                withAnimation(.linear(duration: 0.25)) {
                    self.offsetY -= 18
                }
            } else {
                self.offsetY = 0
            }
        })
        
        .frame(width: UIScreen.main.bounds.width, height: 18, alignment: .top)
        .clipped()
    }
}

enum CarouselAction {
    case next, reset
}

class CarouselActionPublisher: ObservableObject {
    @Published var carouselAction: CarouselAction?
    private let timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
    private var index = 0
    private let count: Int
    private var cancellable: Cancellable?
    private var anyCancellable: AnyCancellable?
    init(count: Int, animationTime: TimeInterval) {
        self.count = count
        if count <= 1 {
            return
        }
        cancellable = timer.connect()
        anyCancellable = timer.sink { [weak self](date) in
            self?.index += 1
            if self?.index == count {
                self?.index = 0
            }
            if self?.index == 0 {
                self?.carouselAction = .next
                DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                    self?.carouselAction = .reset
                }
            } else {
                self?.carouselAction = .next
            }
        }
    }
}
