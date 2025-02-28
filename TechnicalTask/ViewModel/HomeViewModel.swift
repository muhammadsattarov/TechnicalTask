

import UIKit

class HomeViewModel {
  var todos: [Todo] = []
  var users: [User] = []
  var displayedTodos: [Todo] = [] // Only 20 to display
  var currentPage = 0 // Page layout for pagination
  let itemsPerPage = 20 // Number of ingredients added each time

  var onDataLoaded: (() -> Void)?

  func fetchData() {
    print(#function)
    if NetworkMonitor.shared.isConnected {
      fetchFromAPI()
    } else {
      loadFromCache()
    }
  }

  private func fetchFromAPI() {
    print(#function)
    let group = DispatchGroup()

    group.enter()
    TodoService.shared.fetchTodos { [weak self] fetchedTodos in
      if let fetchedTodos {
        self?.todos = fetchedTodos
        CoreDataManager.shared.saveTodos(fetchedTodos) // Saved to core data
        self?.resetPagination()
        group.leave()
      }
    }

    group.enter()
    TodoService.shared.fetchUsers { [weak self] fetchedUsers in
      if let fetchedUsers{
        self?.users = fetchedUsers
        CoreDataManager.shared.saveUsers(fetchedUsers) // Saved to core data
        group.leave()
      }
    }

    group.notify(queue: .main) { [weak self] in
      self?.onDataLoaded?()
    }
  }

  private func loadFromCache() {
    print(#function)
    self.todos = CoreDataManager.shared.fetchTodos()
    self.users = CoreDataManager.shared.fetchUsers()
    resetPagination()
    onDataLoaded?()
  }

  private func resetPagination() {
      currentPage = 0
      displayedTodos.removeAll()
      loadMoreTodos()
  }

  func loadMoreTodos() {
      let startIndex = currentPage * itemsPerPage
      let endIndex = min(startIndex + itemsPerPage, todos.count)

      guard startIndex < todos.count else { return }

      let newItems = todos[startIndex..<endIndex]
      displayedTodos.append(contentsOf: newItems)

      currentPage += 1
      onDataLoaded?()
  }

}
