//
//  ContentView.swift
//  CombineNetworking
//
//  Created by Giovanni Gaffé on 2022/2/21.
//

import Combine
import SwiftUI

struct User: Decodable {
    var id: UUID
    var name: String
    
    static let `default` = User(id: UUID(), name: "Anonymous")
}

struct ContentView: View {
    @State private var requests = Set<AnyCancellable>()
    
    var body: some View {
        Button {
            let url = URL(string: "https://www.hackingwithswift.com/samples/user-24601.json")!
            fetch(url, defaultValue: User.default) {
                print($0.name)
            }
        } label: {
            Text("Fetch data")
        }
    }
    
    func fetch<T: Decodable>(_ url: URL, defaultValue: T, completion: @escaping (T) -> Void) {
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: completion)
            .store(in: &requests)
    }
    
    
    
//    func fetch(_ url: URL) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print(User.default.name)
//            } else if let data = data {
//                print(data)
//                let decoder = JSONDecoder()
//
//                do {
//                    let user = try decoder.decode(User.self, from: data)
//                    print(user.name)
//                } catch {
//                    print(User.default.name)
//                }
//            }
//        }.resume()
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
