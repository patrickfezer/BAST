//
//  MailView.swift
//  BAST
//
//  Created by Patrick Fezer on 25.08.22.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    let newSubject : String
    let newMsgBody : String
    let mailAddress: String
    

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([mailAddress])
        vc.setSubject(newSubject)
        vc.setMessageBody(newMsgBody, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}


class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

    @Binding var presentation: PresentationMode
    @Binding var result: Result<MFMailComposeResult, Error>?

    init(presentation: Binding<PresentationMode>,
         result: Binding<Result<MFMailComposeResult, Error>?>) {
        _presentation = presentation
        _result = result
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        // Code in defer wird immer ausgeführt!
        defer {
            $presentation.wrappedValue.dismiss()
        }
        guard error == nil else {
            self.result = .failure(error!)
            return
        }
        self.result = .success(result)
    }
}
