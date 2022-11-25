//
//  ReportPostCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/20.
//

import Then
import SnapKit
import UIKit
//MARK: ReportPostCell
final class ReportPostCell: UITableViewCell {
    //MARK: - Properties
    let titlaLabel = UILabel().then {
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.subheader.font
    }
    let checkboxButton = UIButton().then {
        $0.setImage(Images.Report.checkboxSelectNone.image)
    }
    
    override var isSelected: Bool {
        didSet {
            checkboxButton.setImage(isSelected ? Images.Report.checkboxSelect.image : Images.Report.checkboxSelectNone.image)
        }
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(titlaLabel)
        contentView.addSubview(checkboxButton)
        
        checkboxButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        titlaLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(checkboxButton.snp.left).offset(4)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func configure(with title: String?) {
        titlaLabel.text = title
    }
}

