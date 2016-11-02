//
//  CardDetailViewController.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/22/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController, UITextFieldDelegate {

    var selectedCard: Card!
    var cardIndex:Int!
    
    @IBOutlet weak var cardFrontField: UITextField!
    @IBOutlet weak var cardBackField: UITextField!
    @IBOutlet weak var masteryLabel: UILabel!
    @IBOutlet weak var nextReviewLabel: UILabel!
    @IBOutlet weak var currStreakLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.buttonBorder(cancelButton)
        Utilities.buttonBorder(updateButton)
        
        cardFrontField.text = selectedCard.front
        cardBackField.text = selectedCard.back
        masteryLabel.text = String(selectedCard.mastery)
        masteryLabel.backgroundColor = selectedCard.mastery.cellColor()
        currStreakLabel.text = String(selectedCard.correctStreak)
        let formatter = NSDateFormatter.init()
        formatter.setLocalizedDateFormatFromTemplate("MM/dd/yy h:mm a")
        if selectedCard.readyForReview()
        {
            nextReviewLabel.text = "Ready for Review"
        }
        else
        {
            nextReviewLabel.text = formatter.stringFromDate(selectedCard.nextReview)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func updateCard(sender: AnyObject) {
        selectedCard.front = cardFrontField.text!
        selectedCard.back = cardBackField.text!
        self.performSegueWithIdentifier("SaveCardDetail", sender: self)
    }
    @IBAction func cancelUpdate(sender: AnyObject) {
        self.performSegueWithIdentifier("SaveCardDetail", sender: self)
    }
}
