class Asio < Formula
  desc "Asio C++ Library"
  homepage "https://github.com/chriskohlhoff/asio"
  url "https://github.com/FairRootGroup/asio",
    :using => :git,
    :revision => "fdabf904b0a54222dbc907520a0c1581f54c4173"
  license "BSL-1.0"
  version "1.18.1"

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
