class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.7.0.tar.gz"
  sha256 "4aa704747b4f8f1d59768b663c488fa937e6783db2a46ae407cd2a599cfbf8b1"

  bottle do
    revision 1
    sha256 "fc590bf2fcc5a3736d7f24ac8e8926dd131784cb4748d2defb326ca6422513a5" => :el_capitan
    sha256 "933b6a9bca39a0cac6cfb139e357761b2cffedd0e291adf63a8b811a00052dc3" => :yosemite
    sha256 "b5fd64ba9aef4476952b5a74e20d30f54907e1728b9208d72883336d4ce95414" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end
end
