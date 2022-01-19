class Fairroot < Formula
  desc "C++ simulation, reconstruction and analysis framework for particle physics experiments"
  homepage "http://github.com/FairRootGroup/FairRoot"
  url "https://github.com/FairRootGroup/FairRoot",
    :using => :git,
    :revision => "99491c25d0cd952cad8d5260dfcc871c06d32a78"
  license "LGPL-3.0+"
  version "18.6.6"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages/brew"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy { MacOS::CLT.installed? }
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
  depends_on "ninja" => :build
  depends_on "fairsoft"

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    args << "-DSIMPATH=#{Formula["fairsoft"].prefix}"
    args << "-DCMAKE_CXX_STANDARD=17"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "install"
  end
end
