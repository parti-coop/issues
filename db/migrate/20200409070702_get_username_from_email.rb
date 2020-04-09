class GetUsernameFromEmail < ActiveRecord::Migration[5.2]
  def up
    User.all.each do |user|
      user.update(name: user.email.split('@').first)
    end
  end

  def down
    User.all.each do |user|
      user.update(name: nil)
    end
  end
end
