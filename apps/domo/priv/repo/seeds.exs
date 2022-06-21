# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Domo.Repo.insert!(%Domo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Domo.Accounts
alias Domo.Users
alias Domo.Repo

Repo.delete_all(Accounts.User)
Repo.delete_all(Users.Interval)
Repo.delete_all(Users.Period)

Repo.insert(%Accounts.User{
  uname: "aaa",
  email: "aaa@aaa.com",
  hashed_password: Accounts.User.pwd_hash("123456789012"),
  }
)

Repo.insert(%Accounts.User{
  uname: "bbb",
  email: "bbb@bbb.com",
  hashed_password: Accounts.User.pwd_hash("123456789012"),
  }
)

Repo.insert(%Accounts.User{
  uname: "ccc",
  email: "ccc@ccc.com",
  hashed_password: Accounts.User.pwd_hash("123456789012")
  }
)
