require 'tilt'

class FastlyVclUpload

  def self.install(vcl_path, login_opts)
    self.new(vcl_path, login_opts).install.activate!
  end

  def initialize(vcl_path, login_opts = {})
    login_opts[:api_key] ||= ENV['FASTLY_API_KEY']
    @service_name = login_opts[:service_name]
    @login_opts = login_opts
    @vcl_path = vcl_path
  end

  def fastly
    @fastly ||= Fastly.new @login_opts
  end

  def service_name
    @service_name
  end

  def service
    @service ||= fastly.search_services name: service_name
  end

  def version
    @version ||= service.version.clone
  end

  def vcls
    Dir.glob File.join(@vcl_path, "*.vcl*")
  end

  def create(name, content)
    vcl = fastly.get_vcl service.id, version.number, name
    vcl.content = content
    vcl.save!
  end

  def update(name, content)
    fastly.create_vcl(
      name: name,
      content: content,
      service_id: service.id,
      version: version.number,
      main: (name == 'main' ? true : false)
    )
  end

  def create_or_update(name, vcl_path)
    vcl_content = Tilt.new(vcl_path).render

    begin
      create name, vcl_content
    rescue Fastly::Error
      update name, vcl_content
    end
  end

  def vcl_path_to_name(vcl_path)
    vcl_path.split('/').last.split('.').first
  end

  def install
    vcls.each do |vcl_path|
      create_or_update vcl_path_to_name(vcl_path), vcl_path
    end
    self
  end

  def activate!
    print "Trying to activate version #{version.number} "
    version.activate!
    print "\033[32m✓\033[0m\n"
    self
  end
end