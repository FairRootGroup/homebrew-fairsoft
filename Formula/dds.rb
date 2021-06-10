class Dds < Formula
  desc "The Dynamic Deployment System"
  homepage "http://dds.gsi.de"
  url "https://github.com/FairRootGroup/DDS",
    :using => :git,
    :revision => "0345b498985f40cfcb389c0c64dcc35d1960d36b"
  license "LGPL-3.0+"
  version "3.5.13"

#  bottle do
#    root_url "https://alfa-ci.gsi.de/packages/brew"
#    rebuild 1
#    sha256 big_sur: "295e0c696c211b5327161f251c50d87a512912e4bd0d24c736167b652c88551c"
#    sha256 catalina: "1f825b6d5907fa26a2434d7dfe80da1bdd69fa03b743d898672bda78c7216912"
#  end

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

#  patch do
#    url "https://raw.githubusercontent.com/FairRootGroup/FairSoft/56264b8e496302c4cbc09e543f5663c5698359d3/patches/dds/fix_wn_bin_master.patch"
#    sha256 "3e0631c54c3edc8e3c944686484a304127d9797c0359047efd0273391bebff79"
#  end

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
