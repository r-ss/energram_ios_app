//
//  MiniChart.swift
//  Energram
//
//  Created by Alex Antipov on 13.11.2022.
//

import SwiftUI
import Charts

private struct BarTick: Identifiable {
    var hour: Int
    var value: Float
    var id = UUID()
    var color: Color = Palette.chartTickColor
    var cheapIndex = 0
}

private struct MinMaxHour {
    var hour: Int
    var value: Float
    var measure: String
    var color: Color = Palette.chartGreenTickColor
}

struct MiniChart: View {
    var forDay: DayPrice
    
    @EnvironmentObject private var currency: Currency
    
    private let y_labels = Array(0...23)
    
    private let circleRadius: CGFloat = 8
    
    private let smallerFont: Font = Font.system(size: 12)
    
    private var min_hour: MinMaxHour {
        let minValue: Float = forDay.data.min()!
        let idx: Int = forDay.data.firstIndex(where: {$0 == minValue})!
        return MinMaxHour(hour: idx, value: minValue * currency.rate, measure: currency.powerUsageNotation)
    }
    
    private var max_hour: MinMaxHour {
        let maxValue: Float = forDay.data.max()!
        let idx: Int = forDay.data.firstIndex(where: {$0 == maxValue})!
        return MinMaxHour(hour: idx, value: maxValue * currency.rate, measure: currency.powerUsageNotation, color: Palette.chartRedTickColor)
    }
    
    private var ticks: [BarTick] {
        var bin:[BarTick] = []
        
        let pmax: Float = forDay.data.max()!
        let pmin: Float = forDay.data.min()!
        let diff: Float = pmax - pmin
        
        var hour = 0
        for i in forDay.data {
            let fl = CGFloat( (i - pmin) / diff  )           
            
//            let tickColor: Color = Color(UIColor.blend(color1: UIColor(Palette.chartGreenTickColor), intensity1: 1-fl/24, color2: UIColor(Palette.chartRedTickColor), intensity2: fl/24))
            let tickColor: Color = Color(UIColor.blend(color1: UIColor(Palette.chartGreenTickColor), intensity1: 1-fl, color2: UIColor(Palette.chartRedTickColor), intensity2: fl))
            
            bin.append(BarTick(hour: hour, value: i * currency.rate, color: tickColor))
            hour+=1
        }
        return bin
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            Chart {
                ForEach(ticks) { item in
                    BarMark(
                        x: .value("Hour", item.hour),
                        y: .value("Value", item.value),
                        width: 6
                    )
                    .foregroundStyle(item.color)
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
                
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                        .foregroundStyle(Color.gray)
                    //                            AxisTick(centered: false, stroke: StrokeStyle(lineWidth: 2))
                    //                              .foregroundStyle(Color.red)
                    AxisValueLabel() { // construct Text here
                        if let floatVal = value.as(Float.self) {
                            Text("\(floatVal, specifier: "%.1f") \(currency.powerUsageNotation)")
                                .font(.system(size: 12)) // style it
                                .foregroundColor(Palette.textColor)
                        }
                    }
                    .offset(x:5,y:0)
                }
            }
            
            VStack(spacing: 0) {
                
                HStack(alignment: .firstTextBaseline, spacing: 15) {
                    //                        Circle().fill(min_hour.color).frame(width: circleRadius, height: circleRadius)
                    Text("\(String(format: "%02d", min_hour.hour)):00 — \(String(format: "%02d", min_hour.hour + 1)):00").font(smallerFont).foregroundColor(min_hour.color)
                    Text("\(String(format: "%.2f", min_hour.value)) \(min_hour.measure)").font(smallerFont).foregroundColor(min_hour.color)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack(alignment: .firstTextBaseline, spacing: 15) {
                    //                        Circle().fill(max_hour.color).frame(width: circleRadius, height: circleRadius)
                    Text("\(String(format: "%02d", max_hour.hour)):00 — \(String(format: "%02d", max_hour.hour + 1)):00").font(smallerFont).foregroundColor(max_hour.color)
                    Text("\(String(format: "%.2f", max_hour.value)) \(max_hour.measure)").font(smallerFont).foregroundColor(max_hour.color)
                }.frame(maxWidth: .infinity, alignment: .trailing)//.border(.red)
                
            }
        }
    }
}

struct MiniChart_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MiniChart(forDay: DayPrice.mocked.day1).frame(width: 360, height: 160, alignment: .leading)
            MiniChart(forDay: DayPrice.mocked.day2).frame(width: 360, height: 160, alignment: .leading)
        }
    }
}
