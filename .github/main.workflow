workflow "Build" {
  on = "release"
  resolves = [
    "release darwin/amd64",
  ]
}

action "release darwin/amd64" {
  uses = "ngs/go-release.action@master"
  env = {
    GOOS = "darwin"
    GOARCH = "amd64"
  }
  secrets = ["GITHUB_TOKEN"]
}
