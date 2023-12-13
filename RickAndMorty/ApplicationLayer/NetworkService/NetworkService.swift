//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Network service protocol

protocol NetworkServiceProtocol {
    func getEpisodes(completion: @escaping (Result<EpisodeDtoModels, Error>) -> Void)
//    func getCharacter(completion: @escaping (Result<EpisodesDto, Error>) -> Void)
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void)
}

// MARK: - Api settings

enum ApiType {
    case getEpisodes
    case getCharacter
 
    static var baseURL: String {
        return "https://rickandmortyapi.com/api"
    }
    
    private var path: String {
        switch self{
        case .getEpisodes: return "/episode"
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
    private let decoder = JSONDecoder()
    private let imageCache = NSCache<NSString, ImageDataWrapper>()
    
    private func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else { return }

                guard let data = data else { return }
                do {
                    let decodedData = try self.decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    func getEpisodes(completion: @escaping (Result<EpisodeDtoModels, Error>) -> Void) {
        guard let url = URL(string: api.getEpisodes.urlString) else { return }
        fetchData(from: url) { (result: Result<EpisodesDto, Error>) in
            switch result {
            case .success(let episodes):
                    completion(.success(episodes.results))
            case .failure(let error):
               completion(.failure(error))
            }
        }
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

    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
           if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
               completion(cachedImage.imageData)
           }
           fetchData(from: url) { (result: Result<Data, Error>) in
               switch result {
               case .success(let data):
                   self.imageCache.setObject(ImageDataWrapper(imageData: data), forKey: url.absoluteString as NSString)
                   completion(data)
               case .failure:
                   completion(nil)
               }
           }
       }
}
