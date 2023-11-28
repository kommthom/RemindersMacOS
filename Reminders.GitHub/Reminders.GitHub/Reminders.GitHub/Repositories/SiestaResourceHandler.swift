//
//  SiestaResourceHandler.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.11.23.
//

import Foundation
import Siesta

public class SiestaResourceHandler<T, V: GetResourceParams>: ResourceObserver {
    
    public typealias CallBack = (T) -> Void
    private let callBack: CallBack
    private let getResource: (_ params: V) -> Resource?
    private let params: V
    private var returnValue: T?
    public var resource: Resource?{
        didSet {
            returnValue = nil
            updateObservation(from: oldValue, to: resource)
        }
    }
    
    private func updateObservation(from oldResource: Resource?, to newResource: Resource?) {
        guard oldResource != newResource else { return }
        if oldResource !== nil {
            oldResource?.removeObservers(ownedBy: self)
            oldResource?.cancelLoadIfUnobserved(afterDelay: 0.1)
        }
        if newResource !== nil {
            newResource?
                .addObserver(self)
                .loadIfNeeded()
        }
    }
    public func resourceChanged(_ resource: Siesta.Resource, event: Siesta.ResourceEvent) {
        returnValue = resource.typedContent()
        if let _ = returnValue {
            callBack(returnValue!)
        }
    }
    
    public init(getResource: @escaping (_ params: V) -> Resource, params: V, _ callBack: @escaping CallBack) {
        self.getResource = getResource
        self.callBack = callBack
        self.resource = nil
        self.returnValue = nil
        self.params = params
        self.resource = getResource(params)
        self.resource?.loadIfNeeded()
        Delay(10).performWork({
            if let _ = self.returnValue {} else {
                callBack(self.returnValue!)
            }
        })
    }
}
