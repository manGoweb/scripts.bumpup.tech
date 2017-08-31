//
//  Routes.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Vapor


extension Droplet {
    
    var groupName: String {
        return "v1"
    }
    
    var group: RouteBuilder {
        return grouped(groupName)
    }
    
    func setupRoutes() throws {
        group.options("*") { (request) in
            return BumpsController.cors(request: request)
        }
        
        group.get("request") { req in
            return JSON.response(withDataString: req.description, dataStringName: "headers")
        }
        
        group.get("teapot") { req in
            return JSON.response(withMessage: "I have been brewing for a while!", andStatus: .imATeapot)
        }
        
        group.get("*") { req in
            return JSON.response(withMessage: "Stumbling?", andStatus: .notFound)
        }
        
        group.post("*") { req in
            return JSON.response(withMessage: "Trying to post something?", andStatus: .notFound)
        }
        
        group.put("*") { req in
            return JSON.response(withMessage: "Put it back!", andStatus: .notFound)
        }
        
        group.delete("*") { req in
            return JSON.response(withMessage: "WHY?", andStatus: .notFound)
        }
        
        group.get("token") { (request) -> ResponseRepresentable in
            return try BumpsController.token(request: request, drop: self)
        }
        
        group.get("increment") { (request) -> ResponseRepresentable in
            return try BumpsController.incrementBuildNumber(request: request, drop: self)
        }
        
        group.get("build") { (request) -> ResponseRepresentable in
            return try BumpsController.buildNumber(request: request, drop: self)
        }
        
    }
    
}
