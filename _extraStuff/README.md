## Helper scripts

### ./upload-images
You can use these to help with uploading binaries to the Pi
Example:
```
# Starts a http server on the host, connects to the target, mounts the SD and downloads the images onto it:
./upload-images-to-pi.sh root@localhost p30314
```

### ./diffconfig
Is my patch of a [script from the kernel sources](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/scripts/diffconfig)
to make it usable with buildroot, and add some colors to make the output nicer to read,  
I might add some more small things later

