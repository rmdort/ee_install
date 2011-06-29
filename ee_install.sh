#!/bin/zsh

# Figure out the directory to assume default URLs and databases
directory_basename=`basename $(pwd)`

# Establish a global return value variable
return_value=''

# ---------------------------------------------------------------------------
# Prompt the user for a value and suggest a default to accept if they don't
# supply a value at the prompt
# 
# @param string Name of the value to ask for
# @param string Default value to suggest and use otherwise
function prompt () {
	echo "$1? [$2] \c"
	read prompt_value
	
	if [[ $prompt_value == '' ]]; then
		prompt_value=$2
	fi
	
	return_value=$prompt_value
}

# ---------------------------------------------------------------------------
# Display the script header explaining the license agreement
echo "------------------------------------------------------------------------"
echo "By using this script, you accept the ExpressionEngine License Agreement."
echo "------------------------------------------------------------------------"

# ---------------------------------------------------------------------------
# Then start asking for all of the information

# Ask for the URL of the site
prompt 'Local URL of site' http://${directory_basename}/
site_url=$return_value

# Ask for the name of the system directory
prompt 'System directory name' 'system'
system=$return_value

# Ask for the email of the webmaster
prompt "Webmasters email address" 'developers@ellislab.com'
webmaster_email=$return_value

# Ask for the SQL address
prompt "SQL server address" 'localhost'
sql_address=$return_value

# Ask for the SQL username
prompt "SQL username" 'root'
sql_username=$return_value

# Ask for the SQL password
prompt "SQL password" ''
sql_password=$return_value

# Ask for the database name
prompt "SQL Database name" $directory_basename
sql_database=$return_value

# Ask for the admin username
prompt "Admin username" 'admin'
admin_username=$return_value

# Ask for the admin password
prompt "Admin password" 'password'
admin_password=$return_value

# Ask for the admin screen name
prompt "Admin screen name" 'EllisLab Developer'
admin_screenname=$return_value

# Ask for the name of the site
prompt "Name of the site" 'ExpressionEngine Test Bench'
site_name=$return_value

# Ask for site theme
prompt "Site theme (agile_records or none)" 'agile_records'
site_theme=$return_value

# If they passed back none, empty out site_theme
if [[ site_theme == 'none' ]]; then
	site_theme=''
fi

# Ask for time zone
prompt "Time zone (Eastern: UM5, Central: UM6, Mountain: UM7, Pacific: UM8)" 'UM5'
time_zone=$return_value

echo "------------------------------------------------------------------------"


# ---------------------------------------------------------------------------
# Do the file system based actions

# Create a new database
mysqladmin -u root drop $sql_database
mysqladmin -u root create $sql_database

# Fix permissions in system
rm system/expressionengine/config/{config.php,database.php}
touch system/expressionengine/config/{config.php,database.php}
chmod 666 system/expressionengine/config/{config.php,database.php}
chmod 777 system/expressionengine/cache/

# Clear out directories
rm -rf images/gallery/
rm -rf images/wikifiles/

# Create directories and fix image permissions
chmod 777 images/uploads/
mkdir -m 777 images/gallery/
mkdir -m 777 images/wikifiles/

# Changing out system/index.php
cat system/index.php | sed 's/FALSE \&\& is_dir/TRUE \&\& is_dir/' > system/index.php

# ---------------------------------------------------------------------------
# Submit the form

curl \
	--data-urlencode 'webmaster_email='$webmaster_email \
	--data-urlencode 'db_hostname='$sql_address \
	--data-urlencode 'db_username='$sql_username \
	--data-urlencode 'db_password='$sql_password \
	--data-urlencode 'db_name='$sql_database \
	--data-urlencode 'username='$admin_username \
	--data-urlencode 'password='$admin_password \
	--data-urlencode 'password_confirm='$admin_password \
	--data-urlencode 'email_address='$webmaster_email \
	--data-urlencode 'screen_name='$admin_screenname \
	--data-urlencode 'site_label='$site_name \
	--data-urlencode 'theme='$site_theme \
	--data-urlencode 'server_timezone='$time_zone \
	$site_url$system"/index.php?C=wizard&M=do_install&language=english" \
	> /dev/null 2>&1 # Output to dev null
	
# Changing out system/index.php
cat system/index.php | sed 's/TRUE \&\& is_dir/FALSE \&\& is_dir/' > system/index.php
	
echo "------------------------------------------------------------------------"
echo "ExpressionEngine has been installed."
echo "------------------------------------------------------------------------"