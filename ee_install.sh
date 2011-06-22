#!/bin/zsh

# Todo:
# 1. Ask for the name of the database

# Create a new database
mysqladmin -u root drop expressionengine220
mysqladmin -u root create expressionengine220

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