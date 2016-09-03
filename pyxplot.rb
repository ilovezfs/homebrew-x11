class Pyxplot < Formula
  desc "Multi-purpose graph plotting tool"
  homepage "http://pyxplot.org.uk/"
  url "http://pyxplot.org.uk/src/pyxplot_0.9.2.tar.gz"
  sha256 "1c592a0bc77caec445a8d72534471c01d66ca1806309e6c983847c2e0b95e689"
  revision 2

  bottle :disable, "Homebrew cannot currently build bottles against TeX"

  depends_on :x11
  depends_on :tex
  depends_on "fftw"
  depends_on "cfitsio" => :recommended
  depends_on "gv" => :recommended
  depends_on "wget" => :recommended
  depends_on "ghostscript" => "with-x11"
  depends_on "gsl"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "readline"

  def install
    # fix undefined symbol error for _history_list
    ENV.prepend "LDFLAGS", "-lhistory"

    # changes install directory to Cellar, per instructions
    inreplace "Makefile.skel" do |s|
      s.change_make_var! "USRDIR", prefix
    end
    system "./configure"
    system "make", "install"
  end

  test do
    system bin/"pyxplot", "-h"
  end
end
