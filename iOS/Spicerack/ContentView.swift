import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingEntry: SpiceEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button(action: { editingEntry = entry }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(entry.name)").font(Theme.headingFont)
                            Text(entry.purchaseDate, style: .date).font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id.uuidString)")
                    .buttonStyle(.plain)
                }
                .onDelete(perform: store.delete)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Spice Rack Index")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if store.canAddMore {
                            showingAddSheet = true
                        } else {
                            showingPaywall = true
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                EntryFormView(entry: nil) { newEntry in
                    store.add(newEntry)
                }
            }
            .sheet(item: $editingEntry) { entry in
                EntryFormView(entry: entry) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No Spices Yet", systemImage: "tray", description: Text("Tap + to add your first spice."))
                }
            }
        }
        .tint(Theme.accent)
    }
}

struct EntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    let existing: SpiceEntry?
    let onSave: (SpiceEntry) -> Void

    @State private var name: String
    @State private var purchaseDate: Date
    @State private var shelfLocation: String

    init(entry: SpiceEntry?, onSave: @escaping (SpiceEntry) -> Void) {
        self.existing = entry
        self.onSave = onSave
        _name = State(initialValue: entry?.name ?? "")
        _purchaseDate = State(initialValue: entry?.purchaseDate ?? Date())
        _shelfLocation = State(initialValue: entry?.shelfLocation ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .focused($isFocused)
                    .accessibilityIdentifier("form_nameField")
                DatePicker("PurchaseDate", selection: $purchaseDate, displayedComponents: .date)
                TextField("ShelfLocation", text: $shelfLocation)
                    .focused($isFocused)
                    .accessibilityIdentifier("form_shelfLocationField")
            }
            .navigationTitle(existing == nil ? "Add Spice" : "Edit Spice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("formCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .accessibilityIdentifier("formSaveButton")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = false
            }
        }
    }

    private func save() {
        let id = existing?.id ?? UUID()
        let entry = SpiceEntry(id: id, name: name, purchaseDate: purchaseDate, shelfLocation: shelfLocation)
        onSave(entry)
    }
}
