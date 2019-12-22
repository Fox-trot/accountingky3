﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗагрузкаФайлов

// Показывает диалог выбора файла и помещает выбранный файл во временное хранилище.
// Совмещает работу методов глобального контекста НачатьПомещениеФайла и НачатьПомещениеФайлов,
// возвращая идентичный результат вне зависимости от того, подключено расширение работы с файлами или нет.
// Ограничения:
//   Не используется для выбора каталогов - эта опция не поддерживается веб-клиентом.
//
// Параметры:
//   ОбработчикЗавершения - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после
//                             загрузки файла со следующими параметрами:
//      * ПомещенныйФайл - Неопределено - пользователь отказался от выбора.
//                       - Структура    - пользователь выбрал файл.
//                           ** Хранение  - Строка - расположение данных во временном хранилище.
//                           ** Имя       - Строка - в тонком клиенте и в веб-клиенте с установленным
//                                        расширением работы с файлами - локальный путь, по которому
//                                        был получен файл. В веб-клиенте без расширения работы с
//                                        файлами - имя файла с расширением.
//      * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта
//                                ОписаниеОповещения.
//   ПараметрыЗагрузки         - Структура - См. ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла.
//   ИмяФайла                  - Строка - полный путь к файлу, который будет предложен пользователю в начале
//                             интерактивного выбора или помещен во временное хранилище в неинтерактивном. Если
//                             выбран неинтерактивный режим и параметр не заполнен, будет вызвано исключение.
//   АдресВоВременномХранилище - Строка - адрес, по которому будет сохранен файл.
//
// Пример:
//   Оповещение = Новый ОписаниеОповещения("ВыбратьФайлПослеПомещенияФайла", ЭтотОбъект, Контекст);
//   ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
//   ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
//   ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
//
Процедура ЗагрузитьФайл(
		ОбработчикЗавершения, 
		ПараметрыЗагрузки = Неопределено, 
		ИмяФайла = "",
		АдресВоВременномХранилище = "") Экспорт
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ПараметрыЗагрузки = ПараметрыЗагрузкиФайла();
	ИначеЕсли Не ПараметрыЗагрузки.Интерактивно
		И ПустаяСтрока(ИмяФайла) Тогда
		ВызватьИсключение НСтр("ru ='Не указано имя файла для загрузки в неинтерактивном режиме.'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыЗагрузки.ИдентификаторФормы) Тогда
		ПараметрыЗагрузки.ИдентификаторФормы = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяФайла, АдресВоВременномХранилище);
	ПараметрыЗагрузки.Вставить("ЗагружаемыеФайлы", ОписаниеФайла);
	
	ПараметрыЗагрузки.Диалог.ПолноеИмяФайла     = ИмяФайла;
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Ложь;
	ПоказатьПомещениеФайла(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

// Показывает диалог выбора файлов и помещает выбранные файлы во временное хранилище.
// Совмещает работу методов глобального контекста НачатьПомещениеФайла и НачатьПомещениеФайлов,
// возвращая идентичный результат вне зависимости от того, подключено расширение работы с файлами или нет.
// Ограничения:
//   Не используется для выбора каталогов - эта опция не поддерживается веб-клиентом.
//   Не поддерживается множественный выбор в веб-клиенте, если не установлено расширение работы с файлами.
//
// Параметры:
//   ОбработчикЗавершения - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после
//                             загрузки файлов со следующими параметрами:
//      * ПомещенныеФайлы - Неопределено - пользователь отказался от выбора.
//                        - Массив - Содержит объекты типа Структура. Пользователь выбрал файл.
//                           ** Хранение  - Строка - расположение данных во временном хранилище.
//                           ** Имя       - Строка - в тонком клиенте и в веб-клиенте с установленным
//                                        расширением работы с файлами - локальный путь, по которому
//                                        был получен файл. В веб-клиенте без расширения работы с
//                                        файлами - имя файла с расширением.
//                           ** ПолноеИмя - Строка - в тонком клиенте и в веб-клиенте с установленным
//                                         расширением работы с файлами - локальный путь, по которому
//                                         был получен файл. В веб-клиенте без расширения работы с файлами
//                                         принимает значение "".
//                           ** ИмяФайла  - Строка - имя файла с расширением.
//      * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//   ПараметрыЗагрузки    - Структура - См. ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла.
//   ЗагружаемыеФайлы     - Массив - содержит объекты типа ОписаниеПередаваемогоФайла. Может быть заполнен полностью,
//                        в этом случае загружаемые файлы будут сохранены по указанным адресам. Может быть заполнен
//                        частично - у элементов массива заполнены только имена. В этом случае, загружаемые файлы будут
//                        размещены в новых временных хранилищах. Массив может быть не заполнен. В этом случае набор
//                        помещаемых файлов определяется по значениям, указанным в параметре ПараметрыЗагрузки. Если в
//                        параметрах загрузки выбран неинтерактивный режим и параметр ЗагружаемыеФайлы не заполнен, будет
//                        вызвано исключение.
//
// Пример:
//   Оповещение = Новый ОписаниеОповещения("ЗагрузитьРасширениеПослеПомещенияФайлов", ЭтотОбъект, Контекст);
//   ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
//   ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
//   ФайловаяСистемаКлиент.ЗагрузитьФайлы(Оповещение, ПараметрыЗагрузки);
//
Процедура ЗагрузитьФайлы(
		ОбработчикЗавершения, 
		ПараметрыЗагрузки = Неопределено,
		ЗагружаемыеФайлы = Неопределено) Экспорт
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ПараметрыЗагрузки = ПараметрыЗагрузкиФайла();
	КонецЕсли;
	
	Если Не ПараметрыЗагрузки.Интерактивно
		И (ЗагружаемыеФайлы = Неопределено 
		Или (ТипЗнч(ЗагружаемыеФайлы) = Тип("Массив")
		И ЗагружаемыеФайлы.Количество() = 0)) Тогда
		
		ВызватьИсключение НСтр("ru ='Не указаны файлы для загрузки в неинтерактивном режиме.'");
		
	КонецЕсли;
	
	Если ЗагружаемыеФайлы = Неопределено Тогда
		ЗагружаемыеФайлы = Новый Массив;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыЗагрузки.ИдентификаторФормы) Тогда
		ПараметрыЗагрузки.ИдентификаторФормы = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Истина;
	ПараметрыЗагрузки.Вставить("ЗагружаемыеФайлы", ЗагружаемыеФайлы);
	ПоказатьПомещениеФайла(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СохранениеФайлов

// Получает файл и сохраняет его в локальную файловую систему пользователя.
//
// Параметры:
//   ОбработчикЗавершения      - ОписаниеОповещения, Неопределено - содержит описание процедуры, которая
//                             будет вызвана после завершения со следующими параметрами:
//      * ПолученныеФайлы         - Неопределено - файлы не были получены.
//                                - Массив - Содержит объекты типа ОписаниеПереданногоФайла. Сохраненные файлы.
//      * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//   АдресВоВременномХранилище - Строка - расположение данных во временном хранилище.
//   ИмяФайла                  - Строка - полный путь, по которому должен быть сохранен получаемый файл или имя файла
//                             с расширением.
//   ПараметрыСохранения       - Структура - См. ФайловаяСистемаКлиент.ПараметрыСохраненияФайла
//
// Пример:
//   Оповещение = Новый ОписаниеОповещения("СохранитьСертификатПослеПолученияФайлов", ЭтотОбъект, Контекст);
//   ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
//   ФайловаяСистемаКлиент.СохранитьФайл(Оповещение, Контекст.АдресСертификата, ИмяФайла, ПараметрыСохранения);
//
Процедура СохранитьФайл(ОбработчикЗавершения, АдресВоВременномХранилище, ИмяФайла = "",
	ПараметрыСохранения = Неопределено) Экспорт
	
	Если ПараметрыСохранения = Неопределено Тогда
		ПараметрыСохранения = ПараметрыСохраненияФайла();
	КонецЕсли;
	
	ДанныеФайла = Новый ОписаниеПередаваемогоФайла(ИмяФайла, АдресВоВременномХранилище);
	
	СохраняемыеФайлы = Новый Массив;
	СохраняемыеФайлы.Добавить(ДанныеФайла);
	
	ПоказатьПолучениеФайлов(ОбработчикЗавершения, СохраняемыеФайлы, ПараметрыСохранения);
	
КонецПроцедуры

// Получает файлы и сохраняет их в локальную файловую систему пользователя.
// Для сохранения файлов в неинтерактивном режиме свойство Имя параметра СохраняемыеФайлы должно содержать
// полный путь к сохраняемому файлу или, если свойство Имя содержит только имя файла с расширением, необходимо
// заполнить свойство Каталог элемента Диалог параметра ПараметрыСохранения. В иных случаях будет вызвано
// исключение.
//
// Параметры:
//   ОбработчикЗавершения - ОписаниеОповещения, Неопределено - содержит описание процедуры, которая
//                             будет вызвана после завершения со следующими параметрами:
//     * ПолученныеФайлы         - Неопределено - файлы не были получены.
//                               - Массив - содержит объекты типа ОписаниеПереданногоФайла. Сохраненные файлы.
//     * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта
//                               ОписаниеОповещения.
//   СохраняемыеФайлы     - Массив - содержит объекты типа ОписаниеПереданногоФайла:
//     * Хранение - расположение данных во временном хранилище.
//     * Имя      - Строка - полный путь, по которому должен быть сохранен получаемый файл или имя файла с расширением.
//   ПараметрыСохранения  - Структура - см. ФайловаяСистемаКлиент.ПараметрыСохраненияФайла
//
// Пример:
//   Оповещение = Новый ОписаниеОповещения("СохранитьПечатнуюФормуВФайлПослеПолученияФайлов", ЭтотОбъект);
//   ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайлов();
//   ФайловаяСистемаКлиент.СохранитьФайлы(Оповещение, ПолучаемыеФайлы, ПараметрыСохранения);
//
Процедура СохранитьФайлы(ОбработчикЗавершения, СохраняемыеФайлы, ПараметрыСохранения = Неопределено) Экспорт
	
	Если ПараметрыСохранения = Неопределено Тогда
		ПараметрыСохранения = ПараметрыСохраненияФайлов();
	КонецЕсли;
	
	ПоказатьПолучениеФайлов(ОбработчикЗавершения, СохраняемыеФайлы, ПараметрыСохранения);
	
КонецПроцедуры

#КонецОбласти

#Область Параметры

// Инициализирует структуру параметров для загрузки файла из файловой системы.
// Для использования в ФайловаяСистемаКлиент.ЗагрузитьФайл и ФайловаяСистемаКлиент.ЗагрузитьФайлы
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * ИдентификаторФормы                  - УникальныйИдентификатор - уникальный идентификатор формы, из
//                                          которой выполняется размещение файла. Если параметр не заполнен,
//                                          необходимо вызывать метод глобального контекста УдалитьИзВременногоХранилища
//                                          после завершения работы с полученными двоичными данными. Значение по
//                                          умолчанию - Неопределено.
//    * Интерактивно                        - Булево - указывает использование интерактивного режима, при котором
//                                          пользователю показывается диалог выбора файлов. Значение по
//                                          умолчанию - Истина.
//    * Диалог                              - ДиалогВыбораФайла - свойства см. в синтакс-помощнике.
//                                          Используется, если свойство Интерактивно принимает значение Истина и
//                                          удалось подключить расширение работы с файлами.
//    * ТекстПредложения                    - Строка - текст предложения об установке расширения. Если параметр
//                                          принимает значение "", будет выведен стандартный текст предложения.
//                                          Значение по умолчанию - "".
//    * ДействиеПередНачаломПомещенияФайлов - ОписаниеОповещения, Неопределено - содержит описание процедуры,
//                                          которая будет вызвана непосредственно перед началом помещения файла
//                                          во временное хранилище.Если параметр принимает значение Неопределено,
//                                          перед помещением файла никакая процедура вызываться не будет. Значение
//                                          по умолчанию - Неопределено. Параметры вызываемой процедуры:
//        ** ПомещаемыеФайлы         - СсылкаНаФайл, Массив - ссылка на файл, готовый к помещению во временное хранилище.
//                                   Если загружалось несколько файлов, содержит массив ссылок.
//        ** ОтказОтПомещенияФайла   - Булево - признак отказа от дальнейшего помещения файла. Если в теле процедуры-обработчика
//                                   установить данному параметру значение Истина, то помещение файла будет отменено.
//        ** ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
// Пример:
//  ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
//  ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите документ'");
//  ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файлы MS Word (*.doc;*.docx)|*.doc;*.docx|Все файлы(*.*)|*.*'");
//  ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
//
Функция ПараметрыЗагрузкиФайла() Экспорт
	
	ПараметрыЗагрузки = КонтекстОперации(РежимДиалогаВыбораФайла.Открытие);
	ПараметрыЗагрузки.Вставить("ИдентификаторФормы", Неопределено);
	ПараметрыЗагрузки.Вставить("ДействиеПередНачаломПомещенияФайлов", Неопределено);
	Возврат ПараметрыЗагрузки;
	
КонецФункции

// Инициализирует структуру параметров для сохранения файла в файловую систему.
// Для использования в ФайловаяСистемаКлиент.СохранитьФайл.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * Интерактивно     - Булево - указывает использование интерактивного режима, при котором
//                       пользователю показывается диалог выбора файлов. Значение по
//                       умолчанию - Истина.
//    * Диалог           - ДиалогВыбораФайла - свойства см. в синтакс-помощнике.
//                       Используется, если свойство Интерактивно принимает значение Истина и
//                       удалось подключить расширение работы с файлами.
//    * ТекстПредложения - Строка - текст предложения об установке расширения. Если параметр
//                       принимает значение "", будет выведен стандартный текст предложения.
//                       Значение по умолчанию - "".
//
// Пример:
//  ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
//  ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Сохранить профиль ключевых операций в файл'");
//  ПараметрыСохранения.Диалог.Фильтр = "Файлы профиля ключевых операций (*.xml)|*.xml";
//  ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, СохранитьПрофильКлючевыхОперацийНаСервере(), , ПараметрыСохранения);
//
Функция ПараметрыСохраненияФайла() Экспорт
	
	Возврат КонтекстОперации(РежимДиалогаВыбораФайла.Сохранение);
	
КонецФункции

// Инициализирует структуру параметров для сохранения файла в файловую систему.
// Для использования в ФайловаяСистемаКлиент.СохранитьФайлы
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * Интерактивно     - Булево - указывает использование интерактивного режима, при котором
//                       пользователю показывается диалог выбора файлов. Значение по
//                       умолчанию - Истина.
//    * Диалог           - ДиалогВыбораФайла - свойства см. в синтакс-помощнике.
//                       Используется, если свойство Интерактивно принимает значение Истина и
//                       удалось подключить расширение работы с файлами.
//    * ТекстПредложения - Строка - текст предложения об установке расширения. Если параметр
//                       принимает значение "", будет выведен стандартный текст предложения.
//                       Значение по умолчанию - "".
//
// Пример:
//  ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайлов();
//  ПараметрыСохранения.Диалог.Заголовок = НСтр("ru ='Выбор папки для сохранения сформированного документа'");
//  ФайловаяСистемаКлиент.СохранитьФайлы(Оповещение, ПолучаемыеФайлы, ПараметрыСохранения);
//
Функция ПараметрыСохраненияФайлов() Экспорт
	
	Возврат КонтекстОперации(РежимДиалогаВыбораФайла.ВыборКаталога);
	
КонецФункции

// Инициализирует структуру параметров для открытия файла.
// Для использования в ФайловаяСистемаКлиент.ОткрытьФайл
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    *Кодировка         - Строка - кодировка текстового файла. Если параметр не задан, формат текста
//                       будет определен автоматически. Список кодировок см. в синтакс-помощнике в 
//                       описании метода Записать текстового документа. Значение по умолчанию - "".
//    *ДляРедактирования - Булево - Истина, если файл открывается для редактирования, иначе Ложь. Если
//                       параметр принимает значение Истина, ожидает закрытия программы и если в параметре
//                       РасположениеФайла хранится адрес во временном хранилище, обновляет данные файла.
//                       Значение по умолчанию - Ложь.
//
Функция ПараметрыОткрытияФайла() Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Кодировка", "");
	Контекст.Вставить("ДляРедактирования", Ложь);
	Возврат Контекст;
	
КонецФункции

#КонецОбласти

#Область ЗапускВнешнихПриложений

// Открывает файл для просмотра или редактирования.
// Если файл открывается из двоичных данных во временном хранилище, предварительно сохраняет
// его во временный каталог.
//
// Параметры:
//  РасположениеФайла    - Строка - полный путь к файлу в файловой системе или адрес данных файла
//                       во временном хранилище.
//  ОбработчикЗавершения - ОписаниеОповещения, Неопределено - описание процедуры, принимающей результат работы
//                       метода, с параметрами:
//    * ФайлИзменен             - Булево - изменен файл на диске или двоичные данные во временном хранилище.
//    * ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта
//                              ОписаниеОповещения.
//  ИмяФайла             - Строка - имя файла с расширением или расширение файла без точки. Если
//                       параметр РасположениеФайла содержит адрес во временном хранилище и параметр
//                       ИмяФайла не заполнен, будет вызвано исключение.
//  ПараметрыОткрытия    - Структура - см. ФайловаяСистемаКлиент.ПараметрыОткрытияФайла.
//
Процедура ОткрытьФайл(
		РасположениеФайла,
		ОбработчикЗавершения = Неопределено,
		ИмяФайла = "",
		ПараметрыОткрытия = Неопределено) Экспорт
		
	Если ПараметрыОткрытия = Неопределено Тогда
		ПараметрыОткрытия = ПараметрыОткрытияФайла();
	КонецЕсли;
	
	ПараметрыОткрытия.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	Если ЭтоАдресВременногоХранилища(РасположениеФайла) Тогда
		
		Если ПустаяСтрока(ИмяФайла) Тогда
			ВызватьИсключение НСтр("ru ='Не указано имя файла.'");
		КонецЕсли;
		
		ПутьКФайлу = ПолноеИмяВременногоФайла(ИмяФайла);
		
		ПараметрыОткрытия.Вставить("ПутьКФайлу", ПутьКФайлу);
		ПараметрыОткрытия.Вставить("АдресДвоичныхДанныхДляОбновления", РасположениеФайла);
		ПараметрыОткрытия.Вставить("УдалятьПослеОбновленияДанных", Истина);
		
		ПараметрыСохранения = ПараметрыСохраненияФайла();
		ПараметрыСохранения.Интерактивно = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьФайлПослеСохранения", ФайловаяСистемаСлужебныйКлиент, ПараметрыОткрытия);
		
		СохранитьФайл(ОписаниеОповещения, РасположениеФайла, ПутьКФайлу, ПараметрыСохранения);
		
	Иначе
		ФайловаяСистемаСлужебныйКлиент.ОткрытьФайлПослеСохранения(Новый Структура("ПолноеИмя", РасположениеФайла), ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

// Открывает проводник с указанным путем.
// Если передан путь к файлу, то выполняет позиционирование курсора в проводнике на этом файле.
//
// Параметры:
//  ПутьККаталогуИлиФайлу - Строка - полный путь к файлу или каталогу на диске.
//
// Пример:
//  // Для Windows
//  ФайловаяСистемаКлиент.ОткрытьПроводник("C:\Users");
//  ФайловаяСистемаКлиент.ОткрытьПроводник("C:\Program Files\1cv8\common\1cestart.exe");
//  // Для Linux
//  ФайловаяСистемаКлиент.ОткрытьПроводник("/home/");
//  ФайловаяСистемаКлиент.ОткрытьПроводник("/opt/1C/v8.3/x86_64/1cv8c");
//
Процедура ОткрытьПроводник(ПутьККаталогуИлиФайлу) Экспорт
	
	ФайлИнфо = Новый Файл(ПутьККаталогуИлиФайлу);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ФайлИнфо", ФайлИнфо);
	
	Оповещение = Новый ОписаниеОповещения(
		"ОткрытьПроводникПослеПроверкиРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, Контекст);
		
	ТекстПредложения = НСтр("ru = 'Для открытия папки необходимо установить расширение работы с файлами.'");
	ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
	
КонецПроцедуры

// Открывает навигационную ссылку в программе, которая ассоциирована с протоколом навигационной ссылки.
//
// Допустимые протоколы: http, https, e1c, v8help, mailto, tel, skype.
//
// Для открытия проводника или файла в программе просмотра не следует формировать ссылку по протоколу file://
// - для открытия проводника см. ОткрытьПроводник.
// - для открытия файла по расширению см. ОткрытьФайлВПрограммеПросмотра.
//
// Параметры:
//  НавигационнаяСсылка - Строка - ссылка, которую требуется открыть.
//  Оповещение - ОписаниеОповещения - оповещение о результате открытия.
//      если оповещение не задано, в случае ошибки будет показано предупреждение.
//      - ПриложениеЗапущено - Булево - Истина, если внешнее приложение не вызвало ошибок при открытии.
//      - ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//
// Пример:
//  ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/navigationpoint/startpage"); // начальная страница.
//  ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("v8help://1cv8/QueryLanguageFullTextSearchInData");
//  ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://1c.ru");
//  ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("mailto:help@1c.ru");
//  ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("skype:echo123?call");
//
Процедура ОткрытьНавигационнуюСсылку(НавигационнаяСсылка, Знач Оповещение = Неопределено) Экспорт
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	Контекст = Новый Структура;
	Контекст.Вставить("НавигационнаяСсылка", НавигационнаяСсылка);
	Контекст.Вставить("Оповещение", Оповещение);
	
	ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось перейти по ссылке ""%1"" по причине: 
		           |Неверно задана навигационная ссылка.'"),
		НавигационнаяСсылка);
	
	Если Не ФайловаяСистемаСлужебныйКлиент.ЭтоДопустимаяСсылка(НавигационнаяСсылка) Тогда 
		
		ФайловаяСистемаСлужебныйКлиент.ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		
	ИначеЕсли ФайловаяСистемаСлужебныйКлиент.ЭтоВебСсылка(НавигационнаяСсылка)
		Или ОбщегоНазначенияСлужебныйКлиент.ЭтоНавигационнаяСсылка(НавигационнаяСсылка) Тогда 
		
		Попытка
		
#Если ТолстыйКлиентОбычноеПриложение Тогда
			
			// Особенность платформы: ПерейтиПоНавигационнойСсылке не доступен в толстом клиенте обычного приложения.
			Оповещение = Новый ОписаниеОповещения(
				,, Контекст,
				"ОткрытьНавигационнуюСсылкуПриОбработкеОшибки", ФайловаяСистемаСлужебныйКлиент);
			НачатьЗапускПриложения(Оповещение, НавигационнаяСсылка);
#Иначе
			ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
#КонецЕсли
			
			Если Оповещение <> Неопределено Тогда 
				ПриложениеЗапущено = Истина;
				ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
			КонецЕсли;
			
		Исключение
			ФайловаяСистемаСлужебныйКлиент.ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		КонецПопытки;
		
	ИначеЕсли ФайловаяСистемаСлужебныйКлиент.ЭтоСсылкаНаСправку(НавигационнаяСсылка) Тогда 
		
		ОткрытьСправку(НавигационнаяСсылка);
		
	Иначе 
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьНавигационнуюСсылкуПослеПроверкиРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, Контекст);
		
		ТекстПредложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для открытия ссылки ""%1"" необходимо установить расширение работы с файлами.'"),
			НавигационнаяСсылка);
		ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
		
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

