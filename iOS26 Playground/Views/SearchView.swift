import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "all"
    @State private var showingFilters = false
    
    let categories = ["all", "apps", "games", "tools", "design"]
    let searchResults = [
        SearchResult(title: "Navigation Stack", category: "tools", description: "Advanced navigation patterns", icon: "arrow.right.square"),
        SearchResult(title: "Glass Effects", category: "design", description: "Liquid Glass materials", icon: "square.3.layers.3d"),
        SearchResult(title: "SwiftUI Games", category: "games", description: "Game development toolkit", icon: "gamecontroller"),
        SearchResult(title: "Productivity Apps", category: "apps", description: "Build better apps", icon: "app.badge"),
        SearchResult(title: "Design System", category: "design", description: "iOS 26 design language", icon: "paintbrush"),
        SearchResult(title: "Developer Tools", category: "tools", description: "Xcode 26 features", icon: "hammer"),
    ]
    
    var filteredResults: [SearchResult] {
        searchResults.filter { result in
            (selectedCategory == "all" || result.category == selectedCategory) &&
            (searchText.isEmpty || result.title.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    searchHeader
                    
                    categoryPicker
                    
                    if filteredResults.isEmpty {
                        emptyState
                    } else {
                        resultsSection
                    }
                }
                .padding()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search iOS 26 features")
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showingFilters) {
                FiltersView()
            }
        }
    }
    
    var searchHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Discover")
                        .font(.largeTitle.bold())
                    Text("iOS 26 Features & Tools")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    showingFilters = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
    var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category.capitalized,
                        isSelected: selectedCategory == category,
                        action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
        }
    }
    
    var resultsSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(filteredResults) { result in
                SearchResultCard(result: result)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
        }
    }
    
    var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No results found")
                .font(.title2.bold())
            
            Text("Try adjusting your search or filters")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let description: String
    let icon: String
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AnyShapeStyle(.blue.gradient) : AnyShapeStyle(.ultraThinMaterial),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.clear : Color(.quaternaryLabel), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: result.icon)
                .font(.title2)
                .foregroundStyle(.blue.gradient)
                .frame(width: 50, height: 50)
                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.headline)
                
                Text(result.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(result.category.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.secondary.opacity(0.1), in: Capsule())
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color(.quaternaryLabel), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.98 : 1)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sortBy = "relevance"
    @State private var showRecent = true
    @State private var showPopular = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Sort By") {
                    Picker("Sort", selection: $sortBy) {
                        Text("Relevance").tag("relevance")
                        Text("Name").tag("name")
                        Text("Date").tag("date")
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Filters") {
                    Toggle("Show Recent", isOn: $showRecent)
                    Toggle("Show Popular", isOn: $showPopular)
                }
                
                Section {
                    Button("Reset Filters") {
                        sortBy = "relevance"
                        showRecent = true
                        showPopular = true
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Search Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}