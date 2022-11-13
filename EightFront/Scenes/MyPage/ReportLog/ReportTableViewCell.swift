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
    
    private let addressLabel = UILabel().then {
        $0.text = "주소"
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "시간"
    }
    
    private let stateView = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    
    private let stateLabel = UILabel().then {
        $0.text = "처리중"
        $0.textColor = .white
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
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.left.equalToSuperview().inset(24)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(7)
            $0.left.equalToSuperview().inset(24)
        }
        
        addSubview(stateView)
        stateView.snp.makeConstraints {
            $0.width.equalTo(59)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(31)
        }
        
        stateView.addSubview(stateLabel)
        stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(report: Report) {
        addressLabel.text = report.address
        timeLabel.text = report.time
        stateLabel.text = report.state
        if report.state == "처리 중" {
            stateView.backgroundColor = .red
        } else if report.state == "완료" {
            stateView.backgroundColor = .black
        } else if report.state == "반려" {
            stateView.backgroundColor = .blue
        }
    }
}
