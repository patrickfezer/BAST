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
            
            ScrollView
            {
                
                FAQListView(header: Text("missingValuesHeader"), content: Text("missingValuesDesc"))
                
                FAQListView(header: Text("strangeValuesHeader"), content: Text("strangeValuesDesc"))


                FAQListView(header: Text("cannotImportFileHeader"), content: Text("cannotOpenFileDesc"))

 
                FAQListView(header: Text("logfileMissingHeader"), content: Text("logfileMissingDesc"))
                
                // FAQListView(header: Text("healthCalcHeader"), content: Text("healthCalcDesc"))
                
                FAQListView(header: Text("diffrentValuesHeader"), content: Text("diffrentValuesDesc"))

            }
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

            .preferredColorScheme(.dark)
    }
}
