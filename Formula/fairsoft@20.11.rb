class FairsoftAT2011 < Formula
  desc "External software needed to compile and use FairRoot"
  homepage "https://github.com/FairRootGroup/FairSoft"
  url "https://github.com/FairRootGroup/FairSoft",
    :using => :git,
    :revision => "b428490e4c1d3c9ee8d00c57297ea06269c86199"
  license "LGPL-3.0+"
  version "nov20p1"

  disable! date: "2020-04-30", because: :does_not_build
end
