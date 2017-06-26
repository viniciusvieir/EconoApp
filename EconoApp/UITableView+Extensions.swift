//
//  UITableView+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 25/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

extension UITableView {
    
    var standardTableView: UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 4
        tableView.alpha = 0
        tableView.backgroundColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    func presentTableViewAnimated(y: CGFloat, completion: @escaping () -> ()) {
        self.transform = CGAffineTransform(translationX: 0, y: y)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: { (success) in
            completion()
        })
    }
    
    func selectPointIn(chart: LineChartView, arrayCount: Int, indexPath: IndexPath, selectedIndexPath: IndexPath?) -> IndexPath? {
        var selectedIndexPath = selectedIndexPath
        if selectedIndexPath == indexPath {
            self.deselectRow(at: indexPath, animated: false)
            return nil
        }
        
        
        
        selectedIndexPath = indexPath
        chart.highlightValue(x: Double(arrayCount - indexPath.row), dataSetIndex: 0)
        return selectedIndexPath
    }
    
}






