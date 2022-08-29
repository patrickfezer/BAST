//
//  InformationView.swift
//  BAST
//
//  Created by Patrick Fezer on 25.08.22.
//

import SwiftUI

struct InformationView: View {
    @Binding var dismiss: Bool
    
    var body: some View {
        NavigationView {
            List
            {
                Section {
                    HStack
                    {
                        Text("Version:")
                        Spacer()
                        Text("\(AppInformation.appVersion) (\(AppInformation.buildVersion))")
                    }
                } header: {
                    Text("App Information")
                        .textCase(nil)
                }
                
                Section {
                    let url = URL(string: "https://www.fezerapps.com")!
                    Link(destination: url) {
                        LabelIconView(icon: "globe", iconColor: .white, backgroundColor: .blue, text: Text("Website"))
                    }
                } header: {
                    Text("Developer")
                        .textCase(nil)
                } footer: {
                    Text("© Patrick Fezer")
                }


            }
            .navigationTitle(Text("App Information"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button("close")
                    {
                        dismiss = false
                    }
                }
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(dismiss: .constant(false))
    }
}
