//
//  CommonTextField.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//


import SwiftUI

struct CommonTextField: View {
    
    @Binding var content: String
    
    
    var body: some View {
        
        TextField("Enter text...", text: $content)
            .onReceive(content.publisher.collect()) {
                let s = String($0.prefix(50)) // < something about chartacter s limit
                if content != s {
                    content = s
                }
            }
            .disableAutocorrection(true)
        
    }
}

struct CommonTextField_Previews: PreviewProvider {
    static var previews: some View {
        Text("Enter text...")
    }
}
