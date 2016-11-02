//
//  NewDeckAlertController.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/19/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class NewDeckAlertController : UIAlertController
{
    weak var addAction: UIAlertAction!
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle)
    {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.addTextFieldWithConfigurationHandler { textField in
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewDeckAlertController.handleTextFieldTextDidChangeNotification(_:)), name: UITextFieldTextDidChangeNotification, object: textField)
            textField.placeholder = "Deck Name"
        }
        func removeTextFieldObserver() {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: self.textFields![0])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { ACTION in
            removeTextFieldObserver()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.addAction(cancelAction)
        
        addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { ACTION in
            let newName = (self.textFields?.first?.text)!
            let newDeck = Deck(name: newName)
            self.decks.append(newDeck)
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.decks.count - 1, inSection: 0)], withRowAnimation: .Left)
        }
        addAction.enabled = false
    }
    
    
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        addAction!.enabled = !(textField.text?.isEmpty)!
    }
    
}