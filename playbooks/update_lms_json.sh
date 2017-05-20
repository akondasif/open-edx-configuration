# This script will update lms.env.json file with micro site information
# for demo purpose we are using two microsites (unizin1, unizin2).
# You can customize them for your need.
#
site1='"unizin1": {"domain_prefix": "unizin1","university": "unizin1","platform_name": "Unizin 1 Professional Education Online X Programs","logo_image_url":  "images/header-logo.png","ENABLE_MKTG_SITE":  false,"SITE_NAME": "unizin1.arbisoft.com","course_org_filter": "unizin1X","course_about_show_social_links": false,"css_overrides_file":  "css/style.css","show_partners":  false,"show_homepage_promo_video": false,"course_index_overlay_text": "Explore unizin1 courses from leading universities","homepage_overlay_html":  "<h1>Micro Site 1 Deployed Successfully</h1>","favicon_path": "images/header-logo.png","ENABLE_THIRD_PARTY_AUTH": false,"ALLOW_AUTOMATED_SIGNUPS": true,"ALWAYS_REDIRECT_HOMEPAGE_TO_DASHBOARD_FOR_AUTHENTICATED_USER": false,"course_email_template_name": "unizin1","course_email_from_addr": "unizin1@unizin.com","SESSION_COOKIE_DOMAIN": "unizin1.arbisoft.com"}'


site2='"unizin2": {"domain_prefix": "unizin2","university": "unizin2","platform_name": "Unizin 2 Professional Education Online X Programs","logo_image_url":  "images/header-logo.png","ENABLE_MKTG_SITE":  false,"SITE_NAME": "unizin2.arbisoft.com","course_org_filter": "unizin2X","course_about_show_social_links": false,"css_overrides_file":  "css/style.css","show_partners":  false,"show_homepage_promo_video": false,"course_index_overlay_text": "Explore unizin2 courses from leading universities","homepage_overlay_html":  "<h1>Micro Site 2 Deployed Successfully</h1>","favicon_path": "images/header-logo.png","ENABLE_THIRD_PARTY_AUTH": false,"ALLOW_AUTOMATED_SIGNUPS": true,"ALWAYS_REDIRECT_HOMEPAGE_TO_DASHBOARD_FOR_AUTHENTICATED_USER": false,"course_email_template_name": "unizin2","course_email_from_addr": "unizin2@unizin.com","SESSION_COOKIE_DOMAIN": "unizin2.arbisoft.com"}'

# don't worry if you messed up with values, a backup file (lms.env.json.bk) 
# is generated before executing these commands.
sed -i.bk '174a,"USE_MICROSITE": true' /edx/app/edxapp/lms.env.json

sed -i "215d" /edx/app/edxapp/lms.env.json

sed -i "214a\"MICROSITE_CONFIGURATION\": {$site1,$site2}," /edx/app/edxapp/lms.env.json
