//
//  MinimumWageViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 22/06/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

class MinimumWageViewController: BaseInfoViewController {
    
    let cellId = "WageCell"
    
    var years = [String]()
    var wageArray = [String: [AnnualMinimumWage]]()
    var wageContinuousArray = [AnnualMinimumWage]()
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if currentCountryCode == "BR" {
            getDieeseData()
        } else {
            getWorldBankData()
        }
        
    }
    
    func setupViews() {
        
        chart.showGrid()
        
        chart.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func getDieeseData() {
        
        MinimumWageBrazil { (info) in
            
            guard let info = info else {
                self.dismissViewController()
                return
            }
            
            self.wageArray = info
            self.years = Array(self.wageArray.keys).sorted{ $0 > $1 }
            
            self.reloadInfo()
        }
        
    }
    
    fileprivate func getWorldBankData() {
        // TODO:- FIND AN API TO GET OTHER COUNTRIES MINIMUM WAGE, NOT FOUND SO FAR - 22/06/17
    }
    
    fileprivate func reloadInfo() {
        self.activityIndicator.stopAnimating()
        
        self.activityLabel.stopAnimating(completion: {
            self.tableView.reloadData()
            self.tableView.presentTableViewAnimated(y: self.view.bounds.size.height, completion: {
                self.descriptionLabel.text = "* DIEESE"
            })
            
            var values = [Double]()
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_BR")
            
            for year in self.years {
                if let yearlyInfo = self.wageArray[year] {
                    for item in yearlyInfo {
                        self.wageContinuousArray.append(item)
                        if let value = item.minimumWage {
                            let number = formatter.number(from: value.replacingOccurrences(of: " ", with: ""))?.doubleValue ?? 0.0
                            values.append(number)
                        } else {
                            values.append(0.0)
                        }
                    }
                }
            }
            
            self.chart.setData(dataPoints: values.map{return "\($0)"}, values: values.reversed(), label: "Minimum Wage", lineColor: self.view.backgroundColor?.inverse())
        })
    }
    
}

extension MinimumWageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return years[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wageArray[years[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        cell.menuItem = menuItem
        
        if let item = wageArray[years[indexPath.section]]?[indexPath.row] {
            cell.titleLabel.text = item.month?.replacingOccurrences(of: "&ccedil;", with: "ç")
            cell.valueLabel.text = item.minimumWage
        }
        
        return cell
    }
    
}

extension MinimumWageViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        selectedIndexPath = chartView.selectIn(tableView: tableView, arrayCount: gdpPerCapitaArray.count, xEntry: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndexPath = nil
    }
    
}
