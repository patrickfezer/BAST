//
//  ContentView.swift
//  BAST
//
//  Created by Patrick Fezer on 23.08.22.
//

import SwiftUI
import MessageUI
import OSLog

struct ContentView: View {
    @State private var showImportView = false
    @State private var showInformationView = false
    @State private var showMailSheet = false
    @State private var showMailAlert = false
    @State private var showFAQSheet = false
    @State private var wrongFileAlert = false
    @State private var missingValuesAlert = false
    @State private var header = Text("headerUserGuide")
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var file = Data()
    @State private var batteryValues: [BatteryMangerV2.keys : Int] = [.capacity : 0] // set default value to 0
    @EnvironmentObject var logger: TextLogger
    
    let appInformationString = "\n\n________________\nVersion: \(AppInformation.appVersion + " (\(AppInformation.buildVersion))")\nDevice: \(AppInformation.device)\n \(AppInformation.systemVersion)"
    
    
    var bm: BatteryMangerV2
    {
        return BatteryMangerV2(logger)
    }
    
    var body: some View {
        NavigationView
        {
            Group
            {
                if !file.isEmpty
                {
                    List
                    {
                        Section("headerBatteryHealth")
                        {
                            bm.batteryKeyView(label: "Health", value: batteryValues, key: .capacity)
                            bm.batteryKeyView(label: "Cycle Count", value: batteryValues, key: .cycleCount)
                        }
                        
                        Section("capacityCyclesHeader")
                        {
                            bm.batteryKeyView(label: "Current Capacity", value: batteryValues, key: .NCC)
                            
                            // Show minNCC and maxFCC only if values are greater then 0
                            if batteryValues[.minNCC]! > 0 && batteryValues[.maxNCC]! > 0
                            {
                                bm.batteryKeyView(label: "Maximum Capacity", value: batteryValues, key: .minNCC)
                                bm.batteryKeyView(label: "Minimum Capacity", value: batteryValues, key: .maxNCC)
                            }
                            
                        }
                        // Disclaimer
                        Section("disclaimerHeader")
                        {
                            Text("disclaimer")
                        }
                    }
                    
                } else
                {
                    // InstructionView if File is emty
                    InstructionView()
                }
            }
            
                .navigationTitle(header)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    // Import Button
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        Button
                        {
                            self.showImportView.toggle()
                        } label:
                        {
                            Text("import")
                        }
                        // Wrong File imported
                        .alert(isPresented: $wrongFileAlert)
                        {
                            Alert(title: Text("wrongFileWarningTitle"), message: Text("wrongFileMsg"), dismissButton: .default(Text("Ok")))
                        }
                    }
                    
                    // Help Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Menu
                        {
                            if !file.isEmpty
                            {
                                // User Guide
                                Button
                                {
                                    file = Data() // Clear File, User Guide will be called
                                    logger.log("Opened User Guide")
                                    logger.log("Cleared Data")
                                } label: {
                                    Label("userGuide", systemImage: "globe")
                                }
                            }

                            // InformationSheet
                            Button
                            {
                                showInformationView.toggle()
                                logger.log("Opened Info")
                            } label: {
                                Label("Info", systemImage: "info.circle.fill")
                            }
                            
                            // FAQSheet
                            Button {
                                showFAQSheet.toggle()
                                logger.log("Read FAQ")
                            } label: {
                                Label("FAQ", systemImage: "person.fill.questionmark")
                            }

                            // MailSheet
                            Button {
                                if MFMailComposeViewController.canSendMail()
                                {
                                    self.showMailSheet = true
                                    logger.log("Opened Mail")
                                } else
                                {
                                    showMailAlert = true
                                    logger.log("Mail Alert")
                                }
                            } label: {
                                Label("contact", systemImage: "envelope.fill")
                            }
                            // Missing Mail App
                            .alert(isPresented: $showMailAlert) {
                                Alert(title: Text("mailNotFoundWarningTitle"), message: Text("mailNotFoundWarningDescription"), dismissButton: .default(Text("Ok")))
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
            
            
            // Missing Battery values in logfile
            .alert(isPresented: $missingValuesAlert)
            {
                Alert(title: Text("missingValuesWarningTitle"), message: Text("missingValuesMsg"))
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
                        if selectedFile.pathExtension != "synced"
                        {
                            wrongFileAlert = true
                            self.file = Data() // reset file
                            
                            // Log warning
                            logger.log("Wrong file extension. Extension is: \(selectedFile.pathExtension)")
                        } else
                        {
                            // Set file to data
                            self.file = data
                            self.batteryValues = bm.getBatteryValues(file: data)
                            
                            // Check if a values are missing
                            if batteryValues[.capacity] == 0 || batteryValues[.cycleCount] == 0 || batteryValues[.NCC] == 0
                            {
                                missingValuesAlert = true
                                self.file = Data()
                            }
                        }
                        
                    } catch
                    {
                        logger.log(error.localizedDescription)
                    }
                }
            })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
            .preferredColorScheme(.dark)
            .environmentObject(TextLogger())
    }
}
