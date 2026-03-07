class DieselGuard < Formula
  desc "Linter for dangerous Postgres migration patterns in Diesel and SQLx"
  homepage "https://github.com/ayarotsky/diesel-guard"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-aarch64-apple-darwin.tar.xz"
      sha256 "cd54f31ccb310cb58912e4ab82309683a0c191e973bac67064086c2af7d7b271"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-x86_64-apple-darwin.tar.xz"
      sha256 "a5bbec871139c6c4d9e323399c4e6962ab39bae56fe79f70c17c1594dd1abdb6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4fe23a5aabcc57ede8a5da219643bd3fea35313c2584a0b7e8cfd06543083338"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a79e239184f588c6033ed10ab3321e9721f22125e71369088a5763ac9b8416dc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "diesel-guard" if OS.mac? && Hardware::CPU.arm?
    bin.install "diesel-guard" if OS.mac? && Hardware::CPU.intel?
    bin.install "diesel-guard" if OS.linux? && Hardware::CPU.arm?
    bin.install "diesel-guard" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
