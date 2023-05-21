//
//  FlagView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import SwiftUI


struct YellowZoneEventData {
    let fingerIndex: Int
    let xPercentage: CGFloat
    let yPercentage: CGFloat
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
}

struct FlagView: View, TwoZoneHandler {
    let flagModel: FlagModel
    let isBlueViewHidden: Bool
    
    @Binding var isBlueZoneTapped: Bool
    @Binding var isYellowZoneTapped: Bool
    
    @GestureState private var dragState = DragState.inactive
    @State private var yellowZoneTouches: [Int: CGPoint] = [:]
    
    private var cornerRadius: CGFloat {
        flagModel.width > flagModel.height ? flagModel.width / 15 : flagModel.height / 15
    }
    private var lineWidth: CGFloat {
        flagModel.width > flagModel.height ? flagModel.width / 100 : flagModel.height / 100
    }
    
    var body: some View {
        VStack {
            
            ForEach(Array(yellowZoneTouches.keys), id: \.self) { fingerIndex in
                Text("\(fingerIndex)")
            }
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Color.yellow
                        .frame(height: geometry.size.height * (isBlueViewHidden ? 1 : 0.7))
                        .gesture(dragGesture(proxy: geometry))
                        .onAppear {
                            yellowZoneTouches = [:]
                        }
                    
                    if !isBlueViewHidden {
                        Rectangle()
                            .fill(.black)
                            .frame(height: lineWidth)
                        
                        Color.blue
                            .animation(.easeInOut(duration: 1))
                            .frame(height: geometry.size.height * 0.3)
                            .gesture(blueZoneTap)
                    }
                }
                .cornerRadius(cornerRadius)
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.black, lineWidth: lineWidth)
                }
                .animation(.default.speed(3), value: isBlueViewHidden)
            }
            .frame(width: flagModel.width, height: flagModel.height)
            .offset(x: flagModel.positionX, y: flagModel.positionY)
        }
        
    }
    
    private var blueZoneTap: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard !isBlueZoneTapped else { return }
                isBlueZoneTapped = true
                DispatchQueue.main.async {
                    onBlueZoneEvent(isPressed: true)
                }
            }
            .onEnded { _ in
                isBlueZoneTapped = false
                onBlueZoneEvent(isPressed: false)
            }
    }
    
    private func dragGesture(proxy: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { value, state, _ in
                state = .dragging(translation: value.translation)
            }
            .onChanged { value in
                let touchLocation = value.location
                let fingerIndex = value.startLocation == touchLocation ? yellowZoneTouches.count : getFingerIndex(for: touchLocation)
                
                yellowZoneTouches[fingerIndex] = touchLocation
                
                if touchLocationIsInYellowZone(touchLocation, proxy: proxy) {
                    onYellowZoneEvent(fingerIndex: fingerIndex, touchLocation: touchLocation, proxy: proxy)
                }
            }
            .onEnded { value in
                let touchLocation = value.location
                let fingerIndex = getFingerIndex(for: touchLocation)
                yellowZoneTouches.removeValue(forKey: fingerIndex)
            }
    }
    
    func getFingerIndex(for touchLocation: CGPoint) -> Int {
        let sortedKeys = yellowZoneTouches.keys.sorted()
        let nextIndex = sortedKeys.last ?? 0
        return nextIndex
    }
    
    func touchLocationIsInYellowZone(_ location: CGPoint, proxy: GeometryProxy) -> Bool {
        let yellowRect = CGRect(x: proxy.frame(in: .local).origin.x, y: proxy.frame(in: .local).origin.x, width: proxy.size.width, height: isBlueViewHidden ? proxy.size.height : proxy.size.height * 0.7)
        
        return yellowRect.contains(location)
    }
    
    func onYellowZoneEvent(fingerIndex: Int, touchLocation: CGPoint, proxy: GeometryProxy) {
        let normalizedX = (touchLocation.x / proxy.size.width) * 100
        let normalizedY = (touchLocation.y / (isBlueViewHidden ? proxy.size.height : proxy.size.height * 0.7)) * 100
        
        let data = YellowZoneEventData(fingerIndex: fingerIndex, xPercentage: normalizedX, yPercentage: normalizedY)
        print("Yellow zone event: \(data)")
    }
    
    
}

struct FlagView_Previews: PreviewProvider {
    static var previews: some View {
        FlagView(flagModel: .mock, isBlueViewHidden: false, isBlueZoneTapped: .constant(false), isYellowZoneTapped: .constant(false))
    }
}
