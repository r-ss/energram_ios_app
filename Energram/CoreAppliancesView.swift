//
//  CoreAppliancesView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI
import Combine

@MainActor
final class AppliancesListViewModel: ObservableObject {
    
    @Published var showEditor = false
    @Published var isFiltered = false
    @Published var isSorted = false
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var appliances: [Appliance] {
        dataManager.appliancesArray
    }
    
    //    func getProject(with id: UUID?) -> Project? {
    //        guard let id = id else { return nil }
    //        return dataManager.getProject(with: id)
    //    }
    
    //    func toggleIsComplete(todo: Todo) {
    //        var newTodo = todo
    //        newTodo.isComplete.toggle()
    //        dataManager.updateAndSave(todo: newTodo)
    //    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            dataManager.delete(appliance: appliances[index])
        }
    }
    
    func fetchAppliances() {
        dataManager.fetchAppliances()
    }
}






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
                Label("New Todo", systemImage: "plus")
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

