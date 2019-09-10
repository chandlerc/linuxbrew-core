class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=208&file=02&dummy=gwenhywfar-4.20.0.tar.gz"
  sha256 "5a88daabba1388f9528590aab5de527a12dd44a7da4572ce48469a29911b0fb0"
  revision 2

  bottle do
    sha256 "504e7a6106bba20337fc73f5210e15e94d0ba403e20e5197157f60cd8d81cd94" => :mojave
    sha256 "daa91da4c46bdcd6e209f98d28b72462ee60692cbffee0e1243f0939754ecdbc" => :high_sierra
    sha256 "f89a84a78f7a097d7ccbaa463a0663e9d31fa75ffad489c6de11c59aba5a317a" => :sierra
    sha256 "55581581a6d046019dfcc58c0897d59073709cb4adb4d83553146c487b518ca8" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"
  depends_on "qt" unless OS.mac?

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]
    args << (OS.mac? ? "--with-guis=cocoa" : "--with-guis=qt5")

    system "autoreconf", "-fiv" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar4", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
