//
//  ApplianceLabel.swift
//  Energram
//
//  Created by Alex Antipov on 02.12.2022.
//


import SwiftUI

struct ApplianceLabel: View {
    
    var appliance: Appliance
    
    @State var isSelected: Bool
    
    //    var service: ApplianceService
    
    var dailyPlan: DailyPlan
    
    var disableInteraction: Bool = false
    
    //    func random_label_color() -> Color {
    //        return Color(
    //            red: .random(in: 0.15...0.85),
    //            green: .random(in: 0.15...0.85),
    //            blue: .random(in: 0.15...0.85)
    //        )
    //    }
    
    var body: some View {
        Button {
            // skipping action here https://stackoverflow.com/a/66539032
            //            if !disableInteraction {
            //                dailyPlan.toggleApplianceLabel(applianceLabel: self)
            //            }
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 8).foregroundColor( isSelected ? Palette.brandGreen : Palette.brandPurple )
                HStack(spacing: 0){
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle").resizable().padding(8).foregroundColor(.white).frame(width: 32, height: 32)
                    Text(appliance.name).font(.headline).foregroundColor(.white).padding([.top, .trailing,. bottom], 10)
                }
            }.fixedSize()
        }.onAppear {
            
            NotificationCenter.simple(name: .latestPriceRecieved){
                isSelected = false
            }
            
        }.simultaneousGesture(
            LongPressGesture()
                .onEnded { _ in
                    
                    Notification.fire(name: .someApplianceLabelLongTapEvent) // used to set .areAppliancesLabelsTouchLearned setting and hide hint text in DailyPlanView
                    
                    dailyPlan.selectedApplianceToEdit = appliance
                    
                }
        )
        .highPriorityGesture(TapGesture()
            .onEnded { _ in
                //                print("Tap")
                if !disableInteraction {
                    dailyPlan.toggleApplianceLabel(applianceLabel: self)
                }
            })
    }
}

//struct ApplianceLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        
//
//
//
//        VStack(alignment: .leading, spacing: 2) {
//            ApplianceLabel(appliance: Appliance(name: "Device", typical_duration: 20, power: 200, created_by: "NO"), isSelected: false, dailyPlan: DailyPlan())
//
//            ApplianceLabel(appliance: Appliance(name: "Washing machine", typical_duration: 20, power: 200, created_by: "NO"), isSelected: false, dailyPlan: DailyPlan())
//
//            ApplianceLabel(appliance: Appliance(name: "Kettel", typical_duration: 20, power: 200, created_by: "NO"), isSelected: false, dailyPlan: DailyPlan())
//        }
//        .padding(20)
//
//
//    }
//}
