//
//  AppliancesListView.swift
//  Energram
//
//  Created by Alex Antipov on 01.12.2022.
//

import SwiftUI


struct AppliancesListView: View {
    
   

//    @ObservedObject var applianceService = ApplianceService()
    
//    var applianceService: ApplianceService
    @EnvironmentObject var applianceService: ApplianceService

    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Appliances").font(.title)
                    
                    
                    
                    if let receivedAppliances = applianceService.appliances {
                        ForEach(receivedAppliances) { appliance in
                            ApplianceLabel(appliance: appliance, isSelected: false, service: applianceService)
                        }
                    }
                    
//
                    
//                    Text("Selected Appliances").font(.title)
//
//                    if let selectedAppliances = applianceService.selectedAppliances {
//                        ForEach(selectedAppliances) { appliance in
//                            ApplianceLabel(appliance: appliance, isSelected: false, service: applianceService, disableInteraction: true)
//                        }
//                    }
                    
                    
                    
                    
                    
                    
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
//                .onAppear {
//                    self.applianceService.fetchAppliancesData()
//                }
            }
        }}
}

struct AppliancesListView_Previews: PreviewProvider {
    
    @State static var applianceService = ApplianceService()
    
    

    
    static var previews: some View {
        
        AppliancesListView().environmentObject(applianceService)
            .onAppear {self.applianceService.fetchAppliancesData()}
        
        
    }
}
