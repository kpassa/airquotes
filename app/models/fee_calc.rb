class FeeCalc < ActiveRecord::Base

  has_many :source_rows, :dependent => :destroy
  belongs_to :product

  has_attached_file :spreadsheet
  
  validates :product_id, :presence => true

  validates_attachment_presence :spreadsheet

  after_save :process_excel_file

  serialize :table_vars

  def to_s
    product.to_s
  end

  def self.complete?
    for p in Product.all
      return false unless p.fee_calc
    end
    true
  end

  class << self

    # coords are like "2a" or "3c"
    # indices are (i,j) pairs like [2,1] or [3,2]
    # coords2indices( "2a" ) => [1, 0]

    def coords2indices(coords)
      if /(?<row>\d+)(?<col>[a-z])/ =~ coords
        i = row2i(row)
        j = col2j(col)
        return i, j
      else
        nil
      end
    end

    # indices2coords( 1,0 ) => "2a"

    def indices2coords(i,j)
      row = i2row(i)
      col = j2col(j)
      "#{row}#{col}"
    end

    def row2i(row)
      row.to_i-1
    end

    def i2row(i)
      i+1
    end

    def col2j(col)
      ('a'..'z').to_a.index(col)
    end

    def j2col(j)
      ('a'..'z').to_a[j]
    end

    # extracts vars in a string
    # vars_in( "a <b> c d <e>" ) => [ "b", "e" ]
    # variables can only have word characters (a-z, digits, underscore).

    def vars_in(string)
      rest = string
      vars = []
      while /<(?<var>\w+)>/ =~ rest
        vars << var
        rest = $~.post_match
      end
      vars
    end
  end

  # Expands the table variables for coords into querystring-like name=value pairs,
  # the way they are serialized in SourceRow.

  def var_string( coords, params )
    vars = table_vars[coords]
    if vars
      str = vars.sort.inject( '' ) { | str, e | str + "#{e}=#{params[e] ? params[e] : 1}&" }
      str.chop!
      str
    end
  end

  # Returns index in data table of the first column whose value is
  # available in table_vars.

  def j0( i, j )
    k = 0
    while k <= j
      break if table_vars[self.class.indices2coords(i,k)]
      k+=1
    end
    k
  end

  # Column j0 returned as a letter
  def col0(coords)
    i, j = self.class.coords2indices( coords )
    j2col(j0(i,j))
  end

  # Row data for the specified coordinates and parameters
  def tr(coords,params)
    fieldstring = var_string( coords, params )
    logger.debug "#{coords}: looking for #{fieldstring}"
    col_record = source_rows.find_by_fields( fieldstring )
    col_record and col_record.columns
  end

  # Returns table html with variable replacements from params. 
  def table( params )
    html = table_html
    totals = []
    params.keys.each { |k| params[k.to_s] = params[k] }
    while /(?<lcoords>\?\d+[b-z])/ =~ html
      o = $~.offset(:lcoords)
      coords = lcoords
      coords[0] = '' # get rid of '?'
      row = tr(coords,params)
      if row
        i, j = self.class.coords2indices( coords )
        k = j - j0(i,j)
        f = row[k]
        if f
          html[o[0]..o[1]-1] = sprintf( "%.2f", f)
          totals[j] = totals[j] ? totals[j] + f : 0.0
        else
          html[o[0]..o[1]-1] = "!"
          self.errors.add(:base, "No existen datos en la tabla para '#{coords}', seria columna #{k}, #{row[0]} en #{row.columns.join(",")}")
        end
      else
        html[o[0]..o[1]-1] = "?"
        self.errors.add(:base, "No se pudo llenar '#{coords}' usando '#{var_string(coords,params)}'")
      end
    end

    # Replace the <variables> with their values from the params
    while /(?<var>&lt;(?<varname>\w+)&gt;)/ =~ html
      o = $~.offset(:var)
      if params[varname]
        html[o[0]..o[1]-1] = params[varname].to_s
      else
        html[o[0]..o[1]-1] = "?"
      end
    end

    while /\?total:(?<col>[b-z])/ =~ html
      o = $~.offset(0)
      j = self.class.col2j(col)
      html[o[0]..o[1]-1] = sprintf( "%01.2f", totals[j] || 0 )
    end
    html
  end

  private
  
  def process_excel_file
    # Only process the file if table_html is nil or if it is empty.
    return if table_html =~ /\S/

    xls_file = spreadsheet.path
    logger.info "Loading Excel file: #{xls_file}"
    spreadsheet = Spreadsheet.open( File.expand_path( xls_file ) )

    load_template_table(spreadsheet)
    gather_variables(spreadsheet)
    load_source_rows(spreadsheet)

    
  end

  def load_template_table(excel)
    self.table_html = "<table></table>"
    sheet1 = excel.worksheet(0)
    self.table_html = render_erb( "lib/table_template", { :sheet1 => sheet1, :currency => product.country.currency_symbol } )
    save!
  end

  def gather_variables(excel)
    sheet1 = excel.worksheet(0)
    vars = {}
    drows = 0  # how many data rows
    dcols = 0  # and data columns

    sheet1.each_with_index do |row, i|
      row.each_with_index do |col, j|
        coords = self.class.indices2coords( i, j )
        if col == "?"
          drows = i if i > drows
          dcols = j if j > dcols
          # look left
          k = j
          vk = []
          while k >= 0
            vk  += self.class.vars_in( row[k] )
            logger.info "variables for #{i}, #{k} and right are #{vk.join(",")}"
            k = k - 1
          end
          vars[coords] = vk.sort
        end
      end
    end

    self.table_vars = vars
    self.data_rows = drows
    self.data_cols = dcols
    
    save!
  end

  def load_source_rows(excel)
    source_rows.destroy_all
    worksheets = excel.worksheets

    worksheets.each_with_index do |sheet, s|
      next if s == 0 # Ignore the first sheet
      headings = []
      sheet.each_with_index do |row, i|
        if i == 0
          # first row contains headings
          headings = row
        else
          var_cols = row[0..headings.count-1]
          next if var_cols.include? nil
          var_cols.each_with_index do |v, d|
            var_cols[d] = v.to_i if v.class == Float
            var_cols[d] = "1" if v.class == TrueClass
            var_cols[d] = "0" if v.class == FalseClass
          end
          vars = Hash[headings.zip(var_cols)]
          field_string = vars.sort.inject('') { |str, var| str += "#{var[0]}=#{var[1]}&" }
          field_string.chop! # remove trailing '&'

          # Data columns are the ones without headings
          columns = row.to_a[headings.count..-1]
          next if columns.include? nil
          srow = source_rows.create( fields: field_string, columns: columns )

          unless srow.valid?
            if self.errors.empty?
              self.errors.add(:base, "Se encontraron algunos problemas en el archivo:" )
            end
            self.errors.add(:base, "'#{sheet.name}', fila #{i+1}: " + srow.errors.full_messages.join(",") )
          end
        end
      end
    end

  end

  # Rendering erb outside of a controller
  # This is done once as a callback after the excel file is loaded,
  # and doesn't belong in the controller code.  See
  # http://geek.swombat.com/rails-rendering-templates-outside-of-a-contro
  # for a discussion.
  def render_erb(template_path, params)  
    view = ActionView::Base.new(ActionController::Base.view_paths, {})  
  
    class << view  
      include ApplicationHelper, FeeCalcsHelper
    end  
  
    view.render(:file => "#{template_path}.html.erb", :locals => params)  
  end

end
