class Dds < Formula
  desc "The Dynamic Deployment System"
  homepage "http://dds.gsi.de"
  url "https://github.com/FairRootGroup/DDS",
    :using => :git,
    :revision => "2868c2340f688b3045f2d6a73655b71b435bf6ab"
  license "LGPL-3.0+"
  version "3.5.9"

  bottle do
    root_url "https://alfa-ci.gsi.de/packages"
    sha256 big_sur: "4c87a21733383a30fbdb498c9ee5b7e64331a9b98989669219534cff227669d2"
    sha256 catalina: "2e217f2c5a889fb73e8282e289edf2469e783fdfaffdc0b1483558c52912c635"
  end

  pour_bottle? do
    reason "The bottle requires CommandLineTools for Xcode 12+."
    satisfy do
      recent_clt = false
      case MacOS.version
        when "11.0" then recent_clt = MacOS::Xcode.version.major_minor >= ::Version.new("12")
        when "10.15" then recent_clt = MacOS::Xcode.version.major_minor >= ::Version.new("12")
      end
      MacOS::CLT.installed? && recent_clt
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "boost"

  def install
    inreplace "CMakeLists.txt", "set(DDS_BOOST_LIB_DIR ${Boost_LIBRARY_DIR})",
                                "set(DDS_BOOST_LIB_DIR ${Boost_LIBRARY_DIRS})"
    inreplace "CMakeLists.txt", "if(ENV{DDS_LD_LIBRARY_PATH})",
                                "if(DEFINED ENV{DDS_LD_LIBRARY_PATH})"
    inreplace "cmake/DDSConfig.cmake.in", "set_and_check", "set"
    ENV["DDS_LD_LIBRARY_PATH"] = Formula["icu4c"].lib

    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_(CX*_FLAGS|BUILD_TYPE|VERBOSE_MAKEFILE)/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "wn_bin"
    system "cmake", "--build", builddir, "--target", "install"
  end
end
