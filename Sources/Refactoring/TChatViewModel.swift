//
//  TChatViewModel.swift
//  ApplozicSwift
//
//  Created by Mukesh on 27/06/19.
//

import Foundation
import DifferenceKit

struct TChatViewModel: ChatItem {
    var reuseIdentifier: String {
        return "<Change this>"
    }

    // Unique identifier for Differentiable, by default
    // it will be a random id
    var id: Int

    var avatarURL: URL?
    var name: String
    var message: String
    var totalNumberOfUnreadMessages: Int
    var createdAt: String


}

extension TChatViewModel: Differentiable {

    var differenceIdentifier: Int {
        return id
    }

    func isContentEqual(to source: TChatViewModel) -> Bool {
        return source.avatarURL == avatarURL
            && source.name == name
            && source.totalNumberOfUnreadMessages == totalNumberOfUnreadMessages
    }
}
