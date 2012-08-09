# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # 这个是 Rails 提供的可暴露外更新使用的字段, 与 ruby 本身提供的 attr_accessor/ att_reader/ attr_writer 有区别
  attr_accessible :email, :name
end
