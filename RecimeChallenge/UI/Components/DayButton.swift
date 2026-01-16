import SwiftUI

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let hasMeals: Bool
    let action: () -> Void

    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }

    private var dayLabel: String {
        isToday ? "Today" : dayFormatter.string(from: date)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayLabel)
                    .font(AppFont.caption)
                    .foregroundStyle(isSelected ? .white : (isToday ? AppColors.primary : .secondary))

                Text(dateFormatter.string(from: date))
                    .font(AppFont.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? .white : .primary)

                Circle()
                    .fill(hasMeals ? Color.green : Color.clear)
                    .frame(width: 6, height: 6)
            }
            .frame(width: 50, height: 70)
            .background(isSelected ? Color.accentColor : Color.clear)
            .glassCard(cornerRadius: 12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        DayButton(date: Date(), isSelected: true, hasMeals: true, action: {})
        DayButton(date: Date().addingTimeInterval(86400), isSelected: false, hasMeals: false, action: {})
    }
    .padding()
}
