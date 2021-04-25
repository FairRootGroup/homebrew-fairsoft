class Faircmakemodules < Formula
  desc "CMake Modules developed in the context of various FAIR projects"
  homepage "https://github.com/FairRootGroup/FairCMakeModules"
  url "https://github.com/FairRootGroup/FairCMakeModules",
    :using => :git,
    :revision => "0112745f54a45ce70e3bd770b1084e29192c31c9"
  license "LGPL-3.0+"
  version "0.1.0"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages"
    # sha256 big_sur: "af9753bce01e58f83f53a2683735528007120ae2fcb2fc955d1c6d05a6c116b3"
    # sha256 catalina: "1d0d7a46a217f097df0ecf7b86823559509dd6bfc4b662fb91c81c3d3d0cc67d"
  # end

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
