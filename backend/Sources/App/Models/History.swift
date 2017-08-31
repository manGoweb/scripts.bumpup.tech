//
//  History.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Foundation
import FluentProvider
import HTTP


final class History: Model, NodeInitializable {
    
    static let entity = "history"
    static let foreignIdKey = "history_id"
    
    let storage = Storage()
    
    var tokenId: Identifier
    var appId: Identifier
    var version: String
    var added: Date
    
    static let idKey = "id"
    static let tokenIdKey = Token.foreignIdKey
    static let appIdKey = App.foreignIdKey
    static let versionKey = "version"
    static let addedKey = "added"
    
    
    // Creates a new entry
    init(tokenId: Identifier, appId: Identifier, version: String, added: Date) {
        self.tokenId = tokenId
        self.appId = appId
        self.version = version
        self.added = added
    }
    
    init(node: Node) throws {
        tokenId = try node.get(History.tokenIdKey)
        appId = try node.get(History.tokenIdKey)
        version = try node.get(History.versionKey)
        added = try node.get(History.addedKey)
        
        exists = true
        id = try node.get("id")
    }
    
    // MARK: Fluent Serialization
    
    // Initializes an entry from the database row
    init(row: Row) throws {
        tokenId = try row.get(History.tokenIdKey)
        appId = try row.get(History.appIdKey)
        version = try row.get(History.versionKey)
        added = try row.get(History.addedKey)
    }
    
    // Serializes the entry to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(History.tokenIdKey, tokenId)
        try row.set(History.appIdKey, appId)
        try row.set(History.versionKey, version)
        try row.set(History.addedKey, added)
        return row
    }
    
}

// MARK: JSON

extension History: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(
            tokenId: json.get(History.tokenIdKey),
            appId: json.get(History.appIdKey),
            version: json.get(History.versionKey),
            added: json.get(History.addedKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set(History.tokenIdKey, tokenId)
        try json.set(History.appIdKey, appId)
        try json.set(History.versionKey, version)
        try json.set(History.addedKey, added)
        return json
    }
    
}

// MARK: Update

extension History: Updateable {
    
    public static var updateableKeys: [UpdateableKey<History>] {
        return [
            UpdateableKey(History.tokenIdKey, Identifier.self) { history, content in
                history.tokenId = content
            }
        ]
    }
    
}

// MARK: Fluent Preparation

extension History: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.foreignId(for: Token.self)
            builder.foreignId(for: App.self)
            builder.string(History.versionKey)
            builder.date(History.addedKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

// MARK: HTTP

extension History: ResponseRepresentable { }
