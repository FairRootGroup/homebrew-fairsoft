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
    sha256 big_sur: "ed90233471a0e19861472a94ff30b39de3eb8e63f58884c2666b06b6e29b1916"
    sha256 catalina: "855006fca79385b2872d7d40f804d2acf902771353e6c93b3826f0944e8166ae"
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
