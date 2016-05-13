//
//  DetailViewController.swift
//  Immink-pset4
//
//  Created by Emma Immink on 11-05-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import SQLite

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var AddingField: UITextField!

    // Make SQL expressions
    private var database: Connection?
    let notes = Table("notes")
    let id = Expression<Int64>("id")
    let note = Expression<String>("note")
    let track = Expression<String>("track")
    
    var todolist = Array<String> ()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        SetUpDatabase()
        ReadTable()
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveToDatabase(sender: AnyObject) {
        if AddingField.text != nil {
            let insert = notes.insert(note <- AddingField.text!, track <- TodoManager.sharedInstance.whichObject)
            do {
                let rowId = try database!.run(insert)
                AddingField.text = ""
                print(rowId)
                ReadTable()
                tableView.reloadData()
            } catch {
                print("Item not added: \(error)")
            }
        }
        print(todolist)
    }
    
    // Make connection database
    private  func SetUpDatabase(){
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        do {
            database = try Connection("\(path)/database.sqlite3")
            print("connection made")
            CreateTable()
        } catch {
            print("Cannot connect to database: \(error)")
        }
    }
    
    // Make a table in database
    private func CreateTable() {
        do {
            try database!.run(notes.create(ifNotExists: true) { t in  // create table notes
                t.column(id, primaryKey: .Autoincrement)        //create collumn id
                t.column(track)                                 // create collumn track
                t.column(note,  unique: true)                                  // create collumn note
                })
            print("table made")
        } catch {
            print("Failed to create a table: \(error)")
        }
    }
    
    private func ReadTable() {
        todolist.removeAll()
        do {
            for item in try database!.prepare(notes) {
                todolist.append(item[note])
            }
        } catch {
            print("Cannot read database: \(error)")
        }
    }
    
    private func DeleteNote(deleteNote: String) {
        
        let delete = notes.filter(note == deleteNote)
        do {
            if try database!.run(delete.delete()) > 0 {
                print("Delete Succes!")
                ReadTable()
            } else {
                print("Not found")
            }
            
        } catch {
            print("delete failed: \(error)")
        }
    }
}
    extension DetailViewController: UITableViewDelegate {
        
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.Delete {
                
                DeleteNote(todolist[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
//    
//    extension DetailViewController: UITableViewDataSource {
//        
//        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//            
//            let cellNote = self.tableView.dequeueReusableCellWithIdentifier("cellNote", forIndexPath: indexPath) as! CustomCell2
//            
//            cellNote.textNote.text = todolist[indexPath.row]
//            
//            return cellNote
//        }
//        
//        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return todolist.count
//        }
