# super-duper-train

Infrastructure scripts to build up a network, an ecs envronment with a db and finally a service (with multi-environment support)

* `ami` folder contains the base ami for the ecs cluster
* inside the `modules` folder we can find:
** network module to setup a basic vpc with 2 direct-connect + 2 nat subnets
** ecs module that sets up all you need to run ec2 docker-container service (autoscaling group, some policies) and a postgres db
** base_service module which is the first draft for the [symmetrical-octo-parakeet](https://github.com/shipperizer/symmetrical-octo-parakeet) project, a basic [Phoenix](http://www.phoenixframework.org/) app (under seldom-ish development/ learning base)

There is a remote-state sharing that is not in place yet, as nothing is up and running, eventually this is going to be an easy task though (hopefully)
