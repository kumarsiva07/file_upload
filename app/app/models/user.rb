class User < Mysql::Base

  attr_accessor :id, :name, :email, :updated_at, :created_at

  def save
    q = if id.nil?
              "INSERT INTO users (name, email, created_at, updated_at) VALUES ('#{name}', '#{email}', '#{Time.now}', '#{Time.now}')"
            else
              "UPDATE users SET name = '#{name}', email = '#{email}', updated_at = '#{Time.now} WHERE id = #{id})"
            end
    self.id = execute(q)
  end

  def self.find(id)
    q = "SELECT * FROM users WHERE id = #{id})"
    query(q)
  end

  def destroy
    q = "DELETE FROM users WHERE id = #{self.id}"
    query(q)
  end

end
