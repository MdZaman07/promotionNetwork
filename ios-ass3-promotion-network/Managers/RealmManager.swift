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
            if let _ = subs.first(named:"all-appUsers"){} else{
                subs.append(QuerySubscription<AppUser>(name:"all-appUsers"))
            }
            if let _ = subs.first(named:"loginSessions") {}else{
                subs.append(QuerySubscription<LoginSession>(name:"loginSessions"))
            }
            if let _ = subs.first(named:"likedPosts") {} else{
                subs.append(QuerySubscription<LikedPost>(name:"likedPosts"))
            }
            if let _ = subs.first(named:"posts") {} else{
                subs.append(QuerySubscription<Post>(name:"posts"))
            }
            if let _ = subs.first(named:"userFollows") {} else{
                subs.append(QuerySubscription<UserFollow>(name:"userFollows"))
            }
            
            return

        }, rerunOnOpen: true)

        realm = try! await Realm(configuration: configuration!, downloadBeforeOpen: .always)
    }
    
    func getObject(type:Object.Type ,pK: Any)->Object{
        guard let realm = realm else{
            return Object()
        }
        guard let object = realm.object(ofType: type, forPrimaryKey:pK ) else{
            return Object()
        }
        return object
    }
    
    
    func createObject(object:Object){
        // Save your object
        if let realm=realm{
            realm.beginWrite()
            realm.add(object)
            try! realm.commitWrite()
        }
    }

}
