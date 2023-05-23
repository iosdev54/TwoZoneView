//
//  FlagView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import SwiftUI

struct FlagView: View, TwoZoneHandler {
    let flagModel: FlagModel
    let isBlueViewHidden: Bool
    
    @Binding var isBlueZoneTapped: Bool
    @Binding var isYellowZoneTapped: Bool
    
    @Binding var outputYellowZone: String
    
    private var cornerRadius: CGFloat {
        flagModel.width > flagModel.height ? flagModel.width / 15 : flagModel.height / 15
    }
    private var lineWidth: CGFloat {
        flagModel.width > flagModel.height ? flagModel.width / 100 : flagModel.height / 100
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    YellowZoneRepresentable { data in
                        onYellowZoneEvent(idx: data.fingerIndex, x: data.xPercentage, y: data.yPercentage)
                    } fingersIndexesArray: { indexes in
                        outputYellowZone = indexes.description
                    }
                    .frame(height: geometry.size.height * (isBlueViewHidden ? 1 : 0.7))
                    
                    if !isBlueViewHidden {
                        Rectangle()
                            .fill(.black)
                            .frame(height: lineWidth)
                        
                        BlueZoneRepresentable { bool in
                            onBlueZoneEvent(isPressed: bool)
                            bool == true ? (isBlueZoneTapped = true) : (isBlueZoneTapped = false)
                        }
                        .frame(height: geometry.size.height * 0.3)
                        
                        //Можно использовать такой способ, но может нарушиться обработка касаний, так как при нажатии сначала синей зоны - желтую будет нажать невозможно, что противоречит условию!
                        //                        Color.blue
                        //                            .frame(height: geometry.size.height * 0.3)
                        //                            .gesture(blueZoneTap)
                        
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
    
    //    private var blueZoneTap: some Gesture {
    //        DragGesture(minimumDistance: 0)
    //            .onChanged { _ in
    //                guard !isBlueZoneTapped else { return }
    //                isBlueZoneTapped = true
    //                DispatchQueue.main.async {
    //                    onBlueZoneEvent(isPressed: true)
    //                }
    //            }
    //            .onEnded { _ in
    //                isBlueZoneTapped = false
    //                onBlueZoneEvent(isPressed: false)
    //            }
    //    }
}

struct FlagView_Previews: PreviewProvider {
    static var previews: some View {
        FlagView(flagModel: .mock, isBlueViewHidden: false, isBlueZoneTapped: .constant(false), isYellowZoneTapped: .constant(false), outputYellowZone: .constant("[0, 1]"))
    }
}
