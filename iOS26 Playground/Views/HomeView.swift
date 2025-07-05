import SwiftUI

struct HomeView: View {
    @State private var navigationPath = NavigationPath()
    @State private var showingDetail = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    navigationExamplesSection
                    
                    glassEffectSection
                    
                    interactiveSection
                }
                .padding()
            }
            .navigationTitle("iOS 26 Showcase")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome to iOS 26")
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
            
            Text("Explore the new Liquid Glass design system and navigation patterns")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    var navigationExamplesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Navigation Examples")
                .font(.headline)
                .padding(.horizontal)
            
            NavigationLink(value: "detail1") {
                navigationCard(
                    title: "Push Navigation",
                    subtitle: "Navigate to detail view",
                    systemImage: "arrow.right.circle.fill",
                    color: .blue
                )
            }
            
            NavigationLink(value: "detail2") {
                navigationCard(
                    title: "Programmatic Navigation",
                    subtitle: "Navigate using code",
                    systemImage: "chevron.left.forwardslash.chevron.right",
                    color: .green
                )
            }
            
            Button(action: {
                showingDetail = true
            }) {
                navigationCard(
                    title: "Modal Presentation",
                    subtitle: "Show as sheet",
                    systemImage: "rectangle.stack",
                    color: .purple
                )
            }
        }
        .navigationDestination(for: String.self) { value in
            DetailView(title: value == "detail1" ? "Push Detail" : "Programmatic Detail")
        }
        .sheet(isPresented: $showingDetail) {
            SheetDetailView()
        }
    }
    
    var glassEffectSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Liquid Glass Effects")
                .font(.headline)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                glassCard(material: .regular, label: "Regular")
                glassCard(material: .thin, label: "Thin")
            }
            
            HStack(spacing: 16) {
                glassCard(material: .thick, label: "Thick")
                glassCard(material: .ultraThin, label: "Ultra Thin")
            }
        }
    }
    
    var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Elements")
                .font(.headline)
                .padding(.horizontal)
            
            Button(action: {
                navigationPath.append("detail1")
            }) {
                Label("Navigate Programmatically", systemImage: "arrow.right.square")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.white)
            }
            
            Button(action: {
                if !navigationPath.isEmpty {
                    navigationPath.removeLast()
                }
            }) {
                Label("Pop Navigation", systemImage: "arrow.backward")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orange.gradient, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
    
    func navigationCard(title: String, subtitle: String, systemImage: String, color: Color) -> some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1), in: Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color(.quaternaryLabel), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    func glassCard(material: Material, label: String) -> some View {
        Text(label)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(material, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color(.quaternaryLabel), lineWidth: 1)
            )
    }
}

struct DetailView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle.bold())
            
            Text("This is a detail view showcasing navigation in iOS 26")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }
}

struct SheetDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sheet Presentation")
                    .font(.largeTitle.bold())
                
                Text("This view is presented as a sheet with iOS 26's new glass effects")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()
                
                Spacer()
                
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
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
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    HomeView()
}