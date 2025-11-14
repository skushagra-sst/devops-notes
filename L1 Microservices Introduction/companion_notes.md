# 📘 Revision Notes: Introduction to Microservices and DevOps

## 🧩 Introduction to Microservices

### **What are Microservices?**

Microservices are an architectural style that structures an application as a collection of **loosely coupled**, **fine-grained**, and **independently deployable** services.  
Unlike monolithic architectures—where the entire application exists as one large unit—microservices break it into small, autonomous services.

### **Benefits of Microservices**

- **Scalability:** Each service can scale independently for efficiency.
- **Flexibility in Technology Stack:** Different services can use different languages or frameworks.
- **Independent Deployment:** Services can be released or updated without touching others.

---

## 🔑 Key Concepts in Microservices

### **REST API Communication**

Microservices commonly communicate through **REST APIs**, allowing interoperability regardless of language, since they rely on HTTP/HTTPS.  
_Reference: _

### **Statelessness**

Microservices should be **stateless**, meaning they do not store client session data internally.  
State is kept in external data stores, enabling easy scaling.  
_Reference: _

### **Externalized Logging**

Logs are stored externally so developers can trace issues even if a service fails.  
Common tools: **Fluentd, ELK Stack, Splunk**.  
_Reference: _

### **Load Balancing and DNS**

- **Load Balancer:** Spreads traffic across servers for availability and stability.  
  _Reference: _
- **DNS:** Converts domain names into IP addresses for easy human use.  
  _Reference: _

---

## 🚀 DevOps Introduction

### **Importance of DevOps**

DevOps integrates **Development (Dev)** and **Operations (Ops)** to shorten development cycles and achieve continuous, high-quality software delivery.  
_Reference: _

### **Continuous Integration / Continuous Deployment (CI/CD)**

- **CI:** Automatically tests and integrates code changes frequently.
- **CD:** Automates deployment into production environments.  
  _Reference: _

Tools and examples for a full CI/CD pipeline were discussed in class.  
_Reference: _

---

## 🛠️ Upcoming Topics

Future sessions will cover:

- **Docker** → containerization
- **Kubernetes** → orchestration

Assignments and participation are also part of grading.  
_Reference: _

---

## 👥 Class Dynamics and Participation

- Daily notes on GitHub encourage discipline and active involvement.  
  _Reference: _
- Hands-on labs will follow theory to reinforce learning.  
  _Reference: _

---

This summary encapsulates the key ideas of microservices and DevOps, providing a foundational understanding for modern scalable software systems.
