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
}

class ChatCell: UICollectionViewCell {
    var viewModel: ChatItem!
}

protocol Section {

    // Like ALkMessageModel
//    var object: AnyDifferentiable { get }
//
//    init(object: AnyDifferentiable)

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

}
