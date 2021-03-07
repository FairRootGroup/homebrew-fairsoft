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
    sha256 big_sur: "a9941716520d1184e26fa665fa3a96cb08a87c3acb315a7fe9756a206a934d49"
    sha256 catalina: "e62bd6572f4be86cdfb5ff2bf62a057d2f20cb9735517a0264cfefb537fccc54"
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

  keg_only nil,
    <<~EOS
      its install tree is not FHS-compliant which breaks brew's package linking mechanism
    EOS

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
