class Fairsoft < Formula
  desc "External software needed to compile and use FairRoot"
  homepage "https://github.com/FairRootGroup/FairSoft"
  url "https://github.com/FairRootGroup/FairSoft",
    :using => :git,
    :revision => "7a55ebc2c2f15d09e68d853ed4c5fb28c0856569"
  license "LGPL-3.0+"
  version "jan24"

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
    ENV.delete("CMAKE_INCLUDE_PATH")
    ENV.delete("CMAKE_LIBRARY_PATH")
    ENV.delete("HOMEBREW_SDKROOT")

    # Do not filter out -march, see https://github.com/Homebrew/brew/commit/0404da7ba7d22379b236c503d6a87746a848776c
    ENV.runtime_cpu_detection

    # Prevents embedding the brew compiler wrapper path in some root artifacts
    inreplace "#{Dir.pwd}/cmake/legacy.cmake",
      /^    \$\{root_cocoa\}/,
       "    ${root_cocoa}\n    \"-DCLING_CXX_PATH=#{ENV.cxx}\""

    # Prevents embedding the brew compiler wrapper path in some pythia8 artifacts
    inreplace "#{Dir.pwd}/cmake/legacy.cmake",
      /^    "--cxx=\$\{CMAKE_CXX_COMPILER\}"/,
       "    \"--cxx=#{ENV.cxx}\""

    # Prevents embedding the brew compiler wrapper path in some fairsoft-config artifacts
    inreplace "#{Dir.pwd}/cmake/legacy.cmake",
      /^  "-DFAIRSOFT_VERSION=jan24"/,
       "  \"-DFAIRSOFT_VERSION=jan24\" " +
           "\"-DCMAKE_C_COMPILER=/usr/bin/#{ENV.cc}\" " +
           "\"-DCMAKE_CXX_COMPILER=/usr/bin/#{ENV.cxx}\" " +
           "\"-DCMAKE_Fortran_COMPILER=#{HOMEBREW_PREFIX}/bin/gfortran\""

    # Let CMake generate the root-download target
    inreplace "#{Dir.pwd}/cmake/legacy.cmake",
      /ExternalProject_Add\(root\n/,
      "ExternalProject_Add(root\n  STEP_TARGETS download\n"

    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|OSX_SYSROOT)/ }
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DPython_EXECUTABLE=#{Formula["python"].opt_bin}/python3"
    args << "-DICU_ROOT=#{Formula["icu4c"].prefix}"
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"
    system "cmake", "-S", ".", "-B", builddir, *args

    # Fix the built-in libAfterImage in ROOT to support prefix containing the '@' char
    system "cmake", "--build", builddir, "--target", "root-download"
    aic = "#{builddir}/Source/root/graf2d/asimage/src/libAfterImage/configure"
    %w{INSTALL INSTALL_PROGRAM INSTALL_DATA INSTALL_LIB}.each do |var|
      inreplace aic, %{#{var}=`echo $#{var}|sed -e "s@\\^\\.\\.@${currdir}@" -e "s@^autoconf@${currdir}/autoconf@"`},
                     %{#{var}=`echo $#{var}|sed -e "s%\\^\\.\\.%${currdir}%" -e "s%^autoconf%${currdir}/autoconf%"`}
    end

    # Workaround the shim directory being embedded into the output
    inreplace "#{builddir}/Source/root/build/unix/compiledata.sh", "`type -path $CXX`", ENV.cxx

    system "cmake", "--build", builddir
    system "cmake", "--build", builddir, "--target", "onnxruntime"
  end
end
