//
//  ApplozicSwiftMemberUITest.swift
//  ApplozicSwiftDemoUITests
//
//  Created by Kommunicate on 03/02/20.
//  Copyright © 2020 Applozic. All rights reserved.
//

import XCTest

class ApplozicSwiftMemberUITest: XCTestCase {
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

//    func testAddMemberInGroup() {
//        let path = Bundle(for: ApplozicSwiftGroupSendMessageUITest.self).url(forResource: "Info", withExtension: "plist")
//        let dict = NSDictionary(contentsOf: path!) as? [String: Any]
//        let groupName = "DemogroupForText"
//        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
//        waitFor(object: app) { $0.isHittable }
//
//        //        let inputView = app.otherElements[AppScreen.chatBar].children(matching: .textView).matching(identifier: AppTextFeild.chatTextView).firstMatch
//        //        waitFor(object: inputView) { $0.isHittable }
//        //        let numberOfCells = app.tables.cells.count
//        //        inputView.tap()
//        //        inputView.typeText(GroupData.typeText) // typeing message
//        //        app.buttons[InAppButton.ConversationScreen.send].tap() // sending message in group
//        //        XCTAssertEqual(app.tables.cells.count, numberOfCells + 1)
//        //        XCTAssertEqual(app.tables.cells.element(boundBy: numberOfCells).identifier, AppCells.textCell)
//        //        let isGroupDeleted = deleteAGroup_FromConversationList_After_SendMessageInGroup(app: app) // leave the group and delete group
//        //        XCTAssertTrue(isGroupDeleted, "Faild to delete group DemoGroupForImage")
//
//        let addParticipant = app.collectionViews.staticTexts[InAppButton.CreatingGroup.addParticipant]
//        waitFor(object: addParticipant) { $0.isHittable }
//        addParticipant.tap()
//        let selectParticipantTableView = app.tables[AppScreen.selectParticipantView]
//        waitFor(object: selectParticipantTableView) { $0.isHittable }
//        selectParticipantTableView.staticTexts[dict?[GroupData.groupMember1] as! String].tap()
//        selectParticipantTableView.staticTexts[dict?[GroupData.groupMember2] as! String].tap()
//        app.buttons[InAppButton.CreatingGroup.invite].tap()
//    }

