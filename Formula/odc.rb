class Odc < Formula
  desc "Online Device Control"
  homepage "http://github.com/FairRootGroup/ODC"
  url "https://github.com/FairRootGroup/ODC",
    :using => :git,
    :revision => "c834aa25bfc64ca2dc93a0d6a9e03ddb781bc278"
  license "LGPL-3.0+"
  version "0.62"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 big_sur: "b0b1499375c2905ea4b749de6d3081fe28ea5a2e8d828527e41e7a5080a681a0"
    sha256 catalina: "5886eb0b75ab7b94c8bef3115bedea7d95ead18abc80cc93c3c990569f8dbc40"
    sha256 arm64_monterey: "ae6b631438be5f84a8d459283610e1b01e30a0849387d05fa4ae1fe967b8737a"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "dds"
  depends_on "fairmq"
  depends_on "grpc"
  depends_on "protobuf"
  depends_on "flatbuffers"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
