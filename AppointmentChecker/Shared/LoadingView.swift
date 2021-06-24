//
//  LoadingView.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 6/23/21.
//

import Foundation
import SwiftUI

struct LoadingView: View {
  let style = StrokeStyle(lineWidth: 6, lineCap: .round)
  let backgroundColor = Color.gray
  let strokeColor = Color.gray.opacity(0.5)
  
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .trim(from: 0, to: 0.7)
          .stroke(AngularGradient(gradient: .init(colors: [backgroundColor, strokeColor]), center: .center))
          .rotationEffect(Angle(degrees: 360))
          .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
      }
    }.padding().frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
  }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
      LoadingView()
    }
}
