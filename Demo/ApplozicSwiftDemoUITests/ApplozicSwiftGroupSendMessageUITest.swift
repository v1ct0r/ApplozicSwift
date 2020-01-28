//
//  ApplozicSwiftGroupUITest.swift
//  ApplozicSwiftDemoUITests
//
//  Created by Archit on 26/11/19.
//  Copyright © 2019 Applozic. All rights reserved.
//

import XCTest

class ApplozicSwiftGroupSendMessageUITest: XCTestCase {
    enum GroupData {
        static let groupMember1 = "GroupMember1"
        static let groupMember2 = "GroupMember2"
        static let typeText = "Hello Applozic"
        static let fillUserId = "TestUserId"
        static let fillPassword = "TestUserPassword"
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessNotificationInApplication) { (alerts) -> Bool in
            if alerts.buttons[AppPermission.AlertButton.allow].exists {
                alerts.buttons[AppPermission.AlertButton.allow].tap()
            }
            return true
        }
        XCUIApplication().launch()
        sleep(5)
        guard !XCUIApplication().scrollViews.otherElements.buttons[InAppButton.LaunchScreen.getStarted].exists else {
            login()
            return
        }
    }

    func testSendTextMessageInGroup() {
        let groupName = "DemogroupForText"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        waitFor(object: app) { $0.isHittable }
        let inputView = app.otherElements[AppScreen.chatBar].children(matching: .textView).matching(identifier: AppTextFeild.chatTextView).firstMatch
        waitFor(object: inputView) { $0.isHittable }
        let numberOfCells = app.tables.cells.count
        inputView.tap()
        inputView.typeText(GroupData.typeText) // typeing message
        app.buttons[InAppButton.ConversationScreen.send].tap() // sending message in group
        XCTAssertEqual(app.tables.cells.count, numberOfCells + 1)
        XCTAssertEqual(app.tables.cells.element(boundBy: numberOfCells).identifier, AppCells.textCell)
        let isGroupDeleted = deleteAGroup_FromConversationList_After_SendMessageInGroup(app: app) // leave the group and delete group
        XCTAssertTrue(isGroupDeleted, "Faild to delete group DemoGroupForImage")
    }

    func testSendImageInGroup() {
        let groupName = "DemoGroupForImage"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        let openPhotos = app.buttons[InAppButton.ConversationScreen.openPhotos]
        waitFor(object: openPhotos) { $0.isHittable }
        let numberOfCells = app.tables.cells.count
        app.buttons[InAppButton.ConversationScreen.openPhotos].tap() // Click on photo button
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessPhoto) { (alerts) -> Bool in
            if alerts.buttons[AppPermission.AlertButton.ok].exists {
                alerts.buttons[AppPermission.AlertButton.ok].tap()
                return true
            }
            return false
        }
        app.tap()
        let allImages = app.collectionViews.children(matching: .cell)
        let thirdImageInFirstRow = allImages.element(boundBy: 2)
        waitFor(object: thirdImageInFirstRow) { $0.exists }
        thirdImageInFirstRow.tap()
        let selectPhoto = app.navigationBars[InAppButton.ConversationScreen.selectPhoto]
        waitFor(object: selectPhoto) { $0.isHittable }
        selectPhoto.tap()
        let doneButton = app.buttons[InAppButton.ConversationScreen.done]
        waitFor(object: doneButton) { $0.isHittable }
        doneButton.tap()
        waitFor(object: openPhotos) { $0.isHittable }
        XCTAssertEqual(app.tables.cells.count, numberOfCells + 1)
        XCTAssertEqual(app.tables.cells.element(boundBy: numberOfCells).identifier, AppCells.photoCell)
        let isGroupDeleted = deleteAGroup_FromConversationList_After_SendMessageInGroup(app: app) // leave the group and delete group
        XCTAssertTrue(isGroupDeleted, "Faild to delete group DemoGroupForImage")
    }

    func testSendContactInGroup() {
        let groupName = "DemoGroupForContact"

        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        let openContact = app.buttons[InAppButton.ConversationScreen.openContact]
        waitFor(object: openContact) { $0.isHittable }
        let numberOfCells = app.tables.cells.count
        openContact.tap() // Click on Contact button
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessContact) { (alerts) -> Bool in
            if alerts.buttons[AppPermission.AlertButton.ok].exists {
                alerts.buttons[AppPermission.AlertButton.ok].tap()
                return true
            }
            return false
        }
        app.tap()
        let selectcontact = app.tables[InAppButton.ConversationScreen.selectcontact] // selection any conatct and than sending
        waitFor(object: selectcontact) { $0.isHittable }
        selectcontact.tap()
        waitFor(object: openContact) { $0.isHittable }
        XCTAssertEqual(app.tables.cells.count, numberOfCells + 1)
        XCTAssertEqual(app.tables.cells.element(boundBy: numberOfCells).identifier, AppCells.contactCell)
        let isGroupDeleted = deleteAGroup_FromConversationList_After_SendMessageInGroup(app: app) // leave the group and delete group
        XCTAssertTrue(isGroupDeleted, "Faild to delete group DemoGroupForImage")
    }

    func testSendLocationInGroup() {
        let groupName = "DemoGroupForLocation"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        let openLocation = app.buttons[InAppButton.ConversationScreen.openLocation]
        waitFor(object: openLocation) { $0.isHittable }
        let numberOfCells = app.tables.cells.count
        openLocation.tap() // click on location button
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessLocation) { (alerts) -> Bool in
            if alerts.buttons[AppPermission.AlertButton.allowLoation].exists {
                alerts.buttons[AppPermission.AlertButton.allowLoation].tap()
                return true
            }
            return false
        }
        app.tap()
        let sendLocation = app.buttons[InAppButton.ConversationScreen.sendLocation] // sending current location
        waitFor(object: sendLocation) { $0.isHittable }
        sendLocation.tap()
        waitFor(object: openLocation) { $0.isHittable }
        XCTAssertEqual(app.tables.cells.count, numberOfCells + 1)
        XCTAssertEqual(app.tables.cells.element(boundBy: numberOfCells).identifier, AppCells.locationCell)
        let isGroupDeleted = deleteAGroup_FromConversationList_After_SendMessageInGroup(app: app) // leave the group and delete group
        XCTAssertTrue(isGroupDeleted, "Faild to delete group DemoGroupForLocation")
    }

    private func login() {
        let path = Bundle(for: ApplozicSwiftGroupSendMessageUITest.self).url(forResource: "Info", withExtension: "plist")
        let dict = NSDictionary(contentsOf: path!) as? [String: Any]
        let userId = dict?[GroupData.fillUserId]
        let password = dict?[GroupData.fillPassword]
        XCUIApplication().tap()
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let userIdTextField = elementsQuery.textFields[AppTextFeild.userId]
        userIdTextField.tap()
        userIdTextField.typeText(userId as! String)
        let passwordSecureTextField = elementsQuery.secureTextFields[AppTextFeild.password]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password as! String)
        elementsQuery.buttons[InAppButton.LaunchScreen.getStarted].tap()
    }

    private func beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: String) -> (XCUIApplication) {
        let app = XCUIApplication()
        let path = Bundle(for: ApplozicSwiftGroupSendMessageUITest.self).url(forResource: "Info", withExtension: "plist")
        let dict = NSDictionary(contentsOf: path!) as? [String: Any]
        let launchChat = app.buttons[InAppButton.LaunchScreen.launchChat]
        waitFor(object: launchChat) { $0.isHittable }
        app.buttons[InAppButton.LaunchScreen.launchChat].tap()
        let newChat = app.buttons[InAppButton.CreatingGroup.newChat]
        waitFor(object: newChat) { $0.isHittable }
        app.navigationBars[AppScreen.myChatScreen].buttons[InAppButton.CreatingGroup.newChat].tap()
        let createGroup = app.tables.staticTexts[InAppButton.CreatingGroup.createGroup]
        waitFor(object: createGroup) { $0.isHittable }
        createGroup.tap()
        let typeGroupNameTextField = app.textFields[AppTextFeild.typeGroupName]
        waitFor(object: typeGroupNameTextField) { $0.isHittable }
        typeGroupNameTextField.tap()
        typeGroupNameTextField.typeText(groupName)
        let addParticipant = app.collectionViews.staticTexts[InAppButton.CreatingGroup.addParticipant]
        waitFor(object: addParticipant) { $0.isHittable }
        addParticipant.tap()
        let selectParticipantTableView = app.tables[AppScreen.selectParticipantView]
        waitFor(object: selectParticipantTableView) { $0.isHittable }
        selectParticipantTableView.staticTexts[dict?[GroupData.groupMember1] as! String].tap()
        selectParticipantTableView.staticTexts[dict?[GroupData.groupMember2] as! String].tap()
        app.buttons[InAppButton.CreatingGroup.invite].tap()
        return app
    }

    private func deleteAGroup_FromConversationList_After_SendMessageInGroup(app: XCUIApplication) -> Bool {
        let back = app.navigationBars[AppScreen.myChatScreen].buttons[InAppButton.ConversationScreen.back]
        waitFor(object: back) { $0.isHittable }
        back.tap()
        let outerChatScreenTableView = app.tables[AppScreen.conversationList]
        if outerChatScreenTableView.cells.isEmpty {
            return false
        }
        outerChatScreenTableView.cells.allElementsBoundByIndex.first?.swipeRight()
        let swippableDelete1 = app.buttons[InAppButton.ConversationScreen.swippableDelete]
        waitFor(object: swippableDelete1) { $0.isHittable }
        outerChatScreenTableView.buttons[InAppButton.ConversationScreen.swippableDelete].tap()
        let leave = app.alerts.scrollViews.otherElements.buttons[InAppButton.CreatingGroup.leave] // app.buttons[InAppButton.CreatingGroup.leave]
        waitFor(object: leave) { $0.isHittable }
        leave.tap()
        if outerChatScreenTableView.cells.isEmpty {
            return false
        }
        sleep(5)
        outerChatScreenTableView.cells.allElementsBoundByIndex.first?.swipeRight()
        let swippableDelete2 = app.buttons[InAppButton.ConversationScreen.swippableDelete]
        waitFor(object: swippableDelete2) { $0.isHittable }
        outerChatScreenTableView.buttons[InAppButton.ConversationScreen.swippableDelete].tap()
        let remove = app.alerts.scrollViews.otherElements.buttons[InAppButton.CreatingGroup.remove] // app.buttons[InAppButton.CreatingGroup.remove]
        waitFor(object: remove) { $0.isHittable }
        remove.tap()
        return true
    }
}

extension XCTestCase {
    func waitFor<T>(object: T, timeout: TimeInterval = 20, file: String = #file, line: UInt = #line, expectationPredicate: @escaping (T) -> Bool) {
        let predicate = NSPredicate { obj, _ in
            expectationPredicate(obj as! T)
        }
        expectation(for: predicate, evaluatedWith: object, handler: nil)
        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                let message = "Failed to fulful expectation block for \(object) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}
