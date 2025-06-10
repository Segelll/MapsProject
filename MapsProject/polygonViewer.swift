import Foundation
import MapKit

class polygonViewer: ObservableObject{
    @Published var polycoordinates : [CLLocationCoordinate2D] = [ ]
    func deletelast(){
        if polycoordinates.count > 0 {
            polycoordinates.removeLast()
        }
    }

    func createpoly(coordinate1:CLLocationCoordinate2D){
        polycoordinates.append(coordinate1)


    }
                            func clearpoly(){
                                self.polycoordinates = []
                            }


}
