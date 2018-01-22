# README #

### What is this repository for? ###

This is my experimental project to try out couple of my ideas. 


### What's currently done? ###

UIControlBinding - prototype - simple binding micro-framework for UIControls.
Flashcards - dynamic animation made with UIBezierPaths and CoreAnimation.
CardsCollectionViewLayout - CollectionView layot based on UIDynamics, that simulates two decks of cards. On one deck cards are flippable.
Themes - prototype - Application supports custom, dynamically changed themes, defined as JSONs. 
DummyPlatform - Just a dummy implementation of business logic, to test visuals.
Visuals - One separate frameworks with base views implementation, so all parts of application could look consistent.

### What I'd like to accomplish? ###
Architecture:
Application is divided to small frameworks, which are communicating which other. Something similar to microservices concept.
ViewModels treated as models for views. So they only provide information what should be presented, and gather info what about user input.
ViewControllers are handling view logic. 

Domain - Contract between View and businness logic. So any view abstraction layer should work with different business logic implementations.
Domain should separate business logic from model (persistent store)

### TODO: ###
CoreDataPlatform with unit tests
RealmPlatform with unit tests
NetworkPlatform with unit tests
UI tests 
DesignDashboard - Special view, which will appear on the screen on shake gesture. It will allow to modify themes by designer, when using an app. For example change fonts, or colors of views (with ColorWheel control).

Further features for flashcards application

### Examples: ###
[Themes and logo demo](https://bitbucket.org/MMrepo/fiszki/raw/9789cc07190a0b0e28b5256916e4b8b291ce279e/Videos/themesAndCards.mov)
[Cards layout demo](https://bitbucket.org/MMrepo/fiszki/raw/9789cc07190a0b0e28b5256916e4b8b291ce279e/Videos/themesAndCards.mov)