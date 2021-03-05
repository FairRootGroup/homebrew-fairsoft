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
    sha256 big_sur: "c8a7eaf7f475e0f71b6968191f663f741444d8a5d5213ef9c2d9ca03ed942861"
    sha256 catalina: "fb3602de380e704acf12663ac1a2d69e4dc400cb36ca77e0d998556927b0403c"
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
