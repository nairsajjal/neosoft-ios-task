//
//  ContentView.swift
//  neosoft-ios-task
//
//  Created by JustMac on 26/07/24.
//

import SwiftUI

struct CarouselView: View {
    @Binding var currentIndex: Int
    private let images = ["lonavala", "pune", "mumbai", "dehradun", "shimla"]

    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200) // Adjust the height as needed

            HStack(spacing: 8) {
                ForEach(0..<images.count) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 8)
        }
    }
}

struct ListItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
}

struct ListView: View {
    var items: [ListItem]

    var body: some View {
        List(items) { item in
            HStack {
                Image(item.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.pink.opacity(0.2))
            .cornerRadius(10)
        }
        .listStyle(PlainListStyle())
    }
}

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top, 10)
    }
}

struct FloatingActionButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .padding()
    }
}

struct BottomSheetView: View {
    let characterCounts: [Character: Int]

    var body: some View {
        VStack {
            Text("Character Frequencies")
                .font(.headline)
                .padding()
            Divider()
            List {
                ForEach(characterCounts.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                        Spacer()
                        Text("\(value)")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .frame(maxHeight: .infinity)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var currentIndex = 0
    @State private var items: [ListItem] = []
    @State private var showBottomSheet = false
    @State private var characterCounts: [Character: Int] = [:]

    var body: some View {
        ZStack {
            VStack {
                CarouselView(currentIndex: $currentIndex)
                SearchBarView(searchText: $searchText)
                ListView(items: filteredItems)
                Spacer()
            }
            .padding()
            .onChange(of: currentIndex) { newIndex in
                loadData(for: newIndex)
            }
            .onAppear {
                loadData(for: currentIndex)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton(action: showStatistics)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView(characterCounts: calculateCharacterFrequencies())
        }
    }
    
    private var filteredItems: [ListItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) || item.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func loadData(for index: Int) {
        let numberOfItems = 20 // Define how many items you want in the list
        let sampleData = (1...numberOfItems).map { i in
            ListItem(
                image: "lonavala",
                title: "Title \(index + i)",
                subtitle: "Subtitle \(index + i)"
            )
        }
        items = sampleData
    }

    private func showStatistics() {
        characterCounts = calculateCharacterFrequencies()
        showBottomSheet = true
    }

    private func calculateCharacterFrequencies() -> [Character: Int] {
        var counts: [Character: Int] = [:]
        for item in items {
            let combinedText = item.title + item.subtitle
            for char in combinedText {
                counts[char, default: 0] += 1
            }
        }
        return counts
    }
}

#Preview {
    ContentView()
}
