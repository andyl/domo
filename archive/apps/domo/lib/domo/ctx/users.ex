defmodule Domo.Ctx.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Domo.Repo

  alias Domo.Sch.Users.Period

  @doc """
  Get all periods for a user.
  """
  def get_user_period(user_id, seq) when is_integer(user_id) do
    qry = from p in Period, where: p.user_id == ^user_id and p.sequence == ^seq, limit: 1
    Repo.one(qry)
  end

  @doc """
  Get all periods for a user.
  """
  def get_user_periods(user_id) when is_integer(user_id) do
    query = from p in Period, where: p.user_id == ^user_id, order_by: [desc: :id]
    Repo.all(query)
  end

  @doc """
  Starts a period for a user.

  The newly started
  """
  def start_user_period(user_id, seconds) when is_integer(user_id) do
    qry1 = from p in Period, where: p.user_id == ^user_id and p.status == "active"
    Repo.update_all(qry1, set: [status: "finished", end_at: timenow()])

    max = max_sequence(user_id)

    %Period{
      user_id: user_id,
      status: "active",
      seconds: seconds,
      sequence: max + 1,
      start_at: timenow()
    }
    |> Repo.insert()
  end

  @doc """
  Ends a period for a user.
  """
  def end_user_period(user_id) when is_integer(user_id) do
    query = from p in Period, where: p.user_id == ^user_id
    Repo.all(query)

  end

  @doc """
  Update a period for a user.
  """
  def update_user_period(user_id, sequence, args) when is_integer(user_id) do
    qry1 = from p in Period, where: p.user_id == ^user_id and p.sequence == ^sequence
    Repo.update_all(qry1, set: klist(args))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking period changes.

  ## Examples

      iex> period_changeset(period)
      %Ecto.Changeset{data: %Period{}}

  """
  def period_changeset(%Period{} = period, attrs \\ %{}) do
    Period.changeset(period, attrs)
  end

  # ----- helpers

  defp klist(ele) when is_map(ele) do
    Enum.map(ele, fn({key, value}) -> {String.to_existing_atom(key), value} end)
  end

  defp klist(lst) when is_list(lst) do
    lst
  end

  defp timenow do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end

  defp max_sequence(user_id) do
    qry = from p in Period, where: p.user_id == ^user_id, select: [:sequence], order_by: [desc: :id], limit: 1
    result = Repo.one(qry)
    case result do
      nil -> 0
      record -> Map.get(record, :sequence) || 1
    end
  end

  # @doc """
  # Gets a user by email and password.
  #
  # ## Examples
  #
  #     iex> get_user_by_email_and_password("foo@example.com", "correct_password")
  #     %User{}
  #
  #     iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
  #     nil
  #
  # """
  # def get_user_by_email_and_password(email, password)
  #     when is_binary(email) and is_binary(password) do
  #   user = Repo.get_by(User, email: email)
  #   if User.valid_password?(user, password), do: user
  # end
  #
  # @doc """
  # Gets a single user.
  #
  # Raises `Ecto.NoResultsError` if the User does not exist.
  #
  # ## Examples
  #
  #     iex> get_user!(123)
  #     %User{}
  #
  #     iex> get_user!(456)
  #     ** (Ecto.NoResultsError)
  #
  # """
  # def get_user!(id), do: Repo.get!(User, id)
  #
  # ## User registration
  #
  # @doc """
  # Registers a user.
  #
  # ## Examples
  #
  #     iex> register_user(%{field: value})
  #     {:ok, %User{}}
  #
  #     iex> register_user(%{field: bad_value})
  #     {:error, %Ecto.Changeset{}}
  #
  # """
  # def register_user(attrs) do
  #   %User{}
  #   |> User.registration_changeset(attrs)
  #   |> Repo.insert()
  # end
  #
  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking user changes.
  #
  # ## Examples
  #
  #     iex> change_user_registration(user)
  #     %Ecto.Changeset{data: %User{}}
  #
  # """
  # def change_user_registration(%User{} = user, attrs \\ %{}) do
  #   User.registration_changeset(user, attrs, hash_password: false)
  # end
  #
  # ## Settings
  #
  # @doc """
  # Returns an `%Ecto.Changeset{}` for changing the user email.
  #
  # ## Examples
  #
  #     iex> change_user_email(user)
  #     %Ecto.Changeset{data: %User{}}
  #
  # """
  # def change_user_email(user, attrs \\ %{}) do
  #   User.email_changeset(user, attrs)
  # end
  #
  # @doc """
  # Emulates that the email will change without actually changing
  # it in the database.
  #
  # ## Examples
  #
  #     iex> apply_user_email(user, "valid password", %{email: ...})
  #     {:ok, %User{}}
  #
  #     iex> apply_user_email(user, "invalid password", %{email: ...})
  #     {:error, %Ecto.Changeset{}}
  #
  # """
  # def apply_user_email(user, password, attrs) do
  #   user
  #   |> User.email_changeset(attrs)
  #   |> User.validate_current_password(password)
  #   |> Ecto.Changeset.apply_action(:update)
  # end
  #
  # @doc """
  # Updates the user email using the given token.
  #
  # If the token matches, the user email is updated and the token is deleted.
  # The confirmed_at date is also updated to the current time.
  # """
  # def update_user_email(user, token) do
  #   context = "change:#{user.email}"
  #
  #   with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
  #        %UserToken{sent_to: email} <- Repo.one(query),
  #        {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
  #     :ok
  #   else
  #     _ -> :error
  #   end
  # end
  #
  # defp user_email_multi(user, email, context) do
  #   changeset =
  #     user
  #     |> User.email_changeset(%{email: email})
  #     |> User.confirm_changeset()
  #
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:user, changeset)
  #   |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  # end
  #
  # @doc """
  # Delivers the update email instructions to the given user.
  #
  # ## Examples
  #
  #     iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
  #     {:ok, %{to: ..., body: ...}}
  #
  # """
  # def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
  #     when is_function(update_email_url_fun, 1) do
  #   {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")
  #
  #   Repo.insert!(user_token)
  #   UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  # end
  #
  # @doc """
  # Returns an `%Ecto.Changeset{}` for changing the user password.
  #
  # ## Examples
  #
  #     iex> change_user_password(user)
  #     %Ecto.Changeset{data: %User{}}
  #
  # """
  # def change_user_password(user, attrs \\ %{}) do
  #   User.password_changeset(user, attrs, hash_password: false)
  # end
  #
  # @doc """
  # Updates the user password.
  #
  # ## Examples
  #
  #     iex> update_user_password(user, "valid password", %{password: ...})
  #     {:ok, %User{}}
  #
  #     iex> update_user_password(user, "invalid password", %{password: ...})
  #     {:error, %Ecto.Changeset{}}
  #
  # """
  # def update_user_password(user, password, attrs) do
  #   changeset =
  #     user
  #     |> User.password_changeset(attrs)
  #     |> User.validate_current_password(password)
  #
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:user, changeset)
  #   |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{user: user}} -> {:ok, user}
  #     {:error, :user, changeset, _} -> {:error, changeset}
  #   end
  # end
  #
  # ## Session
  #
  # @doc """
  # Generates a session token.
  # """
  # def generate_user_session_token(user) do
  #   {token, user_token} = UserToken.build_session_token(user)
  #   Repo.insert!(user_token)
  #   token
  # end
  #
  # @doc """
  # Gets the user with the given signed token.
  # """
  # def get_user_by_session_token(token) do
  #   {:ok, query} = UserToken.verify_session_token_query(token)
  #   Repo.one(query)
  # end
  #
  # @doc """
  # Deletes the signed token with the given context.
  # """
  # def delete_session_token(token) do
  #   Repo.delete_all(UserToken.token_and_context_query(token, "session"))
  #   :ok
  # end
  #
  # ## Confirmation
  #
  # @doc """
  # Delivers the confirmation email instructions to the given user.
  #
  # ## Examples
  #
  #     iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :edit, &1))
  #     {:ok, %{to: ..., body: ...}}
  #
  #     iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :edit, &1))
  #     {:error, :already_confirmed}
  #
  # """
  # def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
  #     when is_function(confirmation_url_fun, 1) do
  #   if user.confirmed_at do
  #     {:error, :already_confirmed}
  #   else
  #     {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
  #     Repo.insert!(user_token)
  #     UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
  #   end
  # end
  #
  # @doc """
  # Confirms a user by the given token.
  #
  # If the token matches, the user account is marked as confirmed
  # and the token is deleted.
  # """
  # def confirm_user(token) do
  #   with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
  #        %User{} = user <- Repo.one(query),
  #        {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
  #     {:ok, user}
  #   else
  #     _ -> :error
  #   end
  # end
  #
  # defp confirm_user_multi(user) do
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:user, User.confirm_changeset(user))
  #   |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  # end
  #
  # ## Reset password
  #
  # @doc """
  # Delivers the reset password email to the given user.
  #
  # ## Examples
  #
  #     iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
  #     {:ok, %{to: ..., body: ...}}
  #
  # """
  # def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
  #     when is_function(reset_password_url_fun, 1) do
  #   {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
  #   Repo.insert!(user_token)
  #   UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  # end
  #
  # @doc """
  # Gets the user by reset password token.
  #
  # ## Examples
  #
  #     iex> get_user_by_reset_password_token("validtoken")
  #     %User{}
  #
  #     iex> get_user_by_reset_password_token("invalidtoken")
  #     nil
  #
  # """
  # def get_user_by_reset_password_token(token) do
  #   with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
  #        %User{} = user <- Repo.one(query) do
  #     user
  #   else
  #     _ -> nil
  #   end
  # end
  #
  # @doc """
  # Resets the user password.
  #
  # ## Examples
  #
  #     iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
  #     {:ok, %User{}}
  #
  #     iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
  #     {:error, %Ecto.Changeset{}}
  #
  # """
  # def reset_user_password(user, attrs) do
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
  #   |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{user: user}} -> {:ok, user}
  #     {:error, :user, changeset, _} -> {:error, changeset}
  #   end
  # end
end
