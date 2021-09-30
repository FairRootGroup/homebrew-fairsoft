class Dds < Formula
  desc "The Dynamic Deployment System"
  homepage "http://dds.gsi.de"
  url "https://github.com/FairRootGroup/DDS",
    :using => :git,
    :revision => "b36525de128ad74e3d839c20b939359f9594c902"
  license "LGPL-3.0+"
  version "3.5.18"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
    sha256 catalina: "3233f2c1e5087a182bcc468aa9f563a415773a1275e5b719a2e1c6a30e0465cc"
    sha256 big_sur: "90c865f09614bcdc42ef94239c3e09c64efdc022d21334735dc899899e3ac3d8"
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
