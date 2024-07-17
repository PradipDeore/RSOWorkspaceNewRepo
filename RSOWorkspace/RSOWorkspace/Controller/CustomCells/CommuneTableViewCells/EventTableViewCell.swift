//
//  EventTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/03/24.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    weak var delegateButtonRSVP : ButtonRSVPTappedDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    //var data: [EventData] = [] // Assuming EventData is your model
    var eventHandler: ((_ event: Event) -> Void)?
    var eventsArray: [EventsData] = [] // Corrected type

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCollectionViewCell()
        fetchEvents() 
    }
    func fetchEvents() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: EventResponse.self, // Assuming your API returns an array of Services
            type: CommuneEndPoint.events) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.eventsArray = response.data
                    print("count is ",self.eventsArray.count)
                    print("eventsArray ",self.eventsArray)

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
}
extension EventTableViewCell: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        cell.delegateButtonRSVP = self.delegateButtonRSVP
        cell.tag = self.tag
        
        let item = eventsArray[indexPath.item]
        cell.setData(item: item)
        
       // let eventData = data[indexPath.item]
        //cell.configure(with: eventData) // Configure cell with data
        
        return cell
    }
}

extension EventTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set size of collection view cell
        return CGSize(width: collectionView.bounds.width - 50, height: 357) // Adjust dimensions as per your requirement
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

private extension EventTableViewCell {
    func registerCollectionViewCell() {
        let eventCellNib = UINib(nibName: "EventCollectionViewCell", bundle: nil)
        collectionView.register(eventCellNib, forCellWithReuseIdentifier: "EventCollectionViewCell")
    }
}
extension EventTableViewCell {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}


    

