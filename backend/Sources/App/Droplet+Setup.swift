//
//  Config+Setup.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

@_exported import Vapor

extension Droplet {
    
    public func setup() throws {
        try setupRoutes()
    }
    
}
