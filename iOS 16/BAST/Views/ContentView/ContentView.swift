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
    @State private var result: Result<MFMailComposeResult, Error>? = nil

    let appInformationString = "\n\n________________\nVersion: \(AppInformation.appVersion + " (\(AppInformation.buildVersion))")\nDevice: \(AppInformation.devive)\n \(AppInformation.systemVersion)"
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
                            bm.batteryKeyAsText(data: file, label: "Max. Capacity", key1: .maxFCC, key2: nil)
                            bm.batteryKeyAsText(data: file, label: "Min. Capacity", key1: .minFCC, key2: nil)
                            bm.batteryKeyAsText(data: file, label: "Cycle Count", key1: .cycleCount, key2: nil)
                        }
                        
                                
                        Section("Health")
                        {
                            bm.batteryKeyAsText(data: file, label: "Real Health", key1: .nominalChargeCapacity, key2: .designCapacity)
                            bm.batteryKeyAsText(data: file, label: "Max. Health", key1: .nominalChargeCapacity, key2: .minFCC)
                            bm.batteryKeyAsText(data: file, label: "Min. Health", key1: .nominalChargeCapacity, key2: .maxFCC)
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
                .navigationTitle("Battery Health")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        Button
                        {
                            self.showImportView.toggle()
                        } label:
                        {
                            Image(systemName: "square.and.arrow.down")
                        }

                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Menu
                        {
                            
                            // General App information
                            let urlBast = URL(string: "https://www.fezerapps.com/bast")!
                            
                            Link(destination: urlBast)
                            {
                                Label("How does it work?", systemImage: "globe")
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
                            Image(systemName: "questionmark.circle")
                        }
                    }
                })
            
            .sheet(isPresented: $showInformationView, content:
            {
                    InformationView(dismiss: $showInformationView)
                        .interactiveDismissDisabled()
            })
            .sheet(isPresented: $showMailSheet, content: {
                MailView(result: $result, newSubject: "BAST", newMsgBody: appInformationString, mailAddress: "info@fezerapps.com")
            })
            
            .alert(isPresented: $showMailAlert) {
                Alert(title: Text("mailNotFoundWarningTitle"), message: Text("mailNotFoundWarningDescription"), dismissButton: .default(Text("Ok")))
            }
            
            .fileImporter(isPresented: $showImportView, allowedContentTypes: [.data], allowsMultipleSelection: false, onCompletion: { result in
                
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
                        
                        // Convert data to string
                        self.file = data
                        
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
            .preferredColorScheme(.dark)
    }
}