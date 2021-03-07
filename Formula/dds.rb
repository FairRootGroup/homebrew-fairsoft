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

  patch do
    url "https://raw.githubusercontent.com/FairRootGroup/FairSoft/56264b8e496302c4cbc09e543f5663c5698359d3/patches/dds/fix_wn_bin_master.patch"
    sha256 "3e0631c54c3edc8e3c944686484a304127d9797c0359047efd0273391bebff79"
  end

  def install
    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_BUILD_TYPE/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "wn_bin"
    system "cmake", "--build", builddir, "--target", "install"
  end
end
