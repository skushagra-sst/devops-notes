Q: What is the main difference between microservices and monolithic architecture?
A: Microservices are small, independent applications that communicate via APIs, while monolithic architecture is a single large application.

Q: What is the role of DNS in microservices architecture?
A: DNS maps domain names to IP addresses and is the first point of contact for customer requests.

Q: What are the two types of load balancing in microservices?
A: 1. Path-based routing 2. Instance selection

Q: What is the purpose of Authentication and Authorization (A&A) in microservices?
A: A&A verifies user identity and permissions.

Q: What are the two types of communication between microservices?
A: Synchronous (blocking) and Asynchronous (non-blocking)

Q: What is the difference between Publish-Subscribe model and Queue model in asynchronous communication?
A: In Publish-Subscribe, subscribers are notified of messages, while in Queue model, subscribers actively retrieve messages.

Q: What is the Single Database per Service pattern?
A: Each microservice should have its own independent database.

Q: Why is it important to externalize logs in microservices?
A: Externalized logs make troubleshooting easier, especially when dealing with multiple service instances.

Q: What is the purpose of an API Gateway?
A: API Gateway handles API requests from clients, performs authentication, authorization, and routing.

Q: What does "stateless" mean in microservices design?
A: Stateless means that services don't store any client data between requests, making them more scalable.

Q: What is event syncing in microservices?
A: Event syncing tracks timing and instance information for service calls.

Q: Name three tools used for logging in microservices.
A: Fluentd, ELK Stack, and Splunk.

Q: What is the significance of the 12-Factor App in microservices?
A: The 12-Factor App provides guidelines for building scalable, maintainable microservices applications.

Q: Why is it important to have separate codebases for each microservice?
A: Separate codebases allow for independent development, deployment, and scaling of each microservice.

Q: What is the benefit of port binding in microservices?
A: Port binding allows services to be self-contained and exported via ports, making them more portable.
