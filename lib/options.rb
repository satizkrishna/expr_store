module Options
  def self.load_options
    option_yml = (YAML::load_file "#{Rails.root}/config/options.yml")
    option_yml.map { |clazz, options|
      variable_string = ""
      options.each{ |opt_key, opt_values|
        variable_string += "#{opt_key} = {}\n"
        opt_values.map { |k,v|
          variable_string += "#{opt_key}[#{k}] = '#{v}'\n"
          variable_string += "#{v} = #{k}\n"
        }
      }
      clazz.constantize.class_eval variable_string
    }
  end
end
