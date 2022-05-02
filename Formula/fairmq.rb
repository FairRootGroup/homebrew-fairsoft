class Fairmq < Formula
  desc "C++ Message Queuing Library and Framework"
  homepage "http://github.com/FairRootGroup/FairMQ"
  url "https://github.com/FairRootGroup/FairMQ",
    :using => :git,
    :revision => "69faa63c5b46df6c58af919796a9d651c19705e4"
  license "LGPL-3.0+"
  version "1.4.50"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
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
