//
//  PDFViewController.swift
//  ios-pdfview-demo
//
//  Created by Eiji Kushida on 2017/03/14.
//  Copyright © 2017年 Eiji Kushida. All rights reserved.
//

import UIKit

final class PDFViewController: UIViewController {
    
    @IBOutlet public var collectionView: UICollectionView!
    fileprivate var document: PDFDocument!
    fileprivate var currentPageIndex: Int = 0
    
    public var backgroundColor: UIColor? = .lightGray {
        didSet {
            collectionView?.backgroundColor = backgroundColor
        }
    }
    
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            if collectionView == nil {
                _ = view
            }
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = backgroundColor
        collectionView.register(PDFPageCollectionViewCell.self,
                                forCellWithReuseIdentifier: "page")
    }
    
    override public var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    public override func viewWillTransition(to size: CGSize,
                                            with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { context in
            let currentIndexPath = IndexPath(row: self.currentPageIndex,
                                             section: 0)
            self.collectionView.reloadItems(at: [currentIndexPath])
            self.collectionView.scrollToItem(at: currentIndexPath,
                                             at: .centeredHorizontally,
                                             animated: false)
        }) { context in
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension PDFViewController {

    public class func createNew(with document: PDFDocument,
                                title: String? = nil) -> PDFViewController {
        
        let storyboard = UIStoryboard(name: "PDFReader",
                                      bundle: Bundle(for: PDFViewController.self))
        let controller = storyboard.instantiateInitialViewController() as! PDFViewController
        controller.document = document
        
        if let title = title {
            controller.title = title
        } else {
            controller.title = document.fileName
        }        
        return controller
    }
}

//MARK:-UICollectionViewDataSource
extension PDFViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return document.pageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "page",
                                                      for: indexPath) as! PDFPageCollectionViewCell
        
        cell.setup(indexPath.row,
                   collectionViewBounds: collectionView.bounds,
                   document: document,
                   pageCollectionViewCellDelegate: self)
        return cell
    }
}

//MARK:-PDFPageCollectionViewCellDelegate
extension PDFViewController: PDFPageCollectionViewCellDelegate {
    
    func handleSingleTap(_ cell: PDFPageCollectionViewCell,
                         pdfPageView: PDFPageView) {
        
        var shouldHide: Bool {
            guard let isNavigationBarHidden = navigationController?.isNavigationBarHidden else {
                return false
            }
            return !isNavigationBarHidden
        }
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.setNavigationBarHidden(shouldHide, animated: true)
        }
    }
}

//MARK:-UICollectionViewDelegateFlowLayout
extension PDFViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
}

//MARK:-UIScrollViewDelegate
extension PDFViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var updatedPageIndex = currentPageIndex
        
        if self.scrollDirection == .vertical {
            updatedPageIndex = Int(round(max(scrollView.contentOffset.y, 0) / scrollView.bounds.size.height))
        } else {
            updatedPageIndex = Int(round(max(scrollView.contentOffset.x, 0) / scrollView.bounds.size.width))
        }
        
        if updatedPageIndex != currentPageIndex {
            currentPageIndex = updatedPageIndex
        }
    }
}
