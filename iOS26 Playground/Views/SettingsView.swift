import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var useFaceID = true
    @State private var selectedTheme = "system"
    @State private var showingResetAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                accountSection
                
                appearanceSection
                
                privacySection
                
                toolbarDemoSection
                
                aboutSection
                
                dangerZone
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                toolbarContent
            }
            .alert("Reset All Settings?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetSettings()
                }
            } message: {
                Text("This will reset all settings to their default values.")
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    var accountSection: some View {
        Section {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle)
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(.blue.gradient)
                
                VStack(alignment: .leading) {
                    Text("John Developer")
                        .font(.headline)
                    Text("john@example.com")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 4)
            
            Label("Subscription", systemImage: "star.circle.fill")
                .badge("Pro")
            
            Label("iCloud Sync", systemImage: "icloud")
                .badge(
                    Text("On")
                        .foregroundStyle(.green)
                )
        } header: {
            Text("Account")
        }
    }
    
    var appearanceSection: some View {
        Section {
            Picker("Theme", selection: $selectedTheme) {
                Label("System", systemImage: "circle.lefthalf.filled").tag("system")
                Label("Light", systemImage: "sun.max").tag("light")
                Label("Dark", systemImage: "moon").tag("dark")
            }
            .pickerStyle(.menu)
            
            HStack {
                Label("App Icon", systemImage: "app.fill")
                Spacer()
                Image(systemName: "app.fill")
                    .font(.title2)
                    .symbolRenderingMode(.multicolor)
            }
            
            NavigationLink {
                ColorSchemeView()
            } label: {
                Label("Color Scheme", systemImage: "paintpalette")
            }
        } header: {
            Text("Appearance")
        }
    }
    
    var privacySection: some View {
        Section {
            Toggle(isOn: $notificationsEnabled) {
                Label("Notifications", systemImage: "bell")
            }
            
            Toggle(isOn: $useFaceID) {
                Label("Use Face ID", systemImage: "faceid")
            }
            
            NavigationLink {
                PrivacyDetailsView()
            } label: {
                Label("Privacy", systemImage: "hand.raised")
            }
        } header: {
            Text("Privacy & Security")
        }
    }
    
    var toolbarDemoSection: some View {
        Section {
            NavigationLink {
                ToolbarExampleView()
            } label: {
                Label("Toolbar Examples", systemImage: "ellipsis.circle")
                    .badge("New")
            }
            
            NavigationLink {
                AdvancedToolbarView()
            } label: {
                Label("Advanced Toolbar", systemImage: "slider.horizontal.3")
            }
        } header: {
            Text("iOS 26 Toolbar Features")
        } footer: {
            Text("Explore the new ToolbarSpacer and enhanced toolbar customization options")
        }
    }
    
    var aboutSection: some View {
        Section {
            Button(action: {
                showingAbout = true
            }) {
                Label("About iOS 26 Showcase", systemImage: "info.circle")
            }
            
            Label("Version", systemImage: "number")
                .badge("1.0.0")
            
            Link(destination: URL(string: "https://developer.apple.com/ios/")!) {
                Label("Developer Documentation", systemImage: "book")
            }
        } header: {
            Text("About")
        }
    }
    
    var dangerZone: some View {
        Section {
            Button(action: {
                showingResetAlert = true
            }) {
                Label("Reset All Settings", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {}) {
                Image(systemName: "questionmark.circle")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Menu {
                    Button(action: {}) {
                        Label("Export Settings", systemImage: "square.and.arrow.up")
                    }
                    Button(action: {}) {
                        Label("Import Settings", systemImage: "square.and.arrow.down")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    func resetSettings() {
        notificationsEnabled = true
        useFaceID = true
        selectedTheme = "system"
    }
}

struct ToolbarExampleView: View {
    @State private var isEditing = false
    let items = Array(1...10)
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Text("Item \(item)")
            }
        }
        .navigationTitle("Toolbar Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button("Add") {
                        print("Add item")
                    }
                    
                    Button("Filter") {
                        print("Filter items")
                    }
                    
                    Menu {
                        Button("Sort by Name") {}
                        Button("Sort by Date") {}
                        Divider()
                        Button("Reset") {}
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Archive") {}
                
                Spacer()
                
                Text("Toolbar Demo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button("Delete") {}
                    .foregroundStyle(.red)
            }
        }
        .environment(\.editMode, .constant(isEditing ? .active : .inactive))
    }
}

struct AdvancedToolbarView: View {
    @State private var viewMode = "grid"
    @State private var sortOrder = "name"
    @State private var filterEnabled = false
    let contentItems = Array(1...5)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(contentItems, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue.gradient.opacity(0.3))
                        .frame(height: 100)
                        .overlay(
                            Text("Content \(item)")
                                .font(.headline)
                        )
                }
            }
            .padding()
        }
        .navigationTitle("Advanced Toolbar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Picker("View", selection: $viewMode) {
                    Image(systemName: "square.grid.2x2").tag("grid")
                    Image(systemName: "list.bullet").tag("list")
                }
                .pickerStyle(.segmented)
                .fixedSize()
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Toggle(isOn: $filterEnabled) {
                    Image(systemName: filterEnabled ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
                }
                .toggleStyle(.button)
                
                // ToolbarSpacer() // iOS 26 feature - commented out to fix compiler error
                Spacer()
                
                Menu {
                    Picker("Sort", selection: $sortOrder) {
                        Label("Name", systemImage: "textformat").tag("name")
                        Label("Date", systemImage: "calendar").tag("date")
                        Label("Size", systemImage: "arrow.up.arrow.down").tag("size")
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                }
            }
        }
    }
}

struct ColorSchemeView: View {
    let colors: [Color] = [.blue, .purple, .pink, .red, .orange, .yellow, .green, .mint, .cyan]
    @State private var selectedColor: Color = .blue
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Choose your accent color")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color.gradient)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, lineWidth: selectedColor == color ? 3 : 0)
                                    .padding(2)
                            )
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Color Scheme")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyDetailsView: View {
    var body: some View {
        List {
            Section {
                Label("Camera", systemImage: "camera")
                Label("Microphone", systemImage: "mic")
                Label("Location", systemImage: "location")
            } header: {
                Text("Permissions")
            }
            
            Section {
                Toggle("Analytics", isOn: .constant(false))
                Toggle("Crash Reports", isOn: .constant(true))
            } header: {
                Text("Data Collection")
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "apps.iphone")
                    .font(.system(size: 80))
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.bounce, value: true)
                
                VStack(spacing: 10) {
                    Text("iOS 26 Showcase")
                        .font(.largeTitle.bold())
                    
                    Text("Version 1.0.0")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("This app demonstrates the new features and design patterns introduced in iOS 26, including:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Liquid Glass design system", systemImage: "square.3.layers.3d")
                        Label("Enhanced navigation patterns", systemImage: "arrow.right.square")
                        Label("New sheet presentations", systemImage: "rectangle.stack")
                        Label("Toolbar improvements", systemImage: "ellipsis.circle")
                    }
                    .font(.subheadline)
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                
                Spacer()
                
                Link("Learn more about iOS 26", destination: URL(string: "https://developer.apple.com/ios/")!)
                    .font(.headline)
            }
            .padding()
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
    SettingsView()
}