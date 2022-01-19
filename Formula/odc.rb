class Odc < Formula
  desc "Online Device Control"
  homepage "http://github.com/FairRootGroup/ODC"
  url "https://github.com/FairRootGroup/ODC",
    :using => :git,
    :revision => "c834aa25bfc64ca2dc93a0d6a9e03ddb781bc278"
  license "LGPL-3.0+"
  version "0.62"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages"
    # sha256 big_sur: "ed90233471a0e19861472a94ff30b39de3eb8e63f58884c2666b06b6e29b1916"
    # sha256 catalina: "855006fca79385b2872d7d40f804d2acf902771353e6c93b3826f0944e8166ae"
  # end

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
