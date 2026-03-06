class DieselGuard < Formula
  desc "Linter for dangerous Postgres migration patterns in Diesel and SQLx"
  homepage "https://github.com/ayarotsky/diesel-guard"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-aarch64-apple-darwin.tar.xz"
      sha256 "1c4768a1434bd02901e6068c8c7c1f19854da551db5a7fe823d0e8922d237c28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-x86_64-apple-darwin.tar.xz"
      sha256 "6923aec41638ccb650562ea51db019e9add172496efeab29cc3ac28ae337cadc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df7b021f961f830ebb31c8fa6cd6d3e4bf44454b58319c568b08bdc915bf67ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.8.0/diesel-guard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84ad22041ce680060ba93c41c8ce8ab33978fe7e3ddf279d7df4cb9e3543546e"
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
