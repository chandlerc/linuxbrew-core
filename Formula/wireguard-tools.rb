class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200827.tar.xz"
  sha256 "51bc85e33a5b3cf353786ae64b0f1216d7a871447f058b6137f793eb0f53b7fd"
  license "GPL-2.0"
  head "https://git.zx2c4.com/wireguard-tools", using: :git

  livecheck do
    url "https://github.com/WireGuard/wireguard-tools"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "45e84d6fd3efe601ecb6c959a356169908bd12aa2aaa42122663619c47c02e4e" => :catalina
    sha256 "7c53423bac89aef0a7a521f04707961bf4416925edb3022d0bfc839f345f991b" => :mojave
    sha256 "7041f9c62ee72513ec0eb67ec1b240ce4be95c771aeecb9302fed746c0029dfc" => :high_sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  on_linux do
    depends_on "libmnl"
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
