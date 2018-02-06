﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		НачатьТранзакцию();
		Попытка
			ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(Новый Структура("Корреспондент", СтруктураЗаписи.Узел), "НастройкиТранспортаОбменаОбластиДанных");
			ЗаписатьПароль("FTPСоединениеПароль", "FTPСоединениеПарольОбластейДанных", СтруктураЗаписи);
			ЗаписатьПароль("ПарольАрхиваСообщенияОбмена", "ПарольАрхиваСообщенияОбменаОбластейДанных", СтруктураЗаписи);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	Иначе
		НачатьТранзакцию();
		Попытка
			ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбмена");
			ЗаписатьПароль("COMПарольПользователя", "COMПарольПользователя", СтруктураЗаписи);
			ЗаписатьПароль("FTPСоединениеПароль", "FTPСоединениеПароль", СтруктураЗаписи);
			ЗаписатьПароль("WSПароль", "WSПароль", СтруктураЗаписи);
			ЗаписатьПароль("ПарольАрхиваСообщенияОбмена", "ПарольАрхиваСообщенияОбмена", СтруктураЗаписи);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура обновляет запись в регистре по переданным значениям структуры.
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	НачатьТранзакцию();
	Попытка
		ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбмена");
		ЗаписатьПароль("COMПарольПользователя", "COMПарольПользователя", СтруктураЗаписи);
		ЗаписатьПароль("FTPСоединениеПароль", "FTPСоединениеПароль", СтруктураЗаписи);
		ЗаписатьПароль("WSПароль", "WSПароль", СтруктураЗаписи);
		ЗаписатьПароль("ПарольАрхиваСообщенияОбмена", "ПарольАрхиваСообщенияОбмена", СтруктураЗаписи);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для внутреннего использования.
// 
Функция НастройкиТранспортаWS(Узел, ПараметрыАутентификации = Неопределено) Экспорт
	
	СтруктураНастроек = СоставНастроекТранспортаОбмена("WS");
	Результат = ПолучитьДанныеРегистраПоСтруктуре(Узел, СтруктураНастроек);
	
	УстановитьПривилегированныйРежим(Истина);
	WSПароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Узел, "WSПароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(WSПароль) = Тип("Строка")
		Или WSПароль = Неопределено Тогда
		
		Результат.Вставить("WSПароль", WSПароль);
	Иначе
		ВызватьИсключение НСтр("ru='Ошибка при извлечении пароля из безопасного хранилища.'");
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыАутентификации) = Тип("Структура") Тогда // Инициация обмена пользователем с клиента.
		
		Если ПараметрыАутентификации.ИспользоватьТекущегоПользователя Тогда
			
			Результат.WSИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
			
		КонецЕсли;
		
		Пароль = Неопределено;
		
		Если ПараметрыАутентификации.Свойство("Пароль", Пароль)
			И Пароль <> Неопределено Тогда // Ввели пароль на клиенте
			
			Результат.WSПароль = Пароль;
			
		Иначе // Пароль на клиенте не вводили.
			
			Пароль = ОбменДаннымиСервер.ПарольСинхронизацииДанных(Узел);
			
			Результат.WSПароль = ?(Пароль = Неопределено, "", Пароль);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрыАутентификации) = Тип("Строка") Тогда
		Результат.WSПароль = ПараметрыАутентификации;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	НастройкиТранспорта = СохраненныеНастройкиТранспорта();
	
	Пока НастройкиТранспорта.Следующий() Цикл
		
		ПараметрыЗапроса = ПараметрыЗапросаНаИспользованиеВнешнихРесурсов();
		ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, НастройкиТранспорта, ПараметрыЗапроса);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СохраненныеНастройкиТранспорта()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.Узел,
	|	НастройкиТранспортаОбмена.FTPСоединениеПуть,
	|	НастройкиТранспортаОбмена.FILEКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбмена.WSURLВебСервиса,
	|	НастройкиТранспортаОбмена.COMКаталогИнформационнойБазы,
	|	НастройкиТранспортаОбмена.COMИмяИнформационнойБазыНаСервере1СПредприятия,
	|	НастройкиТранспортаОбмена.FTPСоединениеПуть КАК FTPСоединениеПуть,
	|	НастройкиТранспортаОбмена.FTPСоединениеПорт КАК FTPСоединениеПорт,
	|	НастройкиТранспортаОбмена.WSURLВебСервиса КАК WSURLВебСервиса,
	|	НастройкиТранспортаОбмена.FILEКаталогОбменаИнформацией КАК FILEКаталогОбменаИнформацией
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена";
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция ПараметрыЗапросаНаИспользованиеВнешнихРесурсов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ЗапрашиватьCOM",  Истина);
	Параметры.Вставить("ЗапрашиватьFILE", Истина);
	Параметры.Вставить("ЗапрашиватьWS",   Истина);
	Параметры.Вставить("ЗапрашиватьFTP",  Истина);
	
	Возврат Параметры;
	
КонецФункции

