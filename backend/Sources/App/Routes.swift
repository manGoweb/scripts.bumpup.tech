//
//  Routes.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Vapor


extension Droplet {
    
    func setupRoutes() throws {
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
    }
    
}
