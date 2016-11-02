//
//  StudyDeckController.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/29/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class StudyDeckController: UIViewController, UITextFieldDelegate
{
    var selectedDeck: Deck!
    var reviewCards: [Card]!
    var deckIndex:Int!
    var currCardIndex:Int = 0
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var nextCardButton: UIButton!
    
    @IBOutlet weak var currentDeckLabel: UILabel!
    @IBOutlet weak var currCardLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var correctLabel: UILabel!
    
    override func viewDidLoad() {
        changeLabelText(currentDeckLabel, text: "Studying Deck: " + selectedDeck.name)
        
        Utilities.buttonBorder(finishButton)
        Utilities.buttonBorder(nextCardButton)
        
        reviewCards = getReviews()
        reviewCards.shuffleInPlace()
        loadCard()
    }
    
    func getReviews() -> [Card]
    {
        var reviews = [Card]()
        for card in selectedDeck.cards
        {
            if card.readyForReview()
            {
                reviews.append(card)
            }
        }
        return reviews
    }
    
    @IBAction func nextCard(sender: AnyObject) {
        currCardIndex += 1
        loadCard()
    }
    
    func loadCard()
    {
        if reviewCards.count > 0 && currCardIndex < reviewCards.count
        {
            changeLabelText(currCardLabel, text: reviewCards[currCardIndex].front)
            answerTextField.text = ""
        }
        else
        {
            changeLabelText(currCardLabel, text: "No more Cards!")
//            nextCardButton.enabled = false
//            Utilities.enableButton(nextCardButton, enable: false)
            answerTextField.text = ""
            finishButton.setTitle("Done", forState: UIControlState.Normal)
        }
        correctLabel.hidden = true
        Utilities.enableButton(nextCardButton, enable: false)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        checkInput(textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        return true
    }
    
    func checkInput(input: String)
    {
//        nextCardButton.enabled = true
        if (currCardIndex < reviewCards.count)
        {
            Utilities.enableButton(nextCardButton, enable: true)
            let currCard = reviewCards[currCardIndex]
            if (currCard.back.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == input)
            {
                changeLabelText(correctLabel, text: "Correct!")
                correctLabel.hidden = false
                currCard.markCorrect(true)
            }
            else
            {
                changeLabelText(correctLabel, text: reviewCards[currCardIndex].back + "\nIncorrect")
                correctLabel.hidden = false
                currCard.markCorrect(false)
            }
        }
    }
    
    func changeLabelText(label: UILabel, text: String)
    {
        label.text = text
        label.sizeToFit()
    }
    
    @IBAction func cancelStudy(sender: AnyObject) {
        self.performSegueWithIdentifier("SaveDeckDetail", sender: self)
    }
}

//http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension CollectionType
{
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
    
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
