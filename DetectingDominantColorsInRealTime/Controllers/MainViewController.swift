

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var liveStreamCameraUIView: LiveStreamCameraUIView!
    private var mostPopularColors = [DominantColor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLiveStreamCamera()
        setupTableViewCell()
        setupDelegates()
        reloadFiveMostDominantColorsFromCameraToTableView()
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        rotateLiveStreamAccordingOrientation()
    }
    
    
    
    func reloadFiveMostDominantColorsFromCameraToTableView() {
        LiveStreamCamera.shared.getMostFiveDominantColorsInImage { [weak self] fiveMostDominantColor in
            guard let self = self else {return }
            self.mostPopularColors = fiveMostDominantColor
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
            }
        }
        
    }

}

//MARK: Setup live Stream
extension MainViewController {
    
    func configureLiveStreamCamera() {
        
        liveStreamCameraUIView.videoPreviewLayer.session = LiveStreamCamera.shared.captureSesstion
        liveStreamCameraUIView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        DispatchQueue.global(qos: .userInitiated).async {
            LiveStreamCamera.shared.captureSesstion.startRunning()
        }
        
    }
    
    func rotateLiveStreamAccordingOrientation() {
        if UIDevice.current.orientation.isLandscape {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
                liveStreamCameraUIView.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
            }
            else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
                liveStreamCameraUIView.videoPreviewLayer.connection?.videoOrientation = .landscapeLeft
                
            }
        } else if UIDevice.current.orientation.isPortrait {
            liveStreamCameraUIView.videoPreviewLayer.connection?.videoOrientation = .portrait
            
        } else if UIDevice.current.orientation.isValidInterfaceOrientation {
            
        }
    }
    
    
}

//MARK: Setup tableView
extension MainViewController {
    
    func setupTableViewCell() {
        tableView.register(DominantColorCell.getNibCell(), forCellReuseIdentifier: DominantColorCell.identifierCell)
        tableView.rowHeight = DominantColorCell.heightCell
        
    }
    func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}



//MARK: TableView delegate methods
extension MainViewController:UITableViewDelegate {
    
    
}

//MARK: TableView DataSource delegate methods
extension MainViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostPopularColors.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DominantColorCell.identifierCell, for: indexPath) as? DominantColorCell else {return UITableViewCell()}
        
        let popularColor = mostPopularColors[indexPath.row]
        cell.setupData(color: popularColor)
        
        
        return cell
        
    }
    
}