    func testRemoveMemberFromGroup() {
        //        let app = XCUIApplication()
        //        let myChatsNavigationBar = app.navigationBars["My Chats"]
        //        myChatsNavigationBar.buttons["fill 214"].tap()
        //        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Create Group"]/*[[".cells.staticTexts[\"Create Group\"]",".staticTexts[\"Create Group\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //        app.textFields["Type group name"].tap()
        //
        //        let app2 = app
        //        app2.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Add participants"]/*[[".cells.staticTexts[\"Add participants\"]",".staticTexts[\"Add participants\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //
        //        let selectparticipanttableviewTable = app2.tables["SelectParticipantTableView"]
        //        selectparticipanttableviewTable/*@START_MENU_TOKEN@*/.staticTexts["iOS Demo Contact 1"]/*[[".cells.staticTexts[\"iOS Demo Contact 1\"]",".staticTexts[\"iOS Demo Contact 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //        selectparticipanttableviewTable/*@START_MENU_TOKEN@*/.staticTexts["iOS Demo Contact 2"]/*[[".cells.staticTexts[\"iOS Demo Contact 2\"]",".staticTexts[\"iOS Demo Contact 2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //        app/*@START_MENU_TOKEN@*/.buttons["InviteButton"]/*[[".buttons[\"Invite  (2)\"]",".buttons[\"InviteButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //        myChatsNavigationBar.staticTexts["DemoGroupForRemoveUser"].tap()
        //        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"iOS Demo Contact 1").element.tap()
        //
        //        let elementsQuery = app.sheets.scrollViews.otherElements
        //        elementsQuery.buttons["Remove user"].tap()
        //        elementsQuery.buttons["Remove"].tap()
        //        app.buttons["Save"].tap()
        let app = XCUIApplication()
        let groupName = "DemoGroupForRemoveMember"
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

        // return app
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

    //        func beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: String) -> (XCUIApplication) {
    //            let app = XCUIApplication()
    //            let path = Bundle(for: ApplozicSwiftGroupSendMessageUITest.self).url(forResource: "Info", withExtension: "plist")
    //            let dict = NSDictionary(contentsOf: path!) as? [String: Any]
    //            let launchChat = app.buttons[InAppButton.LaunchScreen.launchChat]
    //            waitFor(object: launchChat) { $0.isHittable }
    //            app.buttons[InAppButton.LaunchScreen.launchChat].tap()
    //            let newChat = app.buttons[InAppButton.CreatingGroup.newChat]
    //            waitFor(object: newChat) { $0.isHittable }
    //            app.navigationBars[AppScreen.myChatScreen].buttons[InAppButton.CreatingGroup.newChat].tap()
    //            let createGroup = app.tables.staticTexts[InAppButton.CreatingGroup.createGroup]
    //            waitFor(object: createGroup) { $0.isHittable }
    //            createGroup.tap()
    //            let typeGroupNameTextField = app.textFields[AppTextFeild.typeGroupName]
    //            waitFor(object: typeGroupNameTextField) { $0.isHittable }
    //            typeGroupNameTextField.tap()
    //            typeGroupNameTextField.typeText(groupName)
    //            let addParticipant = app.collectionViews.staticTexts[InAppButton.CreatingGroup.addParticipant]
    //            waitFor(object: addParticipant) { $0.isHittable }
    //            addParticipant.tap()
    //            let selectParticipantTableView = app.tables[AppScreen.selectParticipantView]
    //            waitFor(object: selectParticipantTableView) { $0.isHittable }
    //            selectParticipantTableView.staticTexts[dict?[GroupData.groupMember1] as! String].tap()
    //            selectParticipantTableView.staticTexts[dict?[GroupData.groupMember2] as! String].tap()
    //            app.buttons[InAppButton.CreatingGroup.invite].tap()
    //            return app
    //        }

//    private func deleteAGroup_FromConversationList_After_SendMessageInGroup(app: XCUIApplication) -> Bool {
//        let back = app.navigationBars[AppScreen.myChatScreen].buttons[InAppButton.ConversationScreen.back]
//        waitFor(object: back) { $0.isHittable }
//        back.tap()
//        let outerChatScreenTableView = app.tables[AppScreen.conversationList]
//        if outerChatScreenTableView.cells.count == 0 {
//            return false
//        }
//        outerChatScreenTableView.cells.allElementsBoundByIndex.first?.swipeRight()
//        let swippableDelete1 = app.buttons[InAppButton.ConversationScreen.swippableDelete]
//        waitFor(object: swippableDelete1) { $0.isHittable }
//        outerChatScreenTableView.buttons[InAppButton.ConversationScreen.swippableDelete].tap()
//        let leave = app.alerts.scrollViews.otherElements.buttons[InAppButton.CreatingGroup.leave] // app.buttons[InAppButton.CreatingGroup.leave]
//        waitFor(object: leave) { $0.isHittable }
//        leave.tap()
//        if outerChatScreenTableView.cells.count == 0 {
//            return false
//        }
//        sleep(5)
//        outerChatScreenTableView.cells.allElementsBoundByIndex.first?.swipeRight()
//        let swippableDelete2 = app.buttons[InAppButton.ConversationScreen.swippableDelete]
//        waitFor(object: swippableDelete2) { $0.isHittable }
//        outerChatScreenTableView.buttons[InAppButton.ConversationScreen.swippableDelete].tap()
//        let remove = app.alerts.scrollViews.otherElements.buttons[InAppButton.CreatingGroup.remove] // app.buttons[InAppButton.CreatingGroup.remove]
//        waitFor(object: remove) { $0.isHittable }
//        remove.tap()
//        return true
//    }
}
