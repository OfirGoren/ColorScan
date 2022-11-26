

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var liveCameraUIView: LiveCameraUIView!
    private var mostDominantColorsList = [DominantColor]()
    
    
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
            self.mostDominantColorsList = fiveMostDominantColor
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
            }
        }
        
    }
    
}

//MARK: Setup live Stream
extension MainViewController {
    
    func configureLiveStreamCamera() {
        
        liveCameraUIView.videoPreviewLayer.session = LiveStreamCamera.shared.captureSesstion
        liveCameraUIView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        DispatchQueue.global(qos: .userInitiated).async {
            LiveStreamCamera.shared.captureSesstion.startRunning()
        }
        
    }
    
    func rotateLiveStreamAccordingOrientation() {
        if UIDevice.current.orientation.isLandscape {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
                liveCameraUIView.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
            }
            else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
                liveCameraUIView.videoPreviewLayer.connection?.videoOrientation = .landscapeLeft
                
            }
        } else if UIDevice.current.orientation.isPortrait {
            liveCameraUIView.videoPreviewLayer.connection?.videoOrientation = .portrait
            
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
        return mostDominantColorsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DominantColorCell.identifierCell, for: indexPath) as? DominantColorCell else {return UITableViewCell()}
        
        let popularColor = mostDominantColorsList[indexPath.row]
        cell.setupData(color: popularColor)
        
        return cell
        
    }
    
}







