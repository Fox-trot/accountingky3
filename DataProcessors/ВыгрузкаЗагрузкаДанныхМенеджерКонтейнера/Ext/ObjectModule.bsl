﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДляВыгрузки;
Перем ДляЗагрузки;

Перем КонтейнерИнициализирован;
Перем ВременныйКаталог;
Перем Архив;
Перем КоличествоФайловПоВиду;
Перем ВремяНачалаВыгрузки;
Перем Состав;
Перем ЧтениеZipФайла;
Перем ИспользуемыеФайлы;

Перем Параметры;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ВЫГРУЗКА

// Инициализирует выгрузку.
//
// Параметры:
//	ИмяФайла - Строка - имя файла выгрузки.
//	ПараметрыВыгрузки - см. ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеВАрхив.ПараметрыВыгрузки
//
Процедура ИнициализироватьВыгрузку(Знач ИмяФайла, Знач ПараметрыВыгрузки) Экспорт
	
	ПроверкаИнициализацииКонтейнера(Истина);
	
	ВремяНачалаВыгрузки = ТекущаяДатаСеанса();	

	ВременныйКаталог = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
	СоздатьКаталог(ВременныйКаталог);
	Архив = ZipАрхивы.Создать(ИмяФайла);
	
	Параметры = ПараметрыВыгрузки;
	
	ДляВыгрузки = Истина;
	КонтейнерИнициализирован = Истина;
	
КонецПроцедуры

