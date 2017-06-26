//
//  BaseInfoViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 25/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

class BaseInfoViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    var activityLabel: ActivityProgressLabel!
    var closeButton: UIButton!
    var currentCountryCode: String?
    
    var menuItem: HomeMenuItems?
    
    let topChartPadding: CGFloat = 50
    
    var chart: LineChartView!
    var descriptionLabel: UILabel!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView().standardTableView
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicatorsAndButtons()
    }
    
    final func setupIndicatorsAndButtons() {
        closeButton = self.addCloseButton()
        activityIndicator = self.addActivityIndicator(style: .white)
        chart = self.addLineChartView()
        
        //        activityIndicator.startAnimating()
        self.setupCloseButtonAndActivityIndicator(closeButton: closeButton, activityIndicator: activityIndicator)
        
        if let text = menuItem?.subtitle {
            activityLabel = ActivityProgressLabel(text: text)
        } else {
            activityLabel = ActivityProgressLabel(text: "")
        }
        
        view.addSubview(activityLabel)
        view.addSubview(chart)
        view.addSubview(tableView)
        
        activityLabel.centerTo(view: self.view)
        activityLabel.startAnimating()
        
        _ = chart.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: topChartPadding, leftConstant: 12, bottomConstant: 0, rightConstant: -12, widthConstant: 0, heightConstant: 160)
        _ = tableView.anchor(chart.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: -8, rightConstant: -8, widthConstant: 0, heightConstant: 0)
        
        descriptionLabel = self.addReferenceLabel(text: "", color: UIColor.white, viewAnchor: chart)
    }

}
