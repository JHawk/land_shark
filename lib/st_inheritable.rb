module StInheritable
  class << self
    def included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def real_self
        self.becomes(self.type.constantize)
      end

      def display_name
        self.class.
          model_name.
          human.
          split(' ').
          map(&:capitalize).
          join(' ')
      end
    end

    module ClassMethods
      def st_types
       # if subclasses.present?
       #   subclasses
       # else
          dir = "./app/models/#{self.name.downcase.pluralize}/*.rb"
          Dir[Rails.root.join(dir)].map do |d|
            begin
              subclass_name = d.split('/').
                last.
                gsub('.rb', '').
                classify
              "#{self.name.pluralize}::#{subclass_name}".constantize
            rescue
              puts "Missing #{self.name} #{d}"
            end
          end.compact
       # end
      end
    end
  end
end

