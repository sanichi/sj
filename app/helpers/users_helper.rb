module UsersHelper
  def user_menu(selected)
    options_for_select(User.all.map { |u| [u.handle, u.id] }, selected)
  end
end
