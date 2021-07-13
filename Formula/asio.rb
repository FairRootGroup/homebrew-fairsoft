class Asio < Formula
  desc "Asio C++ Library"
  homepage "https://github.com/chriskohlhoff/asio"
  url "https://github.com/FairRootGroup/asio",
    :using => :git,
    :revision => "78a1032eaf01515941d4baf9c38c69610aa5a614"
  license "BSL-1.0"
  version "1.19.1"

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
