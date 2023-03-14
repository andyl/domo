defmodule Domo.Ctx.UsersTest do
  use Domo.DataCase

  alias Domo.Ctx.Users

  import Domo.AccountsFixtures

  describe "start_user_period/2" do
    test "creates a period" do
      %{id: id} = user_fixture()
      assert Users.start_user_period(id, 20)
    end
  end

  describe "get_user_periods/1" do
    test "does not return periods if they do not exist" do
      assert Users.get_user_periods(1) == []
    end

    test "returns period if it exists" do
      %{id: id} = user_fixture()
      assert Users.start_user_period(id, 20)
      assert Users.get_user_periods(id) != []
    end
  end

end
