//
//  ReportTableViewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    // MARK: - properties
    static let identifier = "ReportTableViewCell"
    
    private let categoryLabel = UILabel().then {
        $0.font = Fonts.Templates.body1.font
        $0.textColor = Colors.gray005.color
    }
    
    private let addressLabel = UILabel().then {
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private let stateView = UIView().then {
        $0.backgroundColor = UIColor.red
        $0.layer.cornerRadius = 11
    }
    
    private let stateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = Fonts.Templates.caption3.font
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: makeUI
    private func makeUI() {
        
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(16)
        }
        
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
        }

        addSubview(stateView)
        stateView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(22)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            
            stateView.addSubview(stateLabel)
            stateLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    func configure(report: Report) {
        addressLabel.text = report.address
        stateLabel.text = report.status
//        if report.state == "처리중" {
//            stateView.backgroundColor = Colors.Report.reportIngBackgroundColor.color
//            stateLabel.textColor = Colors.Report.reportIngFontColor.color
//        } else if report.state == "완료" {
//            stateView.backgroundColor = Colors.Report.reportCompletedBackgroudColor.color
//            stateLabel.textColor = Colors.Report.reportCompletedFontColor.color
//        } else if report.state == "반려" {
//            stateView.backgroundColor = Colors.Report.reportRejectBackgroundColor.color
//            stateLabel.textColor = Colors.Report.reportRejectFontColor.color
//        }
    }
}
