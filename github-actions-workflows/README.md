# A Simple CI Using GitHub Actions

## Introduction to GitHub Actions

### What is GitHub Actions (in Simple Terms)

GitHub Actions lets you run automated tasks when something happens in your repo.

**Examples:**
- When code is pushed → build the app
- When a PR is created → run tests
- When a release is tagged → deploy to production

These automated tasks are defined as workflows written in YAML.

**Key Benefits:**
- Automate repetitive tasks
- Run tests automatically
- Build and deploy applications
- Integrate with external services
- Free for public repositories

## Project Structure (Simple Java App)

We'll use a very basic Java project.

```
java-github-actions-demo/
├── src/
│   └── Main.java
├── pom.xml
└── .github/
    └── workflows/
        └── build.yml
```

## Create a Simple Java Application

### src/Main.java

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from GitHub Actions!");
    }
}
```

This is a simple Java program that prints a message.

## Add Maven Configuration

### pom.xml

This tells Maven how to build your Java project.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>github-actions-demo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>
</project>
```

**Key Elements:**
- `groupId`: Organization/package identifier
- `artifactId`: Project name
- `version`: Project version
- `maven.compiler.source/target`: Java version (17 in this case)

## Understanding GitHub Actions Components

Before writing the workflow, understand these terms:

| Term | Meaning |
|------|---------|
| **Workflow** | The automation (YAML file) |
| **Job** | A set of steps |
| **Step** | A single action or command |
| **Runner** | Machine that runs the job (Linux, Windows, Mac) |
| **Action** | Reusable code (e.g., setup Java) |

### Workflow Structure

```
Workflow
  └── Jobs (can run in parallel or sequence)
      └── Steps (run sequentially)
          └── Actions or Commands
```

## Create the GitHub Actions Workflow

Create this file: `.github/workflows/build.yml`

### Basic Java Build Workflow (Explained Line-by-Line)

#### build.yml

```yaml
name: Java Build Workflow
```

**Name shown in GitHub Actions UI**

```yaml
on:
  push:
    branches:
      - main
```

**Trigger workflow when code is pushed to main branch**

```yaml
jobs:
  build:
```

**Define a job named build**

```yaml
    runs-on: ubuntu-latest
```

**Job runs on a Linux virtual machine**

```yaml
    steps:
```

**List of steps inside this job**

### Step 1: Checkout the Code

```yaml
    - name: Checkout code
      uses: actions/checkout@v4
```

**Downloads your repository code into the runner**

### Step 2: Setup Java

```yaml
    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
```

**Installs Java 17 on the runner**

### Step 3: Build Using Maven

```yaml
    - name: Build with Maven
      run: mvn clean package
```

**Runs Maven build**

- Compiles Java code
- Creates a JAR file

## Full Workflow File (Final)

```yaml
name: Java Build Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Build with Maven
      run: mvn clean package
```

## What Happens When You Push Code?

1. **GitHub detects a push to main**
2. **A Linux VM is created**
3. **Code is checked out**
4. **Java is installed**
5. **Maven builds the project**
6. **If build succeeds → green check**
7. **If build fails → red cross with logs**

## Where to See the Output

1. Go to GitHub Repo → **Actions** tab
2. Click on the workflow run
3. Open **Build with Maven** step to see logs

**You can see:**
- Which steps ran
- Build output
- Any errors
- Execution time

## Common Beginner Mistakes

| Mistake | Fix |
|---------|-----|
| Wrong Java version | Match Java in pom.xml |
| Missing .github/workflows | Folder name must be exact |
| YAML indentation error | Use 2 spaces, not tabs |
| Maven not found | Use setup-java action |

## Workflow Triggers

### Push to Branch

```yaml
on:
  push:
    branches:
      - main
      - develop
```

### Pull Request

```yaml
on:
  pull_request:
    branches:
      - main
```

### Multiple Triggers

```yaml
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:  # Manual trigger
```

## Available Runners

GitHub provides hosted runners:

- **ubuntu-latest** (Ubuntu 22.04)
- **windows-latest** (Windows Server 2022)
- **macos-latest** (macOS 13)

**Example:**
```yaml
runs-on: ubuntu-latest
```

## Common Actions

### Checkout Code

```yaml
- uses: actions/checkout@v4
```

### Setup Java

```yaml
- uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'
```

### Setup Node.js

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'
```

### Setup Python

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'
```

## Advanced Workflow Features

### Matrix Strategy

Run the same job on multiple configurations:

```yaml
strategy:
  matrix:
    java-version: [17, 21]
    os: [ubuntu-latest, windows-latest]
```

### Conditional Steps

Run steps only if conditions are met:

```yaml
- name: Deploy
  if: github.ref == 'refs/heads/main'
  run: echo "Deploying..."
```

### Environment Variables

```yaml
env:
  JAVA_HOME: /usr/lib/jvm/temurin-17
  MAVEN_OPTS: -Xmx2048m
```

### Caching Dependencies

Speed up builds by caching:

```yaml
- name: Cache Maven dependencies
  uses: actions/cache@v3
  with:
    path: ~/.m2
    key: ${{ runner.os }}-m2-${{ hashFiles('**/pom.xml') }}
```

## Workflow Best Practices

1. **Use specific action versions** - Pin to major version (e.g., `@v4`)
2. **Keep workflows simple** - One job per purpose
3. **Use matrix for multiple versions** - Test on different configurations
4. **Cache dependencies** - Speed up builds
5. **Add meaningful step names** - Easier debugging
6. **Use secrets for sensitive data** - Never hardcode credentials
7. **Test workflows locally** - Use `act` or similar tools

## Troubleshooting

### Workflow Not Running

**Check:**
- File is in `.github/workflows/` directory
- YAML syntax is correct
- Trigger conditions match your actions
- Branch name matches

### Build Failing

**Check:**
- Java version matches pom.xml
- Dependencies are available
- Build commands are correct
- Check logs for specific errors

### Slow Workflows

**Solutions:**
- Cache dependencies
- Use matrix for parallel jobs
- Optimize build steps
- Remove unnecessary steps

## Summary

**Key Takeaways:**

1. **GitHub Actions automates workflows** - Define in YAML files
2. **Workflows run on triggers** - Push, PR, schedule, manual
3. **Jobs run on runners** - Linux, Windows, macOS
4. **Steps execute sequentially** - Actions or commands
5. **Actions are reusable** - Community and official actions available
6. **Workflows are version controlled** - Stored in `.github/workflows/`

**Benefits:**
- Automate CI/CD pipelines
- Run tests automatically
- Build and deploy applications
- Integrate with external services
- Free for public repositories

Mastering GitHub Actions enables automated software development workflows, improving code quality and deployment efficiency.
