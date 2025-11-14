# Microservices Architecture

## Introduction

- Microservices are small, independent applications that communicate via APIs
- Contrast with monolithic architecture (single large application)

## Key Components

### DNS (Domain Name System)

- Maps domain names to IP addresses
- First point of contact for customer requests

### Load Balancer

- Distributes traffic among multiple instances
- Two types of load balancing:
  1. Path-based routing
  2. Instance selection

### Authentication and Authorization (A&A)

- Verifies user identity and permissions
- Often uses Redis or Memcache for fast data retrieval

### Microservices Communication

- Synchronous: Blocking, direct communication
- Asynchronous: Non-blocking, uses message brokers (e.g., Kafka, RabbitMQ)
  - Two types: Publish-Subscribe model and Queue model

### API Gateway

- Handles API requests from clients
- Performs authentication, authorization, and routing

### Databases

- Each microservice should have its own database (Single Database per Service pattern)
- Can be SQL or NoSQL

### Event Syncing

- Tracks timing and instance information for service calls

### Logging

- Externalized logs for easier troubleshooting
- Tools: Fluentd, ELK Stack, Splunk, Dynatrace

## 12-Factor App Principles

1. Codebase: One codebase per microservice
2. Dependencies: Explicitly declare and isolate dependencies
3. Config: Store configuration in the environment
4. Build, release, run: Separate build and run stages
5. Processes: Execute the app as stateless processes
6. Port binding: Export services via port binding
7. Concurrency: Scale out via the process model
8. Disposability: Maximize robustness with fast startup and graceful shutdown
9. Dev/prod parity: Keep development, staging, and production as similar as possible
10. Logs: Treat logs as event streams
11. Admin processes: Run admin/management tasks as one-off processes
12. Stateless design: Ensure services are stateless for scalability

## Best Practices

- Externalize logs
- Implement service discovery
- Use API-based communication between services
- Design services to be stateless
- Implement proper monitoring and reporting
