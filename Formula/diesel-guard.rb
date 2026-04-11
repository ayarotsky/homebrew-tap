class DieselGuard < Formula
  desc "Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents downtime caused by unsafe schema changes."
  homepage "https://github.com/ayarotsky/diesel-guard"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.10.0/diesel-guard-aarch64-apple-darwin.tar.xz"
      sha256 "92cdd9a8b69f52c66cdfe2a761d4fd9e27e6d018de0a5308488cb9dbf66c4cfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.10.0/diesel-guard-x86_64-apple-darwin.tar.xz"
      sha256 "6acd1dd0445cbabce471176139f0a1f09ae06b8f21289a34c374dfb5d82b282e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.10.0/diesel-guard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9415b596b8860373fc2fb7566fa628f7bfab9190e652fc7007e8276bee5be47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.10.0/diesel-guard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "714db64518bb31135664ae1c70fbf8f813c3d34c1504ca72afa319eadbcb50c0"
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
