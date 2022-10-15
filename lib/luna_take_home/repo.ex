defmodule LunaTakeHome.Repo do
  use Ecto.Repo,
    otp_app: :luna_take_home,
    adapter: Ecto.Adapters.Postgres
end
