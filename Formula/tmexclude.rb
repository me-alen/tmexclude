class Tmexclude < Formula
  desc "Exclude generated project artifacts from Time Machine"
  homepage "https://example.com/tmexclude"
  url "https://example.com/tmexclude/archive/v0.3.0.tar.gz"
  sha256 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  license "MIT"

  def install
    bin.install "bin/tmexclude"
    (prefix/"libexec").install Dir["lib"]
    (prefix/"share/tmexclude").install "config.example"
  end

  test do
    assert_match "tmexclude", shell_output("#{bin}/tmexclude help")
  end
end
