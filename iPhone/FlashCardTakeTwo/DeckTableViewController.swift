//
//  DeckTableViewController.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/14/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class DeckTableViewController: UITableViewController, UITextFieldDelegate
{
    
    var selectedIndex = -1
    var decks = [Deck]()//loadDecks()! ?? [Deck]()
    
    @IBOutlet weak var addDeckButton: UIButton!
    @IBOutlet weak var studyDeckButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //disable studybutton?
        Utilities.buttonBorder(studyDeckButton)
        Utilities.buttonBorder(addDeckButton)
        
        decks = loadDecks() ?? decks
//        decks = loadSampleDecks()
//        self.tableView.allowsSelectionDuringEditing = true
    }
    
    
    
    func loadSampleDecks() -> [Deck]
    {
        var arr = [Deck]()
        let deck = Deck(name: "Times")
        deck.addCard(Card(front: "Always", back: "A"))
        deck.addCard(Card(front: "Sometimes", back: "S"))
        deck.addCard(Card(front: "Never", back: "N"))
        
        let deck2 = Deck(name: "Numbers")
        deck2.addCard(Card(front: "one", back: "1"))
        deck2.addCard(Card(front: "two", back: "2"))
        deck2.addCard(Card(front: "three", back: "3"))
        
        arr.append(deck)
        arr.append(deck2)
        return arr
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete
        {
//            print("commitEditingStyle select: " + String(selectedIndex) + " indPathRow: " + String(indexPath.row))
            if(selectedIndex >= indexPath.row)
            {
                selectedIndex = selectedIndex - 1
            }
            decks.removeAtIndex(indexPath.row)
            saveDecks()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
//            else if (selectedIndex > indexPath.row)
//            {
//                //subtract one from where it was (cuz the rows moved up)
//                selectedIndex = selectedIndex - 1
//                let indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
//                tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//            }
//            else// < indexPath.row
//            {
//                //reselect what was selected
//                let indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
//                tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//            }
        }
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath?) {
//        if(selectedIndex == indexPath.row)
//        {
//            print("selected = editing")
//            studyDeckButton.enabled = false
//        }
//        else if (selectedIndex > indexPath.row)
//        {
//            //subtract one from where it was (cuz the rows moved up)
//            selectedIndex = selectedIndex - 1
//            let indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
//            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//        }
//        else// < indexPath.row
//        {
//            //reselect what was selected
//            let indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
//            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
//        }
//        print("didEndEditing select: " + String(selectedIndex) + " indPathRow: " + String(indexPath.row))
        if (selectedIndex >= 0)
        {
            let newIndexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
            tableView.selectRowAtIndexPath(newIndexPath, animated: true, scrollPosition: .None)
        }
        else
        {
//            studyDeckButton.enabled = false
            Utilities.enableButton(studyDeckButton, enable: false)
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DeckTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeckTableViewCell

        let deck = decks[indexPath.row]
        if let label1 = cell.deckNameLabel, let label2 = cell.numCardsLabel, let label3 = cell.numReviewsLabel
        {
            label1.text = deck.name
            var numCards = String(deck.cards.count)
            numCards += deck.cards.count != 1 ? " cards" : " card"
            label2.text = numCards
            var numReviews = String(deck.numReviews())
            numReviews += deck.numReviews() != 1 ? " reviews" : " review"
            label3.text = numReviews
        }
        Utilities.buttonBorder(cell.editButton)
        return cell
    }
    
    func textFieldHasText(notification: NSNotification)
    {
        let field = notification.object as! UITextField
        
        let alert = self.presentedViewController as! UIAlertController
        let newName = field.text
        alert.actions[0].enabled = !(newName?.isEmpty)!
//        if self.decks.filter({$0.name == newName}).count > 0
//        {
//            
//        }
    }
    
    @IBAction func addDeck(sender: AnyObject) {
        let alert = UIAlertController(title: "Add Deck", message: "Enter the name of your deck:", preferredStyle: UIAlertControllerStyle.Alert)
        
        var addAction: UIAlertAction
        alert.addTextFieldWithConfigurationHandler({
                (txtField: UITextField!) in txtField.placeholder = "Deck Name"
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(DeckTableViewController.textFieldHasText(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { ACTION in
            alert.dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields![0])
        }
        
        addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { ACTION in
            let newName = (alert.textFields?.first?.text)!
            if self.decks.filter({$0.name == newName}).count > 0
            {
                alert.dismissViewControllerAnimated(false, completion: nil)
                let warningAlert = UIAlertController(title: "Duplicate Name", message: "A deck with the name '" + newName + "' already exists", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { ACTION in
                    warningAlert.dismissViewControllerAnimated(true, completion: nil)
                }
                warningAlert.addAction(okAction)
                self.presentViewController(warningAlert, animated: true, completion: nil)
            }
            else
            {
                let newDeck = Deck(name: newName)
                self.decks.append(newDeck)
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.decks.count - 1, inSection: 0)], withRowAnimation: .Left)
            }
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields![0])
        }
        addAction.enabled = false
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.view.setNeedsLayout()
        presentViewController(alert, animated: true, completion: nil)
    }
    
//    @IBAction func studyDeck(sender: AnyObject) {
//        let selectedDeck = decks[selectedIndex]
////        print(selectedDeck.name)
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("didSelectRow select: " + String(selectedIndex) + " indPathRow: " + String(indexPath.row))
        selectedIndex = indexPath.row
//        studyDeckButton.enabled = true
        Utilities.enableButton(studyDeckButton, enable: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDeck"
        {
            let editButton = sender as! UIButton
            let buttonPos = editButton.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(buttonPos)
            let svc = segue.destinationViewController as! DeckEditViewController
            svc.selectedDeck = decks[(indexPath?.row)!]
            svc.deckIndex = indexPath?.row
        }
        else if segue.identifier == "StudyDeck"
        {
            let svc = segue.destinationViewController as! StudyDeckController
            svc.deckIndex = selectedIndex
            svc.selectedDeck = decks[selectedIndex]
        }
    }
    
    @IBAction func saveDeckDetail(segue:UIStoryboardSegue)
    {
        if let deckEditViewController = segue.sourceViewController as? DeckEditViewController
        {
            let index = NSIndexPath(forRow: deckEditViewController.deckIndex, inSection: 0)
            let indexes = [index]
            self.tableView.reloadRowsAtIndexPaths(indexes, withRowAnimation: .Left)
//            saveDecks()
        }
        else if let studyViewController = segue.sourceViewController as? StudyDeckController
        {
            let index = NSIndexPath(forRow: studyViewController.deckIndex, inSection: 0)
            let indexes = [index]
            self.tableView.reloadRowsAtIndexPaths(indexes, withRowAnimation: .Left)
        }
        saveDecks()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath == nil
        {
//            studyDeckButton.enabled = false
            Utilities.enableButton(studyDeckButton, enable: false)
        }
    }
    
    func saveDecks()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(decks, toFile: Deck.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save decks...")
        }
    }
    
    func loadDecks() -> [Deck]?
    {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Deck.ArchiveURL!.path!) as? [Deck]
    }
    
}

