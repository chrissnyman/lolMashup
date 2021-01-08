#!/bin/bash
echo "-------------------------"
echo "Pushing to github"
echo "-------------------------"
git push
echo "-------------------------"

echo "-------------------------"
echo "Pushing to heroku"
echo "-------------------------"
git push heroku
echo " push completed, running db migrate"
heroku run rake db:migrate -a do-passport
echo " db migrate completed."            
echo "-------------------------"