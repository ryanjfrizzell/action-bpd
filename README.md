# status
master: ![.github/workflows/main.yml](https://github.com/ryanjfrizzell/action-bpd/workflows/.github/workflows/main.yml/badge.svg)
integraion: 

# action-bpd
"action-build push docker"
sometimes you just want to build and push a docker image, and also see what the code has going on quickly. No minified js just good 'ol grandpa bash.

### Using
as is always good practice, the .github/workflows/main.yml file in this repo covers some decent examples of how to use for GitHub packages and for 
Docker Hub. Generally speaking, you need to create secrets in dockerhub for user your Docker login and password. Once those are in place you can use this 
to build an push docker images. 

#### Example: 

```
on: [push,pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    name: test out our github action with no image version
    steps:
    - name: git checkout
      uses: actions/checkout@v2
    - name: test 
      id: test
      uses: ryanjfrizzell/action-bpd@master
      with:
        docker_registry_url: 'docker.pkg.github.com'
        docker_registry_owner: 'ryanjfrizzell'
        docker_repository: 'action-bpd'
        docker_image: 'bpdautolatest'
        docker_username: ${{ secrets.docker_username }}
        docker_password: ${{ secrets.docker_password }}
        dockerfile: 'test/Dockerfile.test'
    - name: Get the output
      run: |
          echo "imageinfo was ${{ steps.test.outputs.imageinfo }}"
```

### Contributing: 
* fork code
* make pull request to integration branch
* discuss
* merge

### Notes for dockerhub: 
* see the main.yml in our .github/workflows/main.yml
* pass dockerhub: 'true'
* use the registry override feature
* I wasn't able to successfully get things working with hub.docker.com without creating an access token and using that as my password. (set in secrets)
* Combine that with using the registry_override setting
