//
//  ViewController.swift
//  FirestoreListenerTest
//
//  Created by Adam S on 6/22/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    let collectionName = "testdata"
    let dataSize = 3000
    let limitSize = 100
    
    let db: Firestore
    var listener: ListenerRegistration?
    var firstListen = false
    
    @IBOutlet weak var textView: UITextView!
    
    
    
    // MARK: - lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        FirebaseApp.configure()
        db = Firestore.firestore()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //createListener()
    }

    
    
    // MARK: - button action handlers
    
    @IBAction func buttonTappedAddData(_ sender: Any) {
        
        // create large data set
        for docName in 1...dataSize {
            db.collection(collectionName).addDocument(data: ["name": docName, "map": ["mappedName": docName]]) { (error) in
                if error == nil {
                    self.logToTextView(text: "Finished writing document \(docName).")
                }
            }
        }
    }
    
    @IBAction func buttonTappedCreateListener(_ sender: Any) {
        createListener()
    }
    
    @IBAction func buttonTappedCreatePagedListener(_ sender: Any) {
        createListener(limit: limitSize)
    }
    
    
    @IBAction func buttonTappedGetDocuments(_ sender: Any) {
        getDocuments()
    }
    
    @IBAction func buttonTappedGetPagedDocuments(_ sender: Any) {
        getDocuments(limit: limitSize)
    }
    
    
    // MARK - helper functions
    
    /**
     Create a listener query
    */
    func createListener(limit: Int? = nil) {
    
        // remove previous listener, if any
        let previousListener = listener
        if let previousListener = previousListener {
            previousListener.remove()
        }
        
        firstListen = true          // track first listen update
        let startDate = Date()      // used to time listener
        self.logToTextView(text: "CREATING NEW LISTENER")
        listener = query(limit: limit).addSnapshotListener { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            if self.firstListen {
                self.logToTextView(text: "First snapshot returned \(querySnapshot.documents.count) docs in \(-startDate.timeIntervalSinceNow) seconds.")
            }
            else {
                self.logToTextView(text: "Snapshot returned \(querySnapshot.documents.count) docs.")
            }

            self.firstListen = false
        }
    }
    
    /**
     Direct getDocuments query
     */
    func getDocuments(limit: Int? = nil) {
        let startDate = Date()  // used to time getDocuments
        self.logToTextView(text: "GETTING DOCUMENTS")
        query(limit: limit).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else { return }
            self.logToTextView(text: "GetDocuments returned \(querySnapshot.documents.count) docs in \(-startDate.timeIntervalSinceNow) seconds.")
        }
    }
    
    /**
     Create query
     */
    func query(limit: Int?) -> Query {
        var query = db.collection(collectionName)
                        .whereField("name", isGreaterThan: 0)
                        .order(by: "name")
        
        // set limit if specified
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        return query
    }
    
    /**
     Log to UI textView
     */
    func logToTextView(text: String) {
        var logText = self.textView.text ?? ""
        logText.append("\n\(text)")
        self.textView.text = logText
        self.textView.setContentOffset(CGPoint(x: 0, y: self.textView.contentSize.height-self.textView.frame.size.height), animated: false)
    }
}

