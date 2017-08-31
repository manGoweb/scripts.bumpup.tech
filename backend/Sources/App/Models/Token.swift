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
    
    static let idKey = "id"
    static let bundleKey = "bundle"
    static let buildKey = "build"
    static let addedKey = "added"
    
    
    // Creates a new entry
    init(bundle: String, build: Int, added: Date) {
        self.token = bundle
        self.build = build
        self.added = added
    }
    
    init(node: Node) throws {
        token = try node.get(Token.bundleKey)
        build = try node.get(Token.buildKey)
        added = try node.get(Token.addedKey)
        
        exists = true
        id = try node.get("id")
    }
    
    // MARK: Fluent Serialization
    
    // Initializes an entry from the database row
    init(row: Row) throws {
        token = try row.get(Token.bundleKey)
        build = try row.get(Token.buildKey)
        added = try row.get(Token.addedKey)
    }
    
    // Serializes the entry to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Token.bundleKey, token)
        try row.set(Token.buildKey, build)
        try row.set(Token.addedKey, added)
        return row
    }
    
}

// MARK: JSON

extension Token: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(
            bundle: json.get(Token.bundleKey),
            build: json.get(Token.buildKey),
            added: json.get(Token.addedKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set(Token.bundleKey, token)
        try json.set(Token.buildKey, build)
        try json.set(Token.addedKey, added)
        return json
    }
    
}

// MARK: Update

extension Token: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Token>] {
        return [
            UpdateableKey(Token.bundleKey, String.self) { token, content in
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
            builder.string(Token.bundleKey)
            builder.int(Token.buildKey)
            builder.date(Token.addedKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

// MARK: HTTP

extension Token: ResponseRepresentable { }
