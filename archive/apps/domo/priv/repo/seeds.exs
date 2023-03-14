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

alias Domo.Ctx
alias Domo.Sch
alias Domo.Repo

Repo.delete_all(Sch.Accounts.User)
Repo.delete_all(Sch.Users.Interval)
Repo.delete_all(Sch.Users.Period)

{:ok, user1} = Repo.insert(%Sch.Accounts.User{
  uname: "aaa",
  email: "aaa@aaa.com",
  hashed_password: Sch.Accounts.User.pwd_hash("123456789012"),
  }
)

Repo.insert(%Sch.Accounts.User{
  uname: "bbb",
  email: "bbb@bbb.com",
  hashed_password: Sch.Accounts.User.pwd_hash("123456789012"),
  }
)

Repo.insert(%Sch.Accounts.User{
  uname: "ccc",
  email: "ccc@ccc.com",
  hashed_password: Sch.Accounts.User.pwd_hash("123456789012")
  }
)

Ctx.Users.start_user_period(user1.id, 5)
