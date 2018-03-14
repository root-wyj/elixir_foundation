defmodule Convert do
  @moduledoc """
  Convert keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """


  def convert(%{type: "doc"}=msg), do: Convert.WORD2PDF.convert(msg)
  def convert(%{type: "docx"}=msg), do: Convert.WORD2PDF.convert(msg)
  def convert(%{type: "pdf"}=msg), do: Convert.PDF2HTML.convert_pre(msg)
  def convert_page(%{type: "pdf", page: page}=msg), do: Convert.PDF2HTML.convert_page(msg)
  def convert(msg), do: {:error, %{reason: "not support"}}
  
end
