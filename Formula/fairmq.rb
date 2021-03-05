class Fairmq < Formula
  desc "C++ Message Queuing Library and Framework"
  homepage "http://github.com/FairRootGroup/FairMQ"
  url "https://github.com/FairRootGroup/FairMQ",
    :using => :git,
    :revision => "bbc1dd460035c0ffe22aa9d0c506d6e59b333315"
  license "LGPL-3.0+"
  version "1.4.32"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 big_sur: "e69419f1c3693c9c9b4ee2ebe3900e35624aa18af463f8cc01eafea9f60455fd"
    sha256 catalina: "1ad7ccac64d97fa2d3c4379f34363bc2f116f713d25b74f0c7d835f35fdeb0c3"
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
  depends_on "asiofi"
  depends_on "boost"
  depends_on "dds"
  depends_on "fairlogger"
  depends_on "flatbuffers"
  depends_on "zeromq"


  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DBUILD_OFI_TRANSPORT=ON"
    args << "-DBUILD_SDK_COMMANDS=ON"
    args << "-DBUILD_SDK=ON"
    args << "-DBUILD_DDS_PLUGIN=ON"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
