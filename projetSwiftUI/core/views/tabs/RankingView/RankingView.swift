//
//  RankingView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-17.
//

import SwiftUI

struct RankingView: View {
    @State private var db=ExpenseDataBaseService.shared
    var body: some View {
       VStack{
           if db.expenses.isEmpty{
               displayEmptyState
           }else{
               Text("Ranking")
               displayRanking
              
           }
        }
       .padding(.top)
    }
    
    var displayRanking: some View {
        ForEach(Array(db.ranking.enumerated()),id: \.offset){
            index,entry in
            HStack{
                Text("\(index+1)").font(.caption)
                Text("\(entry.user)").font(.caption).lineLimit(1)
                Spacer()
                Text(String(format: "%.2f pts", entry.totalAmount)).font(.subheadline)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .padding(.horizontal)
    }
    
    var displayEmptyState: some View {
        ContentUnavailableView("No Ranking yet",systemImage: "figure.run", description:Text("Add expenses to see your ranking")).frame(maxWidth: .infinity, maxHeight: .infinity)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.secondary,.green)
            .font(.title)
    }
}

#Preview {
    RankingView()
}