// Возвращаемое значение:
//  Структура - где:
//    * ТекущийКаталог - Строка - Задает текущий каталог запускаемого приложения.
//    * Оповещение - ОписаниеОповещения - оповещение о результате завершения запущенного приложения, 
//          если оповещение не задано в случае ошибки будет показано предупреждение.
//          - Результат - Структура - результат работы программы:
//              -- ПриложениеЗапущено - Булево - Истина, если внешнее приложение не вызвало ошибок при открытии.
//              -- ОписаниеОшибки - Строка - краткое описание ошибки. При отмене пользователем пустая строка.
//              -- КодВозврата - Число  - код возврата программы.
//              -- ПотокВывода - Строка - результат работы программы, направленный в поток stdout.
//                             В веб-клиенте всегда принимает значение "".
//              -- ПотокОшибок - Строка - ошибки исполнения программы, направленные в поток stderr.
//                             В веб-клиенте всегда принимает значение "".
//          - ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//    * ДождатьсяЗавершения - Булево - Истина, дожидаться завершения запущенного приложения перед продолжением работы.
//    * ПолучитьПотокВывода - Булево - Ложь - результат, направленный в поток stdout,
//         если не указан ДождатьсяЗавершения - игнорируется.
//    * ПолучитьПотокОшибок - Булево - Ложь - ошибки, направленные в поток stderr,
//         если не указан ДождатьсяЗавершения - игнорируется.
//    * КодировкаИсполнения - Строка, Число - Кодировка, устанавливаемая в Windows с помощью команды chcp.
//          в Linux и MacOS игнорируется. Возможные значения "OEM", "CP866", "UTF8" или номер кодовой страницы.
//    * ВыполнитьСНаивысшимиПравами - Булево - Истина, если требуется запустить программу на исполнение
//          с повышением привилегий системы:
//          - Windows: запрос UAC;
//          - Linux: исполнение с командой pkexec;
//          - macOS, веб-клиент и мобильный клиент: будет возвращено Результат.ОписаниеОшибки.
//
Функция ПараметрыЗапускаПрограммы() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТекущийКаталог", "");
	Параметры.Вставить("Оповещение", Неопределено);
	Параметры.Вставить("ДождатьсяЗавершения", Истина);
	Параметры.Вставить("ПолучитьПотокВывода", Ложь);
	Параметры.Вставить("ПолучитьПотокОшибок", Ложь);
	Параметры.Вставить("КодировкаИсполнения", Неопределено);
	Параметры.Вставить("ВыполнитьСНаивысшимиПравами", Ложь);
	
	Возврат Параметры;
	
