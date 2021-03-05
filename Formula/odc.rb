class Odc < Formula
  desc "Online Device Control"
  homepage "http://github.com/FairRootGroup/ODC"
  url "https://github.com/FairRootGroup/ODC",
    :using => :git,
    :revision => "b3adfb2343e182be4507097a58f21f998a551e52"
  license "LGPL-3.0+"
  version "0.16"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 big_sur: "77c1ba768f40ec2e2a012f3c82cc3d57484c9e2a505ee7a60f52c473bc539a7f"
    sha256 catalina: "d8f75700ae40d370cbdc2a3895ee10673ec7f6570325a0968aa7a4f8807657cb"
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
  depends_on "dds"
  depends_on "fairmq"
  depends_on "grpc"
  depends_on "protobuf"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
