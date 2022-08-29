//
//  FAQView.swift
//  BAST
//
//  Created by Patrick Fezer on 29.08.22.
//

import SwiftUI

struct FAQView: View {
    @Binding var dismiss: Bool
    var body: some View {
        NavigationView {
            List
            {
                Section {
                    Text("missingValuesDesc")
                } header: {
                    Text("missingValuesHeader")
                }
                
                Section {
                    Text("cannotOpenFileDesc")
                } header: {
                    Text("cannotImportFileHeader")
                }

            }
        .listStyle(SidebarListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("FAQ"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("close")
                {
                    dismiss.toggle()
                }
            }
        }
        }
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView(dismiss: .constant(false))
    }
}