КонецФункции

// Запускает внешнюю программу в соответствии с параметрами запуска.
//
// Параметры:
//  КомандаЗапуска - Строка - командная строка для запуска программы.
//                 - Массив - первый элемент массива, путь к исполняемому приложению,
//      если Массив, то первый элемент массива - путь к исполняемому приложению, остальные - передаваемые параметры,
//      массив соответствует тому, который получит вызываемая программа в argv.
//  ПараметрыЗапускаПрограммы - Структура - См. ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы
//
Процедура ЗапуститьПрограмму(Знач КомандаЗапуска, ПараметрыЗапускаПрограммы = Неопределено) Экспорт
	
	Если ПараметрыЗапускаПрограммы = Неопределено Тогда 
		ПараметрыЗапускаПрограммы = ПараметрыЗапускаПрограммы();
	КонецЕсли;
	
	СтрокаКоманды = ОбщегоНазначенияСлужебныйКлиентСервер.БезопаснаяСтрокаКоманды(КомандаЗапуска);
	
	ИмяФайлаПотокаВывода = "";
	ИмяФайлаПотокаОшибок = "";
	
#Если Не ВебКлиент Тогда
	Если ПараметрыЗапускаПрограммы.ДождатьсяЗавершения Тогда
		
		// АПК:441-выкл временные файлы удаляются после асинхронных операций
		
		Если ПараметрыЗапускаПрограммы.ПолучитьПотокВывода Тогда
			ИмяФайлаПотокаВывода = ПолучитьИмяВременногоФайла("stdout.tmp");
			СтрокаКоманды = СтрокаКоманды + " > """ + ИмяФайлаПотокаВывода + """";
		КонецЕсли;
		
		Если ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок Тогда 
			ИмяФайлаПотокаОшибок = ПолучитьИмяВременногоФайла("stderr.tmp");
			СтрокаКоманды = СтрокаКоманды + " 2> """ + ИмяФайлаПотокаОшибок + """";
		КонецЕсли;
		
		// АПК:441-вкл
		
	КонецЕсли;
#КонецЕсли
	
	Контекст = Новый Структура;
	Контекст.Вставить("СтрокаКоманды", СтрокаКоманды);
	Контекст.Вставить("ТекущийКаталог", ПараметрыЗапускаПрограммы.ТекущийКаталог);
	Контекст.Вставить("Оповещение", ПараметрыЗапускаПрограммы.Оповещение);
	Контекст.Вставить("ДождатьсяЗавершения", ПараметрыЗапускаПрограммы.ДождатьсяЗавершения);
	Контекст.Вставить("КодировкаИсполнения", ПараметрыЗапускаПрограммы.КодировкаИсполнения);
	Контекст.Вставить("ПолучитьПотокВывода", ПараметрыЗапускаПрограммы.ПолучитьПотокВывода);
	Контекст.Вставить("ПолучитьПотокОшибок", ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок);
	Контекст.Вставить("ИмяФайлаПотокаВывода", ИмяФайлаПотокаВывода);
	Контекст.Вставить("ИмяФайлаПотокаОшибок", ИмяФайлаПотокаОшибок);
	Контекст.Вставить("ВыполнитьСНаивысшимиПравами", ПараметрыЗапускаПрограммы.ВыполнитьСНаивысшимиПравами);
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗапуститьПрограммуПослеПроверкиРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, Контекст);
	ТекстПредложения = 
		НСтр("ru = 'Для создания временного каталога необходимо установить расширение работы с файлами.'");
	ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Показывает диалог выбора каталога.
//
// Параметры:
//   ОбработчикЗавершения - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после
//                        закрытия диалога выбора со следующими параметрами:
//      - ПутьККаталогу - Строка - полный путь к каталогу. Если не установлено расширение работы с файлами
//                        или пользователь отказался от выбора, возвращает пустую строку.
//      - ДополнительныеПараметры - значение, которое было указано при создании объекта ОписаниеОповещения.
//   Заголовок - Строка - заголовок диалога выбора каталога.
//
Процедура ВыбратьКаталог(ОбработчикЗавершения, Заголовок = "") Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	Контекст.Вставить("Заголовок", Заголовок);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьКаталогПриПодключенииРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, Контекст);
	ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Показывает диалог выбора файла.
//
// Параметры:
//   ОбработчикЗавершения - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после
//           закрытия диалога выбора со следующими параметрами:
//   Диалог - ДиалогВыбораФайла - свойства см. в синтакс-помощнике.
//
Процедура ПоказатьДиалогВыбора(ОбработчикЗавершения, Диалог) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	Контекст.Вставить("Диалог", Диалог);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьДиалогВыбораПриПодключенииРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, Контекст);
	ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Получение имени временного каталога.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение о результате получения со следующими параметрами.
//    - ИмяКаталога             - Строка - путь к созданному каталогу.
//    - ДополнительныеПараметры - Структура - значение, которое было указано при создании объекта ОписаниеОповещения.
//  Расширение - Строка - суффикс в имени каталога, который поможет идентифицировать каталог при анализе.
//
Процедура СоздатьВременныйКаталог(Знач Оповещение, Расширение = "") Экспорт 
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("Расширение", Расширение);
	
	Оповещение = Новый ОписаниеОповещения("СоздатьВременныйКаталогПослеПроверкиРасширенияРаботыСФайлами",
		ФайловаяСистемаСлужебныйКлиент, Контекст);
		
	ТекстПредложения = НСтр("ru = 'Для создания временного каталога необходимо установить расширение работы с файлами.'");
	ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
	
КонецПроцедуры

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
//
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия
//          формы со следующими параметрами:
//    - РасширениеПодключено - Булево - Истина, если расширение было подключено.
//    - ДополнительныеПараметры - Произвольный - параметры, заданные в ОписаниеОповещенияОЗакрытии.
//  ТекстПредложения - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//  ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//          если Ложь, будет показана кнопка Отмена.
//
// Пример:
//
//  Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//  ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//  ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстСообщения);
//
//  Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//    Если РасширениеПодключено Тогда
//     // код печати документа, рассчитывающий на то, что расширение подключено.
//     // ...
//    Иначе
//     // код печати документа, который работает без подключенного расширения.
//     // ...
//    КонецЕсли;
//
Процедура ПодключитьРасширениеДляРаботыСФайлами(
		ОписаниеОповещенияОЗакрытии, 
		ТекстПредложения = "",
		ВозможноПродолжениеБезУстановки = Истина) Экспорт
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке", ФайловаяСистемаСлужебныйКлиент,
		ОписаниеОповещенияОЗакрытии);
	
#Если Не ВебКлиент Тогда
	// В мобильном, тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
	Возврат;
#КонецЕсли
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	Контекст.Вставить("ТекстПредложения",             ТекстПредложения);
	Контекст.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения", ФайловаяСистемаСлужебныйКлиент, Контекст);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует структуру параметров для взаимодействия с файловой системой.
//
// Параметры:
//  РежимДиалога - РежимДиалогаВыбораФайла - режим работы конструируемого диалога выбора файлов. 
//
// Возвращаемое значение:
//  Структура - См ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла и ФайловаяСистемаКлиент.ПараметрыСохраненияФайла
//
Функция КонтекстОперации(РежимДиалога)
	
	Контекст = Новый Структура();
	Контекст.Вставить("Диалог", Новый ДиалогВыбораФайла(РежимДиалога));
	Контекст.Вставить("Интерактивно", Истина);
	Контекст.Вставить("ТекстПредложения", "");
	
	Возврат Контекст;
	
КонецФункции

// Помещает выбранные файлы во временное хранилище.
// См. ФайловаяСистемаКлиент.ЗагрузитьФайл и ФайловаяСистемаКлиент.ЗагрузитьФайлы
//
Процедура ПоказатьПомещениеФайла(ОбработчикЗавершения, ПараметрыПомещения)
	
	ПараметрыПомещения.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьПомещениеФайлаПриПодключенииРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, ПараметрыПомещения);
	ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ПараметрыПомещения.ТекстПредложения);
	
КонецПроцедуры

// Сохраняет файлы из временного хранилища в файловую систему.
// См. ФайловаяСистемаКлиент.СохранитьФайл и ФайловаяСистемаКлиент.СохранитьФайлы
//
Процедура ПоказатьПолучениеФайлов(ОбработчикЗавершения, СохраняемыеФайлы, ПараметрыПолучения)
	
	ПараметрыПолучения.Вставить("ПолучаемыеФайлы",      СохраняемыеФайлы);
	ПараметрыПолучения.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьПолучениеФайловПриПодключенииРасширенияРаботыСФайлами", ФайловаяСистемаСлужебныйКлиент, ПараметрыПолучения);
	ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ПараметрыПолучения.ТекстПредложения);
	
КонецПроцедуры

// Получает путь для сохранения файла в каталоге временных файлов.
//
// Параметры:
//  ИмяФайла - Строка - Имя файла с расширением или расширение без точки.
//
// Возвращаемое значение:
//  Строка - Путь для сохранения файла.
//
Функция ПолноеИмяВременногоФайла(Знач ИмяФайла)

#Если ВебКлиент Тогда
	
	Возврат ?(СтрНайти(ИмяФайла, ".") = 0, 
		Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=yyyyMMddHHmmss") + "." + ИмяФайла, ИмяФайла);
	
#Иначе
	
	ПозицияРасширения = СтрНайти(ИмяФайла, ".");
	Если ПозицияРасширения = 0 Тогда
		Возврат ПолучитьИмяВременногоФайла(ИмяФайла);
	Иначе
		Возврат КаталогВременныхФайлов() + ИмяФайла;
	КонецЕсли;
	
#КонецЕсли

КонецФункции

#КонецОбласти