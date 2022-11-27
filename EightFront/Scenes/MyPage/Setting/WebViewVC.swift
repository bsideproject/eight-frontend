//
//  WebViewVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/26.
//

import UIKit
import WebKit
import Combine
final class WebViewVC: UIViewController {
    
    private var webView = WKWebView()
    
    var bag = Set<AnyCancellable>()
    var url = "https://bside.best/"
    var titleLabel = "웹뷰"
    
    private let commonNavigationView = CommonNavigationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeUI()
        bind()
    }
    
    func configure() {
        commonNavigationView.titleLabel.text = titleLabel
        let components = URLComponents(string: url)!
        let request = URLRequest(url: components.url!)
        self.webView.load(request)
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        commonNavigationView.backButton.gesture().receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &bag)
    }
}


