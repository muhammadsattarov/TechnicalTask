


import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    private init() {}

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnectedChanged(path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    private func isConnectedChanged(_ status: Bool) {
        NotificationCenter.default.post(name: .networkStatusChanged, object: status)
    }
}

// Notification qo'shish uchun extension
extension Notification.Name {
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
}

