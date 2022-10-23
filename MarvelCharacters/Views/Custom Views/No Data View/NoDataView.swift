//
//  NoDataView.swift
//  AssessmentApp
//
//  Created by Dina Ragab on 14/10/2022.
//

import UIKit

class NoDataView: UIView {
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViewFromNib()
        setStrings()
    }
    
    func setStrings() {
        noDataLabel.text = "noData".localized()
    }
}
