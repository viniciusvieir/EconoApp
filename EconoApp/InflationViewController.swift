//
//  InflationViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 25/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts
import Timepiece

class InflationViewController: BaseInfoViewController {
    
    let cellId = "InflationCell"
    
    var inflationArray = [InflationData]()
    var genericInfo = [GenericInfo]()
    var selectedIndexPath: IndexPath?
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["IPCA", "IPCA15", "INPC"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.alpha = 0
        sc.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: UIControlEvents.valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if currentCountryCode == "BR" {
            getSidraData(index: .ipca)
        } else {
            getWorldBankData()
        }
    }
    
    fileprivate func setupViews() {
        
        chart.showGrid()
        
        chart.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if currentCountryCode == "BR" {
            view.addSubview(segmentedControl)
            _ = segmentedControl.anchor(closeButton.topAnchor, left: closeButton.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: -16, widthConstant: 0, heightConstant: 36)
        }
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    fileprivate func getSidraData(index: SidraAPI.InflationTableIndex) {
        activityLabel.startAnimating()
        inflationArray = [InflationData]()
        
        var dates = [Date]()
        for i in 0 ... 13 {
            dates.append((Date() - i.months)!)
        }
        
        SidraAPI(tableIndex: index, dates: dates) { (json) in
            
            guard let json = json else {
                self.dismissViewController()
                return
            }
            
            self.inflationArray = SidraAPI.arrayFrom(json: json)
            self.reloadInfo(brazil: true, description: "* Sidra IBGE")
        }
    }
    
    fileprivate func getWorldBankData() {
        
        WorldBankAPI(indicator: .inflationConsumerPrice, numberOfItems: 20) { (json) in
            
            guard let json = json?[1] else {
                self.dismissViewController()
                return
            }
            
            self.genericInfo = WorldBankAPI.arrayFrom(json: json)
            self.reloadInfo(brazil: false, description: "* World Bank " + (json[0]["indicator"]["value"].string ?? ""))
        }
        
    }
    
    fileprivate func reloadInfo(brazil: Bool, description: String) {
        
        self.activityIndicator.stopAnimating()
        self.activityLabel.stopAnimating(completion: {
            self.tableView.reloadData()
            self.animateTableViewAnimated()
            if brazil {
                self.chart.setData(dataPoints: self.inflationArray.map{$0.date}.reversed(), values: self.inflationArray.map{$0.monthVariation}.reversed(), label: "Inflation", lineColor: self.view.backgroundColor?.inverse(), drawCirclesEnabled: true)
                self.segmentedControl.isEnabled = true
            } else {
                self.chart.setData(dataPoints: self.genericInfo.map{$0.date}.reversed(), values: self.genericInfo.map{$0.value}.reversed(), label: "Inflation", lineColor: self.view.backgroundColor?.inverse(), drawCirclesEnabled: true)
            }
            self.descriptionLabel.text = description
        })
        
    }
    
    fileprivate func animateTableViewAnimated() {
        
        self.tableView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.size.height)
        self.segmentedControl.transform = CGAffineTransform(translationX: 0, y: -40)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransform.identity
            
            self.segmentedControl.alpha = 1
            self.segmentedControl.transform = CGAffineTransform.identity
            
            self.descriptionLabel.alpha = 1
            
        }, completion: nil)
        
    }
    
    @objc fileprivate func segmentedControlDidChange(_ sender: UISegmentedControl) {
        sender.isEnabled = false
        let index: SidraAPI.InflationTableIndex = {
            if sender.selectedSegmentIndex == 0 {
                return .ipca
            } else if sender.selectedSegmentIndex == 1 {
                return .ipca15
            }
            return .inpc
        }()
        
        prepareViewForChange(index: index)
    }
    
    fileprivate func prepareViewForChange(index: SidraAPI.InflationTableIndex) {
        
        chart.clear()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.tableView.alpha = 0
            self.tableView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.size.height)
            
            self.segmentedControl.alpha = 0
            self.segmentedControl.transform = CGAffineTransform(translationX: 0, y: -40)
            
            self.descriptionLabel.alpha = 0
            
        }) { (success) in
            self.tableView.transform = CGAffineTransform.identity
            self.segmentedControl.transform = CGAffineTransform.identity
            self.activityLabel.restartAnimating {
                self.getSidraData(index: index)
            }
        }
        
    }
    
}


extension InflationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCountryCode == "BR" ? inflationArray.count : genericInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        cell.menuItem = menuItem
        
        if currentCountryCode == "BR" {
            let inflationData = inflationArray[indexPath.row]
            cell.titleLabel.text = inflationData.date.capitalized
            cell.valueLabel.text = inflationData.monthVariation.twoDigits
        } else {
            let inflationData = genericInfo[indexPath.row]
            cell.titleLabel.text = inflationData.date.capitalized
            cell.valueLabel.text = inflationData.value.twoDigits
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let highlight = Highlight(x: 1.0, dataSetIndex: 4, stackIndex: 0)
        chart.highlightValue(highlight, callDelegate: false)
//        selectedIndexPath = tableView.selectPointIn(chart: chart, arrayCount: inflationArray.count, indexPath: indexPath, selectedIndexPath: selectedIndexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let position = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if position.y > 0 {
            // Dragging down
        } else {
            // Dragging up
        }
    }
    
}

extension InflationViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedIndexPath = chartView.selectIn(tableView: tableView,
                                               arrayCount: currentCountryCode == "BR" ? inflationArray.count : genericInfo.count,
                                               xEntry: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selectedIndexPath = nil
    }
    
}
