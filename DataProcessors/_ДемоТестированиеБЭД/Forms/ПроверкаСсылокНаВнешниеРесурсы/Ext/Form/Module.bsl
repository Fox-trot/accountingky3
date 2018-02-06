﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ОбработкаОбъект.ПолучитьМакет("СсылкиНаВнешниеРесурсы");
	
	КоличествоЗаписей = Макет.ВысотаТаблицы;
	
	ТипСтрока = Новый ОписаниеТипов("Строка");
	
	ТаблицаСсылок = Новый ТаблицаЗначений;
	ТаблицаСсылок.Колонки.Добавить("Банк", ТипСтрока);
	ТаблицаСсылок.Колонки.Добавить("Представление", ТипСтрока);
	ТаблицаСсылок.Колонки.Добавить("Гиперссылка", ТипСтрока);
	ТаблицаСсылок.Колонки.Добавить("КлючеваяФраза", ТипСтрока);
	
	Для Индекс = 2 По КоличествоЗаписей Цикл
		
		НоваяСтрока = ТаблицаСсылок.Добавить();
		НоваяСтрока.Банк          = Макет.Область(Индекс, 1).Текст;
		НоваяСтрока.Представление = Макет.Область(Индекс, 2).Текст;
		НоваяСтрока.Гиперссылка   = Макет.Область(Индекс, 3).Текст;
		НоваяСтрока.КлючеваяФраза = Макет.Область(Индекс, 4).Текст;
		
	КонецЦикла;
	
	ТаблицаСсылок.Сортировать("Банк, Представление");
	
	УзлыДерева = РезультатыПроверки.ПолучитьЭлементы();
	УзлыДерева.Очистить();
	ТекущийБанк = Неопределено;
	ТекущийСайт = Неопределено;
	КоличествоОшибок = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаСсылок Цикл
		Результат = 1;
		
		Если СтрокаТаблицы.Банк <> ТекущийБанк Тогда
			ТекущийБанк = СтрокаТаблицы.Банк;
			
			УзелБанк = УзлыДерева.Добавить();
			УзелБанк.Представление = СтрокаТаблицы.Банк;
			УзелБанк.Результат = 1;
		КонецЕсли;
		
		Если СтрокаТаблицы.Представление <> ТекущийСайт Тогда
			ТекущийСайт = СтрокаТаблицы.Представление;
			
			УзелСсылка = УзелБанк.ПолучитьЭлементы().Добавить();
			УзелСсылка.Представление = СтрокаТаблицы.Представление;
			УзелСсылка.Гиперссылка = СтрокаТаблицы.Гиперссылка;
			УзелСсылка.Результат = 1;
			
			ТекстОшибки = "";
			HTTPОтвет = ВыполнитьHTTPЗапрос(СтрокаТаблицы.Гиперссылка, ТекстОшибки);
			Если HTTPОтвет = Неопределено Тогда
				УзелСсылка.ТекстОшибки = ТекстОшибки;
				КоличествоОшибок = КоличествоОшибок + 1;
				Результат = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если Результат И НЕ ПустаяСтрока(СтрокаТаблицы.КлючеваяФраза) Тогда
			УзелКлючеваяФраза = УзелСсылка.ПолучитьЭлементы().Добавить();
			УзелКлючеваяФраза.Представление = НСтр("ru = 'Ключевая фраза'");
			УзелКлючеваяФраза.Гиперссылка   = СтрокаТаблицы.КлючеваяФраза;
			
			Тело = HTTPОтвет.ПолучитьТелоКакСтроку();
			Если НЕ СтрНайти(Тело, СокрЛП(СтрокаТаблицы.КлючеваяФраза)) Тогда
				КоличествоОшибок = КоличествоОшибок + 1;
				Результат = 0;
			КонецЕсли;
			УзелКлючеваяФраза.Результат = Результат;
		КонецЕсли;
		
		Если НЕ Результат Тогда
			УзелБанк.Результат   = 0;
			УзелСсылка.Результат = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Если КоличествоОшибок Тогда
		Элементы.ГруппаПредупреждение.Видимость = Истина;
		ШаблонЗаголовка = НСтр("ru = 'Предупреждений: %1'");
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(КоличествоОшибок);
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ШаблонЗаголовка, МассивПараметров);
		Элементы.НадписьПредупреждение.Заголовок = ТекстЗаголовка;
	Иначе
		Элементы.ГруппаПредупреждение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьHTTPЗапрос(ПолныйАдресРесурса, ТекстОшибки = "")
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(ПолныйАдресРесурса);
	ЗащищенноеСоединение = ?(НРег(СтруктураURI.Схема) = "http", Неопределено, Новый ЗащищенноеСоединениеOpenSSL);
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост, СтруктураURI.Порт,,,,15,ЗащищенноеСоединение); 
	 
	HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере); 
	Попытка
		Результат =  HTTPСоединение.Получить(HTTPЗапрос);
	Исключение
		ТекстОшибки = НСтр("ru = 'Произошла сетевая ошибка.'");
		Возврат Неопределено;
	КонецПопытки;
		
	Если СтруктураURI.Хост = "its.1c.ru" Тогда
		Тело = Результат.ПолучитьТелоКакСтроку();
		
		ДанныеИД = ЗначениеПараметраИзСтроки(Тело, "data-nonce=", """");
		Если ПустаяСтрока(ДанныеИД) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПутьНаСервере = СтрЗаменить(СтруктураURI.ПутьНаСервере, "#", "/");
		ПутьНаСервере = СтрЗаменить(ПутьНаСервере, ":", "/");
		ПутьНаСервере = ПутьНаСервере + "?bus&" + ДанныеИД;
		
		HTTPЗапрос = Новый HTTPЗапрос(ПутьНаСервере); 
		Попытка
			Результат =  HTTPСоединение.Получить(HTTPЗапрос);
		Исключение
			ТекстОшибки = НСтр("ru = 'Произошла сетевая ошибка.'");
			Возврат Неопределено;
		КонецПопытки;
		
		Тело = Результат.ПолучитьТелоКакСтроку();
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Тело);
		
		КодСостояния = Неопределено;
		Пока ЧтениеJSON.Прочитать() Цикл
			
			Если ЧтениеJSON.ТипТекущегоЗначения <> ТипЗначенияJSON.ИмяСвойства Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЧтениеJSON.ТекущееЗначение = "status" И ЧтениеJSON.Прочитать() Тогда
				КодСостояния = ЧтениеJSON.ТекущееЗначение;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если КодСостояния = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Произошла сетевая ошибка.'");
			Возврат Неопределено;
		КонецЕсли;
		
		Результат = Новый Структура("КодСостояния", КодСостояния);
		
	КонецЕсли;
	
	// Ошибки 4XX говорят о неправильном запросе - в широком смысле.
	// Может быть неправильный адрес, ошибка аутентификации, плохой формат запроса.
	// Подробнее смотри http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4
	Если Результат.КодСостояния = 401 Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка аутентификации. Код статуса: 401'");
		Возврат Неопределено;
		
	ИначеЕсли Результат.КодСостояния >= 400 И Результат.КодСостояния < 500  Тогда
		ШаблонТекста = НСтр("ru = 'Ошибка запроса.  Код статуса: %1'");
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Результат.КодСостояния);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ШаблонТекста, МассивПараметров);
		Возврат Неопределено;
		
	// Ошибки 5XX говорят о проблемах на сервере (возможно, прокси-сервер).
	// Это может быть программная ошибка, нехватка памяти, ошибка конфигурации и т.д.
	// Подробнее смотри http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.5
	ИначеЕсли Результат.КодСостояния >= 500 И Результат.КодСостояния < 600  Тогда
		ШаблонТекста = НСтр("ru = 'Ошибка сервера. Код статуса: %1'");
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Результат.КодСостояния);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ШаблонТекста, МассивПараметров);
		Возврат Неопределено;
		
	// Обрабатываем перенаправление
	ИначеЕсли Результат.КодСостояния = 302 Тогда
		АдресРесурса = Результат.Заголовки.Получить("Location");
		Если АдресРесурса <> Неопределено Тогда
			ШаблонТекста = НСтр("ru = 'Код статуса 302, Постоянное перенаправление по адресу: %1'");
			МассивПараметров = Новый Массив;
			МассивПараметров.Добавить(Результат.КодСостояния);
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ШаблонТекста, МассивПараметров);
		Иначе
			ТекстОшибки = НСтр("ru = 'Код статуса 302, Постоянное перенаправление. Сервер не сообщил адрес ресурса.'");
		КонецЕсли;
		Возврат Неопределено;
		
	ИначеЕсли Результат.КодСостояния >= 300 И Результат.КодСостояния < 400  Тогда
		ШаблонТекста = НСтр("ru = 'Код статуса больше 3XX, Перенаправление. Код статуса: %1'");
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Результат.КодСостояния);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(ШаблонТекста, МассивПараметров);
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Функция ЗначениеПараметраИзСтроки(СтрокаПараметров, ИмяПараметра, Разделитель)
	
	ПозицияПараметра = СтрНайти(СтрокаПараметров, ИмяПараметра);
	Если НЕ ПозицияПараметра Тогда
		Возврат "";
	КонецЕсли;
	
	НачалоСтроки = ПозицияПараметра + СтрДлина(ИмяПараметра) + СтрДлина(Разделитель);
	КонецСтроки  = СтрНайти(СтрокаПараметров, Разделитель,, НачалоСтроки);
	ЗначениеПараметра = Сред(СтрокаПараметров, НачалоСтроки, КонецСтроки - НачалоСтроки);
	
	Возврат ЗначениеПараметра;
	
КонецФункции

#КонецОбласти