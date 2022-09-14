//
//  Doc.swift
//  BAST
//
//  Created by Patrick Fezer on 13.09.22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct Doc: FileDocument {
    // tell the system to support only text
    static var readableContentTypes = [UTType.log]

    // by default the document is empty
    var text = ""

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
