//
//  FAQListView.swift
//  BAST
//
//  Created by Patrick Fezer on 30.08.22.
//

import SwiftUI

struct FAQListView: View {
    let header: Text
    let content: Text
    @State private var collapsed = true
    
    var body: some View {
        VStack
        {
            HStack
            {
                header
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.forward")
                        .rotationEffect(.degrees(collapsed ? 0 : 90))
                        .foregroundColor(.blue)
            }
            .padding(.bottom, 10)
                
            if !collapsed
            {
                HStack
                {
                    content
                    Spacer()
                }
            }
                
        }
        .onTapGesture
        {
            withAnimation
            {
                collapsed.toggle()
            }
            
        }
        .padding(20)
    }
}

struct FAQListView_Previews: PreviewProvider {
    static var previews: some View {
        FAQListView(header: Text("Header"), content: Text("I'm content"))
    }
}
