
import Foundation

// MARK: - User Model
struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

// MARK: - Address Model
struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

// MARK: - Geo Location Model
struct Geo: Codable {
    let lat: String
    let lng: String
}

// MARK: - Company Model
struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
