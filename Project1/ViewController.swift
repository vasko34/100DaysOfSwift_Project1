import UIKit

class ViewController: UITableViewController {
    var pictures: [String] = [String]()
    var viewCountDictionary = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedDict = defaults.object(forKey: "viewCountDict") as? Data{
            let jsonDecoder = JSONDecoder()
            do {
                viewCountDictionary = try jsonDecoder.decode([Int: Int].self, from: savedDict)
            } catch {
                print("Failed to load.")
            }
        }
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        performSelector(inBackground: #selector(loadData), with: nil)
    }
    
    func sortPictures() {
        self.pictures.sort()
    }
    
    @objc func loadData() {
        let fm = FileManager.default // fm allows me to use the file system
        let path = Bundle.main.resourcePath! // the path for all files from this project
        let items = try! fm.contentsOfDirectory(atPath: path) // all files from this project
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        sortPictures()
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.imageCount = pictures.count
            vc.imagePosition = indexPath.row + 1
            vc.selectedImage = pictures[indexPath.row]
            viewCountDictionary[indexPath.row + 1]! += 1
            saveViewCount()
            vc.views = viewCountDictionary[indexPath.row + 1] ?? 0
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Check out Storm Viewer"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func saveViewCount() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(viewCountDictionary) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "viewCountDict")
        } else {
            print("Failed to save data.")
        }
    }


}

