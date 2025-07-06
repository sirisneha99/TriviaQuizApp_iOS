//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by sneha siri nagabathula on 7/5/25.
//

//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaResponse: Decodable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

class TriviaQuestionService {
    
    // MARK: - Properties
    static let shared = TriviaQuestionService()
    
    private let baseURL = "https://opentdb.com/api.php"
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Public Methods
    func fetchTriviaQuestions(amount: Int = 10,
                             category: Int? = nil,
                             difficulty: String? = nil,
                             completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        
        guard let url = buildURL(amount: amount, category: category, difficulty: difficulty) else {
            completion(.failure(TriviaServiceError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(TriviaServiceError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(TriviaServiceError.noData))
                return
            }
            
            do {
                let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                
                // Check if the API returned a successful response
                guard triviaResponse.responseCode == 0 else {
                    completion(.failure(TriviaServiceError.apiError(code: triviaResponse.responseCode)))
                    return
                }
                
                // Decode HTML entities in the questions
                let decodedQuestions = triviaResponse.results.map { question in
                    TriviaQuestion(
                        category: question.category.decodingHTMLEntities(),
                        type: question.type,
                        difficulty: question.difficulty,
                        question: question.question.decodingHTMLEntities(),
                        correctAnswer: question.correctAnswer.decodingHTMLEntities(),
                        incorrectAnswers: question.incorrectAnswers.map { $0.decodingHTMLEntities() }
                    )
                }
                
                completion(.success(decodedQuestions))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    private func buildURL(amount: Int, category: Int?, difficulty: String?) -> URL? {
        var components = URLComponents(string: baseURL)
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "amount", value: String(amount)))
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: String(category)))
        }
        
        if let difficulty = difficulty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty))
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
}

// MARK: - Error Types
enum TriviaServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case apiError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received"
        case .apiError(let code):
            return "API error with code: \(code)"
        }
    }
}

// MARK: - String Extension for HTML Decoding
extension String {
    func decodingHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
