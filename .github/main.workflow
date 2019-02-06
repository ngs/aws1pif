workflow "Build" {
  on = "release"
  resolves = ["HTTP client"]
}

action "build darwin/amd64" {
  uses = "docker://golang:1.11-alpine"
  runs = "go build"
  env = {
    GOOS = "darwin"
    GOARCH = "amd64"
  }
}

action "HTTP client" {
  uses = "swinton/httpie.action@02571a073b9aaf33930a18e697278d589a8051c1"
  needs = ["build darwin/amd64"]
  runs = "ls -lsa"
}
