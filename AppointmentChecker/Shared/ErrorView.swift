//
//  ErrorView.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 6/24/21.
//

import Foundation
import SwiftUI

struct ErrorView: View {
  let style = StrokeStyle(lineWidth: 6, lineCap: .round)
  let backgroundColor = Color.gray
  let strokeColor = Color.gray.opacity(0.5)
  
  var body: some View {
    VStack {
      Text("Error View")
    }.padding()
  }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
      ErrorView()
    }
}
