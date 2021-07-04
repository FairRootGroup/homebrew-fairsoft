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

  def install
    # workaround bugs in wn_bin target (fix proposed in https://github.com/FairRootGroup/DDS/pull/354)
    inreplace "#{Dir.pwd}/CMakeLists.txt",
      /^set\(DDS_BOOST_LIB_DIR \$\{Boost_LIBRARY_DIR\}\)$/,
       'set(DDS_BOOST_LIB_DIR ${Boost_LIBRARY_DIRS})'
    inreplace "#{Dir.pwd}/CMakeLists.txt",
      /^if\(ENV\{DDS_LD_LIBRARY_PATH\}\)$/,
       'if(DDS_LD_LIBRARY_PATH)'
    inreplace "#{Dir.pwd}/CMakeLists.txt",
      /^  file\(TO_CMAKE_PATH "\$ENV\{DDS_LD_LIBRARY_PATH\}" ENV_LD_LIBRARY_PATH\)$/,
       '  file(TO_CMAKE_PATH "${DDS_LD_LIBRARY_PATH}" ENV_LD_LIBRARY_PATH)'

    builddir = "build"
    args = std_cmake_args.reject{ |e| e =~ /CMAKE_BUILD_TYPE/ }
    args << "-GNinja"
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DDDS_LD_LIBRARY_PATH=#{Formula["icu4c"].prefix}/lib"
    system "cmake", "-S", ".", "-B", builddir, *args
    system "cmake", "--build", builddir, "--target", "wn_bin"
    system "cmake", "--build", builddir, "--target", "install"
  end
end
