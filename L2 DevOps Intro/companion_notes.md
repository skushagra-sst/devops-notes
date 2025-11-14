# 📘 DevOps Class Revision Notes

## 🔎 Overview of DevOps

### **What is DevOps?**

DevOps is a set of **practices**, **cultural philosophies**, and **tools** that integrate software development and IT operations to deliver applications **more rapidly and reliably**.  
These three components work together to streamline product delivery and improve reliability within an organization.  
_Reference: _

---

## ⚠️ Challenges in DevOps

The **cultural shift** required in DevOps—especially around change management—is one of its biggest challenges.  
DevOps often requires persuading teams with long-established processes to adopt new methodologies.  
_Reference: _

---

## 🧩 Key Concepts in DevOps

### **DevOps Philosophy**

Unifies software **development (Dev)** and **operations (Ops)** with shared principles and goals.  
_Reference: _

### **Shift Left Approach**

Encourages performing testing **earlier** in the development lifecycle to detect faults sooner.  
_Reference: _

---

## 🔐 Security Testing in DevOps

### **Types of Security Testing**

- **Static Application Security Testing (SAST):**  
  Examines source code for vulnerabilities **without executing** it.  
  _Reference: _

- **Dynamic Application Security Testing (DAST):**  
  Tests applications **while running**, checking for runtime vulnerabilities.  
  _Reference: _

- **Software Composition Analysis (SCA):**  
  Scans for vulnerabilities in open-source and third-party libraries.  
  _Reference: _

### **Example of Code Vulnerability**

A common security issue is **SQL Injection**.  
Using Java’s `Statement` can expose the application to attacks if inputs aren’t sanitized.  
Using `PreparedStatement` helps prevent these attacks by safely escaping user input.  
_Reference: _

---

## 🔄 Continuous Integration (CI) in DevOps

### **CI Workflow Steps**

1. **Code Checkout:** Pulling the latest code from the repository.  
   _Reference: _

2. **Dependency Management:** Installing dependencies required for building the code.  
   _Reference: _

3. **Linting:** Running tools that ensure code quality.  
   _Reference: _

4. **Building:** Compiling/packaging the software.  
   _Reference: _

5. **Testing:** Executing unit tests to validate code functionality.  
   _Reference: _

6. **Security Checks:** Running SAST and SCA tools.  
   _Reference: _

7. **Artifact Creation:** Generating build artifacts (Docker images, binaries, etc.).  
   _Reference: _

8. **Deployment:** Releasing the build to a staging/testing environment.  
   _Reference: _

---

## 🚀 Continuous Deployment (CD)

CD automatically deploys code **after CI completes successfully**.  
Manual approval occurs only when configured thresholds or compliance needs require it.  
The goal: smooth, automated, reliable deployment pipelines.  
_Reference: _

---

## 🔗 Communication & Coordination in DevOps

### **API Gateway**

Routes requests to microservices and handles:  
✔ Authorization  
✔ Rate limiting (throttling)  
✔ Request routing  
_Reference: _

### **Inter-Service Communication**

Microservices communicate via:

- **Synchronous (blocking / real-time)**
- **Asynchronous (non-blocking)** using message brokers like **RabbitMQ** or **Kafka**  
  _Reference: _

---

## 📌 Conclusion

DevOps aims to align development and operations teams to enhance automation, efficiency, and application reliability.  
By adopting DevOps practices, organizations achieve better software delivery, improved collaboration, and higher overall productivity.  
_Reference: _
