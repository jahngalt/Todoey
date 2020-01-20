//
//  AppDelegate.swift
//  Todoey
//
//  Created by Oleg Kudimov on 1/8/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)

        //SetUp Realm
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm \(error)")
        }
//        
        return true
    }
}
