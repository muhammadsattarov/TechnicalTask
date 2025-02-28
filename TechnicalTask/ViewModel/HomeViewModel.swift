

import UIKit


class HomeViewModel {
  var allTodos: [Todo] = []  // All Todos
  var displayedTodos: [Int: [Todo]] = [:] // Only 20 to issue
  var users: [User] = []  // Users
  var currentPage = 0 // Page layout for pagination
  let itemsPerPage = 20 // The number of elements to add each time
  var isLoadingMore = false

  var onDataLoaded: (([User], [Int: [Todo]]) -> Void)?

  func fetchData() {
    print(#function)
    if NetworkMonitor.shared.isConnected {
      fetchFromAPI()
    } else {
      loadFromCache()
    }
  }

  var hasMoreData: Bool { // ✅ Pagination tugaganini tekshiradi
    return currentPage * itemsPerPage < allTodos.count
  }

  private func resetPagination() {
    currentPage = 0
    displayedTodos.removeAll()
    loadMoreTodos()
  }

  private func fetchFromAPI() {
    print(#function)
    let group = DispatchGroup()

    group.enter()
    TodoService.shared.fetchTodos { [weak self] fetchedTodos in
      guard let self = self, let fetchedTodos else { return }
      self.allTodos = fetchedTodos
      CoreDataManager.shared.saveTodos(fetchedTodos)
      self.resetPagination()
      group.leave()
    }

    group.enter()
    TodoService.shared.fetchUsers { [weak self] fetchedUsers in
      guard let self = self, let fetchedUsers else { return }
      self.users = fetchedUsers
      CoreDataManager.shared.saveUsers(fetchedUsers)
      group.leave()
    }

    group.notify(queue: .main) { [weak self] in
      guard let self = self else { return }
      self.onDataLoaded?(self.users, self.displayedTodos)
    }
  }

  private func loadFromCache() {
    print(#function)
    self.allTodos = CoreDataManager.shared.fetchTodos()
    self.users = CoreDataManager.shared.fetchUsers()
    resetPagination()
    onDataLoaded?(users, displayedTodos)
  }


  //    func loadMoreTodos() {
  //        let startIndex = currentPage * itemsPerPage
  //        let endIndex = min(startIndex + itemsPerPage, allTodos.count)
  //
  //        guard startIndex < allTodos.count else { return }
  //
  //        let newItems = allTodos[startIndex..<endIndex]
  //        let groupedTodos = Dictionary(grouping: Array(newItems), by: { $0.userId })
  //
  //        for (userId, todos) in groupedTodos {
  //            if displayedTodos[userId] != nil {
  //                displayedTodos[userId]?.append(contentsOf: todos)
  //            } else {
  //                displayedTodos[userId] = todos
  //            }
  //        }
  //
  //        currentPage += 1
  //        onDataLoaded?(users, displayedTodos)
  //    }

  func loadMoreTodos() {
    guard hasMoreData else { return }

    let startIndex = currentPage * itemsPerPage
    let endIndex = min(startIndex + itemsPerPage, allTodos.count)

    DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in // ✅ 1 soniya kechikish
      guard let self = self else { return }

      let newItems = self.allTodos[startIndex..<endIndex]
      let groupedTodos = Dictionary(grouping: Array(newItems), by: { $0.userId })

      for (userId, todos) in groupedTodos {
        if self.displayedTodos[userId] != nil {
          self.displayedTodos[userId]?.append(contentsOf: todos)
        } else {
          self.displayedTodos[userId] = todos
        }
      }

      self.currentPage += 1

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        guard let self = self else { return }
        self.onDataLoaded?(self.users, self.displayedTodos)
      }
    }
  }

}
