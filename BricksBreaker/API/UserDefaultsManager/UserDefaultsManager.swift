import SwiftUI

enum Keys: String {
    case shopItems = "shopItems"
    case currentLevel = "currentLevel"
    case backgroundVolume = "backgroundVolume"
    case soundEffectVolume = "soundEffectVolume"
}

class UserDefaultsManager: ObservableObject {
    static let defaults = UserDefaults.standard
    
    @Published var arrayOfBalls: [BallModel] = [
        BallModel(name: "Pink", image: BrickImageName.ball1.rawValue, isAvailible: false, isSelected: true, text: "Selected"),
        BallModel(name: "Violet", image: BrickImageName.ball2.rawValue, isAvailible: true, isSelected: false, text: "Available"),
        BallModel(name: "Azure", image: BrickImageName.ball3.rawValue, isAvailible: false, isSelected: false, text: "level 8"),
        BallModel(name: "Purple", image: BrickImageName.ball4.rawValue, isAvailible: false, isSelected: false, text: "level 16"),
        BallModel(name: "Fuchsia", image: BrickImageName.ball5.rawValue, isAvailible: false, isSelected: false, text: "level 24"),
        BallModel(name: "Ice", image: BrickImageName.ball6.rawValue, isAvailible: false, isSelected: false, text: "level 36")
    ]
    
    init() {
        if let savedBalls = loadBalls() {
            self.arrayOfBalls = savedBalls
        }
        updateBallAvailability()
    }
    
    func firstLaunch() {
        if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) == nil {
            UserDefaultsManager.defaults.set(1,  forKey: Keys.currentLevel.rawValue)
            UserDefaultsManager.defaults.set(0.5, forKey: Keys.backgroundVolume.rawValue)
            UserDefaultsManager.defaults.set(0.5, forKey: Keys.soundEffectVolume.rawValue)
        }
    }
    
    func loadBalls() -> [BallModel]? {
        if let savedItemsData = UserDefaultsManager.defaults.data(forKey: Keys.shopItems.rawValue) {
            let decoder = JSONDecoder()
            if let loadedBalls = try? decoder.decode([BallModel].self, from: savedItemsData) {
                return loadedBalls
            }
        }
        return nil
    }
    
    func saveBalls() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(arrayOfBalls) {
            UserDefaultsManager.defaults.set(encoded, forKey: Keys.shopItems.rawValue)
        }
    }
    
    func updateBallAvailability() {
        for index in arrayOfBalls.indices {
            switch arrayOfBalls[index].text {
            case "level 8":
                arrayOfBalls[index].isAvailible = UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1 >= 8
            case "level 16":
                arrayOfBalls[index].isAvailible = UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1 >= 16
            case "level 24":
                arrayOfBalls[index].isAvailible = UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1 >= 24
            case "level 36":
                arrayOfBalls[index].isAvailible = UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1 >= 36
            default:
                break
            }
        }
        saveBalls()
    }
    
    func selectBall(at index: Int) {
        guard index >= 0 && index < arrayOfBalls.count else { return }
        
        if arrayOfBalls[index].isAvailible {
            for i in 0..<arrayOfBalls.count {
                if arrayOfBalls[i].isSelected {
                    arrayOfBalls[i].isSelected = false
                    arrayOfBalls[i].isAvailible = true
                }
            }
            
            arrayOfBalls[index].isSelected = true
            arrayOfBalls[index].isAvailible = false
            saveBalls()
        }
    }
    
    func increaseLevel() {
        let currentLevel = UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1
        UserDefaultsManager.defaults.set(currentLevel + 1, forKey: Keys.currentLevel.rawValue)
        updateBallAvailability()
    }
    
    func getSelectedBall() -> BallModel? {
        return arrayOfBalls.first { $0.isSelected }
    }
    
    func saveVolumeSettings(backgroundVolume: Float, soundEffectVolume: Float) {
        UserDefaultsManager.defaults.set(backgroundVolume, forKey: Keys.backgroundVolume.rawValue)
        UserDefaultsManager.defaults.set(soundEffectVolume, forKey: Keys.soundEffectVolume.rawValue)
    }
    
    func loadVolumeSettings() -> (Float, Float) {
        var backgroundVolume = UserDefaultsManager.defaults.float(forKey: Keys.backgroundVolume.rawValue)
        var soundEffectVolume = UserDefaultsManager.defaults.float(forKey: Keys.soundEffectVolume.rawValue)
        if backgroundVolume == 0.0 && soundEffectVolume == 0.0 {
            backgroundVolume = 0.5
            soundEffectVolume = 0.5
        }
        return (backgroundVolume, soundEffectVolume)
    }
}
