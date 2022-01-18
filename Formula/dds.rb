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
    # rebuild 1
    # sha256 catalina: "4657179abf104e7fa9dce744a4313b5e7e4ecaa58f99e8c43d7c978b053a04c6"
    # sha256 big_sur: "e87bba1806f6f2a3494a82c8735eef4351df46f34612a25e9ba88330c9dee90a"
    # sha256 arm64_big_sur: "c12dfa586e731d149c07ff6162c67311216b4e7b1fc9454615645b71e350a413"
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
