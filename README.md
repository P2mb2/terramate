To start with this project you need to 

```bash
terramate run -C stacks/dev --tags bootstrap terraform init
terramate run -C stacks/dev --tags bootstrap terraform apply --auto-aprove
```


```bash
terramate list --run-order #Show order
```