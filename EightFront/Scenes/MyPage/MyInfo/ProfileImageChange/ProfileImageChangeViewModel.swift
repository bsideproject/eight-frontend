//
//  ProfileImageChangeViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import UIKit
import Kingfisher

class ProfileImageChangeViewModel {
    
    let images = [
        ProfileImage(imageName: "프로 나눔러",
                     imageURLStr: "https://i.pinimg.com/originals/fb/71/04/fb71048e03a5ada757f70d61b583d0bf.png"),
        ProfileImage(imageName: "의세권 주민",
                     imageURLStr: "https://cdn-icons-png.flaticon.com/512/2111/2111466.png"),
        ProfileImage(imageName: "우유부단",
                     imageURLStr: "https://w7.pngwing.com/pngs/869/485/png-transparent-google-logo-computer-icons-google-text-logo-google-logo-thumbnail.png")
    ]
    
    func numberOfItemsInSection() -> Int {
        return images.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> ProfileImage {
        return images[indexPath.row]
    }
    
}
