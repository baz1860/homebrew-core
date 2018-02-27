class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.22.0.tar.gz"
  sha256 "4e08e9a884db6794967518b70cd0b052ea4098c84d4e6bfa1d7d6d8dcda40f62"

  bottle :unneeded

  option "with-bash-snippets", "Install bash-snippets gui"
  option "with-cheat", "Install cheat"
  option "with-cloudup", "Install cloudup"
  option "with-crypt", "Install crypt"
  option "with-cryptocurrency", "Install cryptocurrency"
  option "with-currency", "Install currency"
  option "with-geo", "Install geo"
  option "with-lyrics", "Install lyrics"
  option "with-meme", "Install meme"
  option "with-movies", "Install movies"
  option "with-newton", "Install newton"
  option "with-pwned", "Install pwned"
  option "with-qrify", "Install qrify"
  option "with-short", "Install short"
  option "with-siteciphers", "Install siteciphers"
  option "with-stocks", "Install stocks"
  option "with-taste", "Install taste"
  option "with-todo", "Install todo"
  option "with-transfer", "Install transfer"
  option "with-weather", "Install weather"
  option "with-ytview", "Install ytview"
  option "without-all-tools", "Do not install all available snippets"

  if build.with?("all-tools") || build.with?("cheat")
    conflicts_with "cheat", :because => "Both install a `cheat` executable"
  end

  def install
    if build.with? "all-tools"
      system "./install.sh", "--prefix=#{prefix}", "all"
    else
      args = []
      %w[bash-snippets cheat cloudup crypt cryptocurrency currency geo lyrics movies newton qrify
         short siteciphers stocks taste todo transfer weather ytview].each do |tool|
        args << tool if build.with? tool
      end
      system "./install.sh", "--prefix=#{prefix}", *args
    end
  end

  test do
    if build.with?("all-tools") || build.with?("weather")
      output = shell_output("#{bin}/weather Paramus").lines.first
      assert_equal "Weather report: Paramus, United States of America", output.chomp
    end
    if build.with?("all-tools") || build.with?("qrify")
      output = shell_output("#{bin}/qrify This is a test")
      assert_match "████ ▄▄▄▄▄ █▀ █▀▄█ ▄▄▄▄▄ ████", output
    end
    if build.with?("all-tools") || build.with?("stocks")
      assert_match "AAPL stock info", shell_output("#{bin}/stocks Apple")
    end
  end
end
