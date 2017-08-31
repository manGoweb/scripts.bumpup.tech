//
//  Config+Setup.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import FluentProvider


extension Config {
    
    public func setup() throws {
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
    }
    
    private func setupPreparations() throws {
        preparations.append(App.self)
        preparations.append(Token.self)
        preparations.append(History.self)
    }
    
}
