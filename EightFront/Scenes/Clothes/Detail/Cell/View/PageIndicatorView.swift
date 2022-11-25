//
//  PageIndicatorView.swift
//  EightFront
//
//  Created by wargi on 2022/11/19.
//

import Then
import SnapKit
import UIKit

protocol PageIndicatorViewDataSources: AnyObject {
    func numberOfItems() -> Int
}

//MARK: PageIndicatorView
final class PageIndicatorView: UIView {
    //MARK: - Properties
    weak var dataSources: PageIndicatorViewDataSources? {
        didSet {
            reloadData()
        }
    }
    
    var totalPages = 0
    var currentPage = 0
    let hStackView = UIStackView().then {
        $0.spacing = 6
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {        
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        (0 ..< 5).forEach { idx in
            let view = UIView()
            view.isHidden = true
            view.layer.cornerRadius = 4
            view.snp.makeConstraints {
                $0.width.equalTo(idx == 0 ? 16 : 8)
            }
            view.backgroundColor = UIColor(colorSet: idx == 0 ? 19 : 217)
            hStackView.addArrangedSubview(view)
        }
    }
    
    func reloadData() {
        guard let dataSources else { return }
        
        totalPages = dataSources.numberOfItems()
        
        (0 ..< totalPages).forEach { idx in
            let view = hStackView.subviews[idx]
            view.isHidden = false
            view.snp.updateConstraints {
                $0.width.equalTo(idx == currentPage ? 16 : 8)
            }
            view.backgroundColor = UIColor(colorSet: idx == currentPage ? 19 : 217)
        }
        (totalPages ..< 5).forEach { idx in
            let view = hStackView.subviews[idx]
            view.isHidden = true
        }
    }
    
    func updatePage(at index: Int) {
        guard !hStackView.subviews.isEmpty,
              currentPage < hStackView.subviews.count,
              index < hStackView.subviews.count else { return }
        
        let prevView = hStackView.subviews[currentPage]
        prevView.backgroundColor = UIColor(colorSet: 217)
        prevView.snp.updateConstraints {
            $0.width.equalTo(8)
        }
        
        let currentView = hStackView.subviews[index]
        currentView.backgroundColor = UIColor(colorSet: 19)
        currentView.snp.updateConstraints {
            $0.width.equalTo(16)
        }
        
        currentPage = index
    }
}
