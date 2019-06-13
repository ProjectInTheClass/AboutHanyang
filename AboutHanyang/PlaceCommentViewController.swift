
import UIKit
import Firebase

struct CommentFormat {
    var comment : String
    var sympathy : [String]
    var time : String
    var uid : String
}

protocol CommentViewDelegate {
    func upSympathy(uid:String , sym_list : [String])
}

class CommentViewCell : UITableViewCell {
    
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var sympathy: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var symButton: UIButton!

    var sym_list : [String] = []
    var c_uid : String = ""
    var delegate : CommentViewDelegate? = nil
    
    @IBAction func SympathyComment(_ sender: Any) {
        delegate?.upSympathy(uid: c_uid, sym_list: sym_list)
    }
}

class PlaceCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    
    var selectedPlace : String? = ""
    //var comment_normal : Array<CommentFormat> = []
    var comment_best : [CommentFormat] = []
    var comment_normal : [CommentFormat] = []
    var uid : String = ""
    
    /*
     func addComment(_ userComment : String , _ uid : String) -> Bool {
     
     }
     
     func pullComment(_ placename : String) -> Array<CommentFormat> {
     
     }
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Best 의견"
        }
        else {
            return "일반 의견"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            return comment_best.count
        }
        return comment_normal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentViewCell
        let count = indexPath.row
        var dic : CommentFormat
        
        if (indexPath.section==0) {
            if (comment_best.count > count) {
                dic = comment_best[count]
            }
            else {
                return (cell as UITableViewCell)
            }
        }
        else {
            dic = comment_normal[count]
        }
        
        cell.userComment.text = dic.comment
        cell.dateTime.text = dic.time
        cell.sympathy.text = "\(dic.sympathy.count)"
        cell.sym_list = dic.sympathy
        
        let normal_button = UIImage(named: "Like2")
        let highlited_button = UIImage(named: "Like1")
        
        cell.symButton.setImage(normal_button, for: .init())
        
        for item in dic.sympathy{
            if(item == uid){
                cell.symButton.setImage(highlited_button, for: .init())
                break;
            }
        }
        
        cell.c_uid = dic.uid
        cell.delegate = self
        
        return (cell as UITableViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let getkey = defaults.string(forKey: "user_uid") {
            uid = getkey
        }
        getAllComment()
    }
    
    func getAllComment(){
        comment_best.removeAll();
        comment_normal.removeAll();
        
        ref.child("review").child(selectedPlace!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dic = snapshot.value as? [String:[String:Any]]
                else {
                    print("get data error")
                    self.tableView.reloadData()
                    return
            }
            
            let dic_keys = Array(dic.keys)
            
            for index in 0..<dic_keys.count {
                guard let formatter = self.convertDic(dic_keys[index], dic[dic_keys[index]]!)
                      else { continue }
                
                self.comment_normal.append(formatter)
            }
            
            self.comment_normal.sort{
                (a:CommentFormat, b:CommentFormat) -> Bool in return a.time > b.time
            }
            
            let best_comment = self.comment_normal.sorted{
                (a:CommentFormat, b:CommentFormat) -> Bool in return a.sympathy.count > b.sympathy.count
            }
            
            for i in 0..<2 {
                if (i<best_comment.count) {
                    self.comment_best.append(best_comment[i])
                }
            }
            
            self.tableView.reloadData()
            print("tableview reload done")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "코멘트"
        self.navigationItem.backBarButtonItem?.title = self.selectedPlace
                
        ref = Database.database().reference()
        
        self.tableView.estimatedRowHeight = 250
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendComment(_ sender: Any) {
        let review_comment = textField.text ?? ""
        let time = Double(NSDate().timeIntervalSince1970)
        
        
        if(review_comment.count > 40){
            let alert = UIAlertController(title: "작성 불가", message: "댓글 길이 제한은 40자입니다.", preferredStyle: UIAlertController.Style.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        for item in comment_normal{
            if(item.uid == uid){
                let alert = UIAlertController(title: "이미 의견을 남기셨습니다.", message: "기존 의견을 지우고 새 의견을 쓰시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    self.ref.child("review").child(self.selectedPlace!).child(self.uid).setValue(["comment":review_comment, "sympathy":[""], "time":time]){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            self.getAllComment()
                        }
                    }
                    self.textField.text = ""
                    alert.dismiss(animated: true, completion: nil)
                    
                }
                
                let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(ok)
                alert.addAction(no)
                
                present(alert, animated: true, completion: nil)
                return
            }
        }
        
        let alert = UIAlertController(title: "댓글 쓰기", message: "댓글을 남기시겠습니까?.", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.ref.child("review").child(self.selectedPlace!).child(self.uid).setValue(["comment":review_comment, "sympathy":[""], "time":time]){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    self.getAllComment()
                }
            }
            self.textField.text = ""
            alert.dismiss(animated: true, completion: nil)
        }
        
        let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        alert.addAction(no)

        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            if (indexPath.section == 0){
                if(comment_best[indexPath.row].uid == uid){
                    let alert = UIAlertController(title: "댓글 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                    
                    let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                        self.ref.child("review").child(self.selectedPlace!).child(self.uid).setValue(nil){
                            (error:Error?, ref:DatabaseReference) in
                            if let error = error {
                                print("Data could not be saved: \(error).")
                            } else {
                                self.getAllComment()
                            }
                        }
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    alert.addAction(ok)
                    alert.addAction(no)
                    present(alert, animated: true, completion: nil)
                    
                }
                else{
                    let alert = UIAlertController(title: "삭제 불가", message: "다른 사람의 댓글은 지울 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    alert.addAction(ok)
                    present(alert, animated: true, completion: nil)            }
                
            }
            else if(comment_normal[indexPath.row].uid == uid)
            {
                let alert = UIAlertController(title: "댓글 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    self.ref.child("review").child(self.selectedPlace!).child(self.uid).setValue(nil){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            self.getAllComment()
                        }
                    }
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(ok)
                alert.addAction(no)
                present(alert, animated: true, completion: nil)
                
            }
            else{
                let alert = UIAlertController(title: "삭제 불가", message: "다른 사람의 댓글은 지울 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func convertTimeStamp(timestamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970:timestamp)
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = formatter.string(from: date as Date)
        
        return dateString
    }
    
    func convertDic(_ uid : String,_ dic : [String:Any]) -> CommentFormat? {
        
        guard let comment = dic["comment"] as? String
            else {
                return nil
        }
        guard var sympathy = dic["sympathy"] as? [String]
            else{
                return nil
        }
        sympathy.remove(at: 0)
        guard let time = dic["time"] as? Double
            else{
                return nil
        }
        let convertedTime = convertTimeStamp(timestamp: time)
        
        let formatter = CommentFormat(comment: comment, sympathy: sympathy, time: convertedTime, uid: uid)
        return formatter
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

extension PlaceCommentViewController : CommentViewDelegate {
    
    func upSympathy(uid: String, sym_list : [String]) {
        var index = 0;
        for item in sym_list{
            if(item == self.uid){
                
                let alert = UIAlertController(title: "이미 공감한 댓글입니다", message: "공감을 취소하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    
                    self.ref.child("review").child(self.selectedPlace!).child(self.uid).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                        if var post = currentData.value as? [String : AnyObject]{
                            
                            var sympathy = post["sympathy"] as! [String]
                            
                            sympathy.remove(at: index)
                            
                            post["sympathy"] = sympathy as AnyObject?
                            
                            // Set value and report transaction success
                            currentData.value = post
                            
                            return TransactionResult.success(withValue: currentData)
                        }
                        return TransactionResult.success(withValue: currentData)
                    }) { (error, committed, snapshot) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if committed {
                            self.getAllComment()
                        }
                    }
                    
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(ok)
                alert.addAction(no)
                present(alert, animated: true, completion: nil)
                return
                }
            index = index + 1;
        }
        let alert = UIAlertController(title: "공감 하기", message: "공감하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.ref.child("review").child(self.selectedPlace!).child(self.uid).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                if var post = currentData.value as? [String : AnyObject]{
                    
                    var sympathy = post["sympathy"] as! [String]
                    
                    
                    
                    sympathy.append(self.uid)
                    
                    
                    post["sympathy"] = sympathy as AnyObject?
                    
                    // Set value and report transaction success
                    currentData.value = post
                    
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }) { (error, committed, snapshot) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if committed {
                    self.getAllComment()
                }
            }
            alert.dismiss(animated: true, completion: nil)
        }
        let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        alert.addAction(no)

        
        present(alert, animated: true, completion: nil)
       
    }
    
}
