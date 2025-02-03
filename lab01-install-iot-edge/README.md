# Lab 01. Install IoT Edge on VM

If you are using RedHat 8.x, you can follow the steps [here](docs/install-iotedge-redhat.md) to install IoT Edge on a VM. Otherwiser, for Ubuntu 18.04, you can follow the steps below.

https://learn.microsoft.com/en-us/azure/iot-edge/quickstart-linux

## Step 1. Create Azure VM

Create a copy of the file `.env.template` with the name `.env`, customize the settings and then you can use the following scripts:

```bash
./create-vm-01.sh 
```

## Step 2. Register new device

Just run:

```bash
./register-device-02.sh 
```

## Step 3. Install IoT Edge runtime

### Update packages

Login to the edge VM and run:


```bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
```

### Install a container engine

1. Run this:

    ```bash
    sudo apt-get install -y moby-engine
    ```

2. Create or open the Docker daemon's config file at `/etc/docker/daemon.json`:

    ```bash
    sudo vi /etc/docker/daemon.json
    ```

3. Set the default logging driver to the local logging driver as shown in the JSON example below:

    ```json
    {
        "log-driver": "local"
    }
    ```

4. Restart the container engine for the changes to take effect.

    ```bash
    sudo systemctl restart docker
    ```

### Install the IoT Edge runtime

```bash
sudo apt-get install -y aziot-edge
```

### Provision device with its cloud identity

```bash
# Create config file
sudo iotedge config mp --connection-string 'PASTE_DEVICE_CONNECTION_STRING_HERE'

# Apply configuration
sudo iotedge config apply

# Get config file
sudo cat /etc/aziot/config.toml
```

### Step 3. Deploy modules

To deploy your IoT Edge modules, go to your IoT hub in the Azure portal, then:

1. Select Devices from the IoT Hub menu.
2. Select your device to open its page.
3. Select the Set Modules tab.
4. Since we want to deploy the IoT Edge default modules (edgeAgent and edgeHub), we don't need to add any modules to this pane, so select Review + create at the bottom.
5. You see the JSON confirmation of your modules. Select Create to deploy the modules.

Check to see that the IoT Edge system service is running.

```bash
sudo iotedge system status

# If you need to troubleshoot the service, retrieve the service logs.
sudo iotedge system logs

# Use the check tool to verify configuration and connection status of the device.
sudo iotedge check

# Once your modules are deployed and running, list them in your device
sudo iotedge list
```
