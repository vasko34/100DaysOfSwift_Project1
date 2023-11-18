import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    let titleLabel = UILabel()
    var selectedImage: String?
    var imagePosition: Int?
    var imageCount: Int?
    var views = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(selectedImage != nil, "The image is nil.")
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        if let imagePosition = self.imagePosition {
            if let imageCount = self.imageCount {
                titleLabel.text = "Picture \(imagePosition) of \(imageCount)\n\(views) views"
                navigationItem.titleView = titleLabel
            }
        }
        
        navigationItem.largeTitleDisplayMode = .never // affects the NavBar just for this screen(NavItem)
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
