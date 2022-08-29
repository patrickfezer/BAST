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
                
                HStack
                {
                    Text("How does it work?")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(10)
                
                    
                InstructionEntrieView(step: "1", text: Text("Open Settings"), systemImage: "gear", backgroundColor: .gray, iconColor: .white)
                InstructionEntrieView(step: "2", text: Text("Privacy & Security"), systemImage: "hand.raised.fill", backgroundColor: .blue, iconColor: .white)
                InstructionEntrieView(step: "3", text: Text("Analytics & Improvements"), systemImage: "hand.raised.fill", backgroundColor: .blue, iconColor: .white)
                InstructionEntrieView(step: "4", text: Text("Analysis Data"), systemImage: "hand.raised.fill", backgroundColor: .blue, iconColor: .white)
                InstructionEntrieView(step: "5", text: Text("Search and open the latest \"log-aggregated\" entry.\nPlease export the logfile to Files-App using the Share Button on the top right side."), systemImage: "square.and.arrow.up", backgroundColor: .orange, iconColor: .white)
                InstructionEntrieView(step: "6", text: Text("If the file is not available, activate \"Share iPhone Analytics.\"\nIt can take up to 24h untill the file will be generated."), systemImage: "exclamationmark.circle", backgroundColor: .red, iconColor: .white)
                InstructionEntrieView(step: "7", text: Text("Please note that logfiles (perhabs personal information) will be sent to Apple if activated!"), systemImage: "exclamationmark.circle", backgroundColor: .red, iconColor: .white)
                InstructionEntrieView(step: "8", text: Text("Import the \"log-aggregated\"-file into the App using the Import Button on the top left site."), systemImage: "square.and.arrow.down", backgroundColor: .green, iconColor: .white)
                InstructionEntrieView(step: "9", text: Text("If values are missing or looking wrong, please try to import an older version of the logfile."), systemImage: "exclamationmark.circle", backgroundColor: .red, iconColor: .white)
            }
            .padding(5)
        }
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView()
            .previewDevice("iPhone 13")
    }
}
