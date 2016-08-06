class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "http://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/v3.20160805.1.tar.gz"
  sha256 "ddafca1239075c203769c17a5a184587731e56fbe0438c09d08f8af1704e117a"

  bottle do
    sha256 "21ce8342f3868e5fedb623587f95b247dfae5aaa7c413b154c081577d48316b2" => :el_capitan
    sha256 "43d6fd4a0d9a56d4fb5c25b059c6caefb7a63dfc49a01ab9e87986fd26a04dbb" => :yosemite
    sha256 "f864cdc4e45f806d5fa8fe7120e7cabe8427631a1ede7fe0026df9d0b40ab96f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libxkbcommon"

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats; <<-EOS.undent
    You will probably want to enable XTEST in your X11 server now by running:
      defaults write org.x.X11 enable_test_extensions -boolean true

    For the source of this useful hint:
      http://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end
