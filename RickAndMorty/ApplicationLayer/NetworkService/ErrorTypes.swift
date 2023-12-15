//
//  ErrorTypes.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 14.12.2023.
//

import Foundation

enum ErrorTypes: Error {
    case invalidResponceCode
    case decodedProblem
    case error(message: String)

    public var description: String {
        switch self {
        case .invalidResponceCode: return "Server back failure code"
        case .decodedProblem: return "Decoded problem from server"
        case .error(let message): return "\(message)"
        }
    }
}
