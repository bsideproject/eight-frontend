//
//  ReportCategoryView.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import UIKit

class ReportCategoryView: UIView {
    
    let viewModel = ReportLogViewModel()
    
    // 전체
    private let allView = UIView()
    private let allLabel = UILabel().then {
        $0.text = "전체"
    }
    private let allBottomDiver = UIView()
    
    // 정보 수정
    private let editView = UIView()
    private let editLabel = UILabel().then {
        $0.text = "정보 수정"
    }
    private let editBottomDiver = UIView()
    
    // 신규 등록
    private let addView = UIView()
    private let addLabel = UILabel().then {
        $0.text = "신규 등록"
    }
    private let addBottomDiver = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
        addSubview(allView)
        allView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.width.equalTo(25)
            $0.height.equalTo(29)
            
            allView.addSubview(allLabel)
            allLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            allView.addSubview(allBottomDiver)
            allBottomDiver.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(3)
                $0.height.equalTo(3)
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        addSubview(editView)
        editView.snp.makeConstraints {
            $0.left.equalTo(allView.snp.right).offset(16)
            $0.width.equalTo(52)
            $0.height.equalTo(29)
            
            editView.addSubview(editLabel)
            editLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            editView.addSubview(editBottomDiver)
            editBottomDiver.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(3)
                $0.height.equalTo(3)
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        addSubview(addView)
        addView.snp.makeConstraints {
            $0.left.equalTo(editView.snp.right).offset(16)
            $0.width.equalTo(52)
            $0.height.equalTo(29)
            
            addView.addSubview(addLabel)
            addLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            addView.addSubview(addBottomDiver)
            addBottomDiver.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(3)
                $0.height.equalTo(3)
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    private func bind() {
        
        allView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.selectedCategory = .all
            }.store(in: &viewModel.bag)
        
        editView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.selectedCategory = .edit
            }.store(in: &viewModel.bag)
        
        addView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.selectedCategory = .add
            }.store(in: &viewModel.bag)
        
        
        viewModel.$selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // 전체
                self?.allLabel.textColor = $0 == .all ? UIColor.black : Colors.gray006.color
                self?.allBottomDiver.backgroundColor = $0 == .all ? Colors.point.color : UIColor.clear
                // 정보 수정
                self?.editLabel.textColor = $0 == .edit ? UIColor.black : Colors.gray006.color
                self?.editBottomDiver.backgroundColor = $0 == .edit ? Colors.point.color : UIColor.clear
                // 신규 등록
                self?.addLabel.textColor = $0 == .add ? UIColor.black : Colors.gray006.color
                self?.addBottomDiver.backgroundColor = $0 == .add ? Colors.point.color : UIColor.clear
            }.store(in: &viewModel.bag)
    }
    
}
