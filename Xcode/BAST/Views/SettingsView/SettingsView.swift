//
//  SettingsView.swift
//  BAST
//
//  Created by Patrick Fezer on 14.02.24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppInformation.expertModeKey) private var expertMode = false
    @Binding var dismiss: Bool
    
    var body: some View {
        NavigationView {
            
            List {
                Section {
                    Toggle("expertModeButton", isOn: $expertMode)
                } header: {
                    Text("expertModeHeader")
                        .textCase(nil)
                } footer: {
                    Text("expertModeDesc")
                }
            }
            .navigationTitle(Text("expertModeHeader"))
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

#Preview {
    SettingsView(dismiss: .constant(false))
        .preferredColorScheme(.dark)
}
