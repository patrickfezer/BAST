//
//  ContentView.swift
//  BAST
//
//  Created by Patrick Fezer on 23.08.22.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    @State private var showImportView = false
    @State private var showInformationView = false
    @State private var showMailSheet = false
    @State private var showMailAlert = false
    @State private var showFAQSheet = false
    @State private var wrongFileAlert = false
    @State private var header = Text("headerUserGuide")
    @State private var result: Result<MFMailComposeResult, Error>? = nil

    let appInformationString = "\n\n________________\nVersion: \(AppInformation.appVersion + " (\(AppInformation.buildVersion))")\nDevice: \(AppInformation.device)\n \(AppInformation.systemVersion)"
    @State private var file = Data()
    let bm = BatteryManager()
    
    var body: some View {
        NavigationView
        {
            Group
            {
                if !file.isEmpty
                {
                    List
                    {
                        Section("Capacity & Cycles")
                        {
                            bm.batteryKeyAsText(data: file, label: "Current Capacity", key1: .nominalChargeCapacity, key2: nil)
                            bm.batteryKeyAsText(data: file, label: "Design Capacity", key1: .designCapacity, key2: nil)
                            bm.batteryKeyAsText(data: file, label: "Maximum Capacity", key1: .maxFCC, key2: nil)
                            bm.batteryKeyAsText(data: file, label: "Minimum Capacity", key1: .minFCC, key2: nil)
                            bm.batteryKeyAsText(data: file, label: "Cycle Count", key1: .cycleCount, key2: nil)
                        }
                        
                                
                        Section("Health")
                        {
                            bm.batteryKeyAsText(data: file, label: "Current Health", key1: .nominalChargeCapacity, key2: .designCapacity)
                            bm.batteryKeyAsText(data: file, label: "Minimum Health", key1: .nominalChargeCapacity, key2: .maxFCC)
                            bm.batteryKeyAsText(data: file, label: "Original Health", key1: .maxFCC, key2: .designCapacity)
                            
                        }
                        
                        Section {
                            Text("disclaimer")
                        } header: {
                            Text("Disclaimer")
                        }
                    }
                } else
                {
                    InstructionView()
                }
            }
                .navigationTitle(header)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        Button
                        {
                            self.showImportView.toggle()
                        } label:
                        {
                            Text("import")
                        }

                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Menu
                        {
                            
                            if !file.isEmpty
                            {
                                Button
                                {
                                    file = Data() // Delete Files
                                } label: {
                                    Label("userGuide", systemImage: "globe")
                                }
                            }
                            

                            
                            // Privacy
                            let urlPrivacy = URL(string: "https://www.fezerapps.com/bast-privacy")!
                            Link(destination: urlPrivacy)
                            {
                                Label("Privacy", systemImage: "hand.raised.fill")
                            }
                            
                            // InformationSheet
                            Button
                            {
                                showInformationView.toggle()
                            } label: {
                                Label("Info", systemImage: "info.circle.fill")
                            }
                            
                            Button {
                                showFAQSheet.toggle()
                            } label: {
                                Label("FAQ", systemImage: "person.fill.questionmark")
                            }

                            
                            // MailSheet
                            Button {
                                if MFMailComposeViewController.canSendMail() {
                                    self.showMailSheet = true
                                } else
                                {
                                    showMailAlert = true
                                }
                            } label: {
                                Label("Contact", systemImage: "envelope.fill")
                            }

 
                        } label: {
                            Text("help")
                        }
                    }
                })
            
            // Trigger file change to change heaader value
            .onChange(of: file, perform: { newFileValue in
                if !newFileValue.isEmpty
                {
                    header = Text("headerBatteryHealth")
                } else
                {
                    header = Text("headerUserGuide")
                }
            })
            
            // Information Sheet
            .sheet(isPresented: $showInformationView, content:
            {
                    InformationView(dismiss: $showInformationView)
                        .interactiveDismissDisabled()
            })
            
            // Mail Sheet
            .sheet(isPresented: $showMailSheet, content: {
                MailView(result: $result, newSubject: "BAST", newMsgBody: appInformationString, mailAddress: "info@fezerapps.com")
            })
            
            // FAQ Sheet
            .sheet(isPresented: $showFAQSheet, content: {
                FAQView(dismiss: $showFAQSheet)
                    .interactiveDismissDisabled()
            })
            
            // Missing Mail App
            .alert(isPresented: $showMailAlert) {
                Alert(title: Text("mailNotFoundWarningTitle"), message: Text("mailNotFoundWarningDescription"), dismissButton: .default(Text("Ok")))
            }
            
            // Wrong File imported
            .alert(isPresented: $wrongFileAlert)
            {
                Alert(title: Text("wrongFileWarningTitle"), message: Text("wrongFileMsg"), dismissButton: .default(Text("Ok")))
            }
            
            .fileImporter(isPresented: $showImportView, allowedContentTypes: [.item], allowsMultipleSelection: false, onCompletion: { result in
                
                // Take File-handling to backgrpund Thread
                DispatchQueue.main.async
                {
                    do
                    {
                        // Get File URL
                        guard let selectedFile: URL = try result.get().first else { return }

                        // Handle Access
                        let canAccess = selectedFile.startAccessingSecurityScopedResource()
                        guard canAccess else
                        {
                            return
                        }

                        // Try to get data
                        let data = try! Data(contentsOf: selectedFile)
                    
                        // Dispose
                        selectedFile.stopAccessingSecurityScopedResource()
                        
                        // check if imported file is correct
                        
                        
                        if selectedFile.pathExtension != "ips"
                        {
                            wrongFileAlert.toggle()
                            self.file = Data() // reset file
                        } else
                        {
                            // set file to data
                            self.file = data
                        }
                        
                    } catch
                    {
                    // print error
                    print(error.localizedDescription)
                    }
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
            .preferredColorScheme(.dark)
    }
}
