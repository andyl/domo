# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

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
