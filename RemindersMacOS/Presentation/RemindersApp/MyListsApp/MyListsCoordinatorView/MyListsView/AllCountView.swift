//
//  AllCountView.swift
//  RemindersMacOS
//
//  Created by David Malicke on 2/16/22.
//

import SwiftUI

struct AllCountView: View {
    
    let count: Int
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "tray.circle.fill")
                    .font(.largeTitle)
                Text("mylists.text.all")
            }
            Spacer()
            VStack {
                Text("\(count)")
                    .font(.title)
                EmptyView()
            }
        }
        .padding()
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .padding()
    }
}
