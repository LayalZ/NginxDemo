sudo yum update -y
sudo yum install -y python3 python3-pip
pip3 install --user ansible
export PATH="$HOME/.local/bin:$PATH"
ansible --version
  
 
sudo pip3 install boto3
rm -rf ~/.local/lib/python3.9/site-packages/ansible_collections/community/crypto
ansible-galaxy collection list community.crypto

ansible-galaxy collection install community.crypto:2.22.1 --force
ansible-doc -t module community.crypto.openssl_csr
ansible-doc -t module community.crypto.openssl_privatekey
ansible-doc -t module community.crypto.openssl_genreq
