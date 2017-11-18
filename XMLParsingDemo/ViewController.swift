
import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tbData : UITableView?
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.beginParsing()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(NSURL(string:"http://images.apple.com/main/rss/hotnews/hotnews.rss"))! as URL)!
        parser.delegate = self
        parser.parse()
        
        tbData!.reloadData()
    }
    
    //XMLParser Methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title" as NSCopying)
            }
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "date" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "title") {
            title1.append(string)
        } else if element.isEqual(to: "pubDate") {
            date.append(string)
        }
    }
    
    //Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        if(cell.isEqual(NSNull.self)) {
            cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)![0] as! UITableViewCell;
        }
        let dict = posts.object(at: indexPath.row) as? NSDictionary
        
        cell.textLabel?.text = dict?.value(forKey: "title") as? String
        cell.self.detailTextLabel?.text = dict?.value(forKey: "date") as? String
        return cell as UITableViewCell
    }
}
