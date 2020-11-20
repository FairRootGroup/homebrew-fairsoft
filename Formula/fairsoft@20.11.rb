class FairsoftAT2011 < Formula
  desc "External software needed to compile and use FairRoot"
  homepage "https://github.com/FairRootGroup/FairSoft"
  url "https://github.com/FairRootGroup/FairSoft",
    :using => :git,
    :revision => "3430192020af2eb92d1a86be72497ef64adbfdb9"
  license "LGPL-3.0+"
  version "nov20"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 "43886e6b194616b76a4fface1ca90a9d4b2ee524af439c9d38487cc3a03a75fe" => :big_sur
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy do
      recent_clt = false
      case MacOS.version
        when "11.0" then recent_clt = MacOS::Xcode.version.major_minor >= ::Version.new("12")
        when "10.15" then recent_clt = MacOS::Xcode.version.major_minor >= ::Version.new("12")
      end
      MacOS::CLT.installed? && recent_clt
    end
  end

  resource "source_cache" do
    url "https://alfa-ci.gsi.de/packages/FairSoft_source_cache_full_nov20.tar.gz"
    sha256 "3aa53451d616ceef2e2dc74f6d55c71f0be89a01286d0c93f0dfca873933d399"
  end

  depends_on :x11
  depends_on "cmake"
  depends_on "cfitsio"
  depends_on "coreutils"
  depends_on "icu4c"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc"
  depends_on "gl2ps"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "libjpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openlibm"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "pkg-config"
  depends_on "python"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on "xerces-c"
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libtool"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  keg_only nil,
    <<~EOS
      it has a separate consumption mechanism via the SIMPATH environment variable
    EOS

  def caveats
    <<~EOS
      Choose this FairSoft installation by exporting the SIMPATH environment variable
      before configuring and building FairRoot, e.g.
        export SIMPATH=$(brew --prefix #{name})
    EOS
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    builddir = "build"
    cache = resource("source_cache").cached_download
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DSOURCE_CACHE=#{cache}"
    args << "-DPYTHON_EXECUTABLE=#{Formula["python"].opt_bin}/python3"
    system "cmake", "-S", ".", "-B", builddir, *args

    # Fix the built-in libAfterImage in ROOT to support prefix containing the '@' char
    system "cmake", "--build", builddir, "--target", "root-download"
    aic = "#{builddir}/Source/root/graf2d/asimage/src/libAfterImage/configure"
    %w{INSTALL INSTALL_PROGRAM INSTALL_DATA INSTALL_LIB}.each do |var|
      inreplace aic, %{#{var}=`echo $#{var}|sed -e "s@\\^\\.\\.@${currdir}@" -e "s@^autoconf@${currdir}/autoconf@"`},
                     %{#{var}=`echo $#{var}|sed -e "s%\\^\\.\\.%${currdir}%" -e "s%^autoconf%${currdir}/autoconf%"`}
    end

    system "cmake", "--build", builddir
  end
end
