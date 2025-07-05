import SwiftUI

struct ProfileView: View {
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var showingActivitySheet = false
    @State private var showingImagePicker = false
    @State private var selectedSheetDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    
                    statsSection
                    
                    sheetExamplesSection
                    
                    modalOptionsSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileSheet()
                    .presentationDetents([.medium, .large], selection: $selectedSheetDetent)
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(28)
                    .presentationBackground(.regularMaterial)
            }
            .sheet(isPresented: $showingActivitySheet) {
                ActivityDetailSheet()
                    .presentationDetents([.height(400), .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(400)))
            }
            .fullScreenCover(isPresented: $showingSettings) {
                SettingsFullScreenView()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerSheet()
                    .presentationDetents([.fraction(0.75)])
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
    
    var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.blue.gradient)
                    .frame(width: 100, height: 100)
                
                Text("JD")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    showingImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(.blue, in: Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
            }
            
            VStack(spacing: 4) {
                Text("John Developer")
                    .font(.title2.bold())
                
                Text("iOS Developer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Button(action: {
                showingEditProfile = true
            }) {
                Label("Edit Profile", systemImage: "pencil")
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.blue.gradient, in: Capsule())
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
    
    var statsSection: some View {
        HStack(spacing: 0) {
            StatView(value: "42", label: "Projects")
            Divider().frame(height: 40)
            StatView(value: "128", label: "Commits")
            Divider().frame(height: 40)
            StatView(value: "8.2k", label: "Lines")
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    var sheetExamplesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sheet Presentations")
                .font(.headline)
            
            SheetExampleCard(
                title: "Resizable Sheet",
                subtitle: "Medium and Large detents",
                icon: "rectangle.expand.vertical",
                color: .blue,
                action: {
                    selectedSheetDetent = .medium
                    showingEditProfile = true
                }
            )
            
            SheetExampleCard(
                title: "Interactive Sheet",
                subtitle: "Background interaction enabled",
                icon: "hand.tap",
                color: .green,
                action: {
                    showingActivitySheet = true
                }
            )
            
            SheetExampleCard(
                title: "Adaptive Sheet",
                subtitle: "Compact popover adaptation",
                icon: "rectangle.portrait.and.arrow.right",
                color: .orange,
                action: {
                    showingImagePicker = true
                }
            )
        }
    }
    
    var modalOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Modal Options")
                .font(.headline)
            
            Button(action: {
                showingSettings = true
            }) {
                HStack {
                    Label("Full Screen Cover", systemImage: "rectangle.fill")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

struct StatView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SheetExampleCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1), in: Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = "John Developer"
    @State private var bio = "iOS Developer passionate about SwiftUI"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile Information") {
                    TextField("Name", text: $name)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Display") {
                    HStack {
                        Text("Profile Color")
                        Spacer()
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct ActivityDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Recent Activity")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ActivityRow(icon: "hammer", title: "Built iOS 26 App", time: "2 hours ago", color: .blue)
                        ActivityRow(icon: "arrow.triangle.merge", title: "Merged PR #42", time: "5 hours ago", color: .green)
                        ActivityRow(icon: "doc.badge.plus", title: "Created new component", time: "Yesterday", color: .orange)
                        ActivityRow(icon: "star", title: "Starred repository", time: "2 days ago", color: .yellow)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
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

struct ActivityRow: View {
    let icon: String
    let title: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SettingsFullScreenView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("Account", systemImage: "person.circle")
                    Label("Privacy", systemImage: "lock")
                    Label("Notifications", systemImage: "bell")
                }
                
                Section {
                    Label("Help", systemImage: "questionmark.circle")
                    Label("About", systemImage: "info.circle")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
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

struct ImagePickerSheet: View {
    @Environment(\.dismiss) var dismiss
    let images = Array(1...12)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                    ForEach(images, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.gradient.opacity(Double(index) / 12))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Text("\(index)")
                                    .font(.title.bold())
                                    .foregroundStyle(.white)
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}