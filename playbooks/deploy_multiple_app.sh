read -p "enter number of instances: " num
for (( i=1 ; i <=$num; i++))
do
read -p "please enter ip for server $i:- " ser
echo "$ser" >> ip.txt
done

while read ser
do 
ansible-playbook -i "$ser," edx-stateless.yml -vvv --private-key=/home/ubuntu/openedx-staging.pem
done < ip.txt
rm ip.txt
