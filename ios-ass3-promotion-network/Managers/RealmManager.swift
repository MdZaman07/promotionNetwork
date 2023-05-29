//
//  RealmManager.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 9/5/23.
//
import Foundation
import RealmSwift

class RealmManager: ObservableObject {

    let app: App

    @Published var realm: Realm?
    static let shared = RealmManager()
    @Published var user: User?
    @Published var configuration: Realm.Configuration?

    private init() {
        self.app = App(id: "promnetapp-nnanp")
    }

    @MainActor
    func initalize() async throws {
        //authentication
        do {
            user = try await app.login(credentials: Credentials.anonymous)

            self.configuration = user?.flexibleSyncConfiguration(clientResetMode: .recoverOrDiscardUnsyncedChanges(), initialSubscriptions: { subs in
                    if let _ = subs.first(named: "all-appUsers") { } else {
                        subs.append(QuerySubscription<AppUser>(name: "all-appUsers"))
                    }
                    if let _ = subs.first(named: "loginSessions") { } else {
                        subs.append(QuerySubscription<LoginSession>(name: "loginSessions"))
                    }
                    if let _ = subs.first(named: "likedPosts") { } else {
                        subs.append(QuerySubscription<LikedPost>(name: "likedPosts"))
                    }
                    if let _ = subs.first(named: "posts") { } else {
                        subs.append(QuerySubscription<Post>(name: "posts"))
                    }
                    if let _ = subs.first(named: "userFollows") { } else {
                        subs.append(QuerySubscription<UserFollow>(name: "userFollows"))
                    }

                    return

                }, rerunOnOpen: true)
            realm = try await Realm(configuration: configuration!, downloadBeforeOpen: .always)
        }
        catch let syncError as SyncError { //if this does not work, copy and paste it on the login view controller
            switch syncError.code {
            case .clientResetError:
                if let (_, clientResetToken) = syncError.clientResetInfo() {
                    SyncSession.immediatelyHandleError(clientResetToken, syncManager: self.app.syncManager)
                }
            default:
                print(syncError.localizedDescription)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

    // gets object from database
    // Example use:  user = getObject(AppUser.self, field:"city", value:"Vitoria"
    func getObject(type: Object.Type, field: String, value: String) -> Object? {
        guard let realm = realm else {
            return Object()
        }
        let DbQuery = "\(field) contains '\(value)' "
        guard let result = realm.objects(type).filter(DbQuery).first else {
            return nil
        }
        return result
    }

    // creates a new object in the database
    //Example use: realmManager.createObject(object: self)
    func createObject(object: Object) {
        if let realm = realm {
            realm.beginWrite()
            realm.add(object)
            try! realm.commitWrite()
        }
    }

    // adds object to list (for linking object relationships)
    // Example use: realmManager.addObjectToList(object: self, list: loggedInUser.loginSessions)
    func addObjectToList<T: Object>(object: T, list: List<T>) {
        if let realm = realm {
            realm.beginWrite()
            list.append(object)
            try! realm.commitWrite()
        }
    }

    // deletes object from the DB
    // Example use:realmManager.removeObject(object: self)
    func removeObject(object: Object) {
        if let realm = realm {
            realm.beginWrite()
            realm.delete(object)
            try! realm.commitWrite()
        }
    }
}
