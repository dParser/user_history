# encoding: utf-8

# Утилита предназначена для улучшения CSV отчета, формируемого в пункте "Пользователи-История пользователей" Редактора тарифов.
# А именно, добавляет в отчет "UserHistory" недостающие дни. 
# Это дни, в которых отсутствует история - не велись работы менеджерами.
# Недостающие дни отслеживаются по каждом пользователю редактора.
# Обработка файла истории ведется с учетом того, что в нем сортировка по дате
#   ведется от более ранних к более поздним записям.
# Результат выводится в новый файл с суффиксом fulldate, например - 
#   user-histories-2017_123.fulldate.csv 
#
# Перед "прогоном" через данную утилиту необходимо файл истории обработать по схеме,
#   описанной в E:\Users\Ed\Documents\Отдел-ТФО\ГруппаТарифов\UserHistory\README.txt
#
# Считается, что исходный файл истории имеет кодировку не UTf-8, поэтому строки из
#   него "форсированно" перекодируются в UTf-8


# Указан ли файл истории в ком. строке:
if ARGV[0] == ""
  puts "\nУкажите в командной строке файл истории пользователей"
  exit
end

# Существует ли файл истории:
if File.exists?(ARGV[0]) & File.file?(ARGV[0])
#  puts ARGV[0]
else
  puts "Файла #{ARGV[0]} не существует. Уточните введенные данные"
  exit
end

# Это "сырой" файл истории (не преобразованный предварительно).
# Т.е. содержит колонки:
#      "Пользователь,Объект,Название,Действие,Параметры,Ошибки импорта,Дата"
hist_file = File.open(ARGV[0])

# Первая строка файла - название полей (здесь и далее 
#   перекодировка форсированная):
head_string = hist_file.readline.chomp.force_encoding(Encoding::UTF_8)

if head_string ==
  "Пользователь,Объект,Название,Действие,Параметры,Ошибки импорта,Дата"
  puts "Файл истории необходимо преобразовать по схеме, описанной в 
        ...\\UserHistory\\README.txt "
  exit
end

# Преобразован ли предварительно файл истории?:
# Т.е. содержит колонки:
#      "Пользователь,Объект,Название,Действие,Параметры,Ошибки импорта,Дата,
#       Год,Месяц,Время,UTF"
unless head_string ==
  "Пользователь,Объект,Название,Действие,Параметры,Ошибки импорта,Дата,Год,Месяц,Время,UTF"
  puts "#{ARGV[0]} не является файлом историей"
  exit
end

# Файл результата с суффиксом OUT:
out_file = File.new(File.basename(ARGV[0], ".*")+".OUT.txt", "w+")
out_file.puts(head_string)
hist_file.each{|ll|
  out_file.puts(ll.force_encoding(Encoding::UTF_8))
              }