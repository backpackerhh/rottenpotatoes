module MoviesHelper
  def highlight_if_current_column(column)
    session[:sort_by] == column.to_s ? 'hilite' : nil
  end
end
