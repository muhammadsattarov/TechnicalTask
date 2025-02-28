

import Foundation

protocol HomeTableViewDelegate: AnyObject {
  func didSelectRowAt(_ indexPath: IndexPath, user: User)
  func loadMoreTodos() 
  var isLoadingMore: Bool { get set }
  var hasMoreData: Bool { get }
}
