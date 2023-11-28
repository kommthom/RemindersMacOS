//
//  ColorListView.swift
//  RemindersMacOS
//
//  Created by David Malicke on 2/12/22.
//

import SwiftUI

struct ColorListView: View {
    
    let colors = [Color.red, Color.orange, Color.green, Color.blue, Color.purple]
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: selectedColor == color ? "record.circle.fill" : "circle.fill")
                    .foregroundColor(color)
                    .font(.system(size: 16))
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedColor = color
                    }
                
            }
        }
    }
}

#if DEBUG
struct ColorListView_Previews: PreviewProvider {
    static var previews: some View {
        ColorListView(selectedColor: .constant(.blue))
    }
}
#endif
