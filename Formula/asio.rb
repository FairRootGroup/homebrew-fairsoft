class Asio < Formula
  desc "Asio C++ Library"
  homepage "https://github.com/chriskohlhoff/asio"
  url "https://github.com/FairRootGroup/asio",
    :using => :git,
    :revision => "e108d24ec1aaa7611d0fbb0de91237068c9ad9f9"
  license "BSL-1.0"
  version "1.19.2"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 cellar: :any_skip_relocation, catalina: "762f8166c7fdb52a00b04adb261d557085ce97dfd13d36aaace907793ffe23a1"
    sha256 cellar: :any_skip_relocation, big_sur: "3b5624c3443505d4b01d77e3b6db7e9391dd491386139eb78bb872c4656f9f03"
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
end
