defmodule SmallUrlWeb.ErrorView do
  use SmallUrlWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # def render("400.html", _assigns) do
  #   "Omegalulz Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("400.json", _conn) do
		%{code: 400, message: "invalid request"}
	end

	def render("404.json", _conn) do
		%{code: 404, message: "not found"}
	end

	def render("500.json", err) do
		%{code: 500, message: "server error"}
	end

end
