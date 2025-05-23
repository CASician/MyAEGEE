# The errors Cri has encountered
## A thread - Linux Ubuntu

### A customization command failed:
    A customization command failed:
    ["modifyvm", :id, "--name", "appserver.test-docker-AEGEE", "--memory", "2048"]
    The following error was experienced:

    Vagrant::Errors::VBoxManageError: There was an error while executing VBoxManage, a CLI used by Vagrant
    for controlling VirtualBox. The command and stderr is shown below.
    Command: ["modifyvm", "e8715714-5f4d-4710-80ad-535ac807bbe0", "--name", "appserver.test-docker-AEGEE", "--memory", "2048"]
    Stderr: VBoxManage: error: Could not rename the directory '/home/carpe/VirtualBox VMs/MyAEGEE_appservertest_1747669007955_1382' to '/home/carpe/VirtualBox VMs/appserver.test-docker-AEGEE' to save the settings file (VERR_ALREADY_EXISTS)
    VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component SessionMachine, interface IMachine, callee nsISupports
    VBoxManage: error: Context: "SaveSettings()" at line 3640 of file VBoxManageModifyVM.cpp

    Please fix this customization and try again.

- Solved with: 

`rm -rf "/home/carpe/VirtualBox VMs/appserver.test-docker-AEGEE"`


### Worrying for thousands of DEPRECATED warnings
- Solved with: chilling. If it doesn't interrupt the installation is not a real problem. 

### appserver.test: Error response from daemon: No such container: myaegee_frontend_1
    appserver.test: Error response from daemon: No such container: myaegee_frontend_1
    The SSH command responded with a non-zero exit status. Vagrant
    assumes that this means the command failed. The output for this command
    should be in the log above. Please read the output to determine what
    went wrong.

- Solved with: hit `./start.sh` again. 

### appserver.test: ERROR: unable to select packages:
    appserver.test: ERROR: unable to select packages:
    appserver.test:   curl-8.11.1-r0:
    appserver.test:     breaks: world[curl=8.11.0-r2]
    appserver.test: The command '/bin/sh -c rm -rf /etc/nginx/conf.d  && apk --no-cache add curl=8.11.0-r2  && chown -R www-data:www-data /usr/app/' returned a non-zero code: 1
    appserver.test: Service 'frontend' failed to build : Build failed
    appserver.test: Makefile:26: recipe for target 'start' failed
    appserver.test: make: *** [start] Error 1
    The SSH command responded with a non-zero exit status. Vagrant
    assumes that this means the command failed. The output for this command
    should be in the log above. Please read the output to determine what
    went wrong.

- Solved with: since it stopped the Frontend build, go to frontend>docker>line 22, and remove curl version.
`apk --no-cache add curl=8.11.0-r2` -> `apk --no-cache add curl`

### Browser (Firefox) can't open MyAEGEE but the installation was successful. 
- Solved with: check the link: it's supposed to be `http`, not `https`. 

### There was an error while executing `VBoxManage`, a CLI used by Vagrant
    There was an error while executing `VBoxManage`, a CLI used by Vagrant
    for controlling VirtualBox. The command and stderr is shown below.

    Command: ["startvm", "e8715714-5f4d-4710-80ad-535ac807bbe0", "--type", "headless"]

    Stderr: VBoxManage: error: VirtualBox can't operate in VMX root mode. Please disable the KVM kernel extension, recompile your kernel and reboot (VERR_VMX_IN_VMX_ROOT_MODE)
    VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component ConsoleWrap, interface IConsole

- Solved with: (specific for Ubuntu Linux) removing KVM. 

`echo -e "blacklist kvm\nblacklist kvm_intel" | sudo tee /etc/modprobe.d/blacklist-kvm.conf`

`sudo update-initramfs -u`

`sudo reboot`

(after restart check if they are deleted)

`lsmod | grep kvm`
(if nothing shows up, they have been removed correctly)
`vagrant up`

