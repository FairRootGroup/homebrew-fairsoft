class Faircmakemodules < Formula
  desc "CMake Modules developed in the context of various FAIR projects"
  homepage "https://github.com/FairRootGroup/FairCMakeModules"
  url "https://github.com/FairRootGroup/FairCMakeModules",
    :using => :git,
    :revision => "ceecfbad90c9dbdb876a4562403280a7c63163f3"
  license "LGPL-3.0+"
  version "0.2.0"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 cellar: :any_skip_relocation, big_sur: "7b151289aea75ad8ef39ea0a542e640fbf7c1f589f44883a05853c2adc919314"
    sha256 cellar: :any_skip_relocation, catalina: "7adfbb9cd1f8922697d9307e70b69d0d89b7b7e183f2d950db4c81b12e9cf5ef"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    builddir = "build"
    args = std_cmake_args
    args << "-GNinja"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end

  def test
    system "cmake", "--build", builddir, "--target", "test"
  end
end
