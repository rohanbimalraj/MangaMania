//
//  NotificationManager.swift
//  MangaMania
//
//  Created by Rohan Bimal Raj on 24/10/23.
//
import SwiftUI

class NotificationManager: ObservableObject {
    
    private let internalQueue = DispatchQueue(label: "com.singletioninternal.queue",
                                                  qos: .default,
                                                  attributes: .concurrent)

    private var _mangaUrl: String?
    var mangaUrl: String? {
        get {
            return internalQueue.sync {
                _mangaUrl
            }
        }
        set {
            objectWillChange.send()
            internalQueue.async(flags: .barrier) {
                self._mangaUrl = newValue
            }
        }
    }
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func decodePayload(userInfo: [AnyHashable: Any]) {
        
        if let mangaUrl = userInfo["manga_url"] as? String {
            self.mangaUrl = mangaUrl
        }
    }
    
    func reset() {
        mangaUrl = nil
    }
}
