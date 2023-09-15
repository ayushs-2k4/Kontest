//
//  ErrorView.swift
//  Kontest
//
//  Created by Ayush Singhal on 15/09/23.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.dismiss) private var dismiss

    let errorWrapper: ErrorWrapper

    init(errorWrapper: ErrorWrapper) {
        self.errorWrapper = errorWrapper
    }

    var body: some View {
        VStack {
            Text(errorWrapper.error is AppError ? (errorWrapper.error as! AppError).title : "Error has occurred")
                .font(.headline)
                .padding(.bottom)

            Text(errorWrapper.error.localizedDescription)

            Text(errorWrapper.guidance)
                .font(.caption)

            Button("Dismiss") {
                dismiss()
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    enum SampleError: Error {
        case OperationFailed
    }

    return ErrorView(errorWrapper: ErrorWrapper(error: SampleError.OperationFailed, guidance: "Operation has failed. Please launch the app again"))
}
