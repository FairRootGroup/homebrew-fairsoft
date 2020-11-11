class FairsoftAT2011 < Formula
  desc "External software needed to compile and use FairRoot"
  homepage "https://github.com/FairRootGroup/FairSoft"
  url "https://github.com/FairRootGroup/FairSoft",
    :using => :git,
    :revision => "03752388523bf8c97defb89bd6e99bcf8394737f"
  license "LGPL-3.0+"
  version "20.11rc"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 "ef5cc9a9a55120f5f5d4026ca176f8e47d3c54e5724e2876c1ee6d53e35ba1af" => :catalina
    sha256 "92045e9cf01a249bbcc6c88813ee788c310d044ff4871a89c88764d7a287610e" => :mojave
  end

  pour_bottle? do
    reason "The bottle requires recent XCode and matching XCode CLT (CommandLineTools) versions. Run 'brew update && brew doctor' and follow the update instructions."
    satisfy do
      recent_xcode = false
      case MacOS.version
        when "10.15" then recent_xcode = MacOS::Xcode.version.major_minor >= ::Version.new("12.1")
        when "10.14" then recent_xcode = MacOS::Xcode.version.major_minor >= ::Version.new("11.3")
      end
      MacOS::Xcode.installed? &&
      MacOS::Xcode.default_prefix? &&
      MacOS::CLT.installed? &&
      recent_xcode &&
      MacOS::Xcode.version.major_minor == MacOS::CLT.version.major_minor
    end
  end
#
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
  depends_on "yaml-cpp"
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
