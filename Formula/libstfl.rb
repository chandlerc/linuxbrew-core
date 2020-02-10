class Libstfl < Formula
  desc "Library implementing a curses-based widget set for terminals"
  homepage "http://www.clifford.at/stfl/"
  url "http://www.clifford.at/stfl/stfl-0.24.tar.gz"
  sha256 "d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090"
  revision 8

  bottle do
    cellar :any
    sha256 "3d9ad970cb1f4fb003ee51f6c8bba9cdc4e949a9bf9f3abed40287b7d7cffb06" => :catalina
    sha256 "69c2c6c2c41794fcf12784a4314718def6065bfec14dd15e822e8be245ba2b5b" => :mojave
    sha256 "3cfbe818441f2f60d24e36a7957c3a27df33e4668060aa045dd8a470c6982f7f" => :high_sierra
    sha256 "d2b2f9c58980f858a80bc930be71590aae52e09dfe21dbb49047f8e876180305" => :sierra
    sha256 "e95c1a585bb6e6b543ea2479bf4ccf31885b4bab91549681139a145b3374726e" => :x86_64_linux
  end

  depends_on :macos # Due to Python 2
  depends_on "swig" => :build
  depends_on "ruby"
  unless OS.mac?
    depends_on "perl"
    depends_on "python@2"
  end

  def install
    if OS.mac?
      ENV.append "LDLIBS", "-liconv"
      ENV.append "LIBS", "-lncurses -liconv -lruby"
    else
      ENV.append "LIBS", "-lncurses -lruby"
    end

    %w[
      stfl.pc.in
      perl5/Makefile.PL
      ruby/Makefile.snippet
    ].each do |f|
      inreplace f, "ncursesw", "ncurses"
    end

    inreplace "stfl_internals.h", "ncursesw/ncurses.h", "ncurses.h"

    inreplace "Makefile" do |s|
      s.gsub! "ncursesw", "ncurses"
      s.gsub! "-Wl,-soname,$(SONAME)", "-Wl"
      s.gsub! "libstfl.so.$(VERSION)", "libstfl.$(VERSION).dylib"
      s.gsub! "libstfl.so", "libstfl.dylib"
    end

    inreplace "python/Makefile.snippet" do |s|
      # Install into the site-packages in the Cellar (so uninstall works)
      s.change_make_var! "PYTHON_SITEARCH", lib/"python2.7/site-packages"
      s.gsub! "lib-dynload/", ""
      s.gsub! "ncursesw", "ncurses"
      if OS.mac?
        s.gsub! "gcc", "gcc -undefined dynamic_lookup #{`python-config --cflags`.chomp}"
        s.gsub! "-lncurses", "-lncurses -liconv"
      else
        s.gsub! "gcc", "gcc #{`python-config --cflags`.chomp}"
      end
    end

    # Fails race condition of test:
    #   ImportError: dynamic module does not define init function (init_stfl)
    #   make: *** [python/_stfl.so] Error 1
    ENV.deparallelize

    system "make"

    inreplace "perl5/Makefile", "Network/Library", libexec/"lib/perl5" if OS.mac?
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stfl.h>
      int main() {
        stfl_ipool * pool = stfl_ipool_create("utf-8");
        stfl_ipool_destroy(pool);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lstfl", "-o", "test"
    system "./test"
  end
end
