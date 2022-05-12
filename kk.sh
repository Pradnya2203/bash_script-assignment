#!/bin/bash

echo "1. Use a existing GPG key
      2. Create a new GPG key"

read val


function git_config () { 
git config --global user.signingkey $newKey
git config --global commit.gpgsign true 
}

if [[ $val -eq "1" ]]
then

key=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
name=$(gpg --list-secret-keys --keyid-format=long|awk '/uid/{if (length($3)>0) print $3}')
declare -a keyA
declare -a uidA
n1=${#key}
n2=${#name}

echo $n1

j=0
k=0
index=0

for((i=0;i<$n1;i++));
do
if [[ ${key:$i:1} == "/" ]]
then
keyA[$j]=${key:$i+1:16}
((j++))
fi
done

for word in $name
do
uidA[${#uidA[@]}]=$word
done

x=0

for word in ${uidA[@]}
do
echo $x $word
((x++))
done

echo "Type the index of GPG key required"

read index

gpg --armor --export ${keyA[index]}

newKey= ${keyA[index]}


git_config newKey

elif [[ $val -eq 2 ]]
then
gpg --gen-key
key=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
newKey= "-n $key | tail -c 16"
gpg --armor --export $newKey

git_config

else
echo "Enter a valid option"

fi







