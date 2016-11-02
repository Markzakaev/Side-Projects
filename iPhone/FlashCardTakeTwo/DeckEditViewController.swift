//
//  DeckEditViewController.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/16/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class DeckEditViewController: UITableViewController
{
    var selectedDeck: Deck!
    var deckIndex:Int!
    
    @IBOutlet weak var currDeckLabel: UILabel!
    
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var backToDecksButton: UIButton!
    
    override func viewDidLoad() {
        currDeckLabel.text = "Editing Deck: " + selectedDeck.name
        Utilities.buttonBorder(addCardButton)
        Utilities.buttonBorder(backToDecksButton)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDeck.cards.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        
        let card = selectedDeck.cards[indexPath.row]
        if let front = cell.cardFrontLabel, let back = cell.cardBackLabel
        {
            front.text = card.front
            back.text = card.back
        }
        cell.backgroundColor = card.mastery.cellColor()
        Utilities.buttonBorder(cell.editButton)
        return cell
    }
    
    @IBAction func backToDecks(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("SaveDeckDetail", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            selectedDeck.cards.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            selectedDeck.saveCards()
        }
    }
    
    func textFieldHasText(notification: NSNotification)
    {
        let field = notification.object as! UITextField
        
        let alert = self.presentedViewController as! UIAlertController
        let newName = field.text
        alert.actions[0].enabled = !(newName?.isEmpty)!
    }
    
    @IBAction func addCard(sender: AnyObject) {
        let alert = UIAlertController(title: "Add Card", message: "Enter the front and back of your card", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({(txtField: UITextField!) in
            txtField.placeholder = "Front"
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(DeckEditViewController.textFieldHasText(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
        })
        
        alert.addTextFieldWithConfigurationHandler({(txtField: UITextField!) in txtField.placeholder = "Back"})
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { ACTION in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { ACTION in
            let newCard = Card(front:(alert.textFields?.first?.text)!, back:(alert.textFields?.last?.text)!)
            self.selectedDeck.addCard(newCard)
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.selectedDeck.cards.count - 1, inSection: 0)], withRowAnimation: .Left)
            self.selectedDeck.saveCards()
        }
        addAction.enabled = false
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveCardDetail(segue: UIStoryboardSegue)
    {
        if let cardDetailViewController = segue.sourceViewController as? CardDetailViewController {
            let index = NSIndexPath(forRow: cardDetailViewController.cardIndex, inSection: 0)
            let indexes = [index]
            self.tableView.reloadRowsAtIndexPaths(indexes, withRowAnimation: .Left)
            self.selectedDeck.saveCards()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditCard"
        {
            let editButton = sender as! UIButton
            let buttonPos = editButton.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(buttonPos)
            let svc = segue.destinationViewController as! CardDetailViewController
            svc.selectedCard = selectedDeck.cards[(indexPath?.row)!]
            svc.cardIndex = (indexPath?.row)!
        }
    }
}