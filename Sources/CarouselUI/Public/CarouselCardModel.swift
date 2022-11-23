//
//  CarouselCardModel.swift
//  CarouselUI
//
//  Created by yukonblue on 08/04/2022.
//

import SwiftUI

public protocol CarouselCardModel: ObservableObject {

    var activeCard: Int { get }

    var screenDrag: Float { get set }

    func incrementActiveCard()

    func decrementActiveCard()

    func willSetActiveCard(newValue: Int)
}

public class CarouselCardModelImpl: CarouselCardModel {

    var itemsCount: Int

    @Published public var activeCard: Int = 0 {
        willSet(newValue) {
            self.willSetActiveCard(newValue: newValue)
        }
    }

    @Published public var screenDrag: Float = 0.0

    public init(itemsCount: Int) {
        self.itemsCount = itemsCount
    }

    public func incrementActiveCard() {
        self.activeCard = min(self.activeCard + 1, itemsCount - 1)
    }

    public func decrementActiveCard() {
        self.activeCard = max(self.activeCard - 1, 0)
    }

    public func willSetActiveCard(newValue: Int) {
        // Do nothing
    }
}
