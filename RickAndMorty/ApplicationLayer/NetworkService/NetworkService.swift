//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Network service protocol

protocol NetworkServiceProtocol {
    func getEpisodes(page: Int, completion: @escaping (Result<EpisodesDto, ErrorTypes>) -> Void)
    func getMultipleEpisodes(episodesStrings: [String], completion: @escaping (Result<EpisodeDtoModels, ErrorTypes>) -> Void)
    func getCharacter(characterUrl: URL, completion: @escaping (Result<CharacterDto, ErrorTypes>) -> Void)
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void)
}

// MARK: - Api settings

private enum ApiType {
    case getEpisodes
    case getMultipleEpisodes
    case getCharacter
 
    static var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    var path: String {
        switch self{
        case .getEpisodes: return "/episode?page="
        case .getMultipleEpisodes: return "/episode/"
        case .getCharacter: return "/character/"
        }
    }
    
    var urlString: String {
        return ApiType.baseURL + path
    }
}

// MARK: - Network service

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let api = ApiType.self
    private let jsonDecoder = JSONDecoder()
    
    private init() {}
    
    private func fetchJsonData<T: Decodable>(from url: URL, returnImageData: Bool = false, completion: @escaping (Result<T, ErrorTypes>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.error(message: error.localizedDescription)))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidResponceCode))
                return
            }
            
            guard let data else { return }
            do {
                self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodedProblem))
            }
        }.resume()
    }
    
    func getEpisodes(page: Int, completion: @escaping (Result<EpisodesDto, ErrorTypes>) -> Void) {
        guard let url = URL(string: api.getEpisodes.urlString + "\(page)") else { return }
        fetchJsonData(from: url) { (result: Result<EpisodesDto, ErrorTypes>) in
            switch result {
                case .success(let episodes):
                    completion(.success(episodes))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getMultipleEpisodes(episodesStrings: [String], completion: @escaping (Result<EpisodeDtoModels, ErrorTypes>) -> Void) {
        guard let url = URL(string: api.getMultipleEpisodes.urlString + episodesStrings.joined(separator: ",")) else { return }
        fetchJsonData(from: url) { (result: Result<EpisodeDtoModels, ErrorTypes>) in
            switch result {
                case .success(let episodes):
                    completion(.success(episodes))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getCharacter(characterUrl: URL, completion: @escaping (Result<CharacterDto, ErrorTypes>) -> Void) {
        guard let url = URL(string: characterUrl.absoluteString) else { return }
        fetchJsonData(from: url) { (result: Result<CharacterDto, ErrorTypes>) in
            switch result {
                case .success(let character):
                    completion(.success(character))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
          URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
}
