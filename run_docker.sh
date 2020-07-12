# Step 1:
# Build image and add a descriptive tag
docker build --tag=denyshubh/myportfolio_client .

# Step 2: 
# List docker images
docker image ls

# Step 3: 
# Run create-react-app
docker run -p 4000:80 denyshubh/myportfolio_client
