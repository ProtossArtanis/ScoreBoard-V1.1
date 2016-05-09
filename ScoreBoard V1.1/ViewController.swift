//
//  ViewController.swift
//  ScoreBoard V1.1
//
//  Created by SteinsGate on 16/5/8.
//  Copyright © 2016年 SteinsGate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var db:SQLiteDB!
    
    @IBOutlet weak var la1: UILabel!
    @IBOutlet weak var la2: UILabel!
    var Ascore = 0
    var Bscore = 0
    var Ascore_2 = 0
    var Bscore_2 = 0
    var Aname = ""
    var Bname = ""
    var time:NSTimer!
    @IBOutlet weak var AContestantName: UITextField!
    @IBOutlet weak var BContestantName: UITextField!
    
    @IBOutlet weak var AOutResult_2: UITextField!
    @IBOutlet weak var AOutResult: UITextField!
    
    @IBOutlet weak var BOutResult_2: UITextField!
    @IBOutlet weak var BOutResult: UITextField!
    
    var x=15
    var y=1
    func dec()
    {
        
        y-=1
        while y==0
        {
            x=x-1
            y=60
        }
        print(x)
        print(y)
        la1.text=String(x)
        la2.text=String(y)
    }
    @IBAction func start(sender: UIButton) {
        time=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("dec"), userInfo: nil, repeats: true)
    }
    @IBAction func AscoreAdd(sender: AnyObject) {
        Ascore = Ascore + 1
        AOutResult.text = ("\(Ascore)")
        if (Ascore == 11){
            Ascore_2 = Ascore_2 + 1
            AOutResult_2.text = ("\(Ascore_2)")
            Ascore = 0
            AOutResult.text = ("\(Ascore)")
            Bscore = 0
            BOutResult.text = ("\(Bscore)")
        }
        else{
            
        }
        saveScore()
    }
    
    @IBAction func BscoreAdd(sender: AnyObject) {
        Bscore = Bscore + 1
        BOutResult.text = ("\(Bscore)")
        if(Bscore == 11){
            Bscore_2 = Bscore_2 + 1
            BOutResult_2.text = ("\(Bscore_2)")
            Bscore = 0
            BOutResult.text = ("\(Bscore)")
            Ascore = 0
            AOutResult.text = ("\(Ascore)")
            
        }
        else{
        
        }
        saveScore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取数据库实例
        db = SQLiteDB.sharedInstance()
        //如果表还不存在则创建表
        db.execute("create table if not exists p_contestant(uid integer primary key,acontestantname varchar(20),ascore varchar(10), ascore_2 vachar(10))")
         db.execute("create table if not exists p_contestant02(uid integer primary key,bcontestantname varchar(20),bscore varchar(10), bscore_2 vachar(10))")
        //如果有数据则加载
        initUser()
    }
    
    //从SQLite加载数据
    func initUser() {
        let data = db.query("select * from p_contestant")
        let data_2 = db.query("select * from p_contestant02")
        if data.count > 0 {
            //获取最后一行数据显示
            let acontestant = data[data.count - 1]
            AContestantName.text = acontestant["acontestname"] as? String
            AOutResult.text = acontestant["ascore"] as? String
            AOutResult_2.text = acontestant["ascore_2"] as? String
           
            
        }
        if data_2.count > 0 {
            //获取最后一行数据显示
            let bcontestant = data_2[data_2.count - 1]
            BContestantName.text = bcontestant["bcontestname"] as? String
            BOutResult.text = bcontestant["bscore"] as? String
            BOutResult_2.text = bcontestant["bscore_2"] as? String
            
        }
    }
    
    //保存数据到SQLite
    func saveScore() {
        let Aname = self.AContestantName.text!
        let Bname = self.BContestantName.text!
        let Ascore = self.AOutResult.text!
        let Ascore_2 = self.AOutResult_2.text!
        let Bscore = self.BOutResult.text!
        let Bscore_2 = self.BOutResult_2.text!
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into p_contestant(acontestantname,ascore,ascore_2) values('\(Aname)','\(Ascore)','\(Ascore_2)')"
        let sql_2 = "insert into p_contestant02(bcontestantname,bscore,bscore_2) values('\(Bname)','\(Bscore)','\(Bscore_2)')"
        print("sql: \(sql)")
        print("sql:\(sql_2)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        print(result)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }}

