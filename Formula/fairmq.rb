class Fairmq < Formula
  desc "C++ Message Queuing Library and Framework"
  homepage "http://github.com/FairRootGroup/FairMQ"
  url "https://github.com/FairRootGroup/FairMQ",
    :using => :git,
    :revision => "9bf908fb52df5af0299fcebb7826cfd33cdd05d6"
  license "LGPL-3.0+"
  version "1.4.38"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages/brew"
    # rebuild 1
    # sha256 cellar: :any, big_sur: "1c9fc818f1261eb28597f480e6afaf17a7b1e4644bf3214b1f96a9020879501b"
    # sha256 cellar: :any, catalina: "1eeaf16639f71ecf2e44b365b0122c3eba1203e34550b4eff4f6cc4f4125750f"
  # end

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
