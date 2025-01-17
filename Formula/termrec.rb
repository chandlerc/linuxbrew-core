class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  license "LGPL-3.0"
  head "https://github.com/kilobyte/termrec.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a03a052b7ee89450b145a866724f6f97727c56bbf0220a14a089c84951aeed35"
    sha256 cellar: :any, big_sur:       "81060090e19bbb56f0b991dfa987eb890c00b116b656be2d2bd29ea027f9496a"
    sha256 cellar: :any, catalina:      "1d93149ec34c0bf531da76b0137390ed1f05bf2e35e806f1fe875fe6648c4c2b"
    sha256 cellar: :any, mojave:        "e3f9f241763a05de367da2ee91727674e18a126a99480a750b901a21bdad0ffb"
    sha256 cellar: :any, high_sierra:   "d6cb43ed14ec0531824bd4eb55ddc625b5711c28b274ce78eb815501e5f3ebf2"
    sha256 cellar: :any, x86_64_linux:  "8e69b3b9c275945b60d2e67ab8b165ce485de75c372a76f321f7579878b229c6" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/termrec", "--help"
  end
end
