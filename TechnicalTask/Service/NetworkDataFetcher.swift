

import UIKit

// MARK: - DataFetcherProtocol
protocol DataFetcherProtocol {
  func fetchDataArray<T: Codable>(from urlString: String, completion: @escaping ([T]?) -> Void)
  func fetchData<T: Codable>(from urlString: String, completion: @escaping (T?) -> Void)
}

// MARK: - NetworkDataFetcher
class NetworkDataFetcher: DataFetcherProtocol {

  let networking: NetworkProtocol
  init(networking: NetworkProtocol = Networking()) {
    self.networking = networking
  }

  func fetchData<T: Codable>(from urlString: String, completion: @escaping (T?) -> Void) where T : Decodable, T : Encodable {
    networking.request(url: urlString) { data, error in
      if let error = error {
        print("DEBUG: fetch Error", error)
        completion(nil)
      }
      let decoded = self.decodeJson(type: T.self, from: data)
      completion(decoded)
    }
  }
  func fetchDataArray<T>(from urlString: String, completion: @escaping ([T]?) -> Void) where T : Decodable, T : Encodable {
    networking.request(url: urlString) { data, error in
      if let error = error {
        print("DEBUG: fetch Error from Array", error)
        completion(nil)
      }
      let decoded = self.decodeJson(type: [T].self, from: data)
      completion(decoded)
    }
  }
}


// MARK: - Decode
private extension NetworkDataFetcher {
  func decodeJson<T: Codable>(type: T.Type, from data: Data?) -> T? {
    guard let data = data else { return nil }
    do {
      let objects = try JSONDecoder().decode(type.self, from: data)
      return objects
    } catch let jsonError {
      print("DEBUG: jsonError is", jsonError)
      return nil
    }
  }
}

