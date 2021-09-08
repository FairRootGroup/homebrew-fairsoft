class Asio < Formula
  desc "Asio C++ Library"
  homepage "https://github.com/chriskohlhoff/asio"
  url "https://github.com/FairRootGroup/asio",
    :using => :git,
    :revision => "e108d24ec1aaa7611d0fbb0de91237068c9ad9f9"
  license "BSL-1.0"
  version "1.19.2"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages/brew"
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
end
