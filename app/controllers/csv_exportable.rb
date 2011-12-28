require 'csv'

module CSVExportable
  def export

    respond_to do |format|
      format.csv { send_data(generate_csv, type: 'text/csv', filename: filename.underscore) }
    end
  end

  private

  def underscored_model_name
    self.class.name.sub('Controller', %q{}).underscore
  end

  def filename
    "#{underscored_model_name}.csv"
  end

  def column_names
    model.fields.collect { |field| field[0] }
  end

  def generate_csv
    scope = model.scoped
    columns = column_names

    CSV.generate do |csv|
      csv << columns
      model.all.each do |obj|
        csv << columns.map {|c| obj.public_send(c) }
      end
    end
  end
end
