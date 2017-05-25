//
//  SPAServicesViewController.swift
//  Reservations
//
//  Created by Chen Shi on 2/21/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

class SPAServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{

    @IBOutlet weak var tableViewSpaServices: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var btnReserve: UIButton!
    var scheduleDelegate: sendScheduleBackDelegate?
    
    let arraySpaService: NSArray = ["Swedish Massage","Deep Tissue Massage", "Hot Stone Massage", "Reflexology", "Trigger Point Therapy"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cellSpaServices"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableViewSpaServices.layer.cornerRadius = 8.0
        tableViewSpaServices.layer.borderWidth = 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.initialSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Methods
    
    func initialSetUp(){
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        btnReserve.layer.cornerRadius = 4.0
        btnReserve.layer.borderWidth = 0.1
        
        let imageMothersDay = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imageMothersDay.image = UIImage(named: "pasted-image")
        let imageHotStone = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imageHotStone.image = UIImage(named: "pasted-image1")
        let imageDeepTissue = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imageDeepTissue.image = UIImage(named: "pasted-image-2")
        
        self.scrollView.addSubview(imageMothersDay)
        self.scrollView.addSubview(imageHotStone)
        self.scrollView.addSubview(imageDeepTissue)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 3, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
    }
    
    //MARK: Button method
    @IBAction func reserverAction(_ sender: AnyObject){
        if pageControl.currentPage == 1{
            performSegue(withIdentifier: "ScheduleSegueIdentifier", sender: nil)
        }
    }
    
    //MARK: Tableview Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySpaService.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let spaServicesCell = tableViewSpaServices.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        spaServicesCell.textLabel?.text = arraySpaService[indexPath.row] as? String
        return spaServicesCell
    }
    
    //MARK: Tableview Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            performSegue(withIdentifier: "ScheduleSegueIdentifier", sender: nil)
        }
        tableViewSpaServices .deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: UIScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
    }

    //MARK: Storyboard methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "ScheduleSegueIdentifier" == segue.identifier {
            let vc = segue.destination as! ScheduleViewController
            vc.scheduleDelegate = self.scheduleDelegate
        }
    }

}
