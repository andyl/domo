# Domo Devlog 

## Roadmap

Basics
- [ ] `phoenix_live_editable`

Styling 
- [ ] Add JS effect to link (25 mins / 15 mins / 5 mins / 5 secs)
- [ ] Copy timer styles from TERMATO

Basics
- [ ] Underline on date boundaries 
- [ ] Add colored favicons (green, yellow, magenta, red)

Features
- [ ] Use UTC time in database / adjust for local TZ 
- [ ] Add an archive feature 

History
- [ ] Add comments to History (Tags, Title, Date, Remaining, Reset, Notes)
- [ ] Server support 
- [ ] Ruby Client (input & output) 
- [ ] Html Client (input & output)
- [ ] Neovim Integration

Websocket Demos
- [ ] Echo: Server, Clients (Ruby, JS, Elixir, LiveView) 
- [ ] Clock: Server, Clients (Ruby, JS, Elixir, LiveView)  
- [ ] Chat: Server, Clients (Ruby, JS, Elixir, LiveView) 

Analytics & Invoicing
- [ ] Add analytics
- [ ] Add invoice generation

Alt
- [ ] Integrate with Atree 
- [ ] Messaging Integration 

CLI 
- [ ] Elixir Client with `phoenix_gen_socket_client` 
- [ ] Add websocket server with token auth 
- [ ] Websocket Clients: Ruby, JS, Elixir 

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

## Next Steps

- [ ] Update CSS formatting 
- [ ] Fix time zone

- [ ] Get tests working with superwatch 
- [ ] Get tests for counter working 

- [ ] Add release 
- [ ] Deploy to lark 

- [ ] Get period edit functions working with PLE

- [ ] Get client working  

- [ ] Remove V1
- [ ] Remove termato 

