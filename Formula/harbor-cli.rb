class HarborCli < Formula
  desc "[Sandbox] Official Harbor CLI"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.2.tar.gz"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/harbor"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/harbor version")
    # Test for handling credential store error during project creation.
    assert_match "failed to read credential store", shell_output("#{bin}/harbor create project 2>&1", 1)
  end

end
