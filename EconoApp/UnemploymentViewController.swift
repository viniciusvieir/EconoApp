
//
//  UnemploymentViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 21/06/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

class UnemploymentViewController: BaseInfoViewController {
    
    let cellId = "UnemploymentCell"
    var graphDescription: String?
    
    var unemploymentArray = [GenericInfo]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getData()
    }
    
    fileprivate func setupViews() {
        
        chart.showGrid()
        
        chart.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func getData() {
        
        WorldBankAPI(indicator: .unemployment, numberOfItems: 30, completion: { (json) in
            
            guard let json = json?[1] else {
                self.dismissViewController()
                return
            }
            
            self.graphDescription = json[0]["indicator"]["value"].string
            self.unemploymentArray = WorldBankAPI.arrayFrom(json: json)
            
            self.activityIndicator.stopAnimating()
            
            self.activityLabel.stopAnimating(completion: {
                self.tableView.reloadData()
                self.tableView.presentTableViewAnimated(y: self.view.bounds.size.height, completion: {
                    self.descriptionLabel.text = "* World Bank \(self.graphDescription ?? "")"
                })
                self.chart.setData(dataPoints: self.unemploymentArray.map{$0.date}.reversed(), values: self.unemploymentArray.map{$0.value}.reversed(), label: "Unemployment", lineColor: self.view.backgroundColor?.inverse())
            })
            
        })
        
    }

}

extension UnemploymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unemploymentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        cell.menuItem = menuItem
        
        let item = unemploymentArray[indexPath.row]
        cell.titleLabel.text = item.date
        cell.valueLabel.text = item.value.twoDigits
        
        return cell
    }
    
}

extension UnemploymentViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedIndexPath = chartView.selectIn(tableView: tableView, arrayCount: unemploymentArray.count, xEntry: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndexPath = nil
    }
    
}










