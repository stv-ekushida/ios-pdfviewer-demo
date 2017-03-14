//
//  PDFPageCollectionViewCell.swift
//  ios-pdfview-demo
//
//  Created by Eiji Kushida on 2017/03/14.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

protocol PDFPageCollectionViewCellDelegate: class {
    func handleSingleTap(_ cell: PDFPageCollectionViewCell, pdfPageView: PDFPageView)
}

final class PDFPageCollectionViewCell: UICollectionViewCell {

    var pageIndex: Int?
    
    var pageView: PDFPageView? {
        didSet {
            subviews.forEach{ $0.removeFromSuperview() }
            if let pageView = pageView {
                addSubview(pageView)
            }
        }
    }
    
    fileprivate weak var pageCollectionViewCellDelegate: PDFPageCollectionViewCellDelegate?
    
    func setup(_ indexPathRow: Int,
               collectionViewBounds: CGRect,
               document: PDFDocument,
               pageCollectionViewCellDelegate: PDFPageCollectionViewCellDelegate?) {
        
        self.pageCollectionViewCellDelegate = pageCollectionViewCellDelegate
        document.pdfPageImage(at: indexPathRow + 1) { (backgroundImage) in
            pageView = PDFPageView(frame: bounds,
                                   document: document,
                                   pageNumber: indexPathRow,
                                   backgroundImage: backgroundImage,
                                   pageViewDelegate: self)
            pageIndex = indexPathRow
        }
    }
}

extension PDFPageCollectionViewCell: PDFPageViewDelegate {
    
    func handleSingleTap(_ pdfPageView: PDFPageView) {
        pageCollectionViewCellDelegate?.handleSingleTap(self, pdfPageView: pdfPageView)
    }
}
