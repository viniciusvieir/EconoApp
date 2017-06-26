//
//  UIViewController+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

extension UIViewController {
    
    func addCloseButton(color: UIColor = UIColor.white) -> UIButton {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close_button").changeColor(to: color), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    func addActivityIndicator(style: UIActivityIndicatorViewStyle) -> UIActivityIndicatorView {
        var ai = UIActivityIndicatorView()
        ai = UIActivityIndicatorView(activityIndicatorStyle: style)
        ai.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ai)
        return ai
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupCloseButtonAndActivityIndicator(closeButton: UIButton, activityIndicator: UIActivityIndicatorView) {
        _ = closeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
    }
    
    func addReferenceLabel(text: String, color: UIColor, viewAnchor: UIView? = nil) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        
        if let viewAnchor = viewAnchor {
            _ = label.anchor(viewAnchor.bottomAnchor, left: viewAnchor.leftAnchor, bottom: nil, right: viewAnchor.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
        return label
    }
    
    // CHART DELEGATES
    
    func addLineChartView() -> LineChartView {
        let chart = LineChartView()
        chart.noDataText = ""
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.chartDescription?.enabled = false
        chart.maxHighlightDistance = 300
        
        chart.xAxis.enabled = false
        
        let yAxis = chart.leftAxis
        yAxis.drawAxisLineEnabled = false
        yAxis.enabled = false
        
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }
    
}
