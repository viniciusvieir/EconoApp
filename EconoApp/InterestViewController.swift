//
//  InterestViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 13/06/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

class InterestViewController: BaseInfoViewController {
    
    let cellId = "InterestCell"
    var graphDescription: String?
    
    var selicArray = [SELIC]()
    var infoArray = [GenericInfo]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if currentCountryCode == "BR" {
            getSELIC()
        } else {
            getDepositInterestRate()
        }
    }
    
    fileprivate func setupViews() {
        
        chart.showGrid()
        
        chart.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func getSELIC() {
        HTMLReaper.getSELIC { (selicArray) in
            guard let selicArray = selicArray else {
                self.dismissViewController()
                return
            }
            if selicArray.count > 100 {
                self.selicArray = Array(selicArray.prefix(100))
            } else {
                self.selicArray = selicArray
            }
            self.reloadInfo(selic: true)
        }
    }
    
    fileprivate func getDepositInterestRate() {
        WorldBankAPI(indicator: .depositInterestRate, numberOfItems: 20, completion: { (json) in
            
            guard let json = json?[1] else {
                self.dismissViewController()
                return
            }
            
            self.graphDescription = json[0]["indicator"]["value"].string
            self.infoArray = WorldBankAPI.arrayFrom(json: json)
            self.reloadInfo(selic: false)
        })
    }
    
    fileprivate func reloadInfo(selic: Bool) {
        self.activityIndicator.stopAnimating()
        self.activityLabel.stopAnimating(completion: {
            self.tableView.reloadData()
            self.tableView.presentTableViewAnimated(y: self.view.bounds.size.height, completion: {
                self.descriptionLabel.text = self.graphDescription ?? "* BCB - SELIC (meta)"
            })
            
            if selic {
                let formatter = NumberFormatter()
                formatter.decimalSeparator = ","
                let values = self.selicArray.map({ (item) -> Double in
                    return formatter.number(from: item.meta ?? "0,0")?.doubleValue ?? 0.0
                })
                self.chart.setData(dataPoints: self.selicArray.map{$0.data ?? ""}.reversed(), values: values.reversed(), label: "Interest")
            } else {
                self.chart.setData(dataPoints: self.infoArray.map{$0.date}.reversed(), values: self.infoArray.map{$0.value}.reversed(), label: "Deposit Interest Rate", lineColor: self.view.backgroundColor?.inverse())
            }
            
        })
    }
    
}

extension InterestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCountryCode == "BR" ? selicArray.count : infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        cell.menuItem = menuItem
        
        if currentCountryCode == "BR" {
            let item = selicArray[indexPath.row]
            cell.titleLabel.text = item.data == "" ? "-" : item.data
            cell.valueLabel.text = item.meta
        } else {
            let item = infoArray[indexPath.row]
            cell.titleLabel.text = item.date
            cell.valueLabel.text = item.value.twoDigits
        }
        
        return cell
    }
    
}

extension InterestViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedIndexPath = chartView.selectIn(tableView: tableView,
                                               arrayCount: currentCountryCode == "BR" ? selicArray.count : infoArray.count,
                                               xEntry: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndexPath = nil
    }
    
}
