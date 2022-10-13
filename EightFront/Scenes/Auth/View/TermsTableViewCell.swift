//
//  TermsTableViewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/13.
//

import UIKit

class TermsTableViewCell: UITableViewCell {
    
    // MARK: - properties
    static let identifier = "TermsTableViewCell"
    
    
    // MARK: - lifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - makeUI
    private func makeUI() {
        backgroundColor = .yellow
    }
    
    
    
}
