How To Install App
1. Install API posTestApi
- create a database with the name postest
- import database postest.sql *) because seeder not ready
- cp .env.example .env
- adjust the connection db, host db, db name, etc. in .env
- composer install
- php artisan key:generate
- php artisan jwt:secret
- php artisan serve --host={YOUR IP} *)example : php artisan serve --host=192.168.0.107
- done
2. Install Flutter tpos_app
- flutter pub get
- go to file constant.dart in ./tpos_app/lib/constant.dart, change value baseURL with host ip which is running.
- run app with your emulator
- the app is ready to run with emulator or others

Authentication
username : admin <br>
pass : admin123

Requirements 
- PHP 8.0.9
- Flutter 3.22.2

Best Regard,<br>
Thanks for all