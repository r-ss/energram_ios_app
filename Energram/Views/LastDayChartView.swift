//
//  LastDayChartView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI
import Charts

struct BarTick: Identifiable {
    var hour: Int
    var value: Float
    var id = UUID()
}

struct LastDayChartView: View {
    
    @ObservedObject var priceService = PriceService()
    
    let jsonFont = Font.system(size: 12).monospaced()
    
    let y_labels = Array(0...23)
    
    var ticks: [BarTick] {
        var bin:[BarTick] = []
        if let dp = priceService.dayPrice {
            
            var hour = 0
            for i in dp.data {
                bin.append(BarTick(hour: hour, value: i))
                hour+=1
            }
        }
        return bin
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if let dp = priceService.dayPrice {
                        Text("Electricity price in Spain for \(dp.date) by hour:")
                    }
                    
                    
                    
                    Chart {
                        ForEach(ticks) { item in
                            BarMark(
                                x: .value("Hour", item.hour),
                                y: .value("Value", item.value),
                                width: 6
                            )
                            .foregroundStyle(Palette.b)
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
                                            .foregroundColor(.black)
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
                                        .foregroundColor(.black)
                                }
                            }
                            .offset(x:5,y:0)
                        }
                    }
                    
                    
                    
                    
                    
                    
                    //                    Chart {
                    //                        BarMark(
                    //                            x: .value("Shape Type", 1),
                    //                            y: .value("Total Count", 1)
                    //                        )
                    //                        BarMark(
                    //                             x: .value("Shape Type", 2),
                    //                             y: .value("Total Count", 2)
                    //                        )
                    //                        BarMark(
                    //                            x: .value("Shape Type", 2.5),
                    //                            y: .value("Total Count", 3.5)
                    //                        )
                    //                    }
                    
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                self.priceService.fetchData()
            }
        }}
}

struct LastDayChartView_Previews: PreviewProvider {
    static var previews: some View {
        LastDayJsonView()
    }
}
