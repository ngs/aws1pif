workflow "Build" {
  on = "push"
  resolves = [
    "build darwin/amd64",
    "release darwin/amd64",
  ]
}

action "build darwin/amd64" {
  uses = "./.github/actions/build"
  env = {
    GOOS = "darwin"
    GOARCH = "amd64"
  }
}

action "release darwin/amd64" {
  uses = "./.github/actions/release"
  needs = ["build darwin/amd64"]
  env = {
    GOOS = "darwin"
    GOARCH = "amd64"
  }
}

