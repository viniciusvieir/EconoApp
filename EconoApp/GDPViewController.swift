//
//  GDPViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 24/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts

class GDPViewController: BaseInfoViewController {
    
    let cellId = "GDPCell"
    var graphDescription: String?
    
    var gdpArrayAll = [GenericInfo]()
    var gdpArray = [GenericInfo]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getData()
    }
    
    fileprivate func setupViews() {
        
        chart.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func getData() {
        
        WorldBankAPI(indicator: .gdp, numberOfItems: 30, completion: { (json) in
            
            guard let json = json?[1] else {
                self.dismissViewController()
                return
            }
            
            self.graphDescription = json[0]["indicator"]["value"].string
            self.gdpArrayAll = WorldBankAPI.arrayFrom(json: json)
            self.gdpArray = self.gdpArrayAll
            
            self.activityIndicator.stopAnimating()
            
            self.activityLabel.stopAnimating(completion: {
                self.tableView.reloadData()
                self.tableView.presentTableViewAnimated(y: self.view.bounds.size.height, completion: {
                    self.descriptionLabel.text = "* World Bank \(self.graphDescription ?? "")"
                })
                self.chart.setData(dataPoints: self.gdpArray.map{$0.date}.reversed(), values: self.gdpArray.map{$0.value}.reversed(), label: "PIB", lineColor: self.view.backgroundColor?.inverse())
            })
            
        })
    }
    
//    func setSelected(xEntry: Int, indexPath: IndexPath? = nil) {
//        selectedIndexPath = IndexPath(row: gdpArray.count - xEntry, section: 0)
//        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
//
//        let highlight = Highlight(x: 1.1, dataSetIndex: 0, stackIndex: 0)
//        chart.highlightValue(highlight)
//
//    }
    
}

extension GDPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gdpArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        cell.menuItem = menuItem
        
        let item = gdpArray[indexPath.row]
        cell.titleLabel.text = item.date
        cell.valueLabel.text = item.value.zeroDecimals
        
        return cell
    }
    
}

extension GDPViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedIndexPath = chartView.selectIn(tableView: tableView, arrayCount: gdpArray.count, xEntry: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndexPath = nil
    }
    
}












