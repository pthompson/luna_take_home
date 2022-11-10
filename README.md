# LunaTakeHome

This project is a solution for the "Build an Open Graph previewer" take home project.

The project is implemented as a Phoenix LiveView app. The primary page is a
LiveView. While LiveViews execute in their own process and, as such, don't
block any other live (or dead) views, the logic to get the og:image is
executed in a separate Oban process, so the LiveView won't be blocked either.
This could be useful if you wanted to have a cancel button or allow other
user actions while the og:image is being fetched.

The Oban process publishes the result of the lookup to a PubSub topic,
so no database is necessary to store the result. Note, Oban
does require a database for its operation.

Here is how it works:

1. Show page with form to enter URL of page to fetch og:image from.
2. When user clicks form submit button, handle_event function is called.
3. handle_event function validates the URL with a schemaless changeset.
4. If the input is valid then an Oban worker to get og:image is enqueued.
5. OG image worker fetches the page with HTTPoison and parses the
   HTML with Floki to extract the og:image (if any).
6. The result of the og image worker is published on a PubSub topic.
7. The LiveView is subscribed to the PubSub topic and gets notified of
   the result.
8. If the lookup was successful then the image is displayed in the
   LiveView, otherwise an error message is displayed.

For production, it would probably be a good idea to add a timeout using
send_after in case the og image worker never returns. Also, we would
want to add more tests.

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
