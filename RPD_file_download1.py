from selenium import webdriver
from selenium.common.exceptions import *
from selenium.webdriver.common.keys import Keys  # модуль нажатий клавиш клавиатуры
from selenium.webdriver.common.by import By     #модуль для настройки явных ожиданий
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait  #модуль для настройки явных ожиданий
from selenium.webdriver.support import expected_conditions as EC #модуль исключений Selenium
import time
import os, shutil

path = input('Введите путь папки для сохранения: ') #r'F:\...\ДГТУ УМКД\УМКД ПиТСТТС\УМКД_авто'
os.chdir(path)
print('Теперь этот путь текущий - ', os.getcwd())

# Настройка драйвера браузера Хром, приписание пути расположения файла драйвера
EXE_PATH = r'C:\Users\VARoGh\PycharmProjects\pythonProject_old\venv\Scripts\chromedriver.exe'

# Установка папки автозагрузки браузера
options = Options()
options.add_experimental_option("prefs", {
    "download.default_directory": path,
    "download.prompt_for_download": False,
    "download.directory_upgrade": True,
    "safebrowsing.enabled": True })

# Настройка драйвера браузера в фоновом режиме без отображения окна в 2 вариантах (оба рабочие)
# options.headless = True
# options.add_argument('--headless')

# Инициализация драйвера браузера Хром с настройками
driver = webdriver.Chrome(executable_path = EXE_PATH, chrome_options = options)

# Настройка неявного ожидания в 10 с. (т.е. любые действия с веб-элементами html-страницы
# driver.implicitly_wait(10)

# Запуск страницы
driver.get('https://rpd.donstu.ru/Auth/Index?ReturnUrl=%2f')

# Настройка окна браузера - полноэранный с разрешением 1920х1080
# driver.set_window_size(1920, 1080)

# Ввод логина и пароля
print('Страница менеджера загрузилась... Вводим логин и пароль.')

login = input('Введите логин: ')
log=driver.find_element_by_id('UserName_I')
log.send_keys(login)
time.sleep(1)
log.send_keys(Keys.ENTER)
psw = input('Введите пароль: ')
password=driver.find_element_by_id('Password_I')
password.send_keys(psw)
password.send_keys(Keys.ENTER)
time.sleep(1)

# Выбор представления менеджера РПД - по планам
print('Зашли в менеджер')

# elem=driver.find_element_by_id('ChabgeRepresentation_I') # поиск элемента по id без ожидания
elem = WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.ID, 'ChabgeRepresentation_I'))) # поиск элемента с явным ожиданием 20 с
elem.click()
time.sleep(0.5)
elem.send_keys(Keys.ARROW_DOWN)
time.sleep(0.5)
elem.click()
elem.send_keys(Keys.ENTER)
time.sleep(2)

# Поиск учебного плана по шаблону - 230501А
str = input('Введите шифр учебного плана: ')  #'230501А'
elem=driver.find_element_by_id('RUPList_DXFREditorcol0_I')
elem.send_keys(str)
time.sleep(3)

# Перебор учебных планов 230501А
table=driver.find_element_by_id('RUPList_DXMainTable')
lst=table.find_elements_by_class_name('dxgvDataRow_DevEx')
print(f'Всего учебных планов {str}: {len(lst)} шт.')

