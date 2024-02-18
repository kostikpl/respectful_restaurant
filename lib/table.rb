class Table
  include Singleton

  def all
    @all ||= load_file_content
  end

  def load_file_content
    JSON.parse(
      File.read(Rails.root.join('json_data/tables.json'))
    )
  end
end
