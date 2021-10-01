class Faircmakemodules < Formula
  desc "CMake Modules developed in the context of various FAIR projects"
  homepage "https://github.com/FairRootGroup/FairCMakeModules"
  url "https://github.com/FairRootGroup/FairCMakeModules",
    :using => :git,
    :revision => "b1a416dc30fa8d83535e159c98764408c3f89d28"
  license "LGPL-3.0+"
  version "1.0.0"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 cellar: :any_skip_relocation, catalina: "4b3512d3b8cc59fb2d78ec794efb5b424e6e59897b5eef6dc8bba19947e373e7"
    sha256 cellar: :any_skip_relocation, big_sur: "b07304119d762acce4dbebd56b7511c103c087d354f3f96bc01ea73f9b8da416"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5de395ea39ca88a3fd3b06418591c8da017e88fe6b7e163c067cf673c475cfb6"
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
