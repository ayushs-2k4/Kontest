//
//  CodeForcesAPIModel.swift
//  Kontests
//
//  Created by Ayush Singhal on 16/08/23.
//

import Foundation

// MARK: - CodeForcesAPIModel

struct CodeForcesAPIModel: Codable {
    let status: String
    let result: [CodeForcesResult]
}

// MARK: - Result

struct CodeForcesResult: Codable {
    let contestId: Int
    let contestName: String
    let handle: String
    let rank, ratingUpdateTimeSeconds, oldRating, newRating: Int

    enum CodingKeys: String, CodingKey {
        case contestId
        case contestName, handle, rank, ratingUpdateTimeSeconds, oldRating, newRating
    }
}

extension CodeForcesAPIModel {
    static func from(dto: CodeForcesAPIDTO) -> CodeForcesAPIModel {
        let results = dto.result.map { resultDTO in
            resultDTOToResultModel(codeForcesResultDTO: resultDTO)
        }
        return CodeForcesAPIModel(status: dto.status, result: results)
    }

    private static func resultDTOToResultModel(codeForcesResultDTO: CodeForcesResultDTO) -> CodeForcesResult {
        return CodeForcesResult(contestId: codeForcesResultDTO.contestId, contestName: codeForcesResultDTO.contestName, handle: codeForcesResultDTO.handle, rank: codeForcesResultDTO.rank, ratingUpdateTimeSeconds: codeForcesResultDTO.ratingUpdateTimeSeconds, oldRating: codeForcesResultDTO.oldRating, newRating: codeForcesResultDTO.newRating)
    }
}
