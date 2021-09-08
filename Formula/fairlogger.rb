class Fairlogger < Formula
  desc "Lightweight and fast C++ Logging Library"
  homepage "https://github.com/FairRootGroup/FairLogger"
  url "https://github.com/FairRootGroup/FairLogger",
    :using => :git,
    :revision => "13ebedca3d66e8e07e1481028c36dc19334e4b4e"
  license "LGPL-3.0+"
  version "1.9.3"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages"
    # sha256 big_sur: "af9753bce01e58f83f53a2683735528007120ae2fcb2fc955d1c6d05a6c116b3"
    # sha256 catalina: "1d0d7a46a217f097df0ecf7b86823559509dd6bfc4b662fb91c81c3d3d0cc67d"
  # end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy do
      MacOS::CLT.installed?
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "fmt"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DUSE_BOOST_PRETTY_FUNCTION=ON"
    args << "-DUSE_EXTERNAL_FMT=ON"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end

  def test
    system "cmake", "--build", builddir, "--target", "test"
  end
end