for i in lst[4:5]:
    name = i.text
    print(f'Выбран учебный план {name}')  #Вывод в консоль названия плана

    # Создание папки с названием учебного плана
    name_dir=os.path.join(path, name)
    if name not in os.listdir('.'):
        os.makedirs(name_dir)   # r'F:\...\ДГТУ УМКД\УМКД ПиТСТТС\УМКД_авто\уч_план'
    i.click()
    time.sleep(1)

    # Создание списка дисциплин, входящих в план
    modul = driver.find_element_by_id('disc4RUPGrid_DXMainTable')
    lst2 = modul.find_elements_by_tag_name('tr')

    # Сохранение списка дисциплин (по id) в список list_id
    list_id=[]
    for j in lst2:
        list_id.append(j.get_attribute('id'))
    print(f'Всего дисциплин: {len(list_id[1:])} шт.')

    # Выбор рабочей программы дисциплины
    for id in list_id[1:]:
        disciplina = driver.find_element_by_id(id)
        s=disciplina.text
        disciplina.click()
        time.sleep(2)

        def symbol_delete(s):
            """Функция для очистки названия от различных символов symb"""
            for symbol in r':"/,#!?':
                while symbol in s:
                    dw = s.find(symbol)
                    s = s[:dw] + s[dw + 1:]
            return s

        if ' 0 ' in s:
            name_disciplina = s.split(" 0 ")[0]
            # Удаление двоеточия и других символов из названия дисциплины, т.к это может привести к ошибке при создании папки
            name_disciplina = symbol_delete(name_disciplina)
            print(f'По дисциплине {name_disciplina} не создано ни одной рабочей программы')
            name_to_file = os.path.join(name_dir, name_disciplina)
            os.makedirs(name_to_file)
            print(f'Создана пустая папка для дисциплины {name_disciplina}')
            continue
        elif ' 2 ' in s:
            name_disciplina = s.split(" 2 ")[0]
            id_rp = 'RPDGrid_DXDataRow1'
        elif ' 3 ' in s:
            name_disciplina = s.split(" 3 ")[0]
            id_rp = 'RPDGrid_DXDataRow2'
        else:
            name_disciplina = s.split(" 1 ")[0]
            id_rp = 'RPDGrid_DXDataRow0'

        name_disciplina = symbol_delete(name_disciplina)
        print(f'Вот так будет названа папка {name_disciplina}')

        table2 = driver.find_element_by_id('RPDGrid')
        programma = WebDriverWait(table2, 20).until(EC.element_to_be_clickable((By.ID, id_rp)))

        # Создание папки с названием дисциплины
        name_to_file = os.path.join(name_dir, name_disciplina)
        if name_disciplina not in os.listdir(name_dir):
            os.makedirs(name_to_file)   #'F:\Доцент\ДГТУ УМКД\УМКД ПиТСТТС\УМКД_авто\уч_план\назва_дисциплины'
        # Эти доп условия нужно только для технологических практик, т.к их бывает две с одни названием
        elif name_disciplina == 'Технологическая практика':
            os.makedirs(name_to_file + ' 1')
        elif name_disciplina == 'Технологическая практика 1':
            continue
        else:
            continue

        # Открыть выбранную программу дисциплины (открывается в новом окне)
        programma.click()
        time.sleep(0.25)
        driver.find_element_by_id('btnCreateOpen').click()
        flag = False #флаг для окна с черновиками, которое может всплыть
        time.sleep(1)

        #Обработка исключения, возникающего если уже создан черновик (возможно ранее открывалось)
        try:
            driver.find_element_by_id('openDraft_CD').click()
        except ElementNotInteractableException:
            print('Черновиков нет, а значит продолжаем работу...')
            time.sleep(2)

        def is_id(id):
            """Функция, которая определяет, есть ли id на странице HTML или нет"""
            try:
                driver.find_element_by_id(id)
            except NoSuchElementException:
                return False
            else:
                return True

        #Удаление черновиков, если всплывает другое спец. окно со списком ранее открытых дисциплин
        while is_id('draftsGrid2_DXCBtn0Img'):
            flag = True  # активируем флаг, для последующего повторного открытия рпд дисциплины
            delet = driver.find_element_by_id('draftsGrid2_DXCBtn0Img') #Ищем кнопку удаления черновика дисциплины
            delet.click()
            time.sleep(1)
            alert = driver.switch_to.alert #функция для работы с модальным окном системы
            alert.accept() #подтверждение удаления окна (жмем кнопку ОК)
            time.sleep(1)

        # Если было окно со списком черновиков
        if flag:
            # Закрыть окно со списком черновиков (уже пустым)
            driver.find_element_by_id('draftsOverflowNotification_HCB-1').click()
            time.sleep(2)
            print('Список черновик успешно очищен.')
            # Повторить открытие рпд выбранной ранее дисциплины
            print('Повторно открываем РПД дисциплины')
            driver.find_element_by_id('btnCreateOpen').click()
            flag = False

        time.sleep(2)
        print(driver.window_handles) #Список хэндлов открытых вкладок в браузере

        # Переход во вкладку открытой рпд дисциплины
        while True:
            if len(driver.window_handles) == 1:
                time.sleep(5)
            else:
                driver.switch_to.window(driver.window_handles[1])
                break

        # Нажатие кнопки Скачать черновик
        numb_protokol = WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.ID, 'UPNum_I')))
        # numb_protokol = driver.find_element_by_id('UPNum_I')
        numb_protokol.send_keys('')
        driver.find_element_by_xpath('/html/body/div[4]/div[2]/div/table/tbody/tr[8]/td/div/table/tbody/tr[7]/td/div/table/tbody/tr/td[2]/table/tbody/tr/td[1]/label').click()
        time.sleep(1)
        btn_down = driver.find_element_by_id('DownloadDraft')
        # driver.execute_script("arguments[0].disabled=false", btn_down) #'этот вариант работает, но падает сервер ДГТУ
        btn_down.click()
        time.sleep(3)

        # Выбор списка экспорт в MS Word
        export = driver.find_element_by_id('exportMenu_DXI0_PImg')
        export.click()

        # Выбор пункта экспорт РП
        try:
            export_rpd = WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.ID, 'exportMenu_DXI0i0_')))
            # export_rpd = driver.find_element_by_id('exportMenu_DXI0i0_')
            export_rpd.click()
            # time.sleep(3)
        except TimeoutException:
            time.sleep(1)
            print(f'Черновик {name_disciplina} ,был не скачан. Но была повторная попытка!')
            export_rpd = driver.find_element_by_id('exportMenu_DXI0i0_')

        # Повторный выбор списка экспорт в MS Word
        export = WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.ID, 'exportMenu_DXI0_PImg')))
        # export = driver.find_element_by_id('exportMenu_DXI0_PImg')
        export.click()

        # Выбор пункта экспорт ФОС
        export_fos = WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.ID, 'exportMenu_DXI0i1_')))
        # export_fos = driver.find_element_by_id('exportMenu_DXI0i1_')
        export_fos.click()

        # Нажать кнопку вправо для пролистывания к вкладке Приложение
        print('Ищем таб пролистывания к приложению')
        rtab = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.ID, 'mainTabPanel_SBR')))
        rtab.click()
        time.sleep(0.5)
        rtab.click()
        time.sleep(0.5)

        # Переход на вкладку Приложения
        vkladka = WebDriverWait(driver, 30).until(EC.element_to_be_clickable((By.ID, 'mainTabPanel_T24T')))
        # vkladka = driver.find_element_by_id('mainTabPanel_T24T')
        vkladka.click()
        time.sleep(2)

        # Поиск и скачивание ссылок залитых ФОС и МУ
        links=driver.find_elements_by_class_name('dxeHyperlink_DevEx')
        if len(links)>0:
            for ref in links:
                try:
                    if 'https://rpd.donstu.ru/RPDAppendices/Download' in ref.get_attribute('href'):
                        ref.click()
                        print('Скачиваю ФОС или метод. указание по ссылке: ',  ref.get_attribute('href'))
                        time.sleep(3)
                except TypeError:
                    print('Что-то произошло при скачивании ссылок ФОС и МУ - NoneType')
        else:
            print('ФОС и метод. указаний не было')

        # Закрыть вкладку с открытой РП и переход в основное окно менеджера РПД
        driver.close()
        driver.switch_to.window(driver.window_handles[0])
        time.sleep(3)

        #Перемещение скачанных файлов дицисплины в заданную папку
        while True:
            refs = next(os.walk(path))[2]
            if 'download' in ''.join(refs):
                time.sleep(5)
            else:
                break

        count=0  #счетчик для файлов у кторых очень длинные имена
        for file in refs:
            filepath = os.path.join(path, file)
            name_to_file1 = name_to_file

            # Переименование файлов длина пути которого превышает 256 символов
            if len(name_to_file)+len(file)>255:
                count+=1
                name_to_file1 = os.path.join(name_to_file, file[:(256-len(name_to_file))-4]+str(count)+file[-5:])

            try:
                shutil.move(filepath, name_to_file1)
            except PermissionError:
                time.sleep(5)
                print(f'Файл {file} не успел скачаться')

        print(f'Все {len(refs)} файлов успешно перенесены в папку {name_to_file}')

input('Все завершено. Для завершения работы браузера нажмите Enter  ')
driver.close()
quit()
