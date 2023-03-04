//
//  ApplianceDetailView.swift
//  Energram
//
//  Created by Alex Antipov on 03.03.2023.
//

import SwiftUI

struct ApplianceDetailView: View {
    
    var appliance: Appliance
    
    
    var body: some View {
        //GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Appliance Detail View").font(Font.system(size: 22)).padding(.bottom, 15)
                
                Text("Name: \(appliance.name)")
                Text("Id: \(appliance.id)").font(Font.system(size: 14).monospaced())
                Text("Power: \(appliance.power)")
            }
        //}
    }
}

struct ApplianceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceDetailView(appliance: Appliance.mocked.appliance1)
    }
}
