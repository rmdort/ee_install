ExpressionEngine Install Script
===============================

This is the beginnings of an ExpressionEngine install script. At the moment all it does is:

- Drop the existing database (assumed to be expressionengine220)
- Create a new database
- Create config.php and database.php if they don't exist
- Fix permissions on config.php, database.php, and cache/
- Delete existing image directories used for testing
- Create image directories for testing
- Changes out system/index.php so install can actually happen


Plans
-----

Eventually, this script will be able to do a whole ExpressionEngine install given the necessary information. It will have intelligent defaults, but allow you to customize as well.

- Prompt for configuration information, but have smart defaults
- Fix system/index.php when done
- Use python fixtures to add dummy data
- Use curl to download a large batch of pictures