import Foundation

class UserDefaultManager
{
    class func saveTasksToUserDefaults(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "taskArray")
        }
    }

    class func loadTasks() -> [Task] {
        if let savedData = UserDefaults.standard.data(forKey: "taskArray") {
            let decoder = JSONDecoder()
            if let loadedTasks = try? decoder.decode([Task].self, from: savedData) {
                return loadedTasks
            }
        }
        return []
    }
}
