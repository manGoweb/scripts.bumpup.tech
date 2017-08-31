//
//  ResponseRepresentable+BumpUp.swift
//  BumpUp
//
//  Created by Ondrej Rafaj on 31/08/2017.
//
//

import Foundation
import HTTP


extension ResponseRepresentable {
    
    private func configure(response: Response, request: Request, status: Status?) -> Response {
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if status != nil {
            response.status = status!
        }
        if let origin: String = request.headers["Origin"] {
            response.headers["Access-Control-Allow-Origin"] = origin
            response.headers["Access-Control-Expose-Headers"] = "Authorization"
        }
        return response
    }
    
    func bump(responseFor request: Request, status: Status? = nil) throws -> Response {
        guard let response: Response = self as? Response else {
            return configure(response: try self.makeResponse(), request: request, status: status)
        }
        return configure(response: response, request: request, status: status)
    }
    
}
