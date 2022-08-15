vagrant destroy -f && vagrant up
vagrant ssh-config > .vagrant/ssh-config
/c/Python37/python.exe -m venv ./py_venv
./py_venv/Scripts/pip3 install wheel paramiko pytest-testinfra
./py_venv/Scripts/python.exe -m py.test -v --hosts=test-1,test-2 --ssh-config=.vagrant/ssh-config .
