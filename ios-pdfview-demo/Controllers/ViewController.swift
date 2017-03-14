//
//  ViewController.swift
//  ios-pdfview-demo
//
//  Created by Eiji Kushida on 2017/03/14.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func didTapShowPdf(_ sender: UIButton) {
        
        let doc = document("apple")
        showDocument(doc!)
    }
    
    fileprivate func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        return PDFDocument(fileURL: documentURL)
    }
    
    fileprivate func showDocument(_ document: PDFDocument) {
        let controller = PDFViewController.createNew(with: document, title: "apple")
        navigationController?.pushViewController(controller, animated: true)
    }
}

