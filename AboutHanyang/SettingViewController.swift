//
//  SettingViewController.swift
//  aboutHanyang
//
//  Created by aboutHanyang on 25/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
import GoogleMaps

struct Settings {
    var showCategoryAsMap:Bool // true일 때 카테고리 선택 시 지도 상에 결과 출력
    var restorePointInMap:GMSCameraPosition // 지도 기본 시점 위치
    
    init() {
        self.showCategoryAsMap = true
        self.restorePointInMap =
            GMSCameraPosition.camera(withLatitude: 37.55576196, longitude: 127.04947214, zoom: 17.0)
    }
}

// 저장된 세팅 정보가 있을 경우 불러오는 기능 필요
var settings = Settings()

class SettingViewController: UIViewController {
    
    @IBOutlet weak var categoryModeSwitch: UISwitch!
    
    @IBAction func setCategoryShowMode(_ sender: UISwitch) {
        if (sender.isOn) {
            settings.showCategoryAsMap = true
        }
        else {
            settings.showCategoryAsMap = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        categoryModeSwitch.setOn(settings.showCategoryAsMap, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
