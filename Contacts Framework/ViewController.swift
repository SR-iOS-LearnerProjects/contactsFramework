//
//  ViewController.swift
//  Contacts Framework
//
//  Created by MAC006 on 12/02/20.
//  Copyright © 2020 MAC006. All rights reserved.
//

import UIKit
import Contacts

struct contactStruct {
    var givenName: String
    var familyName: String
    var number: String
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // 1. Define and declare two variables for contactStore and another to store contacts data
    var contactStore = CNContactStore()
    var contactData = [contactStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 2. Create a usage description in Info.plist to access privacy-sensitive data (contacts) with a usage description
        // 3. Requesting user to give permission to access phone contacts
        contactStore.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("Failed to request access : ", error)
            }
            
            if granted {
                print("Access Granted.")
            }
            else {
                print("Access Denied.")
            }
        }
        
        fetchContacts()
        
    }
    
    // 4. Fetch Contacts
    func fetchContacts() {
        
        // Creating a Key which will be an array of required data from contact store
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        // Creating a fetch request to contact store with a key
        let request = CNContactFetchRequest(keysToFetch: key)
        
        do {
            // Making request to contacts store
            try contactStore.enumerateContacts(with: request) { (contact, stopPointer) in
            
                let name = contact.givenName
                let familyName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
            
                print(contact.givenName)
                print(contact.phoneNumbers.first?.value.stringValue ?? "no number")
                
                let contactsToAppend = contactStruct(givenName: name, familyName: familyName, number: number!)
                self.contactData.append(contactsToAppend)
                
            }
        } catch let error {
            print("Failed to enumerate contacts store : ", error.localizedDescription)
        }
        
        tableView.reloadData()
        // prints given name of first contact
//        print(contactData.first?.givenName)
        
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToDisplay = contactData[indexPath.row]
        cell.textLabel?.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = contactToDisplay.number
        return cell
    }

}

