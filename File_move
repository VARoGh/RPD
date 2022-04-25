import os, shutil

outpath= input('Введите путь папки: ')  # откуда надо скопировать файлы  
todir= input('Введите путь к папке, куда надо скопировать файлы: ')  # куда надо переместить файлы
ras= input('Введите расширение файлов: ')    # выбрать расширение перемещаемых файлов 'doc'

count=1
num=0 #кол-во успешно скопированных файлов
for dirpath, dirnames, filenames in os.walk(outpath):
    for file in filenames:
        if file.endswith(ras):
            filepath=os.path.join(dirpath, file)
            tofile=os.path.join(todir, file)
            if os.path.isfile(tofile):
                tofile=tofile[: tofile.rindex('.')]+'_Копия_'+str(count)+tofile[tofile.rindex('.') :]
                shutil.copy(filepath, tofile)
                count+=1
            else:
                shutil.copy(filepath, todir)
            num+=1
print('Успешно скопировано {} файлов'.format(num))
