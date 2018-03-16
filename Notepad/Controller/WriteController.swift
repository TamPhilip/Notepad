//
//  ViewController.swift
//  Notepad
//
//  Created by Philip Tam on 2018-03-14.
//  Copyright © 2018 RPSTAM. All rights reserved.
//

import UIKit
import CoreData

class WriteController: UIViewController, UITextViewDelegate{

    //MARK: Outlet and Variable Initialization
    @IBOutlet weak var textView: UITextView!
    
    var noteTitle : String?
    var text = [Text]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedNote : Note?{
        didSet{
            loadText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Observer Keyboard Setup
        NotificationCenter.default.addObserver(self, selector: #selector(WriteController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WriteController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        //Textview Delegate
        textView.delegate = self
        
        navigationItem.title = noteTitle
        
        if let loadedText = text.first?.content {
            textView.text = loadedText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Save and Load Text Methods
    func saveText(){
        do{
            try context.save()
        }
        catch{
            print("Error while saving text \(error)")
        }
    }
    func loadText(){
        let request : NSFetchRequest<Text> = Text.fetchRequest()
        let predicate = NSPredicate(format: "parentNote.title MATCHES %@", selectedNote!.title!)
        request.predicate = predicate
        do{
            text = try context.fetch(request)
            print("TEXT IS SET UP")
        }
        catch{
            print("Error while fetching text data \(error)")
        }
        
    }
    
    //MARK: Keyboard Shown and Hide Methods
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            textView.frame.size.height -= keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            textView.frame.size.height += keyboardSize.height
        }
    }
    //MARK: Remove Observer after WriterCOntroller is gone
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
         saveText()
    }
    
    //Saving Text
    func textViewDidChange(_ textView: UITextView) {

        let savingText = Text(context: context)
        
        savingText.content = textView.text
        
        savingText.parentNote = selectedNote

    }
}
