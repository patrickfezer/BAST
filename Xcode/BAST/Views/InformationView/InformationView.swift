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
    @EnvironmentObject var logger: TextLogger
    let urlPrivacy = URL(string: "https://www.fezerapps.com/bast-privacy")!
    let urlWebsite = URL(string: "https://www.fezerapps.com")!
    
    var document: TransferableDocument
    {
        return TransferableDocument(initialText: logger.convertToString())
    }
    
    @available(iOS 16, *)
    var sd: simpleDocument
    {
        return simpleDocument(context: logger.convertToString())
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
                    
//                    if #available(iOS 16, *), AppInformation.debug
//                    {
//                        ShareLink(item: sd ,preview: SharePreview("logfile")) {
//                            Text("Export")
//                        }
//                    }
                    
                    Button {
                        showFileExporter.toggle()
                        logger.log("Logfile exported")
                        logger.log("App Version: " + AppInformation.appVersion)
                        logger.log("Build Version: " + AppInformation.buildVersion)
                        logger.log("Device: " + AppInformation.device)
                        logger.log("System Version: " + AppInformation.systemVersion)
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
                
                if AppInformation.debug
                {
                    Section {
                        Button("Clear Logfile")
                        {
                            logger.clearLogfile()
                        }
                        
                        Button("Print all entries")
                        {
                            logger.printAllEntries()
                        }
                    } header: {
                        Text("Debug")
                    }
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
            .fileExporter(isPresented: $showFileExporter, document: document, contentType: .text, defaultFilename: "log_BAST.log") { result in
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
