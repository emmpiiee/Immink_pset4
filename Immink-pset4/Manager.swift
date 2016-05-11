//
//  Manager.swift
//  Immink-pset4
//
//  Created by Emma Immink on 11-05-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import Foundation

class TodoManager {
    static let sharedInstance = TodoManager()
    
    private init() {}
    
    func printHello(){
        print("Helloo")
    }
}