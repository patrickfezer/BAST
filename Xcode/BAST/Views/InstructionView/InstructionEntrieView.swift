//
//  InstructionEntrieView.swift
//  BAST
//
//  Created by Patrick Fezer on 25.08.22.
//

import SwiftUI

struct InstructionEntrieView: View {
    let step: String
    let text: Text
    let systemImage: String
    let backgroundColor: Color
    let iconColor: Color
    
    var body: some View {
        HStack {
            HStack
            {
                
                ZStack(alignment: .center)
                {
                    Text(step)
                    Circle()
                        .stroke(Color("Circle"), lineWidth: 2)
                        .frame(width: 25)
                }
                
                
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 19, height: 19, alignment: .center)
                    .padding(5)
                    .foregroundColor(iconColor)
                    .background(backgroundColor)
                    .cornerRadius(6)
                    .padding(.leading, 5)
                    
                text
                    .padding(.leading, 10)
     
            }
            Spacer()
        }
        .padding(10)
    }
}

struct InstructionEntrieView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionEntrieView(step: "1", text: Text("Placeholder"), systemImage: "gear", backgroundColor: .gray, iconColor: .white)
    }
}
