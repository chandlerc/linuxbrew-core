class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v2.0.3.tar.gz"
  sha256 "6529d521a7fa006808cd07331f31256e91773ec7e1a0c7839cd14884034fb185"
  license "MIT"
  head "https://github.com/JamesClonk/vultr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0d5bffa07a97813ca4eece9a0e396d8a0c76fdd738d5041ad5d82385cb05dda"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7a764a5516eaf4923bd134a85f2a6a9c4f2b9537ff7b585e8a32a6581975cab"
    sha256 cellar: :any_skip_relocation, catalina:      "b3fb6e155013b41bd2b48202e70ef0236be3e24b3f87cf1f1234e7a09e2e7e97"
    sha256 cellar: :any_skip_relocation, mojave:        "7348b1e615d088dc03781613b17b7187827e9cc98e743fa472c617876f6a543a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9df1926813cac027a1b25aa2c4dbbb469f219afc3b595f475a0df1c748267e" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system bin/"vultr", "version"
  end
end
