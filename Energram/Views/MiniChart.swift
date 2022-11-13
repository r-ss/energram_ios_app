//
//  MiniChart.swift
//  Energram
//
//  Created by Alex Antipov on 13.11.2022.
//

import SwiftUI
import Charts

struct BarTick: Identifiable {
    var hour: Int
    var value: Float
    var id = UUID()
}

struct MiniChart: View {
    var forDay: DayPrice
    
    let y_labels = Array(0...23)
    
    var ticks: [BarTick] {
        var bin:[BarTick] = []
        
        var hour = 0
        for i in forDay.data {
            bin.append(BarTick(hour: hour, value: i))
            hour+=1
        }
        return bin
    }
    
    var body: some View {
        
        Chart {
            ForEach(ticks) { item in
                BarMark(
                    x: .value("Hour", item.hour),
                    y: .value("Value", item.value),
                    width: 6
                )
                .foregroundStyle(Palette.e)
                //                                    .annotation(position: .overlay, alignment: .top, spacing: 2.0) {
                //                                                              Text("\(item.value, specifier: "%.2f")")
                //                                                                   .font(.system(size:10))
                //                                                                   .foregroundColor(.white)
                //                                                                   .fontWeight(.bold)
                //                                                       }
                
            }
        }
        //                        .chartPlotStyle { plotContent in
        //                            plotContent
        //                              .background(.green.opacity(0.2))
        //                              .border(Color.blue, width: 1)
        //                          }
        .chartXAxis {
            AxisMarks(values: y_labels) { hour_value in
                //                            AxisMarks(values: y_labels) { hour_value in
                //                            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2, 2]))
                //                              .foregroundStyle(Color.indigo)
                //                            AxisTick(stroke: StrokeStyle(lineWidth: 2))
                //                              .foregroundStyle(Color.mint)
                //                              AxisValueLabel(centered: false)
                AxisValueLabel() { // construct Text here
                    if let hour = hour_value.as(Int.self) {
                        
                        let key_marks = [0,4,8,12,16,20,23]
                        if key_marks.contains(hour) {
                            Text("\(hour)")
                                .font(.system(size: 12)) // style it
                                .foregroundColor(Palette.textColor)
                        }
                    }
                }
                .offset(x:-5,y:0)
                
            }
            //                          .position: .leading
            
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                    .foregroundStyle(Color.gray)
                //                            AxisTick(centered: false, stroke: StrokeStyle(lineWidth: 2))
                //                              .foregroundStyle(Color.red)
                AxisValueLabel() { // construct Text here
                    if let floatVal = value.as(Float.self) {
                        Text("\(floatVal, specifier: "%.1f") €/kWh")
                            .font(.system(size: 12)) // style it
                            .foregroundColor(Palette.textColor)
                    }
                }
                .offset(x:5,y:0)
            }
        }
        
    }
}

//struct MiniChart_Previews: PreviewProvider {
//    static var previews: some View {
//        MiniChart()
//    }
//}
