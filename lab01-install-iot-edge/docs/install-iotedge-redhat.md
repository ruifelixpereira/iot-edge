# Lab 01. Install IoT Edge on VM (RedHat 8.x)

### Update packages

Just run:

```
wget https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm -O packages-microsoft-prod.rpm
sudo yum localinstall -y packages-microsoft-prod.rpm
rm packages-microsoft-prod.rpm
```

### Install a container engine

1. Run this:

    ```
    sudo yum install -y moby-engine moby-cli
    ```

2. Create or open the Docker daemon's config file at `/etc/docker/daemon.json`:

    ```
    sudo vi /etc/docker/daemon.json
    ```

3. Set the default logging driver to the local logging driver as shown in the JSON example below:

    ```
    {
        "log-driver": "local"
    }
    ```

4. Restart the container engine for the changes to take effect.

    ```
    sudo systemctl restart docker
    ```

## Install the IoT Edge runtime

```
sudo yum install -y aziot-edge
```
