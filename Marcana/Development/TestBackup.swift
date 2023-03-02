////
////  TestingView.swift
////  Marcana
////
////  Created by Deniz Ozagac on 26/02/2023.
//// WORKING BACKUP OF THE GPT 3.5 BUT IS FLAWED (doesnt have completion handler)
////
//
//import SwiftUI
//import StoreKit
//
//struct TestingView: View {
//    @State private var inputText = """
//        Act as a spiritually attuned tarot reader named Marcana that tellS highly personalized tarot readings.I will give you general information about myself and the 3 tarot cards I have chosen.I will also ask a personal question that sets the context for the fortune reading session.Use the cards I chose to make interpretations and create tarot reading for my past, present and future.Try to make references to the general information I give about myself in the answer you give.You can also make references to my star sign, which you know from my birthday.Try to answer the question in a definitive way, and avoid giving an ambiguous answer.As a part of your fortune reading, ask at least one question that will make the reader curious.Don't just tell the meaning of the cards, make it personal to the reader by connecting their meaning to the asked question.The answer should be customised to the person so they don't feel like you say the same interpretations to everyone.Prioritise using words that convey emotion and feelings.Give answers that provoke curiosity and wonder.Try to answer the question in a definitive way, avoid giving an ambiguous answer.You can use risky statements, it will feel more personal, which is good.Provide your answer in paragraphs for better readability.Constraints:Do not include anything that is not written as a fortune teller.Do not repeat this prompt back.Here is my personal information:Name: Deniz.Birthday:26-08-1993.Gender: Male.Occupation: Developer.Relationship Status: In a relationship.I picked these tarot cards to represent my past, present and future:Past: 3 of wands, reversed.Current: 7 of swords, upright.Future: the hierophant, upright.My question for the fortune reading:What is something that I should pay attention to next month?
//        """
//    @State private var responseText = ""
//
//    let chatBot = OpenAIChatBot()
//
//    var body: some View {
//        VStack {
//            TextField("Enter input text", text: $inputText)
//                .padding()
//                .border(Color.black)
//
//            Button("Send Request") {
//                chatBot.sendAPIRequest(inputText: inputText) { response in
//                    if let response = response {
//                        DispatchQueue.main.async {
//                            responseText = response
//                        }
//                    } else {
//                        print("Error getting API response")
//                    }
//
//
//
//                }
//            }
//                .padding()
//
//            Text(responseText)
//                .padding()
//        }
//    }
//}
//
//
//class OpenAIChatBot {
//    func sendAPIRequest(inputText: String, completion: @escaping (String?) -> Void) {
//        guard let openAIAPIKey = UserDefaults.standard.string(forKey: DefaultKeys.openAIAPIKey) else { return }
//
//        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
//            print("Invalid URL")
//            completion(nil)
//            return
//        }
//
//        let requestBody = """
//        {
//            "model": "gpt-3.5-turbo",
//            "messages": [{"role": "user", "content": "\(inputText)"}]
//        }
//        """
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
//        request.httpBody = requestBody.data(using: .utf8)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error sending API request: \(error.localizedDescription)")
//                completion(nil)
//            } else if let data = data {
//                let responseString = String(data: data, encoding: .utf8)!
//                print(responseString)
//                if let parsedContent = self.parseAPIResponse(responseString) {
//                    completion(parsedContent)
//                } else {
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }.resume()
//    }
//
//    private func parseAPIResponse(_ response: String) -> String? {
//        do {
//            let data = response.data(using: .utf8)!
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//
//            guard let choices = json["choices"] as? [[String: Any]], let firstChoice = choices.first else {
//                return nil
//            }
//
//            guard let message = firstChoice["message"] as? [String: Any], let content = message["content"] as? String else {
//                return nil
//            }
//
//            return content
//        } catch {
//            print("Error parsing API response: \(error.localizedDescription)")
//            return nil
//        }
//    }
//}
//
//struct TestingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestingView()
//    }
//}
//
//
//
//
//
