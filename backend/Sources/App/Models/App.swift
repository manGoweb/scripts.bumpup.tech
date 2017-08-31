//
//  App.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Vapor
import FluentProvider
import HTTP


final class App: Model, NodeInitializable {
    
    static let foreignIdKey = "app_id"
    
    let storage = Storage()
    
    var bundle: String
    var added: Date
    
    static let idKey = "id"
    static let bundleKey = "bundle"
    static let addedKey = "added"
    
    
    // Creates a new entry
    init(bundle: String, added: Date) {
        self.bundle = bundle
        self.added = added
    }
    
    init(node: Node) throws {
        bundle = try node.get(App.bundleKey)
        added = try node.get(App.addedKey)
        
        exists = true
        id = try node.get("id")
    }
    
    // MARK: Fluent Serialization
    
    // Initializes an entry from the database row
    init(row: Row) throws {
        bundle = try row.get(App.bundleKey)
        added = try row.get(App.addedKey)
    }
    
    // Serializes the entry to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(App.bundleKey, bundle)
        try row.set(App.addedKey, added)
        return row
    }
    
}

// MARK: JSON

extension App: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(
            bundle: json.get(App.bundleKey),
            added: json.get(App.addedKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set(App.bundleKey, bundle)
        try json.set(App.addedKey, added)
        return json
    }
    
}

// MARK: Update

extension App: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<App>] {
        return [
            UpdateableKey(App.bundleKey, String.self) { app, content in
                app.bundle = content
            }
        ]
    }
}

// MARK: Fluent Preparation

extension App: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(App.bundleKey)
            builder.date(App.addedKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

// MARK: HTTP

extension App: ResponseRepresentable { }
