class FusionauthApp < Formula
  desc "FusionAuth App"
  homepage "https://fusionauth.io"
  url "https://files.fusionauth.io/products/fusionauth/1.36.5/fusionauth-app-1.36.5.zip"
  sha256 "dd7f15ae499ca983b74dfd9288cf24a773097eed21f114c0b9a96fbf26f1eac1"

  def install
    prefix.install "fusionauth-app"
    etc.install "config" => "fusionauth" unless File.exists? etc/"fusionauth"
    prefix.install_symlink etc/"fusionauth" => "config"
    (var/"fusionauth/java").mkpath unless File.exists? var/"fusionauth/java"
    prefix.install_symlink var/"fusionauth/java"
    (var/"log/fusionauth").mkpath unless File.exists? var/"log/fusionauth"
    prefix.install_symlink var/"log/fusionauth" => "logs"
  end

  def post_install
    #noop
  end

  def caveats; <<~EOS
      Logs:   #{var}/log/fusionauth/fusionauth-app.log
      Config: #{etc}/fusionauth/fusionauth.properties
    EOS
  end

  # http://www.manpagez.com/man/5/launchd.plist/
  def plist; <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>sh</string>
          <string>catalina.sh</string>
          <string>run</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{prefix}/fusionauth-app/apache-tomcat/bin</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/fusionauth/fusionauth-app.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/fusionauth/fusionauth-app.log</string>
      </dict>
      </plist>
    EOS
  end
end
