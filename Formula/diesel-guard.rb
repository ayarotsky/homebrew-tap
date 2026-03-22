class DieselGuard < Formula
  desc "Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents downtime caused by unsafe schema changes."
  homepage "https://github.com/ayarotsky/diesel-guard"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.9.0/diesel-guard-aarch64-apple-darwin.tar.xz"
      sha256 "202e186bf32c106ddd5adf96324d548b6aa7c1325d25d8f8bc85d4162fb8073f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.9.0/diesel-guard-x86_64-apple-darwin.tar.xz"
      sha256 "eafb2bdecfdaf36d4e2882f171a8565a6ff1030569946734f4306eba3e6d7cf7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.9.0/diesel-guard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95bd746b49dd3a076ab579eacd2526b333d948253b5861ab8732b5af71dd218e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.9.0/diesel-guard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80fdb5c614b4d364558532b4d7a5425026f5b9284673b487de0cf46fbc161006"
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
