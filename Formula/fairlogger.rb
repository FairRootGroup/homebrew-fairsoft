class Fairlogger < Formula
  desc "Lightweight and fast C++ Logging Library"
  homepage "https://github.com/FairRootGroup/FairLogger"
  url "https://github.com/FairRootGroup/FairLogger",
    :using => :git,
    :revision => "13ebedca3d66e8e07e1481028c36dc19334e4b4e"
  license "LGPL-3.0+"
  version "1.9.3"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 cellar: :any, catalina: "61c62a141cd3314b3a16b2cc63be69c5a00974c227dfe4266f25db8102a8ca64"
    sha256 cellar: :any, big_sur: "526bb7e6fe417c874d7241fd89d5de09be6452f766d3ab1fa58a84326d2c7612"
    sha256 cellar: :any, arm64_big_sur: "587d83a3353dff85f07a354ab8171125b3ad10d00dc78bc2ba78ef3f0c9bb8f8"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
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
