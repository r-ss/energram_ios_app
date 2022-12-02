//
//  DayTileView.swift
//  Energram
//
//  Created by Alex Antipov on 27.11.2022.
//

import SwiftUI

struct DayTileView: View {
    
    let tileHeight: CGFloat = 390
    
    var quarterWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        return (screenWidth - 40 - 3) / 4
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Tomorrow's consumers:").font(.title)
                    
                    Text("🧦 Washing machine").frame(maxWidth: .infinity, alignment: .leading)
                    Text("🥵 heater").frame(maxWidth: .infinity, alignment: .leading)
                    Text("🥘 oven").frame(maxWidth: .infinity, alignment: .leading)
                    Text("📺 television").frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("Daily plan:").font(.title).padding(.top, 20)
                    HStack(spacing: 1) {
                        
                        
                        ZStack {
                            Rectangle().fill(Palette.b).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Night").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("00:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("01:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("02:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("03:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                
                                Text("🧦 Washing machine").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("04:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("05:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.d).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Morning").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("06:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("07:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                
                                Text("🥵 heater").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("08:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("09:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("10:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("11:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.e).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Day").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("12:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("13:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("14:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                
                                Text("🥘 oven").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("15:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("16:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("17:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.c).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Evening").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("18:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("19:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("20:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("21:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                
                                Text("📺 television").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold)
                                
                                Text("22:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                                Text("23:00").frame(maxWidth: quarterWidth, alignment: .leading).padding(7)
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        
                        
                        
                    }
                    
                    Text("Cost: €6.56 — optimal 🌿").font(.title).padding(.top, 10)
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
        }}
}

struct DayTileView_Previews: PreviewProvider {
    static var previews: some View {
        DayTileView()
    }
}

