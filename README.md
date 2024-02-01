# the goal

it'd really help ops if we could [try this](https://stackoverflow.com/questions/48577727/how-to-trigger-terraform-to-upload-new-lambda-code)
and get terraform to automagically update lambda.py

## generate.py

generate a lambda.py test handler

### lambda.py

the handler is deliberately simplistic, this is not testing further dependencies like S3

to gaurantee variation, lambda.py is generated with a random string-safe code

for readability, we also include the time

it logs both to AWS
