//
//  GDPPerCapitaViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 24/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

class GDPPerCapitaViewController: BaseInfoViewController {

    let cellId = "GDPPerCapitaCell"
    var graphDescription: String?
        
    var gdpPerCapitaArrayAll = [GenericInfo]()
    var gdpPerCapitaArray = [GenericInfo]()
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
        
        WorldBankAPI(indicator: .gdpPerCapita, numberOfItems: 30, completion: { (json) in
            
            guard let json = json?[1] else {
                self.dismissViewController()
                return
            }
            
            self.graphDescription = json[0]["indicator"]["value"].string
            self.gdpPerCapitaArrayAll = WorldBankAPI.arrayFrom(json: json)
            self.gdpPerCapitaArray = self.gdpPerCapitaArrayAll
            
            self.activityIndicator.stopAnimating()
            
            self.activityLabel.stopAnimating(completion: {
                self.tableView.reloadData()
                self.tableView.presentTableViewAnimated(y: self.view.bounds.size.height, completion: {
                    self.descriptionLabel.text = "* World Bank \(self.graphDescription ?? "")"
                })
                self.chart.setData(dataPoints: self.gdpPerCapitaArray.map{$0.date}.reversed(), values: self.gdpPerCapitaArray.map{$0.value}.reversed(), label: "PIB Per Capita", lineColor: self.view.backgroundColor?.inverse())
            })
            
        })
    }
    
}

extension GDPPerCapitaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gdpPerCapitaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        cell.menuItem = menuItem
        
        let item = gdpPerCapitaArray[indexPath.row]
        cell.titleLabel.text = item.date
        cell.valueLabel.text = item.value.zeroDecimals
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedIndexPath = tableView.selectPointIn(chart: chart, arrayCount: gdpPerCapitaArray.count, indexPath: indexPath, selectedIndexPath: selectedIndexPath)
    }
    
}

extension GDPPerCapitaViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedIndexPath = chartView.selectIn(tableView: tableView, arrayCount: gdpPerCapitaArray.count, xEntry: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndexPath = nil
    }
    
}