Функция ПараметрыВыгрузки() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Если ДляВыгрузки Тогда
		Возврат Новый ФиксированнаяСтруктура(Параметры);
	Иначе
		ВызватьИсключение НСтр("ru = 'Контейнер не инициализирован для выгрузки данных.'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПараметрыВыгрузки(ПараметрыВыгрузки) Экспорт
	
	Параметры = ПараметрыВыгрузки;
	
КонецПроцедуры

// Создает файл в каталоге выгрузке.
//
// Параметры:
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция СоздатьФайл(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ДобавитьФайл(ВидФайла, "xml", ТипДанных);
	
КонецФункции

// Создает произвольный файл выгрузки.
//
// Параметры:
//	Расширение - Строка - расширение файла.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция СоздатьПроизвольныйФайл(Знач Расширение, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ДобавитьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData(), Расширение, ТипДанных);
	
КонецФункции

Процедура УстановитьКоличествоОбъектов(Знач ПолныйПутьКФайлу, Знач ЧислоОбъектов = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = НайтиСтрокуСостава(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Файл не найден'");
	КонецЕсли;
	
	СтрокаСостава.ЧислоОбъектов = ЧислоОбъектов;
	
КонецПроцедуры

Процедура ИсключитьФайл(Знач ПолныйПутьКФайлу) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = НайтиСтрокуСостава(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Файл %1 не найден в составе контейнера.'"), ПолныйПутьКФайлу);
	КонецЕсли;
		
	КоличествоФайлов = КоличествоФайловПоВиду[СтрокаСостава.ВидФайла];
	КоличествоФайловПоВиду.Вставить(СтрокаСостава.ВидФайла, КоличествоФайлов - 1);
		
	Состав.Удалить(СтрокаСостава);
	ИспользуемыеФайлы.Удалить(ИспользуемыеФайлы.Найти(ПолныйПутьКФайлу));
	УдалитьФайлы(ПолныйПутьКФайлу);
	
КонецПроцедуры

Процедура ФайлЗаписан(Знач ПолныйПутьКФайлу) Экспорт
	
	Файл = Новый Файл(ПолныйПутьКФайлу);
	
	СтрокаСостава = НайтиСтрокуСостава(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава <> Неопределено Тогда
		СтрокаСостава.Размер = Файл.Размер();
	КонецЕсли;
	
	ОтносительноеИмя = Сред(ПолныйПутьКФайлу, СтрДлина(ВременныйКаталог));
	КаталогАрхива = ПолучитьИмяВременногоФайла("zip");
	Части = СтрРазделить(ОтносительноеИмя, ПолучитьРазделительПути());
	Части.Удалить(Части.ВГраница());
	СоздатьКаталог(КаталогАрхива + СтрСоединить(Части, ПолучитьРазделительПути()));
	ПереместитьФайл(ПолныйПутьКФайлу, КаталогАрхива + ОтносительноеИмя);
	ИспользуемыеФайлы.Удалить(ИспользуемыеФайлы.Найти(ПолныйПутьКФайлу));
	
	ZipАрхивы.ДобавитьФайл(Архив, КаталогАрхива);
	УдалитьФайлы(КаталогАрхива);
	
КонецПроцедуры

// Финализирует выгрузку. Записывает информацию о выгрузке в файл.
//
Процедура ФинализироватьВыгрузку() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	 
	ИмяФайлаДайджеста = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.Digest(), "CustomData");
	ЗаписатьДайджест(ИмяФайлаДайджеста);
	
	ИмяФайлаРасширений = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.Extensions(), "CustomData"); 
	ЗаписатьИнформациюОРасширениях(ИмяФайлаРасширений);
	
	ИмяФайлаСодержимого = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайлаСодержимого);
	
	Для Каждого НайденныйФайл Из НайтиФайлы(ВременныйКаталог, "*", Истина) Цикл
		Если НайденныйФайл.ЭтоФайл() Тогда
			ФайлЗаписан(НайденныйФайл.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	
	УдалитьФайлы(ВременныйКаталог);
	
	ZipАрхивы.Завершить(Архив);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЗАГРУЗКА

// Инициализирует загрузку.
//
// Параметры:
//	ИмяФайла - Строка - имя файла архива.
//	ПараметрыЗагрузки - см. ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеИзАрхива.ПараметрыЗагрузки
//
Процедура ИнициализироватьЗагрузку(Знач ИмяФайла, Знач ПараметрыЗагрузки) Экспорт
	
	ПроверкаИнициализацииКонтейнера(Истина);
	
	ВременныйКаталог = ПолучитьИмяВременногоФайла("zip") + ПолучитьРазделительПути();
	СоздатьКаталог(ВременныйКаталог);
	
	ЧтениеZipФайла = Новый ЧтениеZipФайла(ИмяФайла);
	
	РаспаковатьФайлПоИмени(ПолучитьИмяФайла(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents()));
	
	ИмяФайлаСодержимого = ВременныйКаталог + ПолучитьИмяФайла(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	
	ФайлСодержимого = Новый Файл(ИмяФайлаСодержимого);
	Если Не ФайлСодержимого.Существует() Тогда
		
		ВызватьИсключение НСтр("ru = 'Ошибка загрузки данных. Неверный формат файла. В архиве не обнаружен файл PackageContents.xml.
                                |Возможно, файл был получен из предыдущих версий программы или поврежден.'");
		
	КонецЕсли;
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайлаСодержимого);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> "Data" Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"),
			"Data");
		
	КонецЕсли;
	
	Если НЕ ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	Пока ПотокЧтения.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
		
		ЭлементКонтейнера = ФабрикаXDTO.ПрочитатьXML(ПотокЧтения, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "File"));
		Файл = Состав.Добавить();
		Файл.Имя = ЭлементКонтейнера.Name;
		Файл.Каталог = ЭлементКонтейнера.Directory;
		Файл.Размер = ЭлементКонтейнера.Size;
		Файл.ВидФайла = ЭлементКонтейнера.Type;
		Файл.ЧислоОбъектов = ЭлементКонтейнера.Count;
		Файл.ТипДанных = ЭлементКонтейнера.DataType;
		
	КонецЦикла;
	
	ПотокЧтения.Закрыть();
	
	Для Каждого Элемент Из Состав Цикл
		Элемент.ПолноеИмя = ВременныйКаталог + Элемент.Каталог + ПолучитьРазделительПути() + Элемент.Имя;
	КонецЦикла;
	
	Состав.Индексы.Добавить("ВидФайла, ТипДанных");
	Состав.Индексы.Добавить("ВидФайла");
	Состав.Индексы.Добавить("ПолноеИмя");
	Состав.Индексы.Добавить("Каталог");
	
	Параметры = ПараметрыЗагрузки;
	
	ДляЗагрузки = Истина;
	КонтейнерИнициализирован = Истина;
	
КонецПроцедуры

Функция ПараметрыЗагрузки() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Если ДляЗагрузки Тогда
		Возврат Новый ФиксированнаяСтруктура(Параметры);
	Иначе
		ВызватьИсключение НСтр("ru = 'Контейнер не инициализирован для загрузки данных.'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПараметрыЗагрузки(ПараметрыЗагрузки) Экспорт
	
	Параметры = ПараметрыЗагрузки;
	
КонецПроцедуры

// Получает файл из каталога.
//
// Параметры:
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - см. таблицу значений "Состав".
//
Функция ПолучитьФайлИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Файлы = ПолучитьФайлыИзСостава(ВидФайла, ТипДанных);
	Если Файлы.Количество() = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли Файлы.Количество() > 1 Тогда
		ВызватьИсключение НСтр("ru = 'В выгрузке содержится дублирующаяся информация'");
	КонецЕсли;
	
	Возврат Файлы[0];
	
КонецФункции

// Получает произвольный файл из каталога.
//
// Параметры:
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - см. таблицу значений "Состав".
//
Функция ПолучитьПроизвольныйФайл(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Файлы = ПолучитьФайлыИзСостава(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData() , ТипДанных);
	Если Файлы.Количество() = 0 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В выгрузке отсутствует произвольный файл с типом данным %1.'"),
			ТипДанных);
	ИначеЕсли Файлы.Количество() > 1 Тогда
		ВызватьИсключение НСтр("ru = 'В выгрузке содержится дублирующаяся информация'");
	КонецЕсли;
	
	РаспаковатьФайл(Файлы[0]);
	
	Возврат Файлы[0].ПолноеИмя;
	
КонецФункции

Функция ПолучитьФайлыИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьОписанияФайловИзКаталога(ВидФайла, ТипДанных);
	
КонецФункции

Функция ПолучитьОписанияФайловИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	ТаблицаСФайлами = Неопределено;
	
	Если ТипЗнч(ВидФайла) = Тип("Массив") Тогда 
		
		Для Каждого ОтдельныйВид Из ВидФайла Цикл
			ДописатьФайлыВТаблицуЗначений(ТаблицаСФайлами, ПолучитьФайлыИзСостава(ОтдельныйВид , ТипДанных));
		КонецЦикла;
		Возврат ТаблицаСФайлами;
		
	ИначеЕсли ТипЗнч(ВидФайла) = Тип("Строка") Тогда 
		
		Возврат ПолучитьФайлыИзСостава(ВидФайла, ТипДанных);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестный вид файла'");
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПроизвольныеФайлы(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьОписанияПроизвольныхФайлов(ТипДанных).ВыгрузитьКолонку("ПолноеИмя");
	
КонецФункции


Функция ПолучитьПолноеИмяФайла(Знач ОтносительноеИмяФайла) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = Состав.Найти(ОтносительноеИмяФайла, "Имя");
	
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В контейнере не обнаружен файл с относительным именем %1.'"),
			ОтносительноеИмяФайла);
	Иначе
		РаспаковатьФайл(СтрокаСостава);
		Возврат СтрокаСостава.ПолноеИмя;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьОтносительноеИмяФайла(Знач ПолноеИмяФайла) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = НайтиСтрокуСостава(ПолноеИмяФайла, "ПолноеИмя");
	
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В контейнере не обнаружен файл %1.'"),
			ПолноеИмяФайла);
	Иначе
		Возврат СтрокаСостава.Имя;
	КонецЕсли;
	
КонецФункции

Процедура ФинализироватьЗагрузку() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	УдалитьФайлы(ВременныйКаталог);
	
КонецПроцедуры

Процедура РаспаковатьФайл(СтрокаФайл) Экспорт
	
	Для ОбратныйИндекс = 1 - ИспользуемыеФайлы.Количество() По 0 Цикл
		ПолноеИмяФайла = ИспользуемыеФайлы[-ОбратныйИндекс];
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Не Файл.Существует() Тогда
			ИспользуемыеФайлы.Удалить(-ОбратныйИндекс);
		ИначеЕсли ФайлДоступенДляЗаписи(ПолноеИмяФайла) Тогда
			УдалитьФайлы(ПолноеИмяФайла);
			ИспользуемыеФайлы.Удалить(-ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	
	РаспаковатьФайлПоИмени(СтрокаФайл.Имя, СтрокаФайл.Каталог);
	ИспользуемыеФайлы.Добавить(СтрокаФайл.ПолноеИмя);
	
КонецПроцедуры

Функция ПрочитатьОбъектИзФайла(Файл) Экспорт
	
	РаспаковатьФайл(Файл);
	Результат = ВыгрузкаЗагрузкаДанных.ПрочитатьОбъектИзФайла(Файл.ПолноеИмя);
	УдалитьФайлы(Файл.ПолноеИмя);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Возвращает таблицу состава контейнера выгрузки.
// 
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * Имя - Строка -
// * Каталог - Строка -
// * ПолноеИмя - Строка -
// * Размер - Число -
// * ВидФайла - Строка -
// * Хеш - Строка -
// * ЧислоОбъектов - Число -
// * ТипДанных - Строка - 
//
Функция НовыйСостав()
	
	НовыйСостав = Новый ТаблицаЗначений;
	НовыйСостав.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("Каталог", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("Размер", Новый ОписаниеТипов("Число"));
	НовыйСостав.Колонки.Добавить("ВидФайла", Новый ОписаниеТипов("Строка"));
	НовыйСостав.Колонки.Добавить("ЧислоОбъектов", Новый ОписаниеТипов("Число"));
	НовыйСостав.Колонки.Добавить("ТипДанных", Новый ОписаниеТипов("Строка"));
	
	Возврат НовыйСостав;
	
КонецФункции

Функция ПолучитьФайлыИзСостава(Знач ВидФайла = Неопределено, Знач ТипДанных = Неопределено)
	
	Фильтр = Новый Структура;
	Если ВидФайла <> Неопределено Тогда
		Фильтр.Вставить("ВидФайла", ВидФайла);
	КонецЕсли;
	Если ТипДанных <> Неопределено Тогда
		Фильтр.Вставить("ТипДанных", ТипДанных);
	КонецЕсли;
	
	Возврат Состав.Скопировать(Фильтр);
	
КонецФункции

Процедура ПроверкаИнициализацииКонтейнера(Знач ПриИнициализации = Ложь)
	
	Если ДляВыгрузки И ДляЗагрузки Тогда
		ВызватьИсключение НСтр("ru = 'Некорректная инициализация контейнера.'");
	КонецЕсли;
	
	Если ПриИнициализации Тогда
		
		Если КонтейнерИнициализирован <> Неопределено И КонтейнерИнициализирован Тогда
			ВызватьИсключение НСтр("ru = 'Контейнер выгрузки уже был инициализирован ранее.'");
		КонецЕсли;
		
	Иначе
		
		Если Не КонтейнерИнициализирован Тогда
			ВызватьИсключение НСтр("ru = 'Контейнер выгрузки не инициализирован.'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Работа с файлами в составе контейнера

Функция ДобавитьФайл(Знач ВидФайла, Знач Расширение = "xml", Знач ТипДанных = Неопределено)
	
	Для ОбратныйИндекс = 1 - ИспользуемыеФайлы.Количество() По 0 Цикл
		ПолноеИмяФайла = ИспользуемыеФайлы[-ОбратныйИндекс];
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Файл.Существует() И ФайлДоступенДляЗаписи(ПолноеИмяФайла) Тогда
			ФайлЗаписан(ПолноеИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
	ИмяФайла = ПолучитьИмяФайла(ВидФайла, Расширение, ТипДанных);
	
	Каталог = "";
	
	// для дайджеста нет отдельного вида файла
	Если ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest()
		ИЛИ ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Extensions() Тогда
		
		ВидФайла = "CustomData";
		
	КонецЕсли;
	
	Если Не ВыгрузкаЗагрузкаДанныхСлужебный.ПравилаФормированияСтруктурыКаталогов().Свойство(ВидФайла, Каталог) Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Вид файла %1 не поддерживается.'"), ВидФайла);
	КонецЕсли;
	
	Если ПустаяСтрока(Каталог) Тогда
		ПолноеИмя = ВременныйКаталог + ИмяФайла;
	Иначе
			
		КоличествоФайлов = 0;
		Если Не КоличествоФайловПоВиду.Свойство(ВидФайла, КоличествоФайлов) Тогда
			КоличествоФайлов = 0;
		КонецЕсли;
		КоличествоФайлов = КоличествоФайлов + 1;
		КоличествоФайловПоВиду.Вставить(ВидФайла, КоличествоФайлов);
		
		МаксимальноеКоличествоФайловВКаталоге = 1000;
		
		НомерКаталога = Цел((КоличествоФайлов - 1) / МаксимальноеКоличествоФайловВКаталоге) + 1;
		Каталог = Каталог + ?(НомерКаталога = 1, "", Формат(НомерКаталога, "ЧГ=0"));
		
		Если КоличествоФайлов % МаксимальноеКоличествоФайловВКаталоге = 1 Тогда
			СоздатьКаталог(ВременныйКаталог + Каталог);
		КонецЕсли;
		
		ПолноеИмя = ВременныйКаталог + Каталог + ПолучитьРазделительПути() + ИмяФайла;
		
	КонецЕсли;
	
	Файл = Состав.Добавить();
	Файл.Имя = ИмяФайла;
	Файл.Каталог = Каталог;
	Файл.ПолноеИмя = ПолноеИмя;
	Файл.ТипДанных = ТипДанных;
	Файл.ВидФайла = ВидФайла;
	
	ИспользуемыеФайлы.Добавить(ПолноеИмя);
	
	Возврат ПолноеИмя;
	
КонецФункции

Функция ФайлДоступенДляЗаписи(ИмяФайла)
	
	Попытка
		ЗаписьДанных = Новый ЗаписьДанных(ИмяФайла);
		ЗаписьДанных.Закрыть();
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьИмяФайла(Знач ВидФайла, Знач Расширение = "xml", Знач ТипДанных = Неопределено)
	
	Если ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.DumpInfo() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.DumpInfo();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Extensions() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Extensions();	
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Users() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Users();
	Иначе
		ИмяФайла = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Если Расширение <> "" Тогда
		
		ИмяФайла = ИмяФайла + "." + Расширение;
		
	КонецЕсли;
	
	Возврат ИмяФайла;
	
КонецФункции

// Работа с описанием содержимого контейнера

Процедура ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайла)
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Data");
	
	ТипFile = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "File");
	Для Каждого Строка Из Состав Цикл
		
		ДанныеОФайле = ФабрикаXDTO.Создать(ТипFile);
		
		ДанныеОФайле.Name = Строка.Имя;
		ДанныеОФайле.Type = Строка.ВидФайла;
		Если ЗначениеЗаполнено(Строка.Каталог) Тогда
			ДанныеОФайле.Directory = Строка.Каталог;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.Размер) Тогда
			ДанныеОФайле.Size = Строка.Размер;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.ЧислоОбъектов) Тогда
			ДанныеОФайле.Count = Строка.ЧислоОбъектов;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.ТипДанных) Тогда
			ДанныеОФайле.DataType = Строка.ТипДанных;
		КонецЕсли;
		
		ФабрикаXDTO.ЗаписатьXML(ПотокЗаписи, ДанныеОФайле);
		
	КонецЦикла;
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Процедура ЗаписатьДайджест(ИмяФайла)
	
	ИнформацияОКонфигурации = Новый СистемнаяИнформация();
	
	ЧислоОбъектов = Состав.Итог("ЧислоОбъектов");
	РазмерДанных  = Состав.Итог("Размер");
	
	ПродолжительностьВыгрузки = ТекущаяДатаСеанса() - ВремяНачалаВыгрузки;
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Digest");
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Platform");
	ПотокЗаписи.ЗаписатьТекст(ИнформацияОКонфигурации.ВерсияПриложения);
	ПотокЗаписи.ЗаписатьКонецЭлемента(); 
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		ПотокЗаписи.ЗаписатьНачалоЭлемента("Zone");
		ПотокЗаписи.ЗаписатьТекст(XMLСтрока(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса()));
		ПотокЗаписи.ЗаписатьКонецЭлемента();
	КонецЕсли; 
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("ObjectCount");
	ПотокЗаписи.ЗаписатьТекст(Формат(ЧислоОбъектов, "ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("DataSize");
	ПотокЗаписи.ЗаписатьАтрибут("Measure", "Byte");
	ПотокЗаписи.ЗаписатьТекст(Формат(РазмерДанных, "ЧДЦ=1; ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Duration");
	ПотокЗаписи.ЗаписатьАтрибут("Measure", "Second");
	ПотокЗаписи.ЗаписатьТекст(Формат(ПродолжительностьВыгрузки, "ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	Если ПродолжительностьВыгрузки <>0 Тогда
		ПотокЗаписи.ЗаписатьНачалоЭлемента("SerializationSpeed");
		ПотокЗаписи.ЗаписатьАтрибут("Measure", "Byte/Second");
		ПотокЗаписи.ЗаписатьТекст(Формат(РазмерДанных / ПродолжительностьВыгрузки, "ЧДЦ=1; ЧГ=0"));
		ПотокЗаписи.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	Если ВыгрузкаОбластейДанныхДляТехническойПоддержки.РежимВыгрузкиДляТехническойПоддержки(ЭтотОбъект) Тогда
		ТипВыгрузки = "TechnicalSupport"
	Иначе                                  
		ТипВыгрузки = "Ordinary"	
	КонецЕсли;
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("DataDumpType");	
	ПотокЗаписи.ЗаписатьТекст(ТипВыгрузки); 
	ПотокЗаписи.ЗаписатьКонецЭлемента(); 
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Процедура ЗаписатьИнформациюОРасширениях(ИмяФайла)
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Data");	
	
	Для Каждого ДанныеРасширения Из РасширенияКонфигурации.Получить() Цикл
		
		ИзменяетСтруктуру = ДанныеРасширения.ИзменяетСтруктуруДанных();
		ПоставляемоеРасширение = РасширенияВМоделиСервиса.ПоставляемоеРасширение(ДанныеРасширения.УникальныйИдентификатор);
		
		Если ПоставляемоеРасширение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеРасширения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПоставляемоеРасширение, "ИдентификаторВерсии, Наименование");
		
		ПотокЗаписи.ЗаписатьНачалоЭлемента("Extension");
		ПотокЗаписи.ЗаписатьАтрибут("ModifiesDataStructure", Формат(ИзменяетСтруктуру, "БЛ=false; БИ=true"));
		ПотокЗаписи.ЗаписатьАтрибут("Name", Строка(ДанныеРасширения.Наименование));
		ПотокЗаписи.ЗаписатьАтрибут("VersionUUID", Строка(ДанныеРасширения.ИдентификаторВерсии));
		
		ПотокЗаписи.ЗаписатьКонецЭлемента();				
		
	КонецЦикла;
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Функция ПолучитьОписанияПроизвольныхФайлов(Знач ТипДанных = Неопределено)
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьФайлыИзСостава(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData(), ТипДанных);
	
КонецФункции

Процедура ДописатьФайлыВТаблицуЗначений(ТаблицаСФайлами, Знач ФайлыИзСостава)
	
	Если ТаблицаСФайлами = Неопределено Тогда 
		ТаблицаСФайлами = ФайлыИзСостава;
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ФайлыИзСостава, ТаблицаСФайлами);
	
КонецПроцедуры

Процедура РаспаковатьФайлПоИмени(Знач Имя, Знач Путь = "")
	
	Если Не ПустаяСтрока(Путь) Тогда
		Путь = Путь + ПолучитьРазделительПути();
	КонецЕсли;
	
	ЭлементZipФайла = ЧтениеZipФайла.Элементы.Найти(Имя);
	Если ЭлементZipФайла = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Файл не найден'");
	КонецЕсли;
	
	Если ЭлементZipФайла.Путь <> Путь Тогда
		ВызватьИсключение НСтр("ru = 'Файл не найден'");
	КонецЕсли;
	
	ЧтениеZipФайла.Извлечь(ЭлементZipФайла, ВременныйКаталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	
КонецПроцедуры

// Ищет строку с конца, т.к. это быстрее, когда строк > 100к
Функция НайтиСтрокуСостава(Значение, Колонка)
	
	Для ОбратныйИндекс = 1 - Состав.Количество() По Мин(4 - Состав.Количество(), 0) Цикл
		Если Состав[-ОбратныйИндекс][Колонка] = Значение Тогда
			Возврат Состав[-ОбратныйИндекс];
		КонецЕсли;
	КонецЦикла;
	
	Возврат Состав.Найти(Значение, Колонка);
	
КонецФункции

#КонецОбласти

#Область Инициализация

// Инициализация состояния контейнера по умолчанию

ДополнительныеСвойства = Новый Структура();

КоличествоФайловПоВиду = Новый Структура();
ИспользуемыеФайлы = Новый Массив;

ДляВыгрузки = Ложь;
ДляЗагрузки = Ложь;

Состав = НовыйСостав();

#КонецОбласти

#КонецЕсли