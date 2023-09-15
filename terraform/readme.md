# DND Interview Terraform

This is an example repo for the purposes of establishing your aptitude with terraform and AWS application design.

The intent is to provide a terraformed environment for the application example.dyedurham.dev. This contains:

* a VPC with: 
  * 3 networks; public, private and database.
  * Basic security group rules.
* a managed Microsoft AD.
* web and application servers running Windows.
* a jump host for managing the instance for application administration.
* an ALB for the web and application servers.
* a managed database service running PostgreSQL.
* a managed SFTP instance for clients to upload documents to.
* supporting AWS resources

The web servers should be accessed via a public ALB, while the ALB for the app servers should only be accessible via private subnets.

## Things to prep for your interview

Draw up a rough layout of what is deployed by this TF code. This should include details like subnet boundaries, and what is/isn't accessible via the internet.

Propose at least 3 fixes that need to be made on this repo to achieve the intent stated above. These can be from any perspective, from not achieving the goals, to not being secure, to being bad TF practice, or anything else that stands out to you.

Using Github Actions we want to automate the linting/validation of any fixes to this repo, and then have an approval process that leads to terraform changes being applied. Describe how you would go about achieving this. No need to write valid Github Actions code, metacode / general description is fine. 
