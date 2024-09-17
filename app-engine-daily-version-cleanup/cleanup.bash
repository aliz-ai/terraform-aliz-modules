# !/bin/bash
gcloud config list project

gcloud app services list >> services.txt

tail -n +2 services.txt > services.txt.tmp && mv services.txt.tmp services.txt
awk '{print $1}' services.txt > services.txt.tmp && mv services.txt.tmp services.txt

filename=services.txt

unset myArray
declare -a myArray
myArray=(`cat "$filename"`)

for (( i = 0 ; i < ${#myArray[@]} ; i++))
do
  echo "Service [$i]: ${myArray[$i]}"
done

for i in ${!myArray[@]}; do
echo "Service : ${myArray[$i]}"
    gcloud app versions list --service=${myArray[$i]} --format="value(version.id)" --sort-by="~version.createTime" | tail -n +11 | xargs -r gcloud app versions delete --service=${myArray[$i]} --quiet
done

unset myArray
rm services.txt
