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
    sha256 big_sur: "7a6d04eb73c5308f1a5c47651a27664b1f18f3f423dc730d2b62b2ee3a921331"
    sha256 catalina: "e5bdbb08cb78fd3f516b014b2fd62e34f943f6cf09d97dfcdc454f7466d9c214"
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
