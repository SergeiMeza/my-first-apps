
import Foundation

class FeaturedApps: NSObject {
   
   var bannerCategory: AppCategory?
   var appCategories: [AppCategory]?
   
   override func setValue(_ value: Any?, forKey key: String) {
      if key == "categories" {
         appCategories = [AppCategory]()
         
         for dict in value as! [[String: AnyObject]] {
            let appCategory = AppCategory()
            appCategory.setValuesForKeys(dict)
            appCategories?.append(appCategory)
         }
      } else if key == "bannerCategory" {
         bannerCategory = AppCategory()
         bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
      } else {
         super.setValue(value, forKey: key)
      }
   }
}


class AppCategory: NSObject {
   
   var name: String?
   var apps: [App]?
   var type: String?
   
   override func setValue(_ value: Any?, forKey key: String) {
      
      if key == "apps" {
         apps = [App]()
         for dict in value as! [[String: AnyObject]] {
            let app = App()
            app.setValuesForKeys(dict)
            apps?.append(app)
         }
      } else {
         super.setValue(value, forKey: key)
      }
   }
   
   static func fetchFeatureApps(_ completion: @escaping (FeaturedApps) -> ()) {

      let urlString = "http://www.statsallday.com/appstore/featured"
      
      URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
         if error != nil {
            print(error!)
            return
         }
         
         do {
            let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
            
            print(json)
            
            let featuredApps = FeaturedApps()
            featuredApps.setValuesForKeys(json as! [String:AnyObject])
            
            DispatchQueue.main.async {
               completion(featuredApps)
            }
         } catch let error {
            print(error)
         }
      }.resume()
   }
   
   static func sampleAppCategories() -> [AppCategory] {
      
      let bestNewAppsCategory = AppCategory()
      bestNewAppsCategory.name = "Best New Apps"
      
      var apps = [App]()
      
      // logic
      let frozenApp = App()
      frozenApp.name = "Disney Build It: Frozen"
      frozenApp.imageName = "Frozen"
      frozenApp.category = "Entertainment"
      frozenApp.price = NSNumber(value: 3.99 as Float)
      apps.append(frozenApp)
      
      bestNewAppsCategory.apps = apps
      
      
      let bestNewGamesCategory = AppCategory()
      bestNewGamesCategory.name = "Best New Games"
      
      var bestNewGamesApps = [App]()
      
      let telepaintApp = App()
      telepaintApp.name = "Telepaint"
      telepaintApp.category = "Games"
      telepaintApp.imageName = "telepaint"
      telepaintApp.price = NSNumber(value: 2.99 as Float)
      
      bestNewGamesApps.append(telepaintApp)
      
      bestNewGamesCategory.apps = bestNewGamesApps
      
      return [bestNewAppsCategory, bestNewGamesCategory]
   }
}

class App: NSObject {
   
   var id: NSNumber?
   var name: String?
   var category: String?
   var imageName: String?
   var price: NSNumber?
   
   var screenshots: [String]?
   var desc: String?
   var appInformation: AnyObject?
   
   override func setValue(_ value: Any?, forKey key: String) {
      if key == "description" {
         self.desc = value as? String
      } else {
         super.setValue(value, forKey: key)
      }
   }
}
