To start with this project you need to 

```bash
terramate run -C stacks/dev --tags bootstrap terraform init
terramate run -C stacks/dev --tags bootstrap terraform apply --auto-approve
find /c/users/joaop/terramate/stacks/dev/bootstrap -name "stack.tm.hcl" -exec sed -i 's/"no-backend", //; s/, "no-backend"//; s/"no-backend"//' {} \;
terramate generate
git add .
git commit -m "removing no-backend tags on dev environment"
terramate run -C stacks/dev --tags bootstrap terraform init --auto-approve
```




```bash
terramate list --run-order #Show order
```