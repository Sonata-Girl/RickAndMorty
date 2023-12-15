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
    func getEpisode(episodeNumber: Int, completion: @escaping (Result<EpisodeDto, ErrorTypes>) -> Void)
    func getCharacter(characterUrl: URL, completion: @escaping (Result<CharacterDto, ErrorTypes>) -> Void)
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void)
}

// MARK: - Api settings

private enum ApiType {
    case getEpisodes
    case getEpisode
    case getCharacter
 
    static var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    var path: String {
        switch self{
        case .getEpisodes: return "/episode?page="
        case .getEpisode: return "/episode/"
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
    private let imageCache = NSCache<NSString, ImageDataWrapper>()
    
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
    
    func getEpisode(episodeNumber: Int, completion: @escaping (Result<EpisodeDto, ErrorTypes>) -> Void) {
        guard let url = URL(string: api.getEpisode.urlString + "\(episodeNumber)") else { return }
        fetchJsonData(from: url) { (result: Result<EpisodeDto, ErrorTypes>) in
            switch result {
                case .success(let episode):
                    completion(.success(episode))
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
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage.imageData)
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            self.imageCache.setObject(ImageDataWrapper(imageData: data), forKey: url.absoluteString as NSString)
            completion(data)
        }.resume()
    }
    
//    func getEpisodes(completion: @escaping (Result<EpisodesDto, Error>) -> Void) {
//        guard let url = URL(string: api.getEpisodes.urlString) else { return }
//         
//        guard let path = Bundle.main.path(forResource: "JSON", ofType: "json") else { return }
//        let jsonDecoder = JSONDecoder()
//        
////        DispatchQueue.global().async {
////            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
////                let episodesDto = try! jsonDecoder.decode(EpisodesDto.self, from: data)
////                completion(.success(episodesDto))
////            }
////        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200 else { return }
//
//            guard let data = data else { return }
//            do {
//                let episodesDto = try self.decoder.decode(EpisodesDto.self, from: data)
//                completion(.success(episodesDto))
//            } catch let error {
//                completion(.failure(error))
//            }
//        }.resume()
//    }

//    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
//           if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//               completion(cachedImage.imageData)
//           }
//           fetchData(from: url) { (result: Result<Data, ErrorTypes>) in
//               switch result {
//               case .success(let data):
//                   self.imageCache.setObject(ImageDataWrapper(imageData: data), forKey: url.absoluteString as NSString)
//                   completion(data)
//               case .failure:
//                   completion(nil)
//               }
//           }
//       }
}
