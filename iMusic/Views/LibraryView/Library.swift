//
//  Library.swift
//  iMusic
//
//  Created by Arman Davidoff on 27.03.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import SwiftUI

struct Library: View {
    
    @ObservedObject var viewModel = LibraryViewModel()
    @State var flag = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                GeometryReader { geometry in
                    HStack(spacing: 10) {
                        Button(action: {
                            self.viewModel.playFirstTrack()
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9107416272, green: 0.9053277373, blue: 0.9149031043, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            self.viewModel.updatePlayList()
                        }, label: {
                            Image(systemName: "gobackward")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9107416272, green: 0.9053277373, blue: 0.9149031043, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                List() {
                    ForEach(viewModel.tracks) { track in
                        Cell(track: track)
                            .gesture(TapGesture().onEnded{
                                guard let delegate = self.viewModel.openTrackDelegate else { return }
                                self.viewModel.changeDelegateForMusicPlayer()
                                self.viewModel.selectedTrack = track
                                delegate.animateOpen(model: track)
                            }).simultaneousGesture(LongPressGesture().onEnded{ _ in
                                self.flag = true
                                self.viewModel.deletedTrack = track
                            })
                    }.onDelete(perform: { (indexSet) in
                        self.viewModel.delete(indexSet: indexSet)
                    }).actionSheet(isPresented: $flag, content: {
                        ActionSheet(title: Text("Вы уверены что хотите удалить этот трек?"), buttons: [.destructive(Text("Delete"), action: {
                            self.viewModel.delete(track: self.viewModel.deletedTrack)
                        }),.cancel()])
                    })
                }
                .navigationBarTitle("Library")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}


