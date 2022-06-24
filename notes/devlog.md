# Domo Devlog 

## Roadmap

Basics
- [ ] `phoenix_live_editable`

Basics
- [ ] Underline on date boundaries 
- [ ] Add colored favicons (green, yellow, magenta, red)

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

## Next Steps

- [ ] Write liveview page for periods 
- [ ] Get period update links working 
- [ ] Get period edit functions working with PLE
- [ ] Get tests working with superwatch 

- [ ] Get client working  

- [ ] Add release 

- [ ] Get tests for counter working 
- [ ] Remove V1
- [ ] Remove termato 

