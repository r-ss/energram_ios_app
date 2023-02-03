//
//  HourLabel.swift
//  Energram
//
//  Created by Alex Antipov on 10.12.2022.
//


import SwiftUI

struct HourLabel: View {
    
    
    var hour: Int = 0
//    var dailyPlan: DailyPlan?
    
    
    
    //    var selectedAppliances: [SelectedAppliance] = []
    
//    var appliancesForHour: [Appliance] = []
    
    @EnvironmentObject var priceService: PriceService
    

    
    var appliancesForHour: [Appliance] {
        return []
    
//            if let have = self.dailyPlan?.hours[self.hour].appliancesAssigned {
//                return have
//            } else {
//                return []
//            }
    
    
    
    }
    
    //        return String(self.dailyPlan?.hours.filter { $0.id == self.hour })
    
    
    
    
    //        return self.selectedAppliances.filter { $0.time_start == self.hour }
    
    
    
    @EnvironmentObject var applianceService: ApplianceService
    
    
    //    var selectedAppliances: [SelectedAppliance] = []
    
    @State private var draggedApplianceItem: Appliance?
    
    //    @State private var borderColor: Color = .black
    @State private var borderWidth: CGFloat = 0.0
    
    
    
    
    
    var body: some View {
        
        
        VStack {
            
            if let plan = priceService.dailyPlan {
                Text("\(plan.statevar),\(plan.publishedvar)")
            }
            
            Text("\(hour):00").frame(maxWidth: 100, alignment: .leading).padding(7).foregroundColor(.white)//.border(.green, width: 1.0)
            
            
            //            if let dp = dayPrices {
            //                Text("\(dp.data[hour])")
            //            }
            
            
            
            
            ForEach(appliancesForHour) { appl in
                Text(appl.name)
                    .fontWeight(.bold)
                //                    .foregroundColor(.black)
                    .frame(width: 80, height: 20, alignment: .leading)
                //                    .contentShape(Rectangle())
                    .padding(0)
                    .foregroundColor(Palette.brandGreen)
                //                    .border(.red, width: 1.0)
                    .draggable(appl) {
                        Text(appl.name).foregroundColor(Palette.brandGreen)
                    }
            }
            
            
            //            if draggedApplianceItem != nil {
            //                Text(draggedApplianceItem!.name)
            //            } //else {
            //                //Text("Drag here!").foregroundColor(.secondary)
            //            //}
        }
        .frame(maxWidth: 100, alignment: .leading)
        //            .frame(width: 80, minHeight: 20)
        .contentShape(Rectangle())
        .border(Palette.brandGreen, width: borderWidth)
        .dropDestination(for: Appliance.self) { items, location in
            draggedApplianceItem = items.first
            //                print(location)
            
            //                draggedApplianceItem!.name = "zzz"
            if let safeAppliance = draggedApplianceItem {
                applianceService.changeApplianceRunTime(appliance: safeAppliance, newStartTime: hour)
                
            }
            
            
            
            
            return true
        } isTargeted: { inDropArea in
            //                print("In drop area", inDropArea)
            //            borderColor = inDropArea ? .accentColor : .black
            borderWidth = inDropArea ? 2.0 : 0.0
        }
        
        
        
        
        
        //        ForEach(appliancesForHour) { appl in
        //            Text(appl.appliance.name).fontWeight(.bold).padding(7).foregroundColor(.black)
        //                .frame(width: 80, height: 20)
        //                .contentShape(Rectangle())
        //                .padding(0)
        //                .foregroundColor(.black)
        //                .draggable(appl.appliance) {
        //                    Text(appl.appliance.name)
        //                }
        //        }
        
    }
    
    
    
}

struct HourLabel_Previews: PreviewProvider {
    static var previews: some View {
        HourLabel(hour: 5)
    }
}
