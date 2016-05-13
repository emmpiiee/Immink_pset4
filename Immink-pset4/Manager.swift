//
//  Manager.swift
//  Immink-pset4
//
//  Created by Emma Immink on 11-05-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import Foundation
import SQLite

class TodoManager {
    static let sharedInstance = TodoManager()
    
    private init() {}
    
    private var db: Connection?
    let notes = Table("notes")
    let id = Expression<Int64>("id")
    let note = Expression<String>("note")

    var whichObject = String()
    
    var todolist = Array<String> ()
    
    
    func printHello(){
        print("Helloo")
    }
    
    // set up database
    func SetUpDatabase(){
        print("function geroepen")
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            print("connection made")
            CreateTable()
        } catch {
            print("Cannot connect to database: \(error)")
        }
    }
    // Make a table in database
    func CreateTable() {
        do {
            try db!.run(notes.create(ifNotExists: true) { t in  // create table notes
                t.column(id, primaryKey: .Autoincrement)        //create collumn id
                t.column(note)                                  // create collumn note
                })
            print("table made")
        } catch {
            print("Failed to create a table: \(error)")
        }
    }
    
    // Read table
    func ReadTable() {
        todolist.removeAll()
        do {
            for item in try db!.prepare(notes) {
                todolist.append(item[note])
            }
        } catch {
            print("Cannot read database: \(error)")
        }
    }
    
    //Delete note
    func DeleteNote(deleteNote: String) {
        
        let delete = notes.filter(note == deleteNote)
        do {
            if try db!.run(delete.delete()) > 0 {
                print("Delete Succes!")
                ReadTable()
            } else {
                print("Not found")
            }
            
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    // save to database
    func SaveToDatabase(sender: AnyObject) {
            let insert = notes.insert(note <- (sender as! String))
            do {
                let rowId = try db!.run(insert)
                print(rowId)
                ReadTable()
            } catch {
                print("Item not added: \(error)")
            }
        }
    }
    
//    func saveToDatabase(sender: AnyObject){
//            let insert = notes.insert(note <- sender!)
//            
//            do {
//                let rowId = try db!.run(insert)
//                AddingField.text = ""
//                print(rowId)
//                ReadTable()
//                tableView.reloadData()
//            } catch {
//                print("Item not added: \(error)")
//            }
//        print(todolist)
    
    


    
    
