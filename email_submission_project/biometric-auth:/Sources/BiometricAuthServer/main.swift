import Foundation
import Vapor
import LocalAuthentication

@main
struct App {
    static func main() async throws {
        let app = try await Application.make(.development)
        defer {
            Task {
                await app.shutdown()
            }
        }

        // Add CORS Middleware to allow cross-origin requests
        app.middleware.use(CORSMiddleware(configuration: .init(
            allowedOrigin: .all, // Allow requests from any origin
            allowedMethods: [.GET, .POST, .OPTIONS], // Allowed HTTP methods
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith] // Allowed headers
        )))

        // Define the authenticate route
        app.get("authenticate") { req async -> Response in
            let context = LAContext()
            var error: NSError?

            // Check if biometric authentication is available
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                let message = "Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")"
                print(message)
                return Response(status: .forbidden, body: .init(string: message))
            }

            let reason = "Authenticate with Touch ID to proceed"
            let authSuccess = await performBiometricAuthentication(context: context, reason: reason)

            if authSuccess {
                print("Biometric authentication successful")
                return Response(status: .ok, body: .init(string: "success"))
            } else {
                print("Biometric authentication failed")
                return Response(status: .unauthorized, body: .init(string: "failure"))
            }
        }

        try await app.execute()
    }

    static func performBiometricAuthentication(context: LAContext, reason: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    print("Authentication successful")
                    continuation.resume(returning: true)
                } else {
                    print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}