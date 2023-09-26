//
//  MapAnnotation.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 10/9/22.
//

import SwiftUI

struct MapAnnotationView: View {
    @State var scale = 0.0
    @State var pinTapped: Bool = false
    @State var angle = 0.0
    var bar: BarViewObject
    
    let didTapAnnotation: (() -> Void)
    
    var body: some View {
        ZStack {
            outerCircle()
            pin()
        }
        .onTapGesture {
            withAnimation {
                pinTapped.toggle()
                didTapAnnotation()
            }
        }
        .offset(y: pinTapped ? 0 : 5)
        .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
        .scaleEffect(pinTapped ? 1.5 : 1)
    }
    
    @ViewBuilder
    private func pin() -> some View {
        Circle()
            .fill(
                RadialGradient(colors: [.blue, .white], center: .topLeading, startRadius: 6, endRadius: 40)
            )
            .position(x: 10, y: 1)
            .frame(width: 20, height: 20, alignment: .center)
    }
    
    @ViewBuilder
    private func outerCircle() -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(
                RadialGradient(colors: [.gray], center: .topLeading, startRadius: 6, endRadius: 40)
            )
            .position(x: 0, y: 6)
            .frame(width: 2, height: 25, alignment: .bottom)

    }
}

struct MapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationView(bar: .init(name: "Dummy bar", address: "1 people place", location: .init(latitude: 42.4077573349121, longitude: -71.10387436973836), rating: 5), didTapAnnotation: { print("tapped") })
    }
}
