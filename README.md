# Starup
Starup is an iOS app that connects startups, investors and collaborators

Original App Design Project 

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Starup is an application that allows startups to connect with investors and independent workers. There are three type of users in this app:
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
* Invest in a starup

**Optional Nice-to-have Stories**

* Connecting the app to the Linkedin API.
* Search bar to filter startups
* Search bar to filter posts
* Edit starups to add collaborators to them

### 2. Screen Archetypes

* Login screen
   * Profile creation / authentification
   * Login and signup
   * Persistent storage of users session
* Home feed
   * Being able to see what other people are posting (statuses)
   * Search bar to filter posts
* Compse post feed
   * Being able to make a status post
* Starups tab
   * Being able to navigate startups
* Details tab
   * Being able to see more information about a startup
* Invest/contact tab
    * Invest or contact a specifi starup
* Compose starup 
    * Post a new startup
* Profile tab
    * See and edit your profile
    * See other profiles
* Invest/contact tab
    * See the current investment of the starup
    * Select amount to invest and invest

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
    * Invest/contact tab (tap on invest/contact button)
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
[This section will be completed in Unit 9]

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
| collaborators     | array of pointers to collaborator       | collaborators that participate in that starup      |
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

- [Create basic snippets for each Parse network request] - pending
- [OPTIONAL: List endpoints if using existing API such as Yelp] - pending with linkedin api
