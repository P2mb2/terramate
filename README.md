To start with a new environment you just need to run the script create_env.sh

```bash
sh create_env.sh
```

```bash
terramate run -C stacks/dev --tags bootstrap terraform init
terramate run -C stacks/dev --tags bootstrap terraform apply -auto-approve
find /c/users/joaop/terramate/stacks/dev/bootstrap -name "stack.tm.hcl" -exec sed -i 's/"no-backend", //; s/, "no-backend"//; s/"no-backend"//' {} \;
terramate generate
git add .
git commit -m "removing no-backend tags on dev environment"
terramate run -C stacks/dev --tags bootstrap terraform init -migrate-state -force-copy
terramate run -C stacks/dev --tags bootstrap rm *.tfstate*
```




```bash
terramate list --run-order #Show order
```