import Foundation
import RxSwift
import RxCocoa

protocol HTTPClient {
    func perform(request: HTTPRequest) -> Observable<HTTPResponse>
}

struct SephoraHttpClient: HTTPClient {
    func perform(request: HTTPRequest) -> Observable<HTTPResponse> {
        guard let request = try? request.create() else {
            return Observable.error(HTTPError.invalidURL)
        }
        
        return URLSession.shared
            .rx
            .response(request: request)
            .map { result -> HTTPResponse in
                return HTTPClientResponse(data: result.data, statusCode: result.response.statusCode)
            }
            .catch { error -> Observable<HTTPResponse> in
                Observable.error(HTTPError.serverError)
            }
            .observe(on: MainScheduler.instance)
    }
}
