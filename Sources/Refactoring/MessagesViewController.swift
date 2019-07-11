//
//  MessagesViewController.swift
//  ApplozicSwift
//
//  Created by Mukesh on 10/06/19.
//

//import Foundation
//import DifferenceKit

//private let reuseIdentifier = "Cell"
//
//public class MessagesViewController: MessageThreadViewController {
//
//    var textMessage: ALKMessageModel {
//        let textMessage = ALKMessageModel()
//        textMessage.message = "First message"
//        textMessage.identifier = "12344"
//        textMessage.messageType = .text
//        return textMessage
//    }
//
//    enum Operation {
//        case add
//        case update
//        case delete
//    }
//
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.register(SampleTableViewCell.self)
//
//        var textSections = generateRandomMessages(count: 6)
//        update(sections: textSections)
//
//        if #available(iOS 10.0, *) {
//            let _ = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
//                print(timer)
//                self.randomlyUpdate(sections: &textSections, operation: .add)
//                self.update(sections: textSections)
//            }
//            let _ = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
//                print(timer)
//                self.randomlyUpdate(sections: &textSections, operation: .update)
//                self.update(sections: textSections)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        //TODO: Run a timer for 3 secs then call add Op then after 3 secs update Op.
//
//    }
//
//    func randomlyUpdate(
//        sections: inout [ArraySection<AnySection, AnyChatItem>],
//        operation: Operation) {
//
//        switch operation {
//        case .add:
//            sections.append(contentsOf: generateRandomMessages(count: 1))
//        case .update:
//            let random = Int.random(in: 0...7)
//            let firstMessage = sections[random]
//            let message = textMessage
//            message.identifier = String(firstMessage.differenceIdentifier as! Int)
//            message.message = "updated message \(message.identifier) & \(random)"
//            sections.remove(at: random)
//            sections.insert(createMessageSectionUsing(message), at: 0)
//        default:
//            print("operation not supported")
//        }
//
//
//        // Delete an item
//    }
//
//    func generateRandomMessages(count: Int) -> [ArraySection<AnySection, AnyChatItem>] {
//        var sections = [ArraySection<AnySection, AnyChatItem>]()
//        for _ in 0..<count {
//            let message = textMessage
//            let identifier = String(Int.random(in: 33345...44444))
//            message.message = "First message \(identifier)"
//            let textSection = MessageSection(message)
//            let section = ArraySection(
//                model: AnySection(textSection),
//                elements: textSection.viewModels)
//            sections.append(section)
//        }
//        return sections
//    }
//
//    func createMessageSectionUsing(_ messageModel: ALKMessageModel) -> ArraySection<AnySection, AnyChatItem> {
//        let textSection = MessageSection(messageModel)
//        let section = ArraySection(
//            model: AnySection(textSection),
//            elements: textSection.viewModels)
//        return section
//    }
//
//    func convert(dict: Dictionary<String, String>) -> String? {
//        do {
//            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//            return String(data: data, encoding: String.Encoding.utf8) ?? nil
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//}