Процедура ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, Запись, ПараметрыЗапроса) Экспорт
	
	Разрешения = Новый Массив;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если ПараметрыЗапроса.ЗапрашиватьFTP И Не ПустаяСтрока(Запись.FTPСоединениеПуть) Тогда
		
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Запись.FTPСоединениеПуть);
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			СтруктураАдреса.Схема, СтруктураАдреса.Хост, Запись.FTPСоединениеПорт));
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.ЗапрашиватьFILE И Не ПустаяСтрока(Запись.FILEКаталогОбменаИнформацией) Тогда
		
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
			Запись.FILEКаталогОбменаИнформацией, Истина, Истина));
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.ЗапрашиватьWS И Не ПустаяСтрока(Запись.WSURLВебСервиса) Тогда
		
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(Запись.WSURLВебСервиса);
		Если ЗначениеЗаполнено(СтруктураАдреса.Схема) Тогда
			Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				СтруктураАдреса.Схема, СтруктураАдреса.Хост, СтруктураАдреса.Порт));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.ЗапрашиватьCOM И (Не ПустаяСтрока(Запись.COMКаталогИнформационнойБазы)
		Или Не ПустаяСтрока(Запись.COMИмяИнформационнойБазыНаСервере1СПредприятия)) Тогда
		
		ИмяCOMСоединителя = ОбщегоНазначенияКлиентСервер.ИмяCOMСоединителя();
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаСозданиеCOMКласса(
			ИмяCOMСоединителя, ОбщегоНазначения.ИдентификаторCOMСоединителя(ИмяCOMСоединителя)));
		
	КонецЕсли;
	
	// Разрешения для обмена через почту запрашиваются в подсистеме Работе с почтовыми сообщениями.
	
	Если Разрешения.Количество() > 0 Тогда
		
		ЗапросыРазрешений.Добавить(
			МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, Запись.Узел));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьПароль(ИмяПароляВСтруктуре, ИмяПароляПриЗаписи, СтруктураЗаписи)
	
	Если СтруктураЗаписи.Свойство(ИмяПароляВСтруктуре) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(СтруктураЗаписи.Узел, СтруктураЗаписи[ИмяПароляВСтруктуре], ИмяПароляПриЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции получения значений настроек для узла плана обмена.

// Получает значения настроек транспорта определенного вида.
// Если вид транспорта не указан (ВидТранспортаОбмена = Неопределено),
// то получает настройки всех видов транспорта, заведенных в системе.
//
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  
//
Функция НастройкиТранспорта(Знач Узел, Знач ВидТранспортаОбмена = Неопределено) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Возврат РегистрыСведений["НастройкиТранспортаОбменаОбластиДанных"].НастройкиТранспорта(Узел);
	Иначе
		
		Возврат НастройкиТранспортаОбмена(Узел, ВидТранспортаОбмена);
	КонецЕсли;
	
КонецФункции

Функция ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Возвращаемое значение функции.
	ВидТранспортаСообщений = Неопределено;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию КАК ВидТранспортаСообщенийОбменаПоУмолчанию
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &УзелИнформационнойБазы
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВидТранспортаСообщений = Выборка.ВидТранспортаСообщенийОбменаПоУмолчанию;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ВидТранспортаСообщений;
КонецФункции

Функция ИмяКаталогаОбменаИнформацией(ВидТранспортаСообщенийОбмена, УзелИнформационнойБазы) Экспорт
	
	// Возвращаемое значение функции.
	Результат = "";
	
	Если ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
		
		Результат = НастройкиТранспорта["FILEКаталогОбменаИнформацией"];
		
	ИначеЕсли ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
		
		Результат = НастройкиТранспорта["FTPСоединениеПуть"];
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПредставленияНастроекТранспорта(ВидТранспорта) Экспорт
	
	Результат = Новый Структура;
	
	Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "COMВариантРаботыИнформационнойБазы");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMИмяСервера1СПредприятия");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMИмяИнформационнойБазыНаСервере1СПредприятия");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMКаталогИнформационнойБазы");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMАутентификацияОперационнойСистемы");
		ДобавитьЭлементПредставленияНастройки(Результат, "COMИмяПользователя");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "FILEКаталогОбменаИнформацией");
		ДобавитьЭлементПредставленияНастройки(Результат, "FILEСжиматьФайлИсходящегоСообщения");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПуть");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПорт");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПользователь");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеМаксимальныйДопустимыйРазмерСообщения");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСоединениеПассивноеСоединение");
		ДобавитьЭлементПредставленияНастройки(Результат, "FTPСжиматьФайлИсходящегоСообщения");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "EMAILУчетнаяЗапись");
		ДобавитьЭлементПредставленияНастройки(Результат, "EMAILМаксимальныйДопустимыйРазмерСообщения");
		ДобавитьЭлементПредставленияНастройки(Результат, "EMAILСжиматьФайлИсходящегоСообщения");
		
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		
		ДобавитьЭлементПредставленияНастройки(Результат, "WSURLВебСервиса");
		ДобавитьЭлементПредставленияНастройки(Результат, "WSИмяПользователя");
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция НастройкиТранспортаДляУзлаЗаданы(Узел) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1 ИЗ РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &Узел
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Узел);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Функция НастроенныеВидыТранспорта(УзелИнформационнойБазы) Экспорт
	
	Результат = Новый Массив;
	
	НастройкиТранспорта = НастройкиТранспорта(УзелИнформационнойБазы);
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.COMКаталогИнформационнойБазы) 
		ИЛИ ЗначениеЗаполнено(НастройкиТранспорта.COMИмяИнформационнойБазыНаСервере1СПредприятия) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.EMAILУчетнаяЗапись) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.FILEКаталогОбменаИнформацией) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.FTPСоединениеПуть) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиТранспорта.WSURLВебСервиса) Тогда
		
		Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

