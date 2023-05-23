class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.12.1.tar.gz"
  sha256 "da018fc61694753ecb7ac33b21215fd6fb2ba660bd7d6c56245891de1a5f061c"
  license "MIT"
  revision 2

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina


  # Fix compatibility with Ruby 3.2, remove in next release
  patch do
    url "https://github.com/CocoaPods/CocoaPods/commit/2af8ba7e3477296d975243eeb1c12f379ab556a1.patch?full_index=1"
    sha256 "391da12230d5e413853d96af7f310f5e588e80974df82caf1284c3d6f467cabc"
  end

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
