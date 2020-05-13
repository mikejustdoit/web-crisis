# Web Crisis

## Testing

Automated tests can be run on the Docker container:

```bash
$ ./docker/test
```

You can also (attempt to) render and print screenshots of one or more websites using `docker/printall`. Just provide a list of newline-seperated URIs to its stdin:

```bash
$ echo 'https://kryogenix.org/code/browser/everyonehasjs.html' | ./docker/printall
```

Successful screenshots will be saved to `tmp/`.
