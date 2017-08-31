//
//  Token.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Vapor
import FluentProvider
import HTTP


final class Token: Model, NodeInitializable {
    
    static let foreignIdKey = "token_id"
    
    let storage = Storage()
    
    var token: String
    var build: Int
    var added: Date
    var appId: Identifier
    
    static let idKey = "id"
    static let tokenKey = "token"
    static let buildKey = "build"
    static let appIdKey = App.foreignIdKey
    static let addedKey = "added"
    
    
    // Creates a new entry
    init(token: String, build: Int, appId: Identifier, added: Date) {
        self.token = token
        self.build = build
        self.added = added
        self.appId = appId
    }
    
    init(node: Node) throws {
        token = try node.get(Token.tokenKey)
        build = try node.get(Token.buildKey)
        appId = try node.get(Token.appIdKey)
        added = try node.get(Token.addedKey)
        
        exists = true
        id = try node.get("id")
    }
    
    // MARK: Fluent Serialization
    
    // Initializes an entry from the database row
    init(row: Row) throws {
        token = try row.get(Token.tokenKey)
        build = try row.get(Token.buildKey)
        appId = try row.get(Token.appIdKey)
        added = try row.get(Token.addedKey)
    }
    
    // Serializes the entry to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Token.tokenKey, token)
        try row.set(Token.buildKey, build)
        try row.set(Token.appIdKey, appId)
        try row.set(Token.addedKey, added)
        return row
    }
    
}

// MARK: Helpers

extension Token {
    
    static func find(token: String) throws -> Token? {
        let query = try Token.makeQuery()
        try query.filter(Token.tokenKey, .equals, token)
        return try query.first()
    }

    func app() throws -> Parent<Token, App> {
        return parent(id: appId)
    }
    
}

// MARK: JSON

extension Token: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(
            token: json.get(Token.tokenKey),
            build: json.get(Token.buildKey),
            appId: json.get(Token.appIdKey),
            added: json.get(Token.addedKey)
        )
    }
    
    func makeFullJSON() throws -> JSON {
        var json = JSON()
        try json.set(Token.tokenKey, token)
        try json.set(Token.buildKey, build)
        return json
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Token.buildKey, build)
        return json
    }
    
}

// MARK: Update

extension Token: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Token>] {
        return [
            UpdateableKey(Token.tokenKey, String.self) { token, content in
                token.token = content
            }
        ]
    }
}

// MARK: Fluent Preparation

extension Token: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Token.tokenKey)
            builder.int(Token.buildKey)
            builder.foreignId(for: App.self)
            builder.date(Token.addedKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

// MARK: HTTP

extension Token: ResponseRepresentable { }
