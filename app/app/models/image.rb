class Image < Mysql::Base

  attr_accessor :id, :file_name, :content_type, :file_size, :user_id, :created_at, :updated_at, :image

  def validate
    image_size = ImageSize.path(image.tempfile)

    raise 'invalid.file.format' unless ['jpeg', 'jpg', 'png'].include? image_size.format.downcase.to_s
    raise 'invalid.file.size' if image_size.width < 350 || image_size.width > 5000 || image_size.height < 350 || image_size.height > 5000
  end

  def self.find(id)
    q = "SELECT * FROM images WHERE id = #{id}"
    image = query(q)
    Image.new(image.first)
  end

  def destroy
    q = "DELETE FROM images WHERE id = #{self.id}"
    query(q)
    delete_file
  end

  def upload
    validate
    update_image_attributes
    q = "INSERT INTO images (file_name, content_type, file_size, user_id, created_at, updated_at) VALUES ('#{file_name}', '#{content_type}', #{file_size}, '#{user_id}', '#{Time.now}', '#{Time.now}')"
    self.id = execute(q)
    write_file
  end

  def self.all(user_id, options={})
    q = "SELECT count(*) as count FROM images"
    q = q + " WHERE user_id = #{user_id}" unless user_id.nil?
    count = query(q)
    limit = options[:limit] || 50
    offset = options[:offset] || 0
    q = "SELECT * FROM images"
    q = q + " WHERE user_id = #{user_id}" unless user_id.nil?
    q = q + " LIMIT #{limit} OFFSET #{offset}"
    images = query(q)

    { pagination: { count: count.first['count'], offset: offset, limit: limit }, images: images }
  end

  private

  def write_file
    Dir.mkdir("./uploads/#{self.id}") unless Dir.exist?("./uploads/#{self.id}")
    File.open("./uploads/#{self.id}/#{self.file_name}", 'wb') do |f|
      f.write(image.read)
    end
    self.image = nil
    true
  end

  def delete_file
    File.delete("./uploads/#{self.id}/#{self.file_name}")
  end


  def update_image_attributes
      self.content_type = image.content_type
      self.file_size = image.size
      self.file_name = image.original_filename
  end
end
