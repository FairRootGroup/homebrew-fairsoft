class Fairlogger < Formula
  desc "Lightweight and fast C++ Logging Library"
  homepage "https://github.com/FairRootGroup/FairLogger"
  url "https://github.com/FairRootGroup/FairLogger",
    :using => :git,
    :revision => "bcfe438862edc4047131a282c5e72a77d0b0d78c"
  license "LGPL-3.0+"
  version "1.9.0"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 big_sur: "af9753bce01e58f83f53a2683735528007120ae2fcb2fc955d1c6d05a6c116b3"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy do
      recent_clt = false
      case MacOS.version
        when "11.0" then recent_clt = MacOS::Xcode.version.major_minor >= ::Version.new("12")
        when "10.15" then recent_clt = MacOS::Xcode.version.major_minor >= ::Version.new("12")
      end
      MacOS::CLT.installed? && recent_clt
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "fmt"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
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
