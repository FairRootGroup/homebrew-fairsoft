class Fairroot < Formula
  desc "C++ simulation, reconstruction and analysis framework for particle physics experiments"
  homepage "http://github.com/FairRootGroup/FairRoot"
  url "https://github.com/FairRootGroup/FairRoot",
    :using => :git,
    :revision => "1f9e60a223d697b491f0f1ec1693f48e29699caa"
  license "LGPL-3.0+"
  version "18.6.4"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages/brew"
    # rebuild 1
    # sha256 cellar: :any, big_sur: "1c9fc818f1261eb28597f480e6afaf17a7b1e4644bf3214b1f96a9020879501b"
    # sha256 cellar: :any, catalina: "1eeaf16639f71ecf2e44b365b0122c3eba1203e34550b4eff4f6cc4f4125750f"
  # end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy do
      MacOS::CLT.installed?
    end
  end

  keg_only nil,
    <<~EOS
      it has a separate consumption mechanism via the FAIRROOTPATH environment variable
    EOS

  def caveats
    <<~EOS
      Choose this FairRoot installation by exporting the FAIRROOTPATH environment variable
      before configuring and building your <Experiment>Root, e.g.
        export FAIRROOTPATH=$(brew --prefix #{name})
    EOS
  end

  depends_on "cmake" => :build
  depends_on "faircmakemodules" => :build
  depends_on "ninja" => :build
  depends_on "fairsoft"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["icu4c"].prefix}"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
