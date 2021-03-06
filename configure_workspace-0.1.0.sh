if [ `whoami` != "root" ]; then
  echo
  echo "The chef-moderniztion-setup script must be run as root."
  echo "Please execute the script with the sudo command."
  echo
  exit -1
fi

if [[ $PATH == *"chef"* ]]; then
  echo
  echo "The workspace configure script cannot be run when sourced to a project."
  echo "Please execute the script in a new terminal session."
  echo
  exit -1
fi

curl -o aidk_workspace_setup.sh -L "http://nexus.vaftl.us:8081/nexus/service/local/artifact/maven/redirect?r=setup&g=workspace-setup&a=aidk_workspace_setup&v=LATEST&e=sh"

sh aidk_workspace_setup.sh
rm aidk_workspace_setup.sh

