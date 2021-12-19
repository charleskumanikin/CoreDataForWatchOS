//
//  ContentView.swift
//  CoreDataForWatchOS WatchKit Extension
//
//  Created by Adrian Kumanikin on 19.12.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
   var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    
    var body: some View {
        FoodList().environment (\.managedObjectContext, managedObjectContext)
    }
}


struct FoodList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Food.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var foodList: FetchedResults<Food>
    
    var body: some View {
        ScrollView {
            ForEach(foodList, id: \.self)  { food in
                NavigationLink(destination: EditFood(food : food)) {
                Text ("\(food.name)")
            }
        }
            Button(action: {
                let food = Food(context: managedObjectContext)
                food.name = "New food"
                do {
                    try managedObjectContext.save()
                    
                } catch {
                    print (error)
                }
            }) {
                
                
                
                Text("Add Food")
            }
            
            
            foregroundColor(Color.green)
            
        }
        
    }
}



struct EditFood: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presantationMode
    
    @State var name: String = ""
    var food: Food
    
    var body: some View {
        VStack {
            TextField("Food Name", text: $name).onAppear  {
                self.name = self.food.name
            }
            Button(action: {
                self.food.name = self.name
                self.food.objectWillChange.send()
                
                
                do {
                    try managedObjectContext.save()
                    
                } catch {
                    print(error)
                }
                
                presantationMode.wrappedValue.dismiss()
            } ) {
                
                Text("Save")
                
                
            }.foregroundColor(Color.green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
