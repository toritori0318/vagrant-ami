# Create AMIs from Vagrant EC2 boxes

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin that adds a command
to create [AWS](http://aws.amazon.com) AMIs.

This plugin has a very short lifespan in terms of usefulness.

Technically this plugin is already superseded by [Packer](http://packer.io) which
is a more general solution for creating various types of machine images.

However, Packer does not yet have the same level of provisioner support enjoyed
by Vagrant. Until then, I need a simple way to make AMIs based on Vagrant EC2 boxes
provisioned with Puppet and Chef, which can be called easily from Jenkins.

**NOTE:** This plugin requires Vagrant 1.2+,


## Features

* Create AMIs from Vagrant-managed EC2 instances
* Assign tags to newly-created AMIs


## Usage

Install using standard Vagrant 1.1+ plugin installation methods. After
bringing up an AwS instance issue the command to create the AMI as shown
below.

```
$ vagrant plugin install vagrant-ami
...
$ vagrant up --provider=aws
...
$ vagrant create_ami --name my-ami --desc "My AMI" --tags role=test,environment=dev
...
$ vagrant destroy
```

vagrant-ami relies heavily on vagrant-aws, and reuses all of its configuration settings.
