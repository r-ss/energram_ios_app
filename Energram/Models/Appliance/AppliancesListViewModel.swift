//
//  AppliancesListViewModel.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import Foundation
import Combine

//@MainActor
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
