module Plugin
  module ClassMethods
    def plugins
      @plugins ||= []
    end

    def inherited(klass)
      plugins << klass
    end

    def plugin_path path = nil
      return @plugin_path if path.nil? || @plugin_path
      @plugin_path = Gem.find_files path
    end

    def load_plugins
      return unless plugins.empty?

      seen = {}

      plugin_path.each do |plugin_path|
        name = File.basename plugin_path, ".rb"

        next if seen[name]
        seen[name] = true

        require plugin_path
      end
    end
  end

  def self.included(klass)
    klass.extend ClassMethods  # Somewhat controversial
  end
end
