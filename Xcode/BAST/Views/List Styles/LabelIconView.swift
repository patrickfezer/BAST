//
//  LabelIconView.swift
//  BAST
//
//  Created by Patrick Fezer on 25.08.22.
//

import SwiftUI

struct LabelIconView: View {
    
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let text: Text

    
    var body: some View {
        
        
        HStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 19, height: 19, alignment: .center)
                .padding(5)
                .foregroundColor(iconColor)
                .background(backgroundColor)
                .cornerRadius(6)
            
            // Show Text
            text
        }
        
    }
}

struct LabelIconView_Previews: PreviewProvider {
    static var previews: some View {
        LabelIconView(icon: "envelope.fill", iconColor: .white, backgroundColor: .blue, text: Text("Weiter"))
    }
}
