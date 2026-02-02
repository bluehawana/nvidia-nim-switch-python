class CcNvd < Formula
  desc "Enhanced NVIDIA NIM proxy with dynamic model switching capabilities"
  homepage "https://github.com/your-username/cc-nvd"
  url "https://github.com/your-username/cc-nvd/archive/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"

  depends_on "python@3.10"
  depends_on "uv" => :recommended

  def install
    # Install Python dependencies using uv
    system "uv", "sync", "--frozen"

    # Install the package
    prefix.install "config", "api", "providers", "static", "server.py", "nvidia_nim_models.json"

    # Create executable script
    (bin/"cc-nvd").write <<~EOS
      #!/bin/bash
      cd "#{prefix}"
      exec uv run python3 server.py "$@"
    EOS

    # Make executable
    chmod "+x", bin/"cc-nvd"
  end

  def post_install
    # Create default config if it doesn't exist
    config_dir = Pathname.new("~/.config/cc-nvd").expand_path
    config_dir.mkpath unless config_dir.exist?
  end

  def caveats
    <<~EOS
      🚀 cc-nvd (Claude Code - NVIDIA Dynamic) installed successfully!

      To start the server:
        cc-nvd serve

      Web interface will be available at:
        http://localhost:8082/

      API documentation:
        http://localhost:8082/docs

      For configuration, edit:
        ~/.config/cc-nvd/.env
    EOS
  end

  test do
    # Simple test to verify installation
    assert_match "usage", shell_output("#{bin}/cc-nvd --help", 2)
  end
end