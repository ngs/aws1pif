package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/ngs/go-onepif"
)

type credentials struct {
	url             string
	username        string
	password        string
	accessKeyID     string
	secretAccessKey string
	accountID       string
}

func main() {
	s := bufio.NewScanner(os.Stdin)
	line := 0
	for s.Scan() {
		if line == 1 {
			fmt.Println(writeJSON(parseLine(s.Text())))
			break
		}
		line++
	}
}

func parseLine(line string) credentials {
	comps := strings.Split(line, ",")
	url := comps[4]
	re := regexp.MustCompile("^https://([^/]+)\\.signin\\.aws\\.amazon\\.com.*")
	m := re.FindAllStringSubmatch(url, 1)
	accountID := m[0][1]
	return credentials{
		url:             url,
		username:        comps[0],
		password:        comps[1],
		accessKeyID:     comps[2],
		secretAccessKey: comps[3],
		accountID:       accountID,
	}
}

func writeJSON(credentials credentials) string {
	data := &onepif.Onepif{
		LocationKey: "amazon.com",
		Title:       fmt.Sprintf("AWS %s@%s", credentials.username, credentials.accountID),
		Location:    credentials.url,
		TypeName:    "webforms.WebForm",
		SecureContents: onepif.SecureContent{
			URLs: []onepif.URL{{
				Label: "Console",
				URL:   credentials.url,
			}},
			Fields: []onepif.FormField{
				onepif.FormField{Value: credentials.username, Name: "username", Type: "T", Designation: "username"},
				onepif.FormField{Value: credentials.password, Name: "password", Type: "P", Designation: "password"},
			},
			Sections: []onepif.Section{
				onepif.Section{
					Title: "API Credentials",
					Fields: []onepif.Field{
						onepif.Field{Kind: "string", Value: credentials.accessKeyID, Title: "AWS_ACCESS_KEY_ID"},
						onepif.Field{Kind: "string", Value: credentials.secretAccessKey, Title: "AWS_SECRET_ACCESS_KEY"},
					},
				},
				onepif.Section{
					Title: "Account",
					Fields: []onepif.Field{
						onepif.Field{Kind: "string", Value: credentials.accountID, Title: "Account ID"},
					},
				},
			},
		},
	}
	json, _ := json.MarshalIndent(data, "", "  ")
	return string(json)
}
