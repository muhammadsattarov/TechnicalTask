

import UIKit
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  private init() {}

  private var appDelegate: AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
  }

  private var context: NSManagedObjectContext {
    appDelegate.persistentContainer.viewContext
  }

  // 📌 Todos ni saqlash
  func saveTodos(_ todos: [Todo]) {
    print(#function)
    clearEntity("TodoListModel") // Eski ma'lumotlarni o‘chirish
    for todo in todos {
      let entity = TodoListModel(context: context)
      entity.id = Int64(todo.id)
      entity.title = todo.title
      entity.completed = todo.completed
      entity.userId = Int64(todo.userId)
    }
    saveContext()
  }

  // 📌 Todos ni olish
  func fetchTodos() -> [Todo] {
    print(#function)
    let request: NSFetchRequest<TodoListModel> = TodoListModel.fetchRequest()
    do {
      let results = try context.fetch(request)
      return results.map { Todo(userId: Int($0.userId), id: Int($0.id), title: $0.title ?? "", completed: $0.completed)}
    } catch {
      print("❌ Todos olishda xatolik: \(error)")
      return []
    }
  }

  // 📌 Users ni saqlash
  func saveUsers(_ users: [User]) {
    print(#function)
    clearEntity("UserModel")
    for user in users {
      let entity = UserModel(context: context)
      entity.id = Int64(user.id)
      entity.name = user.name
      entity.email = user.email
      entity.username = user.username
      entity.phone = user.phone
      entity.website = user.website

      let addressModel = AddressModel(context: context)
      addressModel.street = user.address.street
      addressModel.suite = user.address.suite
      addressModel.city = user.address.city
      addressModel.zipcode = user.address.zipcode

      let geoModel = GeoModel(context: context)
      geoModel.lat = user.address.geo.lat
      geoModel.lng = user.address.geo.lng
      addressModel.geo = geoModel

      entity.address = addressModel

      let companyModel = CompanyModel(context: context)
      companyModel.name = user.company.name
      companyModel.catchPhrase = user.company.catchPhrase
      companyModel.bs = user.company.bs

      entity.company = companyModel
    }
    saveContext()
  }

  // 📌 Users ni olish
  func fetchUsers() -> [User] {
    print(#function)
      let request: NSFetchRequest<UserModel> = UserModel.fetchRequest()
      do {
          let results = try context.fetch(request)
          return results.map { userModel in
              User(
                  id: Int(userModel.id),
                  name: userModel.name ?? "",
                  username: userModel.username ?? "",
                  email: userModel.email ?? "",
                  address: Address(
                      street: userModel.address?.street ?? "",
                      suite: userModel.address?.suite ?? "",
                      city: userModel.address?.city ?? "",
                      zipcode: userModel.address?.zipcode ?? "",
                      geo: Geo(
                          lat: userModel.address?.geo?.lat ?? "",
                          lng: userModel.address?.geo?.lng ?? ""
                      )
                  ),
                  phone: userModel.phone ?? "",
                  website: userModel.website ?? "",
                  company: Company(
                      name: userModel.company?.name ?? "",
                      catchPhrase: userModel.company?.catchPhrase ?? "",
                      bs: userModel.company?.bs ?? ""
                  )
              )
          }
      } catch {
          print("❌ Foydalanuvchilarni olishda xatolik: \(error)")
          return []
      }
  }


  // 📌 Ma’lumotlarni o‘chirish
  private func clearEntity(_ entityName: String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
      try context.execute(deleteRequest)
    } catch {
      print("❌ \(entityName) tozalashda xatolik: \(error)")
    }
  }

  // 📌 Ma’lumotlarni saqlash
  private func saveContext() {
    do {
      try context.save()
    } catch {
      print("❌ Ma’lumotlarni saqlashda xatolik: \(error)")
    }
  }
}
