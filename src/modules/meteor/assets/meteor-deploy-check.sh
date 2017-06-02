APPNAME=<%= appName %>
APP_PATH=/opt/$APPNAME
APP_URL=<%= appUrl %>
START_SCRIPT=$APP_PATH/config/start.sh
DEPLOY_CHECK_WAIT_TIME=<%= deployCheckWaitTime %>
DEPLOY_CHECK_PORT=<%= deployCheckPort %>

cd $APP_PATH

revert_app (){
  docker logs --tail=50 $APPNAME 1>&2
  if [ -d last ]; then
    sudo mv last current
    sudo bash $START_SCRIPT > /dev/null 2>&1

    echo " " 1>&2
    echo "=> Redeploying previous version of the app" 1>&2
    echo " " 1>&2
  fi
  
  echo 
  echo "To see more logs type 'mup logs --tail=50'"
  echo ""
}

elaspsed=0
while [[ true ]]; do
  sleep 1
  elaspsed=$((elaspsed+1))
  curl --fail -L $APP_URL:$DEPLOY_CHECK_PORT && exit 0

  if [ "$elaspsed" == "$DEPLOY_CHECK_WAIT_TIME" ]; then
    revert_app
    exit 1
  fi
done
 