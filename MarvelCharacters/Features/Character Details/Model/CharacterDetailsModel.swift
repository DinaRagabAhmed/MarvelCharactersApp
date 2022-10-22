//
//  CharacterDetailsModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 22/10/2022.
//

enum CharacterDetailsItem {
   case characterImage(thumbnail: Thumbnail?)
   case characterData(character: MarvelCharacter?)
   case characterMedia(data: CharacterMediaData)
}

class CharacterMediaData {
   var type: CharacterMediaType
   var title: String
   var items: [CharacterMediaItem]
   
   init(type: CharacterMediaType, title: String = "", items: [CharacterMediaItem] = []) {
       self.type = type
       self.title = title
       self.items = items
   }
}

enum CharacterMediaType {
   case comis
   case events
   case series
   case stories
}
