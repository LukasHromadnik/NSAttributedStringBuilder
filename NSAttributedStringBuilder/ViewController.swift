//
//  ViewController.swift
//  Playground
//
//  Created by Lukáš Hromadník on 26/10/2019.
//  Copyright © 2019 Lukáš Hromadník. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white

        let text = NSAttributedString("ahoj\nčusasdahsjkahkjs dajkh dkasj ash jahskdj ah ajkhs djkah jskd") {
            Foreground(.red)
            LineHeight(50)
            LineBreakMode(.byTruncatingTail)
        }
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 100))
        label.numberOfLines = 2
        label.attributedText = text
        view.addSubview(label)
    }

}
