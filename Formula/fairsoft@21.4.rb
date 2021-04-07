class FairsoftAT214 < Formula
  desc "External software needed to compile and use FairRoot"
  homepage "https://github.com/FairRootGroup/FairSoft"
  url "https://github.com/FairRootGroup/FairSoft",
    :using => :git,
    :revision => "0381030a71c3984b8067debbccbbbcfb4038cc0e"
  license "LGPL-3.0+"
  version "apr21"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages"
    # sha256 "43886e6b194616b76a4fface1ca90a9d4b2ee524af439c9d38487cc3a03a75fe" => :big_sur
    # sha256 "e5828f10ea2fab86b1b11552e6be75dc72ab42b412bbfeeeb53533160e69ac30" => :catalina
  # end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy do
      MacOS::CLT.installed?
    end
  end

  resource "source_cache" do
    url "https://alfa-ci.gsi.de/packages/FairSoft_source_cache_full_apr21_0381030.tar.gz"
    sha256 "53343f4430e17a38cb9c50ffc99291e0fc822b0268a77313941fa6745ffcf166"
  end

  depends_on "cmake"
  depends_on "cfitsio"
  depends_on "coreutils"
  depends_on "davix"
  depends_on "icu4c"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc"
  depends_on "giflib"
  depends_on "gl2ps"
  depends_on "gpatch"
  depends_on "graphviz"
  depends_on "grpc"
  depends_on "gsl"
  depends_on "libjpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "mesa-glu"
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
    # ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    builddir = "build"
    cache = resource("source_cache").cached_download
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DSOURCE_CACHE=#{cache}"
    args << "-DPYTHON_EXECUTABLE=#{Formula["python"].opt_bin}/python3"
    args << "-DICU_ROOT=#{Formula["icu4c"].prefix}"
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
