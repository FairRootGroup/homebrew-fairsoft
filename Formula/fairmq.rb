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
    sha256 cellar: :any, catalina: "dad80c3fd77848f6326354168ad7adc4b1aa6eac50c8725c092aa7cb1a17d783"
    sha256 cellar: :any, big_sur: "13bbe754315a958aebcf34b8f9a0c8e8b779b139e404dc0e764f1645404016f4"
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
