class FairsoftAT2011 < Formula
  desc "External software needed to compile and use FairRoot"
  homepage "https://github.com/FairRootGroup/FairSoft"
  url "https://github.com/FairRootGroup/FairSoft",
    :using => :git,
    :revision => "369c2034fb3c6249712652f036df295dcd7a7df5"
  license "LGPL-3.0+"
  version "20.11rc"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages"
    # sha256 "c0a9273d4f14c56909928fec718d6c65623fe04a797f7dc789d55f7e4996a722" => :catalina
    # sha256 "83a9ff8e7e64d24e9b467c0021247d7c4ffe2d8fe118d59a91ea38a2c51a9b21" => :mojave
  # end

  # pour_bottle? do
    # reason "The bottle hardcodes locations inside Xcode.app and requires matching XCode CLT (CommandLineTools) to be installed."
    # satisfy do
      # MacOS::Xcode.installed? &&
      # MacOS::Xcode.default_prefix? &&
      # MacOS::CLT.installed? &&
      # MacOS::Xcode.version.major_minor == MacOS::CLT.version.major_minor
    # end
  # end

  resource "source_cache" do
    url "https://alfa-ci.gsi.de/packages/FairSoft_source_cache_full_nov20rc.tar.gz"
    sha256 "a4ea867d57fe28d0a866ae8e2d66f2e8d55b09312c843c7a4da6d1545d01457c"
  end

  depends_on :xcode
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
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libtool"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  keg_only nil,
    <<~EOS
      it has a separate consumption mechanism via the SIMPATH environment variable.
    EOS

  def caveats
    <<~EOS
      Choose this FairSoft installation by exporting the SIMPATH environment variable
      before configuring and building FairRoot, e.g.:
        export SIMPATH=#{prefix}
      or
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
