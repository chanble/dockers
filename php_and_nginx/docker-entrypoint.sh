#!/bin/bash
sed -i "s%{APP_PROJECT_ROOT}%${APP_PROJECT_ROOT}%g" /usr/local/nginx/conf/nginx.conf;
if (( $APP_PROJECT_IS_TEST_SERVER == 1 )) ; then
  sed -i "s%{VAR_NGINX_CAN_ACCESS_PHP_FILE}%#%g" /usr/local/nginx/conf/nginx.conf;
  sed -i "s%{VAR_NGINX_CAN_ACCESS_ADMIN}%%g" /usr/local/nginx/conf/nginx.conf;
  sed -i "s%{VAR_PHP_ENABLE_OPCACHE}%;%g" /usr/local/etc/php/php.ini;
  sed -i "s%{VAR_PHP_DISPLAY_ERRORS_ON}%%g" /usr/local/etc/php/php.ini;
  sed -i "s%{VAR_PHP_DISPLAY_ERRORS_OFF}%;%g" /usr/local/etc/php/php.ini;
  sed -i "s%{VAR_PHP_FPM_START_NUM_ONLINE}%;%g" /usr/local/etc/php-fpm.conf;
  sed -i "s%{VAR_PHP_FPM_START_NUM_TEST}%%g" /usr/local/etc/php-fpm.conf;
else
  sed -i "s%{VAR_NGINX_CAN_ACCESS_PHP_FILE}%%g" /usr/local/nginx/conf/nginx.conf;
  sed -i "s%{VAR_NGINX_CAN_ACCESS_ADMIN}%#%g" /usr/local/nginx/conf/nginx.conf;
  sed -i "s%{VAR_PHP_ENABLE_OPCACHE}%%g" /usr/local/etc/php/php.ini;
  sed -i "s%{VAR_PHP_DISPLAY_ERRORS_OFF}%%g" /usr/local/etc/php/php.ini;
  sed -i "s%{VAR_PHP_DISPLAY_ERRORS_ON}%;%g" /usr/local/etc/php/php.ini;
  sed -i "s%{VAR_PHP_FPM_START_NUM_ONLINE}%%g" /usr/local/etc/php-fpm.conf;
  sed -i "s%{VAR_PHP_FPM_START_NUM_TEST}%;%g" /usr/local/etc/php-fpm.conf;
fi
if [ ! -z $APP_PROJECT_VERSION ] && [ ! -z $APP_PROJECT_DOWNLOAD_CODE_TOKEN ]; then 
  # https://docs.gitlab.com/ee/api/repositories.html#get-file-archive
  cd /tmp && curl -o app.tar.gz "https://git.daofengdj.com/api/v4/projects/17/repository/archive.tar.gz?&sha=${APP_PROJECT_VERSION}&private_token={$APP_PROJECT_DOWNLOAD_CODE_TOKEN}" \
  && tar zxvf app.tar.gz  && rm -f app.tar.gz \
  && cp -R app*/* ${APP_PROJECT_ROOT} && rm -rf app* \
  && chown -R www-data.www-data ${APP_PROJECT_ROOT}
fi

php-fpm -D -c /usr/local/etc/php/php.ini -y /usr/local/etc/php-fpm.conf && /usr/local/nginx/sbin/nginx
exec "$@"
