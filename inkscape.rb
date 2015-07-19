class Inkscape < Formula
  desc "A professional vector graphics editor"
  homepage "https://inkscape.org/"
  url "https://inkscape.org/en/gallery/item/3854/inkscape-0.91.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/inkscape/inkscape_0.91.orig.tar.gz"
  sha256 "2ca3cfbc8db53e4a4f20650bf50c7ce692a88dcbf41ebc0c92cd24e46500db20"
  revision 2

  bottle do
    root_url "https://homebrew.bintray.com/bottles-x11"
    sha256 "4f08301a4876cf58ccebd4bbbe3a88b0bbd2b80190bc94f0edac70481571c119" => :yosemite
    sha256 "4f29be794837344bde0a50665cdf33b1ea790573ca06ec13b9609dc6527be44b" => :mavericks
    sha256 "2001490c6088f244448096ee7fdb47d09d1ab2a0d27910a1eeb656b1b2e9392b" => :mountain_lion
  end

  head do
    url "lp:inkscape", :using => :bzr
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost-build" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "poppler" => :optional
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "cairomm"
  depends_on "gettext"
  depends_on "glibmm"
  depends_on "gsl"
  depends_on "gtkmm"
  depends_on "hicolor-icon-theme"
  depends_on "little-cms"
  depends_on "pango"
  depends_on "popt"

  if MacOS.version < :mavericks
    fails_with :clang do
      cause "inkscape's dependencies will be built with libstdc++ and fail to link."
    end
  end

  needs :cxx11 if MacOS.version >= :mavericks

  def install
    ENV.cxx11 if MacOS.version >= :mavericks
    ENV.append "LDFLAGS", "-liconv"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-strict-build
      --enable-lcms
      --without-gnome-vfs
    ]
    args << "--disable-poppler-cairo" if build.without? "poppler"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/inkscape", "-x"
  end
end
