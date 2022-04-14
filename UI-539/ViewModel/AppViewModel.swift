//
//  AppViewModel.swift
//  UI-539
//
//  Created by nyannyan0328 on 2022/04/13.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var coins : [CyptonModel]?
    @Published var currentCoin : CyptonModel?
    
    
    init() {
        Task{
            
            do{
                
                try await fetchCyptonData()
                
            }
            catch{
                
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCyptonData()async throws{
        
        guard let url = url else{return}
        
        let session = URLSession.shared
        
        let responce = try await session.data(from: url)
        
        let jsonData = try JSONDecoder().decode([CyptonModel].self, from: responce.0)
        
        
        await MainActor.run(body: {
            
            
            self.coins = jsonData
            
            if let fistCoin = jsonData.first{
                
                
                self.currentCoin = fistCoin
                
            }
        
            
        })
        
        
    }
}

