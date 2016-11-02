//
//  Mastery.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/29/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import Foundation
import UIKit

enum Mastery
{
    case Apprentice, Guru, Master, Enlightened, Burn
    func cellColor() -> UIColor
    {
        switch self {
        case .Apprentice:
            return UIColor(colorLiteralRed: 0, green: 255, blue: 255, alpha: 255)
        case .Guru:
            return UIColor(colorLiteralRed: 255, green: 150, blue: 255, alpha: 255)
        case .Master:
            return UIColor(colorLiteralRed: 255, green: 100, blue: 0, alpha: 255)
        case .Enlightened:
            return UIColor(colorLiteralRed: 255, green: 220, blue: 0, alpha: 255)
        case .Burn:
            return UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 30)
        }
    }
}

extension Mastery
{
    init?(streak: Int32)
    {
        if (streak < 5)
        {
            self = .Apprentice
        }
        else
        {
            switch streak {
            case 5:
                self = .Guru
            case 6:
                self = .Master
            case 7:
                self = .Enlightened
            default:
                self = .Burn
            }
        }
    }
}