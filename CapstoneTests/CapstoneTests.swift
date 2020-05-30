//
//  CapstoneTests.swift
//  CapstoneTests
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import XCTest
import Firebase

@testable import Capstone

class CapstoneTests: XCTestCase {
    
    func testFirebase() {
        let expected = "hello"
        let exp = XCTestExpectation(description: "test found")
        
        DatabaseService.shared.testFirebase { (results) in
            switch results {
                case(.failure(let error)):
                    XCTFail("error in test: \(error.localizedDescription)")
                case(.success(let tests)):
                    XCTAssertEqual(expected, tests.first?.test)
                    exp.fulfill()
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchUserJobs() {
        let expectedCount = 1 // current user has one job 
        let exp = XCTestExpectation(description: "user jobs found")
        
        DatabaseService.shared.fetchUserJobs { (result) in
            exp.fulfill()
            
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching user jobs: \(error.localizedDescription)")
            case(.success(let userJobs)):
                XCTAssertEqual(expectedCount, userJobs.count)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    
    func testAddingToUserJobs() {
        let exp = XCTestExpectation(description: "user job added")
        let id = UUID().uuidString
        
        let userJob = UserJob(["id": id, "title": "title", "companyName": "companyName", "beginDate": Timestamp(date: Date()), "endDate": Timestamp(date: Date()), "currentEmployer": true, "description": "description", "responsibilities": ["id1", "id2"], "starSituationIDs": ["id1", "id2"], "interviewQuestionIDs": ["id1", "id2"]])
        
        DatabaseService.shared.addToUserJobs(userJob: userJob) { (result) in
            exp.fulfill()
            
            switch result {
            case(.failure(let error)):
                XCTFail("error adding to user jobs: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssert(result)
            }
            
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    
    func testRemovingUserJob() {
        let exp = XCTestExpectation(description: "user job removed")
        let testid = "testid" // add new id here to test another delete
        
        DatabaseService.shared.removeUserJob(userJobId: testid) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error deleting to user jobs: \(error.localizedDescription)")
                //print("error deleting to user jobs: \(error.localizedDescription)")
            case(.success(let result)):
                 XCTAssert(result)
            }
        }
        
         wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchingInterviewQuestions() {
        let expectedCount = 6 // during this test there were 6 common interview questions on database
        let exp = XCTestExpectation(description: "interview questions found")

        DatabaseService.shared.fetchCommonInterviewQuestions { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching interview questions: \(error.localizedDescription)")
            case(.success(let questions)):
                XCTAssertEqual(expectedCount, questions.count)

            }
        }
        
        wait(for:[exp], timeout: 5.0)
    }
    
    func testAddingContactsToUserJob() {
        
        let exp = XCTestExpectation(description: "added contact to user job")
        let userJobId = "27A8243C-47D5-4D8F-A0C0-835373828977"
        let contact = Contact(id: "12345id", email: "email.com", firstName: "bob", lastName: "bobby", phoneNumber: "1234567")
        
        
        DatabaseService.shared.addContactsToUserJob(userJobId: userJobId, contact: contact) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding contact to user job: \(error.localizedDescription)")
            case(.success(let result)):
                 XCTAssert(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
        
    }
    
}
