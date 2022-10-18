defmodule LunaTakeHome.ValidUrl do
  @moduledoc """
  The base module of ValidUrl.

  It exposes a single function, `validate`.
  """

  # Regex to validate URLs.
  # Adapted from https://gist.github.com/dperini/729294.
  @link_regex Regex.compile!(
                # protocol identifier
                # user:pass authentication
                # IP address exclusion
                # private & local networks
                # IP address dotted notation octets
                # excludes loopback network 0.0.0.0
                # excludes reserved space >= 224.0.0.0
                # excludes network & broacast addresses
                # (first & last IP address of each class)
                # host name
                # domain name
                # TLD identifier
                # TLD may end with dot
                # port number
                # resource path
                "^" <>
                  "(?:(?:https?|ftp)://)" <>
                  "(?:\\S+(?::\\S*)?@)?" <>
                  "(?:" <>
                  "(?!(?:10|127)(?:\\.\\d{1,3}){3})" <>
                  "(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})" <>
                  "(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})" <>
                  "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" <>
                  "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" <>
                  "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" <>
                  "|" <>
                  "(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]-*)*[a-z\\x{00a1}-\\x{ffff}0-9]+)" <>
                  "(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]-*)*[a-z\\x{00a1}-\\x{ffff}0-9]+)*" <>
                  "(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,}))" <>
                  "\\.?" <>
                  ")" <>
                  "(?::\\d{2,5})?" <>
                  "(?:[/?#]\\S*)?" <>
                  "$",
                "iu"
              )

  @doc """
  Test whether a string is a valid URL.

  Regular expression-based.  Adapted from [https://gist.github.com/dperini/729294](https://gist.github.com/dperini/729294).

  Args:

  * `url` - The URL to validate, string

  Returns a boolean.
  """
  def validate(url) do
    Regex.match?(@link_regex, url)
  end
end
