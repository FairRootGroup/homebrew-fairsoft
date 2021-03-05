class Asiofi < Formula
  desc "C++ Boost.Asio language bindings for OFI libfabric"
  homepage "http://github.com/FairRootGroup/asiofi"
  url "https://github.com/FairRootGroup/asiofi",
    :using => :git,
    :revision => "ad10c5d634aa26671e65d4e7b97b7167b6ce3c99"
  license "LGPL-3.0+"
  version "0.3.3"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 catalina: "eea94fd81000c8e8686b57847ad1110c9806192dd1a9f0661d77198cfbb42e15"
    sha256 big_sur: "bd4984a29ade5f04bd7ba37d6b61c80551a0663e774bfc4eb820c6c6cbecb3d0"
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
  depends_on "libfabric"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
