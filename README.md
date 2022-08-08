# RPD
Программа RPD_file_download.py проводит автоматизированную обработку рабочих программ дисциплин (РПД) в электронном менеджере РПД ДГТУ: производится вход на аккаунт с логином и паролем. После чего по запросу пользователя проводится поиск заданного учебного плана РПД по шаблону (шифр) => перебирает все планы по годам обучения и все дисциплины, входящие в каждый план. После этого проходится по каждой дисциплине, подгружает рпд дисциплины и скачивает файлы ФОС, РПД и методические указания, которые прикреплены и залиты на сервер. При этом в программе предусмотрены обработка ошибок связанных с длинными названиями файлов, зависанием сервера и др. Все файлы по каждой дисциплине скачиваются в папки, автоматически генерируемые программой с названием соответствующей дисциплины. Так как на сайте электронного менеджера используются Java скрипты с загрузкой их по мере надобности (страницы динамические), программа работает на Seleniumе.

В программе задействованы библиотеки Selenium, time, os, shutil.
