//
//  CoreAppliancesView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI


struct CoreAppliancesView: View {
    
    @StateObject var viewModel = AppliancesListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.appliances) { appliance in
                NavigationLink {
                    CoreApplianceEditorView(appliance: appliance)
                } label: {
                    HStack {
                        
                        Text(appliance.name)
                    }
                }
            }
            .onDelete { indexSet in
//                print(indexSet)
                viewModel.delete(at: indexSet)
            }
        }
        
        
        .navigationTitle("Appliances")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
//                    withAnimation {
//                        viewModel.toggleFilter()
//                    }
                    
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle" + (viewModel.isFiltered ?  ".fill" : ""))
                }
                Button {
//                    withAnimation {
//                        viewModel.toggleSort()
//                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle" + (viewModel.isSorted ?  ".fill" : ""))
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.showEditor = true
            } label: {
                Label("New Appliance", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $viewModel.showEditor) {
            CoreApplianceEditorView(appliance: nil)
//            Text("Sheet")
        }
        .onAppear {
            withAnimation{
                viewModel.fetchAppliances()
            }
        }
    }
}


struct CoreAppliancesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoreAppliancesView(viewModel: AppliancesListViewModel(dataManager: DataManager.preview))
        }
    }
}

