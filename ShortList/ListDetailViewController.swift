//
//  ListDetailViewController.swift
//  Shortlist
//
//  Created by Andrew Steinmeyer on 12/6/15.
//  Copyright © 2015 Andrew Steinmeyer. All rights reserved.
//

import UIKit
import CoreData


class ListDetailViewController: UITableViewController {
  
  private var contacts = [[String:String]]()
  
  var list: List? {
    didSet {
      if let listContacts = list?.valueForKey("contacts") {
        let data = JSON(listContacts)
        
        for (_,contact):(String, JSON) in data {
          //Do something you want
          let name = contact["name"].string ?? ""
          let email = contact["email"].string ?? ""
          let phone = contact["phone"].string ?? ""
          
          // make sure there is at least a name
          guard !name.isEmpty else {
            return
          }
          
          let newContact = ["name": name,
                            "email": email,
                            "phone": phone]
            
          contacts.append(newContact)
        }
      } else {
        // clear if no list exists
        contacts = []
      }
    }
  }

  // MARK: UITableView Delegate and Datasource functions
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ContactsTableViewCell
    
    let contact = contacts[indexPath.row]
    
    let data = ContactsTableViewCellData(name: contact["name"], phone: contact["phone"], email: contact["email"])
    cell.setData(data)
      
    return cell
  }
  
}
