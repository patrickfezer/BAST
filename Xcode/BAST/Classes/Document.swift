//
//  Doc.swift
//  BAST
//
//  Created by Patrick Fezer on 13.09.22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct TransferableDocument: FileDocument {
    
    // tell the system to support only text
    static var readableContentTypes: [UTType] = [.text]

    // by default the document is empty
    var text = ""

    init(data: Data)
    {
        text = String(decoding: data, as: UTF8.self)
    }
    
    // this initializer creates a empty document
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write the data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
    
    
    
}

extension TransferableDocument: Transferable
{
    
    static var transferRepresentation: some TransferRepresentation
    {
        
        DataRepresentation(exportedContentType: .text) { file in
            file.data()
        }
//        .suggestedFileName("filename.txt")
    }

    func data() -> Data
    {
        return text.data(using: .ascii) ?? Data()
    }
}


// --- Test ---
struct simpleDocument: Transferable
{
    static var transferRepresentation: some TransferRepresentation
    {
        DataRepresentation(contentType: .text) { file in
            file.data()
        } importing: { file in
            simpleDocument(data: file)
        }
    }
    
    var context: String
    
    init(context: String)
    {
        self.context = context
    }
    
    init(data: Data)
    {
        self.context = String(decoding: data, as: UTF8.self)
    }
    
    func data() -> Data
    {
        return context.data(using: .ascii) ?? Data()
    }
}
