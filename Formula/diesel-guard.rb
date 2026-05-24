class DieselGuard < Formula
  desc "Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents downtime caused by unsafe schema changes."
  homepage "https://github.com/ayarotsky/diesel-guard"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.11.0/diesel-guard-aarch64-apple-darwin.tar.xz"
      sha256 "26bb10d3a128153448be686691bd0f41cb4774dd87f5b98a9a778985754203d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.11.0/diesel-guard-x86_64-apple-darwin.tar.xz"
      sha256 "5366815a3713108524b5d211dd5c064fe3d3558124a16a30cbf159e1ce961b92"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.11.0/diesel-guard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27007efbff73c99e0ed36be2885c89c7a8094182cde435d47ec4ed94f02b61c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ayarotsky/diesel-guard/releases/download/v0.11.0/diesel-guard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c97ff9adf8557f3e16a63c0585a45bb11f7f866f3cd7a931d0c1170f9de0a6d"
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
