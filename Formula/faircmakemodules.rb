class Faircmakemodules < Formula
  desc "CMake Modules developed in the context of various FAIR projects"
  homepage "https://github.com/FairRootGroup/FairCMakeModules"
  url "https://github.com/FairRootGroup/FairCMakeModules",
    :using => :git,
    :revision => "0112745f54a45ce70e3bd770b1084e29192c31c9"
  license "LGPL-3.0+"
  version "0.1.0"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 cellar: :any_skip_relocation, big_sur: "8f1a4612d77341651f98aa225c5a64aa9e8ee04a67dcc0670f1216ce5b6b5157"
    sha256 cellar: :any_skip_relocation, catalina: "2aa7900b013bea3233cba3148c2c889cddf22ad14c986162a5a914b684e4acf9"
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
