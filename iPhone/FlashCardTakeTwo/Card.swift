//
//  Card.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/14/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import Foundation
import UIKit

class Card: NSObject, NSCoding
{
    
    
    
    //TO DO: SRS level
    struct PropertyKey
    {
        static let frontKey = "front"
        static let backKey = "back"
        static let correctStreakKey = "correctStreak"
        static let nextReviewKey = "nextReview"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("cards")
    
    var front: String
    var back: String
    var mastery: Mastery
    var correctStreak: Int32
    var nextReview: NSDate
    
    init(front: String, back: String)
    {
        self.front = front
        self.back = back
        self.mastery = .Apprentice
        self.correctStreak = 0
        self.nextReview = NSDate.init()
        super.init()
    }
    
    init(front: String, back: String, mastery: Mastery, correctStreak: Int32, nextReview: NSDate)
    {
        self.front = front
        self.back = back
        self.mastery = mastery
        self.correctStreak = correctStreak
        self.nextReview = nextReview
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(front, forKey: PropertyKey.frontKey)
        aCoder.encodeObject(back, forKey: PropertyKey.backKey)
        aCoder.encodeInt(correctStreak, forKey: PropertyKey.correctStreakKey)
        aCoder.encodeObject(nextReview, forKey: PropertyKey.nextReviewKey)
//        aCoder.encodeObject(correctStreak, forKey: PropertyKey.correctStreakKey )
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let front = aDecoder.decodeObjectForKey(PropertyKey.frontKey) as! String
        let back = aDecoder.decodeObjectForKey(PropertyKey.backKey) as! String
        let correctStreak = aDecoder.decodeIntForKey(PropertyKey.correctStreakKey)
        let mastery = Mastery(streak: correctStreak)
        let nextReview = aDecoder.decodeObjectForKey(PropertyKey.nextReviewKey) as! NSDate
        self.init(front: front, back: back, mastery: mastery!, correctStreak: correctStreak, nextReview: nextReview)
    }
    
    func markCorrect(correct: Bool)
    {
        if correct
        {
            correctStreak += 1
            //AND change mastery/next review
            
        }
        else
        {
            correctStreak = 0
        }
        nextReview = calcNextReview(correctStreak)
    }
    
    func calcNextReview(streak: Int32) -> NSDate
    {
        var time = NSTimeInterval()
        switch streak {
        case 0:
            time = 60*60*1//poor baby. Come back in an hour.
        case 1:
            time = 60*60*4//4H
        case 2:
            time = 60*60*8//8H
        case 3:
            time = 60*60*24//24H or 1D
        case 4:
            time = 60*60*24*3//3D
        case 5:
            time = 60*60*24*7//7D or 1W
        case 6:
            time = 60*60*24*7*2//2W
        case 7:
            time = 60*60*24*7*4//1M, I hope
        case 8:
            time = 60*60*24*7*4*4//4M
        default:
            time = 60*60*525600//1Y (according to Jonathan Larson)
        }
        return NSDate().dateByAddingTimeInterval(time)
    }
    
    func readyForReview() -> Bool
    {
        switch nextReview.compare(NSDate())
        {
        case .OrderedAscending:
            return true
        default:
            return false
        }
    }
}