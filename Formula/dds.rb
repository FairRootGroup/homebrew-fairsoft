class Dds < Formula
  desc "The Dynamic Deployment System"
  homepage "http://dds.gsi.de"
  url "https://github.com/FairRootGroup/DDS",
    :using => :git,
    :revision => "85aee1f7e34d3648cd6c5fb7439f0482583031a0"
  license "LGPL-3.0+"
  version "3.5.14"

  # bottle do
    # root_url "https://alfa-ci.gsi.de/packages/brew"
    # rebuild 1
    # sha256 big_sur: "295e0c696c211b5327161f251c50d87a512912e4bd0d24c736167b652c88551c"
    # sha256 catalina: "1f825b6d5907fa26a2434d7dfe80da1bdd69fa03b743d898672bda78c7216912"
  # end

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
      # workaround bugs in wn_bin target (fix proposed in https://github.com/FairRootGroup/DDS/pull/354)
      url "https://raw.githubusercontent.com/FairRootGroup/FairSoft/826b979385957fc92d6ef91910208b4e4e9d6312/repos/fairsoft/packages/dds/fix_wn_bin_master.patch"
      sha256 "846d1bebc6c8b30ff14f8d2c3a8625639fe0e00399d052a6d7fdde0d9cb4dd89"
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
