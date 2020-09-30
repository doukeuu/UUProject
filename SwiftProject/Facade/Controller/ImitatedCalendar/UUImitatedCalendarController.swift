//
//  UUImitatedCalendarController.swift
//  SwiftProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUImitatedCalendarController: UIViewController {

    private var collectionView: UICollectionView! // date collection view
    private let sectionNumber = 40 // total section number
    private var deviation = -20    // deviation to make today at top
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        generateSubview()
        resetColletionViewContentOffset()
    }

    // MARK: - Subview
        
    private func generateSubview() {
        // taday button
        let todayButton = UIButton(type: .custom)
        todayButton.setTitleColor(.orange, for: .normal)
        todayButton.setTitle("Today", for: .normal)
        todayButton.addTarget(self, action: #selector(clickTodayButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: todayButton)
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        // collection flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.headerReferenceSize = CGSize(width: width, height: 50)
        
        // date collection view
        let topX = UIApplication.shared.statusBarFrame.height + 44.0
        let rect = CGRect(x: 0, y: topX, width: width, height: height - topX)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .normal
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UUImitatedCalendarDateCell.self, forCellWithReuseIdentifier: "kDateCell")
        collectionView.register(UUImitatedCalendarSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "kDateView")
        self.view.addSubview(collectionView)
        collectionView.layoutIfNeeded()
    }
    
    @objc private func clickTodayButton() {
        deviation = -20
        resetColletionViewContentOffset()
        collectionView.reloadData()
    }

    // MARK: - Seek

    private func resetColletionViewContentOffset() {
        let indexPath = IndexPath(item: 0, section: sectionNumber/2)
        let kind = UICollectionView.elementKindSectionHeader
        let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath)
        collectionView.contentOffset = (attributes?.frame.origin)!
    }
    
    private func sectionAtPoint(_ point: CGPoint) -> Int {
        var indexPath = collectionView?.indexPathForItem(at: point)
        var targetPoint = point
        while indexPath == nil { // if target is top or bottom, can't find indexPath
            targetPoint.y += 10
            indexPath = collectionView?.indexPathForItem(at: targetPoint)
        }
        return indexPath?.section ?? 0
    }
    
    // collectionView section header frame origin at the point
    private func sectionHeaderPoint(with point: CGPoint) -> CGPoint {
        var indexPath = collectionView?.indexPathForItem(at: point)
        var targetPoint = point
        while indexPath == nil { // if target is top or bottom, can't find indexPath
            targetPoint.y += 10
            indexPath = collectionView?.indexPathForItem(at: targetPoint)
        }
        let kind = UICollectionView.elementKindSectionHeader
        let attributes = collectionView?.layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath!)
        return attributes?.frame.origin ?? point
    }

}

// MARK: - UICollectionViewDataSource
extension UUImitatedCalendarController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kDateCell", for: indexPath) as! UUImitatedCalendarDateCell
        cell.dateComponents = UUImitatedCalendarHandler.componentsWithMonthDeviation(deviation + indexPath.section)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "kDateView", for: indexPath) as! UUImitatedCalendarSectionView
        view.components = UUImitatedCalendarHandler.componentsWithMonthDeviation(deviation + indexPath.section)
        return view
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UUImitatedCalendarController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let components = UUImitatedCalendarHandler.componentsWithMonthDeviation(deviation + indexPath.section)
        let rowNumber = UUImitatedCalendarHandler.buttonWillHidden(with: components) ? 5 : 6
        let width = self.view.bounds.size.width
        return CGSize(width: width, height: width / 7.0 * CGFloat(rowNumber))
    }
    
}

// MARK: - UIScrollViewDelegate
extension UUImitatedCalendarController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentSection = sectionAtPoint(collectionView.contentOffset)
        let division = abs(currentSection - sectionNumber)
        if division < sectionNumber / 4 || division > sectionNumber / 4 * 3 {
            let gap = sectionNumber / 2 - currentSection
            deviation -= gap
            resetColletionViewContentOffset()
            collectionView.reloadData()
        }
        let components = UUImitatedCalendarHandler.componentsWithMonthDeviation(deviation + currentSection)
        self.navigationItem.title = "\(components.year!)年"
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > -0.6 && velocity.y < 0.6 { return }
        let originPoint = targetContentOffset.pointee
        let targetPoint = sectionHeaderPoint(with: originPoint)
        targetContentOffset.pointee = targetPoint
    }
    
}
