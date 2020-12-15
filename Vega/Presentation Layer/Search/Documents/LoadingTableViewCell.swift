//
//  LoadingTableViewCell.swift
//  Vega
//
//  Created by Peter Kvasnikov on 08.12.2020.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        activityIndicator.center.x = self.contentView.center.x
        activityIndicator.center.y = self.contentView.center.y
        
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
