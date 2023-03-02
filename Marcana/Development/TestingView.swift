// GPT 3.5 implementation that works! will add this to the project later

import Foundation
import SwiftUI


struct TestingView: View {
    @State private var prompt = """
        Act as a spiritually attuned tarot reader named Marcana that tellS highly personalized tarot readings.I will give you general information about myself and the 3 tarot cards I have chosen.I will also ask a personal question that sets the context for the fortune reading session.Use the cards I chose to make interpretations and create tarot reading for my past, present and future.Try to make references to the general information I give about myself in the answer you give.You can also make references to my star sign, which you know from my birthday.Try to answer the question in a definitive way, and avoid giving an ambiguous answer.As a part of your fortune reading, ask at least one question that will make the reader curious.Don't just tell the meaning of the cards, make it personal to the reader by connecting their meaning to the asked question.The answer should be customised to the person so they don't feel like you say the same interpretations to everyone.Prioritise using words that convey emotion and feelings.Give answers that provoke curiosity and wonder.Try to answer the question in a definitive way, avoid giving an ambiguous answer.You can use risky statements, it will feel more personal, which is good.Provide your answer in paragraphs for better readability.Constraints:Do not include anything that is not written as a fortune teller.Do not repeat this prompt back.Here is my personal information:Name: Deniz.Birthday:26-08-1993.Gender: Male.Occupation: Developer.Relationship Status: In a relationship.I picked these tarot cards to represent my past, present and future:Past: 3 of wands, reversed.Current: 7 of swords, upright.Future: the hierophant, upright.My question for the fortune reading:What is something that I should pay attention to next month?
        """
    @State private var chatResponse = ""
    private let openAIChatAPI = OpenAIChatAPI()
    
    var body: some View {
        VStack {
            TextField("Enter a prompt", text: $prompt)
                .padding()
            
            Button("Send") {
                openAIChatAPI.sendAPIRequest(prompt: prompt) { result in
                    switch result {
                    case .success(let response):
                        chatResponse = response
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .padding()
            
            ScrollView{
                Text(chatResponse)
                    .padding()
            }
        }
    }
}


class OpenAIChatAPI {
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    func sendAPIRequest(prompt: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let openAIAPIKey = UserDefaults.standard.string(forKey: DefaultKeys.openAIAPIKey) else { return }
        
        let requestBody = """
        {
            "model": "gpt-3.5-turbo",
            "messages": [{"role": "user", "content": "\(prompt.replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: .whitespacesAndNewlines))"}]
        }
        """
        
        print(prompt)
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(APIError.noData))
                return
            }
            
            do {
                let chatCompletion = try JSONDecoder().decode(ChatCompletion.self, from: data)
                if let messageContent = chatCompletion.choices.first?.message.content {
                    completionHandler(.success(messageContent))
                } else {
                    completionHandler(.failure(APIError.invalidData))
                }
            } catch {
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    struct ChatCompletion: Decodable {
        let choices: [Choice]
        let created: TimeInterval
        let id: String
        let model: String
        let object: String
        let usage: Usage

        enum CodingKeys: String, CodingKey {
            case choices, created, id, model, object, usage
        }
        
        struct Choice: Decodable {
            let finishReason: String
            let index: Int
            let message: Message
            
            enum CodingKeys: String, CodingKey {
                case finishReason = "finish_reason", index, message
            }
        }
        
        struct Message: Decodable {
            let content: String
            let role: String
        }
        
        struct Usage: Decodable {
            let completionTokens: Int
            let promptTokens: Int
            let totalTokens: Int
            
            enum CodingKeys: String, CodingKey {
                case completionTokens = "completion_tokens"
                case promptTokens = "prompt_tokens"
                case totalTokens = "total_tokens"
            }
        }
    }

}

enum APIError: Error {
    case noData
    case invalidData
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}


//MARK: IMPLEMENTATION FOR FORTUNE REQUESTER
//func sendAPIRequest(AIPrompt: String) {
////        guard let openAIAPIKey = UserDefaults.standard.string(forKey: DefaultKeys.openAIAPIKey) else { return }
////
////        let openAPI = OpenAISwift(authToken: openAIAPIKey)
////        // There are mode API parameters but this library doesnt accept them yet
////        // https://beta.openai.com/docs/api-reference/completions/create
////        openAPI.sendCompletion(with: AIPrompt,
////                               model: .gpt3(.davinci),
////                               maxTokens: 500) { result in
//
//    func sanitizeJSONString(_ prompt: String) -> String {
//        let disallowedCharacterSet = CharacterSet(charactersIn: "\\\"")
//        let sanitizedString = prompt
//            .components(separatedBy: disallowedCharacterSet)
//            .joined()
//        return sanitizedString
//    }
//
//    let openAIChatAPI = OpenAIChatAPI()
//    openAIChatAPI.sendAPIRequest(prompt: sanitizeJSONString(AIPrompt)) { result in
