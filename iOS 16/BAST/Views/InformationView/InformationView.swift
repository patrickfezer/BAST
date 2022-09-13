//
//  InformationView.swift
//  BAST
//
//  Created by Patrick Fezer on 25.08.22.
//

import SwiftUI

struct InformationView: View {
    @Binding var dismiss: Bool
    @State private var showFileExporter = false
    let logger = TextLogger()
    let urlPrivacy = URL(string: "https://www.fezerapps.com/bast-privacy")!
    let urlWebsite = URL(string: "https://www.fezerapps.com")!
    
    var document: Doc
    {
        return Doc(initialText: logger.convertToString())
    }
    
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
                    Text("infoHeader")
                        .textCase(nil)
                }
                
                Section {
                    Button {
                        showFileExporter.toggle()
                        logger.log("Logfile exported")
                    } label: {
                        LabelIconView(icon: "square.and.arrow.up", iconColor: .white, backgroundColor: .orange, text: Text("exportLogfile"))
                    }
                    
                    Link(destination: urlPrivacy)
                    {
                        LabelIconView(icon: "hand.raised.fill", iconColor: .white, backgroundColor: .blue, text: Text("privacy"))
                    }

                
                } header: {
                    Text("servicePrivacy")
                        .textCase(nil)
                }

                
                Section {
                    Link(destination: urlWebsite) {
                        LabelIconView(icon: "globe", iconColor: .white, backgroundColor: .blue, text: Text("website"))
                    }
                } header: {
                    Text("developer")
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
            
            .fileExporter(isPresented: $showFileExporter, document: document, contentType: .log, defaultFilename: "log_BAST.log") { result in
                print("File exporter started")
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(dismiss: .constant(false))
    }
}
