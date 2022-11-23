//
//  CarouselCell.swift
//  CarouselUI
//
//  Created by yukonblue on 11/23/2022.
//

import SwiftUI

struct CarouselCell<Content: View>: View {

    @EnvironmentObject var cardModel: CarouselCardModelImpl

    let _id: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let content: Content

    @inlinable init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self._id = _id
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
        self.cardHeight = self.cardWidth // NOTE: Here we ignore the `cardHeight` parameter, and make the card height equal card width to ensure active cards are always square.
        self.content = content()
    }

    var resolvedCardWidth: CGFloat {
        self.cardWidth
    }

    var resolvedCardHeight: CGFloat {
        self._id == self.cardModel.activeCard ? cardHeight : cardHeight - 60
    }

    var body: some View {
        content
            .frame(width: self.resolvedCardWidth,
                   height: self.resolvedCardHeight,
                   alignment: .center)
    }
}
