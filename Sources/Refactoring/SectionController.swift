//
//  SectionController.swift
//  ApplozicSwift
//
//  Created by Mukesh on 08/06/19.
//

import Foundation
import DifferenceKit

protocol ChatItem {
    var reuseIdentifier: String { get }

    //TODO: Add diffing key by default
}

class ChatCell: UICollectionViewCell {
    var viewModel: ChatItem!
}

protocol Section {

    // Like ALkMessageModel
    var model: AnyDifferentiable { get }

    var viewModels: Array<ChatItem> { get }

    func cellForRow(
        _ viewModel: ChatItem,
        collectionView: UICollectionView,
        indexPath: IndexPath) -> ChatCell
}

extension Section {
    func cellForRow(_ viewModel: ChatItem, collectionView: UICollectionView, indexPath: IndexPath) -> ChatCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: viewModel.reuseIdentifier,
                for: indexPath) as? ChatCell else {
                    return ChatCell()
        }
        cell.viewModel = viewModel
        return cell
    }
}

struct AnySection: Section, Differentiable {

    var base: Section

    var model: AnyDifferentiable {
        return base.model
    }

    var viewModels: Array<ChatItem> {
        return base.viewModels
    }

    var differenceIdentifier: AnyHashable {
        return AnyHashable(model.differenceIdentifier)
    }

    init<S: Section>(base: S) {
        self.base = base
    }

    func isContentEqual(to source: AnySection) -> Bool {
        return model.isContentEqual(to: source.model)
    }
}

struct AnyChatItem: ChatItem, Differentiable {
    var base: ChatItem

    var reuseIdentifier: String {
        return base.reuseIdentifier
    }
    var differenceIdentifier: AnyHashable

    var isEqual: (AnyChatItem) -> Bool

    init<C: ChatItem & Differentiable>(_ base: C) {
        self.base = base
        self.differenceIdentifier = base.differenceIdentifier

        self.isEqual = { source in
            return (source.base as? C)?.differenceIdentifier == base.differenceIdentifier
        }
    }

    func isContentEqual(to source: AnyChatItem) -> Bool {
        return isEqual(source)
    }
}
