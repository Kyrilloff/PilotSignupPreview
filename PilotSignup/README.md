# Pilot Signup
This app demonstrates a SwiftUI project with an MVVM architecture and two main screens for registering a Pilot based on a given set of data, specific constraints and confirming the registration.

## Build Requirements

- Xcode 16
- Swift 6

## Deployment Targets

- iOS 17+
- iPhone (all sizes, portrait & landscape)
- iPad (all sizes, portrait)

## Technologies & Architecture

- SwiftUI
- MVVM Architecture
- Repository Pattern


# Main Screens
Main view names end with "Screen", subview names end with "View" to make the structure easier to navigate.

## Registration Screen
This screen collects user input in a form, validating it against constraints and enabling registration once all criteria are met.

- Password constraints can be checked via an info button. Additionally there is a message showing missing requirements in real time as the user inputs text. 
- License types are dynamically loaded to accomodate future additions.
- The custom "Register" button enhances the design with reusable components.

## Confirmation Screen
This screen displays registration success with user data and allows to logout. Tapping logout triggers a confirmation alert before dismissing the screen. 

# Architecture
## MVVM + Repository Pattern
The app uses the MVVM architecture with a repository pattern for data handling. State classes manage general, app-wide data (user and license data). ViewModels are tied to specific views. Each ViewModel manages the view-specific state and handles presentation logic, like enabling buttons or formatting inputs. 

Repositories manage data fetching and storage, keeping the global state classes cleaner. 

The Views are focusing on presentation / layout and leave the logic to other classes.

## View Models / States
The App has AppState for global data (license data, navigation state data) and UserState for user-specific data.

The States and ViewModels use SwiftUI's Observation framework, which makes the data available and trackable for the views. @Observable has much less overhead than ObservableObject as there is no need for explicit @Publisher annotations.

## Repositories
The two repositories reflect the two states. They are the intermediary between the States and the data layer, consisting of network service (API communication) and local storage (a local data base, in this case core data). 

## Local Storage / Network Service
In this project no real network service was implemented, however in order to show how network services would integrate into the architecture AppDataNetworkService and BaseNetworkService were created. AppDataNetworkService loads the license data from a json file - in real life this would come from an API. UserNetworkService would handle the pilot registration, login, logout, etc. with another API.
To show how Local Storage would work, AppDataLocalStorageService was implemented. It saves and loads license data into a CoreData database. 
 
## Protocols
In order to increase overview and to make everything testable, protocols were used for Network Services, Local Storage Services and Repositories. Due to the protocols the Service and Repository classes can be easily mocked.

## Navigation
The Navigation was kept simple - the Registration Flow is embedded in a Navigation Stack. In a full app it would be presented as a fullscreen cover and dismissed again after the Confirmation Screen. The logout functionality would be moved to a different part of the app (not inside of a flow).

## Folder Structure
The project is organized based on clean architecture with:

- Domain Layer: Entities
- Data Layer: Services (network / local storage) and repositories
- Presentation Layer: Views, view models, and states

Additionally there is a folder for Utils and Extensions, a folder for resources like the String Catalogue, the JSON with the license data and Assets like images, etc. Last but not least there is a Modules folder that hosts internal libraries that are used to make the app more modular.


# Testing
## Unit Tests
Swift's new Testing framework was used as it is much leaner then the older XCTest framework. 

Both repositories, the AppState, the LocalStorageService and the string extensions were tested. NetworkServices and the LocalStorageService were mocked and injected easily into the repositories due to the usage of protocols. Inside of the mocks there is always a bool to influence the method's outcome, a success result and an error result which will be returned / thrown based on the boolean. Inside the actual test classes there usually is a failure and a success test in order to check all possible outcomes.

## UI Tests
XCTest was used for UI testing. The implemented UI test has the benefit of being both - a UI test and an integration test as it tests the whole registration flow including logout.

# Libraries
## UIComponents
The UIComponents library was created to demonstrate how the app could be more modular. It contains a reusable component (the StandardButton) and also design related data like UIConstants and Colors. 
In a full app this would be the place for a design library that could also be reused in other projects. 


# UI Framework
SwiftUI was chosen as it is fast to implement, easy to read and fast to adapt. It allows to easily access data by using environments / observable classes.


# Localization
Localization via String Catalogue was added although there is only one language, as it allowed to concentrate all strings at a central point. Like this the views only know references to the string catalogue and there is a single source of truth for string management and translation. 
