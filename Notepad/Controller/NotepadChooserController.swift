//
//  NotepadChooserController.swift
//  Notepad
//
//  Created by Philip Tam on 2018-03-14.
//  Copyright © 2018 RPSTAM. All rights reserved.
//

import UIKit
import RealmSwift

class NotepadChooserController: UITableViewController {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    let realm = try! Realm()
    
    var noteArray : Results<Note>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
         loadNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return noteArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

        cell.textLabel?.text = noteArray?[indexPath.row].title ?? "No Notes Added Yet"
        print(cell.textLabel?.text)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    //MARK: Deleting Row Table View Method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  && noteArray != nil{
            do{
                try realm.write {
                    realm.delete(noteArray![indexPath.row])
                }
            }
            catch{
                print("Error while deleting Notes \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
            
    }
 
    
    //MARK: - Moving Rows Table View Method
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let movedObject = self.noteArray[fromIndexPath.row]
//        noteArray.remove(at: fromIndexPath.row)
//        noteArray.insert(movedObject, at: to.row)
//    }
    
    //MARK: - Add Button
    @IBAction func addButtonPressed(_ sender: Any) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Note", style: .default) { (action) in
            
            do{
                try self.realm.write {
                    let newNote = Note()
                    newNote.title = textfield.text!
                    self.realm.add(newNote)
                }
            }
            catch{
                print("Error while saving Note \(error)")
            }
            self.tableView.reloadData()
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
            destinationVC.selectedNote = noteArray?[indexPath.row]
        }
    }
    
    //MARK: - Save and Load Notes Methods
    func loadNotes(){
       
        noteArray = realm.objects(Note.self).sorted(byKeyPath: "dateLastUsed", ascending: false)
        
        tableView.reloadData()
    }

}

//MARK: - Search Query
extension NotepadChooserController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        noteArray?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateLastUsed", ascending: false)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadNotes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

