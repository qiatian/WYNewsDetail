//
//  ViewController.swift
//  WYNewsDetail
//
//  Created by sanjingrihua on 17/8/11.
//  Copyright © 2017年 sanjingrihua. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html
        //设置URL
        let url = URL(string:"http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html")
        //设置请求
        let request = URLRequest(url: url!)
        
        //开启异步请求操作
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            判断
            if error == nil {
                //转为json  throws 异常检查
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
//                print(jsonData ?? "")
                
                self.dealNewsDetail(jsonData: jsonData!)
            }
        }
        
        //开启请求
        dataTask.resume()
        
    }
    //处理拿到的数据并显示
    func dealNewsDetail(jsonData : NSDictionary) -> Void {
        //取出所有的内容
        let allData = jsonData["BJ5NRE5T00031H2L"] as! NSDictionary
        print(allData)
        //取出body中的内容
        var bodyHtml = allData["body"] as! String
        
//        取出标题
        let title = allData["title"] as! String
        //取出发布时间
        let pTime = allData["ptime"] as! String
        //q取出来源
        let source = allData["source"] as! String
        //取出所有图片对象
        let img = allData["img"] as! [[String:AnyObject]]
        //遍历所有
        for i in 0..<img.count{
            //取出单独的图片对象
            let imgItem = img[i]
            //取出占位标签
            let ref = imgItem["ref"] as! String
            //取出图片标题
            let imgTitle = imgItem["alt"] as! String
            //取出src
            let src = imgItem["src"] as! String
            let imgHtml = "<div class=\"all_img\"><img src=\"\(src)\"><div>\(imgTitle)</div></div>"
            
            //替换body中的占位符
            bodyHtml = bodyHtml.replacingOccurrences(of: ref, with: imgHtml)
            
        }
        
        
        //创建标题的html标签
        let titleHtml = "<div id=\"mainTitle\">\(title)</div>"
        //创建子标题的html标签
        let subTitleHtml = "<div id=\"subTitle\"><span class=\"time\">\(pTime)</span><span>\(source)</span></div>"
        
        
        //加载css的URL路径
        let css = Bundle.main.url(forResource: "newsDetail", withExtension: "css")
        //创建html标签
        let cssHtml = "<link href=\"\(css!)\" rel = \"stylesheet\">"
        
        //加载js的URL路径
        let js = Bundle.main.url(forResource: "newsDetail", withExtension: "js")
        //创建html标签
        let jsHtml = "<script src =\"\(js!)\"></script>"
        
        
        
        
        //拼接html
        let html = "<html><head>\(cssHtml)</head><body>\(titleHtml)\(subTitleHtml)\(bodyHtml)\(jsHtml)</body></html>"
        
        
        //把对应的内容显示到webView中
        webView.loadHTMLString(html, baseURL: nil)
        
        
    }
    func openCamera() -> Void {
        let photoVC = UIImagePickerController()
        photoVC.sourceType = .photoLibrary
        
        //模态
        self.present(photoVC, animated: true, completion: nil)
        
    }
    //MARK:- uitableviewdelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //决定是否能加载网络请求
        //取出请求字符串
        let requestStr:NSString = (request.url?.absoluteString)! as NSString
        //判断处理
        let urlHeader = "llq://"
        let range = requestStr.range(of: urlHeader)
        let location = range.location
        if location != NSNotFound{//包含了协议头
//            取出要操作的方法名称
            let mehtod = requestStr.substring(from: range.length)
            //包装成sel
            let sel = NSSelectorFromString(mehtod)
            //执行
            self.perform(sel)
            
            
        }
        return true;
    }
    
}

