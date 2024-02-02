# the setup

## generate.py

generate a lambda.py test handler

### lambda.py / lambda.py.template

the handler is deliberately simplistic, this is not testing further dependencies like S3 triggers \
to gaurantee variation, lambda.py is generated with a random string-safe code \
for readability, we also include the time \
it logs both to AWS

# RESULTS

Both configurations require use of

```tf
  lifecycle {
    replace_triggered_by = [thing]
  }

  resource "null_resource" "sauce" {
  triggers = {
    main = sha256(file("${path.module}/../lambda.py"))
  }
}
```

where `thing` is in this case `null_resource.sauce` or a transitive `resource` dependency thereto \
generally I'd reccomend not reaching directly, but through transitives to make reasoning clear \
null resources are **very** opaque in their use without documentation

the null resource is required to fake out a resource dependency upon the identity of the source \
within terraform we can fingerprint identities using `sha256` or some variant \
the strict lifecycle block will then be provoked into a _complete_ replacement of the resource

## S3 deployment notes

updating an S3 object is _not_ sufficient to update a lambda source \
redeployment via S3 requires `lifecycle` replacements throughout the affected branch \
this can be verified by removing the `lifecycle` block from `lam_bucketed.tf` and `make invoke` \
the codes and times will gradually deviate as bucketed is unmodified
