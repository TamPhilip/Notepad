//
//  NotepadChooserController.swift
//  Notepad
//
//  Created by Philip Tam on 2018-03-14.
//  Copyright © 2018 RPSTAM. All rights reserved.
//

import UIKit
import CoreData

class NotepadChooserController: UITableViewController {

    var noteArray = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNotes()
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return noteArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

        cell.textLabel?.text = noteArray[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(noteArray[indexPath.row])
            noteArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveNotes()
        }
            
    }
 
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = self.noteArray[fromIndexPath.row]
        noteArray.remove(at: fromIndexPath.row)
        noteArray.insert(movedObject, at: to.row)
    }
    
    //MARK: - Add Button
    @IBAction func addButtonPressed(_ sender: Any) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Note", style: .default) { (action) in
            let newNote = Note(context: self.context)
            
            newNote.title = textfield.text!
    
            self.noteArray.append(newNote)
            
            self.saveNotes()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name the Note"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Move to Tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWritingPad", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WriteController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedNote = noteArray[indexPath.row]
            destinationVC.noteTitle = noteArray[indexPath.row].title
        }
    }
    
    //MARK: - Save and Load Notes Methods
    func saveNotes(){
        do{
            try context.save()
        }
        catch{
            print("Error while saving data \(error)")
        }
        tableView.reloadData()
    }
    func loadNotes(){
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        do{
           noteArray = try context.fetch(request)
        print(noteArray)
        }
        catch{
            print("Error while fetching Note Data \(error)")
        }
        tableView.reloadData()
    }

}

