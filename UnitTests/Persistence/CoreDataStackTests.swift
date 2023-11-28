//
//  CoreDataStackTests.swift
//  UnitTests
//
//  Created by Thomas on 02.09.23.
//


import XCTest
import Combine
@testable import RemindersMacOS

class CoreDataStackTests: XCTestCase {
    
    var sut: CoreDataStack!
    let testDirectory: FileManager.SearchPathDirectory = .cachesDirectory
    var dbVersion: UInt { fatalError("Override") }
    var cancelBag = CancelBag()
    
    override func setUp() {
        eraseDBFiles()
        sut = CoreDataStack(directory: testDirectory, version: dbVersion)
    }
    
    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        eraseDBFiles()
    }
    
    func eraseDBFiles() {
        let version = CoreDataStack.Version(dbVersion)
        if let url = version.dbFileURL(testDirectory, .userDomainMask) {
            try? FileManager().removeItem(at: url)
        }
    }
}

// MARK: - Version 1

final class CoreDataStackV1Tests: CoreDataStackTests {
    
    override var dbVersion: UInt { 1 }

    func test_initialization() {
        let exp = XCTestExpectation(description: #function)
        let request = MyListMO.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        sut.fetch(request) { _ -> Int? in
            return nil
        }
        .sinkToResult { result in
            result.assertSuccess(value: LazyList<Int>.empty)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }
    
    func test_inaccessibleDirectory() {
        let sut = CoreDataStack(directory: .adminApplicationDirectory,
                                domainMask: .systemDomainMask, version: dbVersion)
        let exp = XCTestExpectation(description: #function)
        let request = MyListMO.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        sut.fetch(request) { _ -> Int? in
            return nil
        }
        .sinkToResult { result in
            result.assertFailure()
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }
    
    func test_counting_onEmptyStore() {
        let request = MyListMO.fetchRequest()
        request.predicate = NSPredicate(value: true)
        let exp = XCTestExpectation(description: #function)
        sut.count(request)
        .sinkToResult { result in
            result.assertSuccess(value: 0)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }
    
    func test_storing_and_countring() {
        let myLists = MyList.mockedData
        
        let request = MyListMO.fetchRequest()
        request.predicate = NSPredicate(value: true)
        
        let exp = XCTestExpectation(description: #function)
        sut.update { context in
            myLists.forEach {
                $0.store(in: context)
            }
        }
        .flatMap { _ in
            self.sut.count(request)
        }
        .sinkToResult { result in
            result.assertSuccess(value: myLists.count)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }
    
    func test_storing_exception() {
        let exp = XCTestExpectation(description: #function)
        sut.update { context in
            throw NSError.test
        }
        .sinkToResult { result in
            result.assertFailure(NSError.test.localizedDescription)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }
    
    /*func test_fetching() {
        let myLists = MyList.mockedData
        let exp = XCTestExpectation(description: #function)
        sut
            .update { context in
                myLists.forEach {
                    $0.store(in: context)
                }
            }
            .flatMap { _ -> AnyPublisher<LazyList<MyList>, Error> in
                let request = MyListMO.fetchRequest()
                request.predicate = NSPredicate(format: "name == %@", myLists[0].name)
                return self.sut.fetch(request) {
                    MyList(managedObject: $0)
                }
            }
            .sinkToResult { result in
                //result.assertSuccess(value: LazyList<MyList>(
                //    count: 1, useCache: false, { _ in myLists[0] })
                //)
                //exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }*/
}
