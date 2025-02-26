

protocol TodoServiceProtocol {
  func fetchTodos(completion: @escaping ([Todo]?) -> Void)
}

class TodoService: TodoServiceProtocol {
  static let shared = TodoService()

  var dataFetcher: DataFetcherProtocol

  init(dataFetcher: DataFetcherProtocol = NetworkDataFetcher()) {
    self.dataFetcher = dataFetcher
  }

  func fetchTodos(completion: @escaping ([Todo]?) -> Void) {
    let entPoint = "\(Constants.baseUrl)\(UrlItem.todos.url)"
    dataFetcher.fetchDataArray(from: entPoint, completion: completion)
  }

  func fetchUsers(completion: @escaping ([User]?) -> Void) {
    let entPoint = "\(Constants.baseUrl)\(UrlItem.users.url)"
    dataFetcher.fetchDataArray(from: entPoint, completion: completion)
  }

}
