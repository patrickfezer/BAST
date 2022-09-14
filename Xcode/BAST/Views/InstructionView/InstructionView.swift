//
//  InstructionView.swift
//  BAST
//
//  Created by Patrick Fezer on 25.08.22.
//

import SwiftUI

struct InstructionView: View {
    var body: some View {
        ScrollView
        {
            VStack
            {
                
//                HStack
//                {
//                    Text("userGuide")
//                        .font(.largeTitle)
//                    Spacer()
//                }
//                .padding(10)
                
                    
                InstructionEntrieView(step: "1", text: Text("openSettings"), systemImage: "gear", backgroundColor: .gray, iconColor: .white)
                InstructionEntrieView(step: "2", text: Text("privacySecurity"), systemImage: "hand.raised.fill", backgroundColor: .blue, iconColor: .white)
                InstructionEntrieView(step: "3", text: Text("analysisImprovement"), systemImage: "hand.raised.fill", backgroundColor: .blue, iconColor: .white)
                InstructionEntrieView(step: "4", text: Text("analysisData"), systemImage: "hand.raised.fill", backgroundColor: .blue, iconColor: .white)
                InstructionEntrieView(step: "5", text: Text("searchFileMsg"), systemImage: "square.and.arrow.up", backgroundColor: .orange, iconColor: .white)
                InstructionEntrieView(step: "6", text: Text("importLogfileMsg"), systemImage: "square.and.arrow.down", backgroundColor: .green, iconColor: .white)
                InstructionEntrieView(step: "7", text: Text("useFAQMsg"), systemImage: "questionmark.circle", backgroundColor: .red, iconColor: .white)
            }
            .padding(5)
        }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
            .previewDevice("iPhone 13")
            .preferredColorScheme(.dark)
    }
}
