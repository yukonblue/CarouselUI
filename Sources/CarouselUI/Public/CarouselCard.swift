//
//  CarouselCard.swift
//  CarouselUI
//
//  Created by yukonblue on 08/29/2022.
//

import SwiftUI

public struct CarouselCard<Content: View> : View {

    let id: Int
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let cardHeight: CGFloat
    let backgroundColor: Color
    let isActiveCard: Bool
    let content: Content

    public init(id: Int,
         spacing: CGFloat,
         widthOfHiddenCards: CGFloat,
         cardHeight: CGFloat,
         backgroundColor: Color,
         isActiveCard: Bool,
         @ViewBuilder contentBuilder: () -> Content
    ) {
        self.id = id
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.cardHeight = cardHeight
        self.backgroundColor = backgroundColor
        self.isActiveCard = isActiveCard
        self.content = contentBuilder()
    }

    public var body: some View {
        CarouselCell(_id: id,
             spacing: spacing,
             widthOfHiddenCards: widthOfHiddenCards,
             cardHeight: cardHeight
        ) {
            self.content
        }
        .foregroundColor(Color.red)
        .background(self.backgroundColor)
        .cornerRadius(CornerRadius.tiny.rawValue)
        .shadow(color: isActiveCard ? .black : .clear, radius: 4.0, x: 0, y: 4)
        .transition(AnyTransition.slide)
        // NOTE: This is the original behavior.
        // However, this `.animation(_:Animation)` is deprecated and also this caused
        // carousel view to be janky on view onAppear.
        // The fix is by replacing this with
        // `.animation(.spring(), value: cardModel.activeCard)` in `Carousel` instead of here.
//                            .animation(.spring())
    }
}

struct CarouselCard_Previews: PreviewProvider {

    static let spacing:            CGFloat = 16
    static let widthOfHiddenCards: CGFloat = 32
    static let cardHeight:         CGFloat = 27

    static var previews: some View {
        CarouselCard(id: 0,
                     spacing: spacing,
                     widthOfHiddenCards: widthOfHiddenCards,
                     cardHeight: cardHeight,
                     backgroundColor: .yellow,
                     isActiveCard: true) {
            Text("Hello, world")
        }
        .environmentObject(CarouselCardModelImpl(itemsCount: 3))
    }
}
