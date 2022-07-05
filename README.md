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

**Optional Nice-to-have Stories**

* Connecting the app to the Linkedin API.
* Search bar to filter startups
* Search bar to filter posts

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

<img src="https://user-images.githubusercontent.com/65412950/177388066-e8714ebe-842d-4e02-8f16-ae01d6aeea8c.png" width=300>

#### Compose starup

<img src="https://user-images.githubusercontent.com/65412950/177388119-15e2f289-8f62-42b7-9057-36fb75fe49b4.png" width=300>

### Interactive Prototype

[Prototype](https://www.figma.com/proto/my8dsbhEzQgZEqM46oi4gx/Untitled?node-id=2%3A2&scaling=scale-down&page-id=0%3A1&starting-point-node-id=2%3A2&show-proto-sidebar=1)

## Schema 
[This section will be completed in Unit 9]

### Models

#### Model: User 
| Property | Type | Description |
| :---         |     :---:      |          ---: |
| objectId   | string     | unique id for the user    |
| username     | string       | unique username of the user      |
| firstName     | string       | first name of the person that owns that profile      |
| lastName     | string       | last name of the person that owns that profile      |
| profilePicture     | string       | name of the person that owns that profile      |
| userBio     | string       | user biography      |
| userRole     | string       | short user role to show beneath their profile (For example: iOS software engineer)      |
| password     | string       | password for login      |

#### Model: Collaborator (catalogue)
| Property | Type | Description |
| :---         |     :---:      |          ---: |
| collaboratorId   | number     | unique id for the collaborator    |
| user    | pointer to user       | the user that participates in the starup      |
| starup     | pointer to starup       | description of the starup      |
| starupCategory     | string       | category of the starup (for example: software, design, etc.)      |
| operatingSince     | DateTime       | Date when the starup started operating      |
| sales     | number       | amount of money that the starup has generated in USD      |
| collaborators     | array of pointers to collaborator       | collaborators that participate in that starup      |

#### Model: Starup
| Property | Type | Description |
| :---         |     :---:      |          ---: |
| starupId   | number     | unique id for the starup    |
| starupName     | string       | the name of the starup      |
| starupDesc     | string       | description of the starup      |
| starupCategory     | string       | category of the starup (for example: software, design, etc.)      |
| operatingSince     | DateTime       | Date when the starup started operating      |
| sales     | number       | amount of money that the starup has generated in USD      |
| collaborators     | array of pointers to collaborator       | collaborators that participate in that starup      |

#### Model: 
| Property | Type | Description |
| :---         |     :---:      |          ---: |
| git status   | git status     | git status    |
| git diff     | git diff       | git diff      |

### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
