//
//  RealmManager.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 9/5/23.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject{
    
    let app: App
    
    @Published var realm: Realm?
    static let shared = RealmManager()
    @Published var user: User?
    @Published var configuration: Realm.Configuration?

    private init(){
        self.app = App(id:"promnetapp-nnanp")
    }
    
    @MainActor
    func initalize() async throws{
        
        //authentication
        user = try await app.login(credentials:Credentials.anonymous)
        
        self.configuration = user?.flexibleSyncConfiguration(initialSubscriptions: { subs in
            if let _ = subs.first(named:"all-appUsers"){
                return
            }else{
                subs.append(QuerySubscription<AppUser>(name:"all-appUsers"))
            }
        }, rerunOnOpen: true)
        
        realm = try! await Realm(configuration: configuration!, downloadBeforeOpen: .always)
    }
    
}
