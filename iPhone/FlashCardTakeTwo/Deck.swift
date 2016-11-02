//
//  Deck.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/14/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import Foundation

class Deck: NSObject, NSCoding //
{
    
    struct PropertyKey {
        static let cardsKey = "cards"
        static let nameKey = "name"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("decks")
    
    var cards = [Card]()
    var name: String
    var cardPath: String
    
    init(name: String)
    {
        self.name = name
        cardPath = Card.ArchiveURL!.path! + name
    }
    
    init(cards: [Card], name: String)
    {
        self.cards = cards
        self.name = name
        cardPath = Card.ArchiveURL!.path! + name
    }
    
    func addCard(card: Card)
    {
        cards.append(card)
    }
    
    func addDeck(deck: Deck)
    {
        for card in deck.cards
        {
            cards.append(card)
        }
    }
    
    func removeCard(index: Int) -> Card
    {
        return cards.removeAtIndex(index)
    }
    
//    func shuffleCards()
//    {
//        var newOrder = [Card]()
//        srandom(arc4random())
//        var ind = 0
//        while (cards.count > 0)
//        {
//            ind = random() % cards.count
//            newOrder.append(cards.removeAtIndex(ind))
//        }
//        cards = newOrder
//    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        saveCards()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.init(name: name)
        let loadedCards = loadCards()!
        self.cards = loadedCards
    }
    
    func loadCards() -> [Card]?
    {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(cardPath) as? [Card]
    }
    
    func saveCards()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.cards, toFile: cardPath)
        if !isSuccessfulSave {
            print("Failed to save cards...")
        }
    }
    
    func numReviews() -> Int
    {
        return cards.filter({$0.readyForReview()}).count
    }
}
