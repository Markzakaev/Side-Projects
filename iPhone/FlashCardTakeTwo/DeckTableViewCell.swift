//
//  DeckTableViewCell.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/14/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell
{
    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var numCardsLabel: UILabel!
    @IBOutlet weak var numReviewsLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
