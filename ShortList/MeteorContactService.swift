//
//  MeteorContactService.swift
//  ShortList
//
//  Created by Andrew Steinmeyer on 12/17/15.
//  Copyright © 2015 Andrew Steinmeyer. All rights reserved.
//

import Meteor

final class MeteorContactService {
  static let sharedInstance = MeteorContactService()
  
  private let modelName = "Contact"
  private let source = "iPhone"
  
  private let managedObjectContext = Meteor.mainQueueManagedObjectContext
  
  private enum Message: String {
    case ImportContacts = "importContacts"
    case CreateContact = "createContact"
    case DeleteContact = "deleteContact"
  }
  
  init() {
    defineStubMethods()
  }
  
  func saveManagedObjectContext() {
    var error: NSError?
    do {
      try managedObjectContext.save()
    } catch let error1 as NSError {
      error = error1
      print("Encountered error saving managed object context: \(error)")
    }
  }
  
  //MARK: - Meteor server calls
  
  func create(var parameters: [AnyObject]?, completionHandler: METMethodCompletionHandler?) {
    // add source
    parameters?.append(self.source)
    
    Meteor.callMethodWithName(Message.CreateContact.rawValue, parameters: parameters, completionHandler: completionHandler)
  }
  
  func delete(parameters: [AnyObject]?, completionHandler: METMethodCompletionHandler?) {
    Meteor.callMethodWithName(Message.DeleteContact.rawValue, parameters: parameters, completionHandler: completionHandler)
  }
  
  //TODO: Implement import method
  func importContacts(parameters: [AnyObject]?, completionHandler: METMethodCompletionHandler?) {
    Meteor.callMethodWithName(Message.ImportContacts.rawValue, parameters: parameters, completionHandler: completionHandler)
  }
  
  //MARK: - Stub Methods for client persistence
  
  func defineStubMethods() {
    
    // Create Contact stub
    Meteor.defineStubForMethodWithName(Message.CreateContact.rawValue) {
      parameters in
      
      let name = parameters[0] as? String ?? nil
      let phone = parameters[1] as? String ?? nil
      let email = parameters[2] as? String ?? nil
      
      guard name != nil
        && phone != nil
        && email != nil
      else {
        return nil
      }
      
      let contact = NSEntityDescription.insertNewObjectForEntityForName(self.modelName, inManagedObjectContext: self.managedObjectContext) as! Contact
      contact.userId = AccountManager.defaultAccountManager.currentUserId
      contact.name = name
      contact.phone = phone
      contact.email = email
      contact.source = self.source
      
      // save local
      self.saveManagedObjectContext()
      
      return nil
    }
  
  }
  
}



