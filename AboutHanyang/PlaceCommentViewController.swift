
import UIKit
import Firebase

struct CommentFormat{
    var comment : String
    var sympathy : Int
    var time : String
    var uid : String
}


class CommentViewCell : UITableViewCell {
    
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var sympathy: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    var ref: DatabaseReference!
    
    var selectedPlace : String? = ""
    
    var c_uid : String = ""
    
    @IBAction func SympathyComment(_ sender: Any) {
       print("1")
        ref.child("review").child(selectedPlace!).child(c_uid).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            print("2")
            if var post = currentData.value as? [String : AnyObject]
            {
                print("3")
                if var count = post["sympathy"] as! Int?
            {
            count = count + 1
            post["sympathy"] = count as AnyObject?
            
            // Set value and report transaction success
            currentData.value = post
                }
            }
            print("4")
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
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
        if(section == 0){
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
        
        if(indexPath.section==0)
        {
            if(comment_best.count > count){
                dic = comment_best[count]
            }
            else{
                return (cell as UITableViewCell)
            }
        }
        else{
            dic = comment_normal[count]
        }
        
        cell.userComment.text = dic.comment
        
        cell.dateTime.text = dic.time
        
        cell.sympathy.text = "\(dic.sympathy)"
        
        cell.ref = self.ref
        
        cell.selectedPlace = self.selectedPlace
        
        return (cell as UITableViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let getkey = defaults.string(forKey: "user_uid") {
            uid = getkey
        }
        getBestComments()
        getAllComment()
    }
    
    func getAllComment(){
        comment_normal.removeAll();
        ref.child("review").child(selectedPlace!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dic = snapshot.value as? [String:[String:Any]]
                else {
                    return
            }
            
            let dic_keys = Array(dic.keys)
            
            for index in 0..<dic_keys.count{
                guard let formatter = self.convertDic(dic_keys[index], dic[dic_keys[index]]!)
                    else {
                        continue
                }
                
                self.comment_normal.append(formatter)
            }
            self.comment_normal.sort{
                (a:CommentFormat, b:CommentFormat) -> Bool in return a.time > b.time
            }
            
            self.tableView.reloadData()
        })
    }
    
    func getBestComments() {
        
        comment_best.removeAll();
        
        let bestCommentQuery = (ref.child("review").child(selectedPlace!).queryOrdered(byChild: "sympathy").queryLimited(toLast: 2))
        bestCommentQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let dic = snapshot.value as? [String:[String:Any]]
                else{
                    return
            }
            
            let dic_keys = Array(dic.keys)
            
            for index in 0..<dic_keys.count{
                guard let formatter = self.convertDic(dic_keys[index], dic[dic_keys[index]]!)
                    else {
                        print("skip index : \(index)")
                        continue
                }
                self.comment_best.append(formatter)
                self.tableView.reloadData()
            }
        }) { (error) in
            print("some error")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "코멘트"
        self.navigationItem.backBarButtonItem?.title = self.selectedPlace
        
        self.selectedPlace = "Cafe Queue"
        
        ref = Database.database().reference()
        
        self.tableView.estimatedRowHeight = 250
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendComment(_ sender: Any) {
        let review_comment = textField.text ?? ""
        let time = Double(NSDate().timeIntervalSince1970)
        
        
        self.ref.child("review").child(self.selectedPlace!).child(uid).setValue(["comment":review_comment, "sympathy":0, "time":time])
        
        getBestComments()
        getAllComment()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            if (indexPath.section == 0){
                return
            }
            if(comment_normal[indexPath.row].uid == uid)
            {
                self.ref.child("review").child(self.selectedPlace!).child(uid).setValue(nil)
                getBestComments()
                getAllComment()
            }
            else{
                //show modal view
            }
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
    
    
    func convertTimeStamp(timestamp : Double) -> String{
        
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
        guard let sympathy = dic["sympathy"] as? Int
            else{
                return nil
        }
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
