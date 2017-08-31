//
//  JSON+Request.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Foundation
import HTTP


extension JSON {
    
    // MARK: Params
    
    func string(parameterPresent parameter: String) -> Bool {
        guard let _: String = try? self.get(parameter) else {
            return false
        }
        return true
    }
    
    func string(parameterNotEmpty parameter: String) -> Bool {
        guard let value: String = try? self.get(parameter) else {
            return false
        }
        return (value.characters.count > 0)
    }
    
    func int(parameterPresent parameter: String) -> Bool {
        guard let _: Int = try? self.get(parameter) else {
            return false
        }
        return true
    }
    
    func bool(parameterPresent parameter: String) -> Bool {
        guard let _: Bool = try? self.get(parameter) else {
            return false
        }
        return true
    }
    
    // MARK: Responses
    
    static func response(withMessage message: String, andStatus status: Status = .ok) -> ResponseRepresentable {
        var json = JSON()
        try? json.set("message", message)
        let response = Response(status: status, body: json)
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        return response
    }
    
    static func response(withErrorMessage message: String, andStatus status: Status = .ok) -> ResponseRepresentable {
        var json = JSON()
        try? json.set("error", message)
        let response = Response(status: status, body: json)
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        return response
    }
    
    static func response(withDataString string: String, andStatus status: Status = .ok, dataStringName: String = "data") -> ResponseRepresentable {
        var json = JSON()
        try? json.set(dataStringName, string)
        let response = Response(status: status, body: json)
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        return response
    }
    
}
