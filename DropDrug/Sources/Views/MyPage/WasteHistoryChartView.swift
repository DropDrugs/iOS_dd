// Copyright © 2024 RT4. All rights reserved

import SwiftUI
import Charts

struct WasteChartView: View {
    @ObservedObject var viewModel: WasteStatsViewModel

    private var maxDisposal: Int {
        let maxStat = viewModel.stats.map { $0.disposalCount }.max() ?? 0
        return max(maxStat, 20)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if viewModel.stats.isEmpty {
                Text("폐기 내역이 없어요. 🥲")
                    .foregroundColor(Color(Constants.Colors.gray700 ?? UIColor.gray))
                    .font(Font(UIFont.ptdRegularFont(ofSize: 16)))
            } else {
                ForEach(0..<viewModel.stats.count, id: \.self) { index in
                    let data = viewModel.stats[index]
                    HStack {
                        
                        Text("\(data.month.split(separator: "-").last ?? "")월")
                            .foregroundColor(Color(Constants.Colors.gray700 ?? UIColor.gray))
                            .font(Font(UIFont.ptdRegularFont(ofSize: 16)))
                            .frame(width: 40, alignment: .leading)
                        
                        // 막대 그래프
                        GeometryReader { geometry in
                            let barWidth = geometry.size.width
                            let scaleFactor = CGFloat(data.disposalCount) / CGFloat(maxDisposal)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(Constants.Colors.gray200 ?? UIColor.gray))
                                    .frame(height: 15)
                                
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(Constants.Colors.skyblue ?? UIColor.blue))
                                    .frame(width: barWidth * scaleFactor, height: 15)
                            }
                        }
                        .frame(height: 15) // 막대 높이 고정
                    }
                    .padding(.vertical, 2) // 막대 간의 간격
                }
            }
        }
        .padding()
        .navigationTitle("월별 폐기량")
    }
}
