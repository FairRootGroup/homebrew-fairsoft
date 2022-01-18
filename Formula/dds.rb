class Dds < Formula
  desc "The Dynamic Deployment System"
  homepage "http://dds.gsi.de"
  url "https://github.com/FairRootGroup/DDS",
    :using => :git,
    :revision => "c71f8df77766c052441f8f3a89e948755a07c2a2"
  license "LGPL-3.0+"
  version "3.6"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 big_sur: "76a66915b8d5e0003de419c6a00ddf8ade0b0dfd961d823c9d7eeadb305467cf"
    sha256 catalina: "e9140a862f20bb6310fa3ff86b1abc11d5b96ac56190965adef872861d6702eb"
    sha256 arm64_monterey: "104b01f38d5df70c3ef86f8cf69d47cb5e4282600b2e2ca73289fd6b1064fee4"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy { MacOS::CLT.installed? }
  end

  keg_only nil,
    <<~EOS
      its install tree is not FHS-compliant which breaks brew's package linking mechanism
    EOS

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "boost"

  patch do
    # workaround bugs in wn_bin target (fix proposed in https://github.com/FairRootGroup/DDS/pull/354)
    url "https://github.com/ChristianTackeGSI/DDS/commit/2355a73d5cfda4f9bab6bc27d1a166f4e26ce564.diff"
    sha256 "0044c44d5c9db164f3f8f1711f82f1a7c3f0c459ce790ba6ce89e94a8cc54558"
  end

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_BUILD_TYPE/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "wn_bin"
    system "cmake", "--build", builddir, "--target", "install"
  end
end
