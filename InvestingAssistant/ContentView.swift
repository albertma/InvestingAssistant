//
//  ContentView.swift
//  InvestingAssistant
//
//  Created by albertma on 2024/11/7.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedSection: SectionType? = .marketData
    
    var body: some View {
        NavigationView {
            // 左侧导航栏
            List {
                ForEach(SectionType.allCases, id: \.self) { section in
                    NavigationLink(
                        destination: WorkspaceView(section: section),
                        tag: section,
                        selection: $selectedSection
                    ) {
                        Label(section.title, systemImage: section.iconName)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("金融市场分析")
            
            // 右侧工作区
            WorkspaceView(section: selectedSection!)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

// 定义不同模块的类型
enum SectionType: String, CaseIterable {
    case marketData, stockData, financialAnalysis, businessAnalysis
    
    var title: String {
        switch self {
        case .marketData: return "市场数据"
        case .stockData: return "个股数据"
        case .financialAnalysis: return "财务分析"
        case .businessAnalysis: return "业务分析"
        }
    }
    
    var iconName: String {
        switch self {
        case .marketData: return "chart.bar"
        case .stockData: return "chart.line.uptrend.xyaxis"
        case .financialAnalysis: return "doc.text.magnifyingglass"
        case .businessAnalysis: return "briefcase.fill"
        }
    }
}

// 右侧工作区的内容视图
struct WorkspaceView: View {
    var section: SectionType
    
    var body: some View {
        VStack {
            switch section {
            case .marketData:
                MarketDataView()
            case .stockData:
                StockDataView()
            case .financialAnalysis:
                FinancialAnalysisView()
            case .businessAnalysis:
                BusinessAnalysisView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("投资分析工具")
        //.navigationTitle(section.title)
    }
}



