# Starup
Starup is an iOS app that connects startups, investors and collaborators

Original App Design Project 

## Table of Contents
1. [Installation](#Installation)
2. [Overview](#Overview)
3. [Features](#Features)
4. [Screenshots and Demo](#Screenshots-and-Demo)
5. [Product Spec](#Product-Spec)
6. [Wireframes](#Wireframes)
7. [Schema](#Schema)

## Installation
1. Clone this github repository on your local machine
`git clone git@github.com:marriagav/starup.git`
2. Go to the `starup` directory with the command `cd starup`
3. Open the project in xcode by running the command `open starup.xcworkspace/`
4. Add the Keys.plist file to the project, with the following keys of the API's (their values are also needed):
    - parseAppID
    - parseClientKey
    - paypalClientID
    - linkedinAppID
    - linkedinSecret
5. Add the GoogleService-Info.plist file to the project
6. Run the project from xcode

*NOTE: installing the pods through the podfile is not necessary, as they're already included in the repository.*

## Overview
### Description
Starup is an application that allows startups to connect with investors and independent workers. There are three user roles in this app:
- Ideators: can post information about their startups and network for "sharks" or "hackers".
- Sharks: can scroll and search for different startups, connecting with "ideators" and potentially investing in their startups.
- Hackers: similarly to sharks, they can search for startups, but rather than investing in them, they can apply to join the project as independent workers.

### App Evaluation

- **Category:** buissness and employment.
- **Mobile:** it will be a mobile experience, from their phones, users will have access to all the funcitonality of the app.
- **Story:** allows startups to grow, as well as offering users opportunities to invest.
- **Market:** anyone that falls into either of these three categories: has any startup ideas, has any skills and interest to participate in a startup, has interest and means to invest in a startup.
- **Habit:** ideators can post as many startup ideas as they want, hackers and sharks can explore endless startups in any category or buissness that exists.
- **Scope:** it is planned to start as a simple app where networking happens around startups, just posting and connecting people.

## Features

**SDK/Database integration**
- Integrated Parse as the main database for my project, designing the database and storing users, posts, connections and starups.
- Integrated Firebase as a secondary database for messaging, using the ChatsSDK (https://chatsdk.co/).
- Linkedin Integration (https://github.com/marriagav/starup/pull/28)
    - Implemented sign in with Linkedin functionality, were the user can authenticate themselves, with the use of the Linkedin API, in order to create their Starup account.
        * This feature also allows users to use their Linkedin names and profile pictures when they log in with Linkedin.
    * Paypal integration (https://github.com/marriagav/starup/pull/29)
        * Added PayPal integration so that users can make investments through the Paypal API, using the sandbox environment and a sandbox account.

**Difficult/ Ambiguous Technical Problems:**
- If a user has Linkedin authentication, they will be able to post both on Starup and on Linkedin if they wish to do so.
- Messages (https://github.com/marriagav/starup/pull/39)
    - Users can manage their conversations: add users, remove users, delete messages, delete conversations, etc.
    - After a new starup is created, a groupchat will be automatically created with all the members of that starup.
* Search (https://github.com/marriagav/starup/pull/31)
    * Built a graph data structure in the server to measure "closeness" between users.
    * User search is reusable (everything goes through the same graph) and It has been added on two view controllers: the profile view controller and the add collaborator view controller.
    * When the user makes a search, a local graph will be traversed looking for users that match the search.
    * Sectioning: in which "recommended" means people that are really close to you, "you may know" is people somewhat close to you and "discover" is people you don't have any type of connection with.

**Visuals and interactions**
- Added a gesture recognizer (https://github.com/marriagav/starup/pull/38) so that users can add collaborators to their starups more easily
- Created my own icons and logo (https://github.com/marriagav/starup/pull/42/files) for the app.
- Starups investment bar is animated.
- Added a MBProgressHUD (https://github.com/jdg/MBProgressHUD) for when the user is performing network requests.

## Screenshots and Demo

**Find the demo here:** video [demo](https://github.com/marriagav/starup/blob/main/demo/Full-demo.mp4)

**Screenshots**

<img src="https://user-images.githubusercontent.com/65412950/183216212-d6fab24b-807b-41af-9e89-bd6b389bcc34.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216218-c8476b85-e3a5-4d32-975b-fed17f29f1b1.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216220-746fa888-b3ec-42d2-8cb1-bab6ed910371.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216223-10a133ce-e36a-4412-8921-0129b17286de.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216224-c116a47c-38ad-4344-b60d-a7fc3164c51c.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216227-032cd88b-9fec-469d-b241-33274b769405.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216229-869299e7-34cc-451e-af29-35cb532a76ee.png" width=300>

<img src="https://user-images.githubusercontent.com/65412950/183216233-147b03bf-662c-4584-8390-ef4103104d90.png" width=300>

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Profile creation / authentification
* Being able to post and navigate startups
* Login and signup
* Being able to click on a startup to see its details and interact with it
* Persistent storage of users session
* Profile view: clicking on a user to see their profile
* Being able to see what other people are posting and make posts yourself
* Invest in a starup with Paypal
* Connecting the app to the Linkedin API.
* Search bar to filter users when adding them to a Starup

**Optional Nice-to-have Stories**

* Search bar to filter startups
* Search bar to filter posts
* Edit starups to add new collaborators to them
* Messaging functionality

### 2. Screen Archetypes

* Login screen
   * Profile creation / authentification
   * Login and signup
   * Persistent storage of users session
* Home feed
   * Being able to see what other people are posting (statuses)
   * Search bar to filter posts
* Compose post
   * Being able to make a status post
* Starups tab
   * Being able to navigate startups
* Details tab
   * Being able to see more information about a startup
   * See the current investment of the starup
* Invest tab
    * Select amount to invest and invest
    * Invest on a specific starup
* Compose starup 
    * Post a new startup
* Profile tab
    * See and edit your profile
    * See other profiles

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home feed 
* Starups tab
* Profile tab

**Flow Navigation** (Screen to Screen)

* Login screen
   * Home feed 
* Home feed
   * Compose post (tap on new post button)
   * Profile tab (tap on profile pictures)
* Compose post
    * Home feed 
* Starups tab
    * Details tab (tap on post)
    * Compose starup tab (tap on new starup button)
* Compose starup tab 
    * Starups tab
* Details tab
    * Profile tab (tap on profile pictures)
    * Invest tab (tap on invest button)
* Profile tab
    * Details tab (tap on starup)

### Wireframes & Mockups

##### Login screen

<img src="https://user-images.githubusercontent.com/65412950/177387710-501b644f-82bd-46a6-9878-afdbbe46d7c0.png" width=300>

#### Home feed

<img src="https://user-images.githubusercontent.com/65412950/177387905-1892d879-6d04-4377-b1ba-7b60f25ccc23.png" width=300>

#### Starups tab

<img src="https://user-images.githubusercontent.com/65412950/177387962-04c02df5-6c3e-43e0-8863-8a5a30ff68e7.png" width=300>

#### Profile tab

<img src="https://user-images.githubusercontent.com/65412950/177387993-619cf10d-56af-4c90-b698-51417f161cd8.png" width=300>

#### Compose post

<img src="https://user-images.githubusercontent.com/65412950/177388037-f5bf39de-7f35-4c96-bcbc-40930a96b15e.png" width=300>

#### Details tab

<img src="https://user-images.githubusercontent.com/65412950/177425096-cddab20d-15f5-4223-a199-04d522be8d87.png" width=300>

#### Compose starup

<img src="https://user-images.githubusercontent.com/65412950/177429942-7f4281e1-2a6b-408f-8cc2-5c120e90ef1b.png" width=300>

#### Invest tab

<img src="https://user-images.githubusercontent.com/65412950/177430007-f2700cc9-eebd-40cb-89d1-b6716499d4b3.png" width=300>

### Interactive Prototype

[Prototype](https://www.figma.com/proto/my8dsbhEzQgZEqM46oi4gx/Untitled?node-id=2%3A2&scaling=scale-down&page-id=0%3A1&starting-point-node-id=2%3A2&show-proto-sidebar=1)

## Schema 

### Models

#### Model: User 
| Property | Type | Description |
| :---:         |     :---:      |          :--- |
| objectId   | string     | unique id for the user    |
| createdAt   | DateTime     | date when user was created    |
| updatedAt   | DateTime     | date when user was updated    |
| username     | string       | unique username of the user      |
| firstName     | string       | first name of the person that owns that profile      |
| lastName     | string       | last name of the person that owns that profile      |
| profilePicture     | string       | name of the person that owns that profile      |
| userBio     | string       | user biography      |
| userRole     | string       | short user role to show beneath their profile (For example: iOS software engineer)      |
| password     | string       | password for login      |
| email     | string       | user email      |

#### Model: Collaborator (catalogue)
| Property | Type | Description |
| :---         |     :---:      |          :--- |
| objectId   | string     | unique id for the collaborator    |
| createdAt   | DateTime     | date when collaborator was created    |
| updatedAt   | DateTime     | date when collaborator was updated    |
| user    | pointer to user       | the user that participates in the starup      |
| starup     | pointer to starup       | starup in which the user participates      |
| role     | string       | role that the user has in that starup (shark, ideator, hacker)      |

#### Model: Starup
| Property | Type | Description |
| :---         |     :---:      |          :--- |
| objectId   | string     | unique id for the starup    |
| createdAt   | DateTime     | date when starup was created    |
| updatedAt   | DateTime     | date when starup was updated    |
| starupName     | string       | the name of the starup      |
| starupDesc     | string       | description of the starup      |
| starupCategory     | string       | category of the starup (for example: software, design, etc.)      |
| operatingSince     | DateTime       | Date when the starup started operating      |
| sales     | number       | amount of money that the starup has generated in USD      |
| goalInvestment     | number       | goal investment amount in usd      |
| currentInvestment     | number       | current investment amount in usd      |
| ownershipPercentForInvestment     | number       | percentage of the company to give in exchange for the goal investment amount      |
| imageOfStarup     | file       | image of the starup      |

#### Model: Post
| Property | Type | Description |
| :---         |     :---:      |          :--- |
| objectId   | string     | unique id for the post    |
| createdAt   | DateTime     | date when post was created    |
| updatedAt   | DateTime     | date when post was updated    |
| updateStatus   | string     | update status of the post (for example: "looking for starups", "posted a new starup", "invested in a starup"    |
| contentOfPost   | string     | text content of the post   |

#### Model: UserConnection
| Property | Type | Description |
| :---         |     :---:      |          :--- |
| objectId   | string     | unique id for the UserConnection    |
| createdAt   | DateTime     | date when UserConnection was created    |
| updatedAt   | DateTime     | date when UserConnection was updated    |
| closeness   | number     | closeness value between the two users    |
| userTwo   | pointer to user     | pointer to one of the users   |
| userOne   | pointer to user     | pointer to the other of the users   |

### Networking

#### Screen: Login
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Create   | POST     | create a new user/registration    |
| Read   | GET     | login the user    |

#### Screen: Homefeed
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Read   | GET     | get the latest posts    |

#### Screen: Starups tab
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Read   | GET     | get the latest starups    |

#### Screen: Profile tab
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Read   | GET     | get the user information    |
| Update   | PUT     | edit the user information    |

#### Screen: Compose post
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Create   | POST     | post the post    |


#### Screen: Compose starup
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Create   | POST     | post the starup    |


#### Screen: Details tab
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Read   | GET     | get the starup information    |

#### Screen: Invest tab
| CRUD | HTTP Verb | Description |
| :---         |     :---:      |          :--- |
| Read   | GET     | get the starup information    |
| Update   | PUT     | make an investment    |

