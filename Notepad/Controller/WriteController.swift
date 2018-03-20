//
//  ViewController.swift
//  Notepad
//
//  Created by Philip Tam on 2018-03-14.
//  Copyright © 2018 RPSTAM. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class WriteController: UIViewController, UITextViewDelegate{

    //MARK: Outlet and Variable Initialization
    @IBOutlet weak var textView: UITextView!

    let realm = try! Realm()
    
    var selectedNote : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Observer Keyboard Setup
        NotificationCenter.default.addObserver(self, selector: #selector(WriteController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WriteController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Textview Delegate
        textView.delegate = self
        
        navigationItem.title = selectedNote?.title
        
        if let text = selectedNote?.text {
            textView.text = text
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
       
    }
    
    func saveText(){
        do{
            try realm.write{
                selectedNote?.text = textView.text
                selectedNote?.dateLastUsed = Date.init()
            }
        }
        catch{
            print("Error while saving text \(error)")
        }
    }
}
