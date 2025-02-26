


import Foundation

struct Constants {
  static let baseUrl = "https://jsonplaceholder.typicode.com/"
}


enum UrlItem {
  case todos
  case users

  var url: String {
    switch self {
    case .todos: return "todos"
    case .users: return "users"
    }
  }
}
