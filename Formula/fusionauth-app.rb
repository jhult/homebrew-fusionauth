class FusionauthApp < Formula
  desc "FusionAuth App"
  homepage "https://fusionauth.io"
  url "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/1.5.0/fusionauth-app-1.5.0.zip"
  sha256 "14bdc6d65622d502149d175ee0765a586e832ae4ef5b5946ff82aee3c7cfde04"

  bottle :unneeded

  def install
    prefix.install "bin" => "sbin"
    prefix.install "fusionauth-app"
    etc.install "config" => "fusionauth" unless File.exists? etc/"fusionauth"
    prefix.install_symlink etc/"fusionauth" => "config"
    (var/"fusionauth/java").mkpath unless File.exists? var/"fusionauth/java"
    prefix.install_symlink var/"fusionauth/java"
    (var/"log/fusionauth").mkpath unless File.exists? var/"log/fusionauth"
    prefix.install_symlink var/"log/fusionauth" => "logs"

    (bin/"fusionauth").write <<~EOS
      #!/bin/bash
      case "$1" in
        start)
          #{prefix}/sbin/startup.sh
          ;;
        stop)
          #{prefix}/sbin/shutdown.sh
          ;;
        *)
          echo "Options are start/stop"
          ;;
      esac
    EOS
  end

  def post_install
    #noop
  end

  def caveats; <<~EOS
      Logs:   #{var}/log/fusionauth/fusionauth-app.log
      Config: #{etc}/fusionauth/fusionauth.properties
    EOS
  end

  plist_options :manual => "fusionauth start"

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
