#  KeepCoding FullStack Mobile Bootcamp iOS Advanced Exam

## Description
The objective of this practice is to put into practice the contents seen in the module. The student must create an iOS project using Storyboard, Core Data, and Tests.

### Requirements
For the development of the project, we will use the Dragon Ball REST API. The general idea of the app is that it should be able to:
- Perform log in. The information returned by this endpoint should be stored in the Keychain.
- List the superheroes.
- Show a map with the superheroes.
- Be able to view the details of a particular hero from the list of superheroes.
- On the main screen (list of heroes), there should be a button to log out.

## Architecture Solution
- Clean architecture
  - Data Layer
    - DataSources
      - Network with endpoint connection.
        - DTO Models
        - DTO Model mapper to domain
      - Local(CoreData and Keychain)
        - DAO Models
        - DAO Models mapper to domain
    - Repository
  - Domain Layer
    - UseCases
    - Models
  - Presentation Layer 
    - Domain model mapper to presentation
    - ViewModels
    - Views

Layer-to-layer connection with protocols

## Features Solution
- Splash
- Login
- Heroes List
- Hero Detail
- Heroes Map

## Preview
![App preview](ReadmeResources/DemoPreview.gif)
