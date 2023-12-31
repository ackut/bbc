# Установка.
1) Установить MoonLoader - https://www.blast.hk/moonloader/download.php При установке, СТАВЬТЕ ВСЕ ГАЛОЧКИ, и путь установки выбирайте: "MyHome Launcher/bin/SAMP"
3) Закинуть файлы bbc.lua и ads.json в папку "MyHome Launcher/bin/SAMP/moonloader/"
4) Отключить CEF интерфейс, в настройках лаунчера.


# Как работает скрипт.
Данный скрипт не редактирует объявления автоматически. Он просто запоминает, как редактируете вы, и если встречает идентичные объявления - сам подставляет нужный текст.
На текущий момент, если объявление отличается всего-лишь на один символ, скрипт подумает что это уже другое объявление, и, как мне кажется это правильно, ибо в объявлении может отличаться только цена, и нельзя чтобы скрипт указывал старую цену, для такого объявления. Вообще можно было сделать достаточно мощный скрипт, который и правда редактировал бы объявления практически за вас, но мне лень.

1) Чтобы активировать / деактивировать скрипт, пропишите команду /bbc.
2) Как только приходит новое объявление, нажимайте клавишу Q. Скрипт сам откроет свободное объявление из списка, и вы сможете сразу начать его редактировать.
3) После того как вы отредактировали объявление - скрипт его сохранит, и как только на редакцию поступит идентичное объявление - сам подставит нужный текст, останется лишь нажать Enter, для отправки.

Если вам ничего не понятно, просто редактируйте объявления, как обычно, и через некоторое время увидите работу скрипта.


# Команды / Горячие клавиши.
1) /bbc - активировать / деактивировать скрипт.
2) Клавиша Q - редактировать объявление.


# Файл ads.json.
В этот файл сохраняются все отредактированные объявления. Если в нормальном редакторе кода, нажать сочитание клавиш CTRL + F, вы увидите нормальное отображение строк.

![image](https://github.com/ackut/bbc/assets/52998293/a1b83ec8-0779-4b69-b2a3-13c05e00aff9)

Структура тут максимально простая:
[отклонено?, "текст объявления, ловеркейс", "Ваш текст объявления."]
[false, "Продам дом на верона №84 эконом", "Продам дом №84, класса Econom, в районе Verona Beach. Цена: Договорная"]

Если возникают какие-либо ошибки, допустим, вы неправильно отредактировали объявление, и опубликовали его - скрипт это запомнил, а значит, вам нужно открыть файл ads.json, пролистать в конец, и изменить сохранённое редактирование.

Так-же, вы можете очистить этот файл, оставив внутри лишь квадратные скобки []. Чтобы он наполнялся только вашими объявлениями.
