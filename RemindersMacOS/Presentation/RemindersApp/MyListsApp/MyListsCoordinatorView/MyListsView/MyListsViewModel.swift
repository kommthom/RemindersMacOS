//
//  MyListsViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.09.23.
//

import Combine
import SwiftUI
import Reminders_Domain

class MyListsViewModel: ObservableObject, MyListsViewModelProtocol {
    private var interactor: MyListsInteractorProtocol
    
    // MARK: - Observable Properties -
    @Published var myListsLoadable: Loadable<LazyList<MyList>> {
        didSet {
            switch myListsLoadable {
            case .notRequested:
                allListItemsCount = 0
                AppLogger.reminders.log("MyLists not requested")
            case .isLoading(_, _):
                allListItemsCount = 0
                AppLogger.reminders.log("MyLists is loading")
            case .failed(let error):
                allListItemsCount = 0
                AppLogger.reminders.log("MyLists loading error: \(error.localizedDescription)")
            case .loaded(let myLists):
                self.myLists = myLists
                for list in myLists {
                    allListItemsCount += list.items.count
                }
                AppLogger.reminders.log("MyLists loaded count: \(myLists.count)")
           }
       }
    }
    var myLists: LazyList<MyList>?
    @Published var allListItemsCount: Int
    @Published var firstMyList: MyList?
    
    // Misc
    private var notificationSub: AnyCancellable?
    
    init(interactor: MyListsInteractorProtocol) {
        self.interactor = interactor
        self.myListsLoadable = .notRequested
        self.allListItemsCount = 0
        self.firstMyList = nil
        self.myLists = nil
        setupObservers()
    }
    
    private var newNotification: String? {
        didSet {
            guard newNotification != nil else { return }
            AppLogger.reminders.log("\(newNotification ?? "")")
            load()
        }
    }
    
    func load() {
        interactor
            .load(myLists: loadableSubject(\.myListsLoadable))
    }
    
    func deleteMyList(myList: MyList) {
        interactor
            .deleteMyList(myList: myList)
    }
    
    private func setupObservers() {
        let _ = NotificationCenter.default.publisher(for: Constants.Notifications.contextChanged)
            .map { notification in notification.object as? String }   // Transform the notification into a simple string
            .assign(to: \.newNotification, on: self)
    }
}
