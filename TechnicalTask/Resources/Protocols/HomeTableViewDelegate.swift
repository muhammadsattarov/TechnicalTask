

import Foundation

protocol HomeTableViewDelegate: AnyObject {
  func didSelectRowAt(_ indexPath: IndexPath, user: User)
}
