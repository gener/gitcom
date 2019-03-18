# gitcommit

Utility for making beautiful commit and check commit message format

## Getting Started

1. Download the project, open it in Xcode. 
2. Change the Team Signing section in project file. 
3. Build and archive project. 
4. Open the directory with executable file. 
5. Run `./gitcom integrate git` to install app in your system (copy gitcom executable file into usr/loclal/bin directory. Allows to use **gitcom**, **git cm** and **git-cm** commands ).

## Usage

### Integration
**integrate** command is used for handy utility usage. 
Arguments:
- **git** - copy gitcom executable file into usr/loclal/bin directory. Allows to use **gitcom**, 
            **git cm** and **git-cm** commands. 
- **hook** - add commit message validation command into .git/hooks/commit-msg hook. 
         Can be used when a commit message is entered in the git client window.
- **all** - perform both options.

### Configuration file
#### Creating

Utility uses JSON file for commit message configuration. 
To create default configuration file, run **gitcom generate-config**.

<details><summary><b>Default configuration file</b></summary>

```json
{
  "body" : {
    "request" : "Please enter a body of commit",
    "newLineSpacer" : "|",
    "length" : {

    }
  },
  "footer" : {
    "length" : {

    },
    "prefix" : "META:",
    "enabled" : true,
    "request" : "Please enter a footer of commit"
  },
  "header" : {
    "scope" : {
      "skiptRequest" : "Do not add scope.",
      "enabled" : true,
      "items" : [
        {
          "key" : "core",
          "value" : "Part of code in core ypu application"
        },
        {
          "key" : "styles",
          "value" : "Code related by styles or markup of project"
        },
        {
          "key" : "unit_tests",
          "value" : "Creation or modification unit tests"
        },
        {
          "key" : "ui_test",
          "value" : "Creation or modification test of interfaces"
        },
        {
          "key" : "stylefix",
          "value" : "Markup fixing",
          "types" : [
            "fix"
          ]
        },
        {
          "key" : "featfix",
          "value" : "Feature fixing",
          "types" : [
            "fix"
          ]
        },
        {
          "key" : "tempfix",
          "value" : "Temporary fix",
          "types" : [
            "fix"
          ]
        }
      ],
      "skip" : false,
      "request" : "Please, choose you scope of code:"
    },
    "length" : {
      "min" : {
        "value" : 5
      },
      "max" : {
        "value" : 72
      }
    },
    "customScope" : {
      "enabled" : true,
      "length" : {
        "min" : {
          "value" : 2
        },
        "max" : {
          "value" : 5
        }
      },
      "request" : "Please, enter your custom scope (or enter `<` to return to list of scopes):",
      "back" : "<"
    },
    "type" : {
      "request" : "Please, choose you type of commit:",
      "items" : [
        {
          "key" : "build",
          "value" : "Modifications related by configuration or building rules of project"
        },
        {
          "key" : "ci",
          "value" : "Changes for continuous integration"
        },
        {
          "key" : "doc",
          "value" : "Some documentation changes"
        },
        {
          "key" : "feat",
          "value" : "Making some feature"
        },
        {
          "key" : "fix",
          "value" : "Bugfixing"
        },
        {
          "key" : "perf",
          "value" : "Perfomance improvement"
        }
      ]
    },
    "request" : "Please enter a header of commit"
  }
}
```
</details>

Configuration file structure:
- **header**: commit message header
  - request: String - message for request to enter commit header
  - scope: commit scope 
    - skiptRequest: String - message indicating that scope is disabled
    - enabled: Bool - enabled boolean flag
    - items: [Array] - scope items
      - key: String - scope name
      - value: String - scope description
    - skip: Bool - need to skip scope entering
    - request: String - message for request to enter commit scope
  - customScope: commit custom scope
    - enabled: Bool - enabled boolean flag
    - length: length of commit body 
      - min: min item length 
        - value: Int
      - max: max item length
        - value: Int
    - request: String - message for request to enter custom commit scope 
    - back: String - symbol to return back to scope entering
  - type: commit type
    - request: String - message for request to enter commit type
    - items: [Array] - type items
      - key: String - type name
      - value: String - type description
  - length: length of commit body 
    - min: min item length 
      - value: Int
    - max: max item length
      - value: Int
- **body**: commit message body
  - request: String - message for request to enter commit body 
  - newLineSpacer: String - representing new line character
  - length: length of commit body 
    - min: min item length 
      - value: Int
    - max: max item length
      - value: Int
- **footer**: commit message footer
  - length: length of commit body 
    - min: min item length 
      - value: Int
    - max: max item length
      - value: Int
  - prefix: String - prefix for message footer
  - enabled: Bool - enabled boolean flag
  - request: String - message for request to enter commit footer
  
  #### Validation
  Use **gitcom check-config** command to validate your configuration file. 
  
  ### Make commit 
  Use **gitcom make** / **git cm** / **git-cm** command to make commit with formatted message.
  
  ### Validate commit 
Run **gitcom validate** command with commit message as argument for its validation.
<br>Example: `gitcom validate "build: (fix) subject|body|META:footer"`
  