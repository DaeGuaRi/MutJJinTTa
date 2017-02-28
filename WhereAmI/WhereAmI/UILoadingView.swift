//
//  UILoadingView.swift
//
//  Created by Ian McDowell on 6/6/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//
import UIKit

class UILoadingView : UIView {
    
    init(frame rect: CGRect, text: NSString = "Loading...") {
        super.init(frame: rect)
        self.backgroundColor = UIColor.white
        self.label.text = text as String
        self.label.textColor = self.spinner.color
        self.spinner.startAnimating()
        
        self.addSubview(self.label)
        self.addSubview(self.spinner)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth;
        self.setNeedsLayout()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    lazy var label : UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        return l
    }()
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func layoutSubviews() {
        let labelString:NSString = self.label.text! as NSString
		let labelSize: CGSize = labelString.size(attributes: [NSFontAttributeName: self.label.font])
        var labelFrame: CGRect = CGRect()
        labelFrame.size = labelSize
        self.label.frame = labelFrame
        
        // center label and spinner
        self.label.center = self.center
        self.spinner.center = self.center
        
        // horizontally align
        labelFrame = self.label.frame
        var spinnerFrame: CGRect = self.spinner.frame
        let totalWidth: CGFloat = spinnerFrame.size.width + 5 + labelSize.width
        spinnerFrame.origin.x = self.bounds.origin.x + (self.bounds.size.width - totalWidth) / 2
        labelFrame.origin.x = spinnerFrame.origin.x + spinnerFrame.size.width + 5
        self.label.frame = labelFrame
        self.spinner.frame = spinnerFrame
    }

}
