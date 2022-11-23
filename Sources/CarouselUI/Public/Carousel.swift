//
//  Carousel.swift
//  CarouselUI
//
//  Created by yukonblue on 08/04/2022.
//

import SwiftUI

/// https://github.com/ericg-learn-apple/SnapCarousel
public struct Carousel<Items: View>: View {

    @EnvironmentObject var cardModel: CarouselCardModelImpl

    @GestureState var isDetectingLongPress = false

    let items: Items
    let numberOfItems: Int
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat

    public init(
        numberOfItems: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items
    ) {
        assert(numberOfItems > 0, "Number of cards must be greater than zero")
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = CGFloat((numberOfItems - 1)) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
    }

    private var offset: CGFloat {
        let totalCanvasWidth: CGFloat = (cardWidth * CGFloat(numberOfItems)) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing

        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(self.cardModel.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(self.cardModel.activeCard) + 1)

        var calcOffset = Float(activeOffset)

        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + self.cardModel.screenDrag
        }

        return CGFloat(calcOffset)
    }

    public var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: self.offset, y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.cardModel.screenDrag = Float(currentState.translation.width)
        }.onEnded { value in
            self.cardModel.screenDrag = 0

            if (value.translation.width < -50) {
                self.cardModel.incrementActiveCard()
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }

            if (value.translation.width > 50) {
                self.cardModel.decrementActiveCard()
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
        // This replaces `.animation(.spring())` on `CarouselCell` within `ExplorationView`
        .animation(.spring(), value: cardModel.activeCard)
    }
}

