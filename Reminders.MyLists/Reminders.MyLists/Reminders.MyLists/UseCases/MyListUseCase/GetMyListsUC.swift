//
//  GetMyListsUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.09.23.
//

import Foundation
import Reminders_Domain
import Combine

// MARK: - Implementation -

public class DefaultGetMyListsUC: GetMyListsUCProtocol {
    private let myListsRepository: MyListsDBRepositoryProtocol
    
    public init(myListsRepository: MyListsDBRepositoryProtocol) {
        self.myListsRepository = myListsRepository
    }
    
    public func execute(myLists: LoadableSubject<LazyList<MyList>>) {
        
        let cancelBag = CancelBag()
        myLists.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [myListsRepository] _ -> AnyPublisher<Bool, Error> in
                myListsRepository.hasLoadedMyLists()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return Just<Void>.withErrorType(Error.self)
                }
            }
            .flatMap { [myListsRepository] in
                myListsRepository.myLists()
            }
            .sinkToLoadable {myLists.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

public class MockedGetMyListsUC: GetMyListsUCProtocol {
    public func execute(myLists: LoadableSubject<LazyList<MyList>>) {
        let cancelBag = CancelBag()
        myLists.wrappedValue.setIsLoading(cancelBag: cancelBag)
    }
    
    public init() {
        
    }
}