// Получает значения настроек транспорта определенного вида.
// Если вид транспорта не указан (ВидТранспортаОбмена = Неопределено),
// то получает настройки всех видов транспорта, заведенных в системе.
//
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  
//
Функция НастройкиТранспортаОбмена(Узел, ВидТранспортаОбмена)
	
	СтруктураНастроек = Новый Структура;
	
	// Общие настройки для всех видов транспорта.
	СтруктураНастроек.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию");
	СписокПаролей = "ПарольАрхиваСообщенияОбмена";
	
	Если ВидТранспортаОбмена = Неопределено Тогда
		СписокПаролей = СписокПаролей + ",FTPСоединениеПароль,WSПароль,COMПарольПользователя";
		Для Каждого ВидТранспорта Из Перечисления.ВидыТранспортаСообщенийОбмена Цикл
			
			СтруктураНастроекТранспорта = СоставНастроекТранспортаОбмена(ОбщегоНазначения.ИмяЗначенияПеречисления(ВидТранспорта));
			
			СтруктураНастроек = ОбъединитьКоллекции(СтруктураНастроек, СтруктураНастроекТранспорта);
			
		КонецЦикла;
		
	Иначе
		
		СтруктураНастроекТранспорта = СоставНастроекТранспортаОбмена(ОбщегоНазначения.ИмяЗначенияПеречисления(ВидТранспортаОбмена));
		СтруктураНастроек = ОбъединитьКоллекции(СтруктураНастроек, СтруктураНастроекТранспорта);
		
		Если ВидТранспортаОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.COM Тогда
			СписокПаролей = СписокПаролей + ",COMПарольПользователя";
		ИначеЕсли ВидТранспортаОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
			СписокПаролей = СписокПаролей + ",WSПароль";
		ИначеЕсли ВидТранспортаОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
			СписокПаролей = СписокПаролей + ",FTPСоединениеПароль";
		КонецЕсли;
	КонецЕсли;
	
	Результат = ПолучитьДанныеРегистраПоСтруктуре(Узел, СтруктураНастроек);
	Результат.Вставить("ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений", Истина);
	
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Узел, СписокПаролей, Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(Пароли) = Тип("Структура") Тогда
		Для каждого КлючИЗначение Из Пароли Цикл
			Результат.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	Иначе
		Результат.Вставить(СписокПаролей, Пароли);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьДанныеРегистраПоСтруктуре(Узел, СтруктураНастроек)
	
	Если Не ЗначениеЗаполнено(Узел) Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	Если СтруктураНастроек.Количество() = 0 Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	// Формируем текст запроса только по необходимым полям -
	// параметрам для указанного вида транспорта.
	ТекстЗапроса = "ВЫБРАТЬ ";
	
	Для Каждого ЭлементНастройки Из СтруктураНастроек Цикл
		
		ТекстЗапроса = ТекстЗапроса + ЭлементНастройки.Ключ + ", ";
		
	КонецЦикла;
	
	// Убираем последний символ ", ".
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстЗапроса, 2);
	
	ТекстЗапроса = ТекстЗапроса + "
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &Узел
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Узел", Узел);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Если есть данные для узла, то заполняем структуру.
	Если Выборка.Следующий() Тогда
		
		Для Каждого ЭлементНастройки Из СтруктураНастроек Цикл
			
			СтруктураНастроек[ЭлементНастройки.Ключ] = Выборка[ЭлементНастройки.Ключ];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

Функция СоставНастроекТранспортаОбмена(ПодстрокаПоиска)
	
	СтруктураНастроекТранспорта = Новый Структура();
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.НастройкиТранспортаОбмена;
	
	Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
		
		Если СтрНайти(Ресурс.Имя, ПодстрокаПоиска) <> 0 Тогда
			
			СтруктураНастроекТранспорта.Вставить(Ресурс.Имя, Ресурс.Синоним);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураНастроекТранспорта;
КонецФункции

Функция ОбъединитьКоллекции(Структура1, Структура2)
	
	СтруктураРезультат = Новый Структура;
	
	ДополнитьКоллекцию(Структура1, СтруктураРезультат);
	ДополнитьКоллекцию(Структура2, СтруктураРезультат);
	
	Возврат СтруктураРезультат;
КонецФункции

Процедура ДополнитьКоллекцию(Источник, Приемник)
	
	Для Каждого Элемент Из Источник Цикл
		
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЭлементПредставленияНастройки(Структура, ИмяНастройки)
	
	Структура.Вставить(ИмяНастройки, Метаданные.РегистрыСведений.НастройкиТранспортаОбмена.Ресурсы[ИмяНастройки].Представление());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли