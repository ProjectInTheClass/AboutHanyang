//
//  MyInfoViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 13/06/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

var showCategoryAsMap:Bool = true

class infoSegueCell:UITableViewCell {
    @IBOutlet weak var title:UILabel!
}

class settingCell: UITableViewCell {
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var optionSwitch:UISwitch!
    
    @IBAction func setCategoryShowMode(_ sender: UISwitch) {
        showCategoryAsMap = sender.isOn
    }
}

class appInfoCell: UITableViewCell {
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var link:UILabel!
}

class MyInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoSegueTable: UITableView!
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var appInfoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoSegueTable.layer.cornerRadius = 10.0
        infoSegueTable.isScrollEnabled = false
        settingTable.layer.cornerRadius = 10.0
        settingTable.isScrollEnabled = false
        settingTable.allowsSelection = false
        appInfoTable.layer.cornerRadius = 10.0
        appInfoTable.isScrollEnabled = false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoSegueTable { return 2 }
        else if tableView == settingTable { return 1 }
        else if tableView == appInfoTable { return 2 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 내 정보
        if tableView == infoSegueTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "segueCell", for: indexPath) as! infoSegueCell
            cell.layer.cornerRadius = 10.0
            switch indexPath.row {
            case 0:
                cell.title.text = "최근 검색 기록 보기"
                break
            case 1:
                cell.title.text = "내가 쓴 댓글 보기"
                break
            default:
                break
            }
            return cell
        }
            
            // 설정
        else if tableView == settingTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! settingCell
            cell.layer.cornerRadius = 10.0
            switch indexPath.row {
            case 0:
                cell.title.text = "카테고리별 장소를 지도에 표시"
                break
            default:
                break
            }
            return cell
        }
            
            // 앱 정보
        else if tableView == appInfoTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appInfoCell", for: indexPath) as! appInfoCell
            cell.layer.cornerRadius = 10.0
            switch indexPath.row {
            case 0:
                cell.title.text = "제작자 정보"
                cell.content.isHidden = true
                break
            case 1:
                cell.title.text = "버전 정보"
                cell.title.textColor = .black
                cell.content.text = "1.0"
                cell.content.textColor = .black
                cell.link.isHidden = true
                break
            default:
                break
            }
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == infoSegueTable {
            tableView.cellForRow(at: indexPath)!.isSelected = false
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "showMyHistory", sender: nil)
                break
            case 1:
                performSegue(withIdentifier: "showMyComment", sender: nil)
                break
            default:
                break
            }
        }
    }
}
