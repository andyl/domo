# Domo

A Pomodoro timer app.

- multi-user
- count timers 
- web-ui

## System requirements

- Ubuntu Host running 20.04
- SystemD
- Postgres (user/pass = postgres/postgres)

## Installing Development

To start your Phoenix server:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4040`](http://localhost:4040) from your browser.

## Running Tests

    > MIX_ENV=test mix do compile, ecto.create, ecto.migrate
    > mix test

## Installing Production

- Clone the repo
- Setup Release

    > MIX_ENV=prod mix do deps.get, compile, phx.digest 
    > MIX_ENV=prod mix do setup, release

- Start the release
- Browse to `locahost:5050`

## Using SystemD

Create the database and run the migrations.  Then:

- edit the SystemD service file in `rel/domo.service`
- `sudo cp rel/domo.service /etc/systemd/system`
- `sudo chmod 644 /etc/systemd/system/domo.service`

Start the service with SystemD

- `sudo systemctl start domo`
- `sudo systemctl status domo`
- `sudo systemctl restart domo`
- `sudo systemctl stop domo`
- `sudo journalctl -u domo -f`

Make sure your service starts when the system reboots

- `sudo systemctl enable domo`

Reboot and test!

