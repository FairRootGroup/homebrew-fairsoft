class Fairmq < Formula
  desc "C++ Message Queuing Library and Framework"
  homepage "http://github.com/FairRootGroup/FairMQ"
  url "https://github.com/FairRootGroup/FairMQ",
    :using => :git,
    :revision => "bce380d87166530c354b0a376481fcc5e16bdd10"
  license "LGPL-3.0+"
  version "1.4.41"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    rebuild 1
    sha256 cellar: :any, big_sur: "21951422253b0b0c139402608138baeca36c6a42f59a991f5c914a855eec2e13"
    sha256 cellar: :any, catalina: "fcf0049294f79d5905c8d99a664d96b5a649ce6150a137ce55bc8bad5a72b2ed"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "cmake" => :build
  depends_on "faircmakemodules" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "fairlogger"
  depends_on "zeromq"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
