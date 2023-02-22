//
//  CommonPrimaryButton.swift
//  Energram
//
//  Created by Alex Antipov on 22.02.2023.
//


import SwiftUI

struct CommonPrimaryButton: View {
    
    var title: String
    var icon_name: String?
    var onClick: (() -> Void) /// use closure for callback
    
    
    var body: some View {
        
        Button(action: onClick) {
            HStack {
                if let icon = icon_name {
                    Image(systemName: icon)
                        .font(.regularCustom)
                }
                Text(title)
                    .font(.regularCustom)
            }
            .padding(12)
            .foregroundColor(.white)
            .background(Palette.brandPurple)
            .cornerRadius(10)
        }
        
    }
}

struct CommonPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        CommonPrimaryButton(title: "Press me", icon_name: "trash", onClick: { print("click")} )
    }
}
