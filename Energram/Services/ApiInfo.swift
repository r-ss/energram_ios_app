//
//  ApiInfo.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI

class ApiInfoService: ObservableObject {
    
    @Published var apiInfo: String = "- no data -"
    
    func fetchData(){
        if let url = URL(string: Config.urlApi + "/info") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let safeData = data {
                        DispatchQueue.main.async {
                            
//                            self.apiInfo = try! String(contentsOf: url, encoding: .utf8)
                            
                            self.apiInfo = safeData.prettyPrintedJSONString!
                            
                            //                            self.apiInfo = String(data: safeData, encoding: .utf8)!
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
