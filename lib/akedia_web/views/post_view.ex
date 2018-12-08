defmodule AkediaWeb.PostView do
  use AkediaWeb, :view
  alias Akedia.Posts.PostImage
  import Scrivener.HTML

  @github_new_issue ~r/^https:\/\/github.com\/(?<user>\w+)\/(?<repo>\w+)\/issues/
  @github_issue_comment ~r/^https:\/\/github.com\/(?<user>\w+)\/(?<repo>\w+)\/issues\/(?<issue>\d+)/

  def image(post, version \\ :thumb) do
    PostImage.url({post.image, post}, version)
  end

  def is_type?(post, type \\ "note"), do: post.type === type

  def is_note?(post), do: is_type?(post)
  def is_reply?(post), do: is_type?(post, "reply")
  def is_bookmark?(post), do: is_type?(post, "bookmark")
  def is_like?(post), do: is_type?(post, "like")
  def is_article?(post), do: is_type?(post, "article")
  def is_repost?(post), do: is_type?(post, "repost")

  def has_image?(post), do: !!post.image

  def has_title?(post), do: !!post.title

  def content_class(post), do: if(has_title?(post), do: "", else: "p-name")

  def is_github_action?(post),
    do: is_github_issue_comment?(post) || is_new_github_issue?(post)

  def github_action(post) do
    cond do
      is_github_issue_comment?(post) ->
        link = safe_to_string(link("issue", to: post.in_reply_to))
        raw("commented on an #{link} on #{github_repo_name(post)}")

      is_new_github_issue?(post) ->
        link = safe_to_string(link(github_repo_name(post), to: post.in_reply_to))
        raw("created an issue on #{link}")
    end
  end

  def is_github_issue_comment?(post) do
    is_reply?(post) && Regex.match?(@github_issue_comment, post.in_reply_to)
  end

  def is_new_github_issue?(post) do
    is_reply?(post) && Regex.match?(@github_new_issue, post.in_reply_to)
  end

  def github_repo_name(post) do
    %{"user" => user, "repo" => repo} = Regex.named_captures(@github_new_issue, post.in_reply_to)
    "#{user}/#{repo}"
  end

  def ribbon(post) do
    {class, icon} =
      case post.type do
        "reply" ->
          cond do
            is_github_action?(post) -> {"is-success", "fab fa-github"}
            true -> {"is-success", "fas fa-comment"}
          end

        "like" ->
          {"is-danger", "fas fa-heart"}

        "bookmark" ->
          {"is-primary", "fas fa-bookmark"}

        "repost" ->
          {"is-warning", "fas fa-recycle"}

        "article" ->
          {"is-link", "fas fa-pen-nib"}

        _ ->
          {"is-dark", "fas fa-sticky-note"}
      end

    cond do
      is_nil(class) -> ""
      true -> raw("<div class='ribbon is-small #{class}'><i class='#{icon}'></i></div>")
    end
  end
end
