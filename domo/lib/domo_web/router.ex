defmodule DomoWeb.Router do
  use DomoWeb, :router

  import DomoWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DomoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DomoWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/count", PageController, :count
  end

  scope "/tlog", DomoWeb do
    pipe_through [:browser, :require_authenticated_user]
    live "/", TlogLive, :index
    live "/:id/edit", TlogLive, :edit
  end

  scope "/wlog", DomoWeb do
    pipe_through [:browser, :require_authenticated_user]
    live "/", WlogLive, :index
    live "/:id/edit", WlogLive, :edit
  end

  # scope "/base", DomoWeb do
  #   pipe_through :browser
  #   get "/",               BaseController, :secs
  #   get "/raw",            BaseController, :secs
  #   get "/mins",           BaseController, :mins
  #   get "/secs",           BaseController, :secs
  #   get "/secs_to_s",      BaseController, :secs_to_s
  #   get "/decrement",      BaseController, :decrement
  #   get "/set_secs/:secs", BaseController, :set_secs
  #   get "/set_mins/:mins", BaseController, :set_mins
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:domo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DomoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", DomoWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{DomoWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", DomoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{DomoWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", DomoWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{DomoWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
