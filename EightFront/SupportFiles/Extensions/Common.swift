//
//  Utils.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/20.
//

import UIKit

final class Common {
    
    // TOOD: 싱글톤으로 만들지 의논
    // static let shared = Common()
    
    /**
     앱 설정 화면으로 이동
     */
    func goSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /**
     앱 종료
     */
    func appExit() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
