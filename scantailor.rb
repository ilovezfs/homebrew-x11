class Scantailor < Formula
  desc "Interactive post-processing tool for scanned pages"
  homepage "http://scantailor.org/"
  head "https://github.com/Tulon/scantailor.git"

  class Version < ::Version
    def enhanced?
      to_s.start_with?("enhanced", "EXPERIMENTAL")
    end

    def <=>(other)
      other = self.class.new(other)
      if enhanced? && other.enhanced?
        super
      elsif enhanced?
        1
      elsif other.enhanced?
        -1
      else
        super
      end
    end
  end

  stable do
    url "https://downloads.sourceforge.net/project/scantailor/scantailor/0.9.11.1/scantailor-0.9.11.1.tar.gz"
    version Scantailor::Version.new("0.9.11.1")
    sha256 "881647a4172c55a067a7b6687965441cf21176d79d93075b22a373ea9accd8d3"

    # Hides Boost headers from Qt's moc tool.
    # Result of perl -ni -e '$b=m/include.*boost/; print "#ifndef Q_MOC_RUN\n" if $b; print $_; print "#endif\n" if $b;' **/*.{h,cpp}
    # https://bugreports.qt.io/browse/QTBUG-22829
    patch do
      url "https://gist.githubusercontent.com/jkseppan/ccf72d14f8b0efee6c7d/raw/dc97fbeb6b086a44c75b857a0f31e7a4f2adcdda/scantailor-0.9.11.1-moc-boost.patch"
      sha256 "442f28e36410191c681ab3d685b1cb1bd1da331ec08d812bc1524c6aa9b7efc6"
    end

    # Makes Scan Tailor work with Clang on OS X Mavericks
    # Approved by maintainer and included in official repository.
    # See: http://sourceforge.net/p/scantailor/mailman/message/31884956/
    patch do
      url "https://gist.githubusercontent.com/muellermartin/8569243/raw/b09215037b346787e0f501ae60966002fd79602e/scantailor-0.9.11.1-clang.patch"
      sha256 "86a3fa456c146844381af8d5bcdcdb9939edd4b11ce832bd928c1be036a27ea6"
    end

    # Changes some uses of boost::lambda::bind to C++11 lambdas.
    # Avoids compilation errors with Boost 1.57.
    # https://github.com/scantailor/scantailor/issues/125
    patch do
      url "https://gist.githubusercontent.com/jkseppan/49901ece3da6a0604887/raw/32a273bec2d20c2c70e8b789616f93590af6a4b1/scantailor-enhanced-20140214-c++11.patch"
      sha256 "026ebf5dc29cc3501f1b6712b189d9f5de1113a3550fd535b5f0ecb37daae123"
    end
  end

  bottle do
    sha256 "d0ddcdd1b83acd05c3021ca4a8bb0f05a577a62956ea5c71e5d00ed5cb8786e6" => :yosemite
    sha256 "87c57b5c683081c9feccbbd7dba3988155cbeeb72312577fd919f39fadabf486" => :mavericks
    sha256 "556a56a3d441822ca4b3442991f4e6c805e7d0cb5cf35c42ceae664b760ee53d" => :mountain_lion
  end

  devel do
    url "https://github.com/Tulon/scantailor/archive/EXPERIMENTAL_2016_02_22.tar.gz"
    version Scantailor::Version.new("EXPERIMENTAL-2016-02-22")
    sha256 "157f5cae617041eefa84c41e87bc18747bafc73eead16f73c2c6c0a717a82fab"

    patch do
      url "https://github.com/Tulon/scantailor/commit/2f091da82d570fd0a83d8a0d4dac3ab7f53454f7.patch"
      sha256 "e898595817659a2008d8996b86d6c87394eee7fc24b37365b403242b8ee8938c"
    end
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on :x11
  if build.stable?
    depends_on "qt"
  else
    depends_on "qt5"
    depends_on "eigen"
  end

  def install
    if build.stable?
      # The build fails with boost >= 1.59
      # Upstream has fixed this in HEAD: https://github.com/scantailor/scantailor/pull/194
      # New version tag requested 8th Apr 2016: https://github.com/scantailor/scantailor/issues/204
      inreplace ["MainWindow.cpp", "ThumbnailSequence.cpp", "filters/deskew/Filter.cpp", "filters/fix_orientation/Filter.cpp", "filters/output/Filter.cpp", "filters/page_layout/Filter.cpp", "filters/page_split/Filter.cpp", "filters/select_content/Filter.cpp"] do |s|
        s.gsub! " _1", " boost::lambda::_1"
        s.gsub! " _2", " boost::lambda::_2", false # MainWindow.cpp doesn't have a _2
        s.gsub! "bind(", "boost::lambda::bind(" unless s =~ /boost::lambda::bind/
      end
      system "cmake", ".", "-DPNG_INCLUDE_DIR=#{MacOS::X11.include}", "-DCMAKE_CXX_FLAGS=-std=c++11 -stdlib=libc++", *std_cmake_args
      system "make", "install"
    else
      mkdir "build" do
        system "cmake", "..", "-DPNG_INCLUDE_DIR=#{MacOS::X11.include}", "-DCMAKE_CXX_FLAGS=-std=c++11 -stdlib=libc++", *std_cmake_args
        system "make", "install"
      end
    end
  end

  test do
    spec = Tab.for_name(name).source["spec"]
    if spec == "stable"
      assert_match version.to_s, shell_output("#{bin}/scantailor-cli")
    elsif spec == "devel"
      # names it after today's date
      assert_match "Version: ", shell_output("#{bin}/scantailor-cli")
    end
  end
end
