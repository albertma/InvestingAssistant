//
//  AIAgent.swift
//  InvestingAssistant
//
//  Created by albertma on 2024/11/7.
//

import SwiftUI
import Foundation

// MARK: - AIAgent Protocol
protocol AIAgentProtocol {
    var name: String { get }
    func ask(question: String, completion: @escaping (String) -> Void)
}

// MARK: - ChatGPT Agent
struct ChatGPTAgent: AIAgentProtocol {
    let name = "ChatGPT"
    
    func ask(question: String, completion: @escaping (String) -> Void) {
        // 示例 API 请求
        let answer = "ChatGPT's answer to: \(question)"
        completion(answer)
    }
}

// MARK: - Kimi Agent
struct KimiAgent: AIAgentProtocol {
    let name = "Kimi"
    
    func ask(question: String, completion: @escaping (String) -> Void) {
        // 示例 API 请求
        let answer = "Kimi's answer to: \(question)"
        completion(answer)
    }
}

// MARK: - Question List
class QuestionList: ObservableObject {
    @Published var questions: [String] = ["默认问题1", "默认问题2"]
    
    func addQuestion(_ question: String) {
        questions.append(question)
    }
    
    func removeQuestion(at index: Int) {
        questions.remove(at: index)
    }
}

// MARK: - Markdown Writer
struct MarkdownWriter {
    func writeToFile(content: String, fileName: String = "QnA.md") {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File written to: \(fileURL.path)")
        } catch {
            print("Failed to write file: \(error)")
        }
    }
}

// MARK: - AIAgentView for SwiftUI
struct AIAgentView: View {
    @ObservedObject var questionList = QuestionList()
    @State private var agent: AIAgentProtocol = ChatGPTAgent() // 默认使用ChatGPT
    @State private var answers: [String] = []
    @State private var selectedQuestion: String?
    
    var body: some View {
        VStack {
            // 问题列表和选择
            List {
                ForEach(questionList.questions, id: \.self) { question in
                    Text(question)
                        .onTapGesture {
                            selectedQuestion = question
                            fetchAnswer(for: question)
                        }
                }
                .onDelete { indexSet in
                    indexSet.forEach { questionList.removeQuestion(at: $0) }
                }
            }
            
            // 显示答案
            ScrollView {
                Text(answers.joined(separator: "\n\n"))
                    .padding()
            }
            
            // 添加新问题按钮
            HStack {
                TextField("输入新问题", text: $selectedQuestion.bound)
                Button("添加问题") {
                    if let question = selectedQuestion {
                        questionList.addQuestion(question)
                    }
                    selectedQuestion = nil
                }
            }
            .padding()
            
            // 切换 AI Agent 和保存按钮
            HStack {
                Button("切换到Kimi") {
                    agent = KimiAgent()
                }
                Button("切换到ChatGPT") {
                    agent = ChatGPTAgent()
                }
                Button("保存到Markdown") {
                    saveToMarkdown()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("AI 问答")
    }
    
    // 获取答案
    private func fetchAnswer(for question: String) {
        agent.ask(question: question) { answer in
            DispatchQueue.main.async {
                answers.append("**\(question)**\n\(answer)")
            }
        }
    }
    
    // 保存到Markdown文件
    private func saveToMarkdown() {
        let content = answers.joined(separator: "\n\n")
        MarkdownWriter().writeToFile(content: content)
    }
}

// MARK: - Preview
struct AIAgentView_Previews: PreviewProvider {
    static var previews: some View {
        AIAgentView()
    }
}

// 扩展用于绑定文本
extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue.isEmpty ? nil : newValue }
    }
}
