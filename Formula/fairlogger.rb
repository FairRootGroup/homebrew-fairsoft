class Fairlogger < Formula
  desc "Lightweight and fast C++ Logging Library"
  homepage "https://github.com/FairRootGroup/FairLogger"
  url "https://github.com/FairRootGroup/FairLogger",
    :using => :git,
    :revision => "953eac19c8d43e31eb131c48bb6fe0656f6b1552"
  license "LGPL-3.0+"
  version "1.11.0"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 13+."
    satisfy { MacOS::CLT.installed? }
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
