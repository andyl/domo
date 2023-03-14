# Domo Devlog 

## Roadmap

Editing / Forms 
- [ ] Form for editing events (Modal?)
- [ ] Add notes to an event 
- [ ] Add projects 
- [ ] Add tags 

Database
- [ ] Tags: 
- [ ] Notes: 
- [ ] Projects: 
- [ ] CubDB: preserve counter between restarts

Testing
- [ ] Get tests for counter working 

Integration
- [ ] Get headline edit function working with PLE

UI 
- [ ] Style with Tailwind 
- [ ] Styling for narrow devices

Clients
- [ ] Cli Client 
- [ ] Flutter Client 
- [ ] Ruby Client (input & output) 
- [ ] Html Client (input & output)
- [ ] Neovim Integration
- [ ] Graphql Client

Websocket Clients
- [ ] Echo: Server, Clients (Ruby, JS, Elixir, LiveView) 
- [ ] Clock: Server, Clients (Ruby, JS, Elixir, LiveView)  
- [ ] Chat: Server, Clients (Ruby, JS, Elixir, LiveView) 

CLI Client
- [ ] Elixir Client with `phoenix_gen_socket_client` 
- [ ] Add websocket server with token auth 
- [ ] Websocket Clients: Ruby, JS, Elixir 

Registration Validation Constraints
- [ ] Unique uname 
- [ ] Unique email 
- [ ] `unsafe_validate_unique`

Production 
- [ ] Fix email sending

Tag Behavior
- [ ] Communication Prefs (phone, SMS)
- [ ] Project Prefs (github project, customer)
- [ ] Atree Prefs (which action tree)

Cleanup
- [ ] Remove V1
- [ ] Remove termato 

Features
- [ ] Add import/export

Analytics & Invoicing
- [ ] Add analytics
- [ ] Add invoice generation

Alt
- [ ] Integrate with Atree 
- [ ] Messaging Integration 

Do Not Disturb
- [ ] Phone 
- [ ] SMS 
- [ ] Email 

Apps
- [ ] Create Flutter Mobile App 
- [ ] Create Flutter Desktop App 

## 2022 Feb 17 Thu

Learnings
- new technique: creating separate copies of app under one repo
- phx.gen.socket - only works with channels (no client support)
- websockex is great

- [x] Regen App
- [x] Test phx.gen.socket 
- [x] Capture termato code
- [x] Add echo socket server
- [x] Add timer socket server
- [x] Add echo client 
- [x] Generate auth 
- [x] Generate history 

## 2022 Feb 18 Fri

- [x] Add restful routes
- [x] Get counter working 
- [x] Get Termato working 
- [x] Update Ansible to auto-install hex, rebar, ex-server, phx-new
- [x] Add Static Web Page 
- [x] Push to Github
- [x] Get counter working on static web page 

## 2022 Jun 16 Thu

- [x] Create Domo Repo 
- [x] Create Domo Umbrella App

## 2022 Jun 20 Mon

- [x] Milligram CSS 
- [x] Build Auth 

## 2022 Jun 21 Tue

- [x] Build setup 
- [x] Add timer migration 
- [x] Build timer page 

## 2022 Jun 22 Wed

- [x] Do `phoenix live_view` book 
  Generators, Forms, Modals, Function Components, Live Components, SVGs/Contex
- [x] Make liveview page  

## 2022 Jun 23 Thu

- [x] Write context functions for periods
- [x] Write liveview page for periods 

## 2022 Jun 24 Fri

- [x] Add counter GenServer
- [x] Get PubSub working 
- [x] Get period update links working 

## 2022 Jun 25 Sat

- [x] Add live title 
- [x] Add alert bell 
- [x] Use label for time-table
- [x] Update CSS formatting 

## 2022 Jun 26 Sun 

- [x] Study DateTime 
- [x] Study JS Hooks 

## 2022 Jun 27 Mon

- [x] Fix time zone
- [x] Get note edit functions working with Modal 
- [x] Get tests working with superwatch 
- [x] Refactor CTX / SCH 
- [x] Make tests for CTX
- [x] Fix alternate file nav (src/tst)
- [x] Review Ecto validations
- [x] Get note edit functions working with Modal 

## 2022 Jun 28 Tue

Deploy
- [x] Add release 
- [x] Deploy to lark 
- [x] Make flash message time-out (with fade transition)

- [x] Update title for edit modal
- [x] Hourglass Favicon: black, green, yellow, purple, red (noun project)
- [x] Fix edit screen validation erasure

## 2022 Jun 30 Thu

- [x] Try resetting favicon to black before closing 
- [x] Cleanup favicon reset logic 

## 2023 Mar 13 Mon

- [x] Phoenix 1.7 from scratch 
- [x] New auth
- [x] Get seeds working 
- [x] Add seeds to ecto.setup 
- [x] Test login 
- [x] Run mix.test 
- [x] Add migrations (intervals, periods)
- [x] New Contexts from scratch (intervals, periods)
- [x] Refactor Schemas and Contexts 
- [x] Learn SSG 
- [x] Install domo favicon
- [x] Install pocket navbar 
- [x] Install pocket page styling 
- [x] Edit home page contents 
- [x] Build wlog page 
- [x] Install table view 
- [x] Get counter-clock working 
- [x] Enable dynamic page title (countdown) 

## 2023 Mar 14 Tue

- [x] Enable dynamic favicon 
- [x] Update title and favicon for hidden tab 

## Next Steps

- [ ] Headline in title "<headline> 07m 22s"

