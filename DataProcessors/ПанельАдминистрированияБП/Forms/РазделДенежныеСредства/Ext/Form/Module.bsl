﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если Результат.Свойство("ТекстОшибки") Тогда
		
		// Нет возможности использовать ОбщегоНазначенияКлиентСервер.СообщитьПользователю, 
		// так как требуется передать UID формы
		ПользовательскоеСообщение = Новый СообщениеПользователю;
		Результат.Свойство("Поле", ПользовательскоеСообщение.Поле);
		Результат.Свойство("ТекстОшибки", ПользовательскоеСообщение.Текст);
		ПользовательскоеСообщение.ИдентификаторНазначения = УникальныйИдентификатор;
		ПользовательскоеСообщение.Сообщить();
		
		ОбновлятьИнтерфейс = Ложь;
		
	КонецЕсли;
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр, Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	ПроверитьВозможностьИзменитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	Если Результат.Свойство("ТекущееЗначение") Тогда
		// Откат значения к предыдущему
		ВернутьЗначениеРеквизитаФормы(РеквизитПутьКДанным, Результат.ТекущееЗначение);
	Иначе
		СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
		
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Инициализация проверки на возможность снятия опции УчетВалютныхОпераций.
//
&НаСервере
Функция ПроверитьВозможностьИзменитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	Если РеквизитПутьКДанным = "НаборКонстант.НациональнаяВалюта" Тогда
		Если Константы.НациональнаяВалюта.Получить() <> НаборКонстант.НациональнаяВалюта Тогда
			ТекстОшибки = ОтказИзменитьВалютаУчета();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.НациональнаяВалюта.Получить());
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции // ПроверитьВозможностьИзменитьЗначениеРеквизита()

// Проверка на возможность изменения установленной валюты учета.
//
Функция ОтказИзменитьВалютаУчета()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Хозрасчетный.Организация
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть движения по ""суммовым"" регистрам! Изменение валюты учета запрещено!'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьВалютаУчета()

// Процедура присваивает переданое значение реквизиту формы
//
// Используется в случае, если новое значение не прошло проверку
//
//
&НаСервере
Процедура ВернутьЗначениеРеквизитаФормы(РеквизитПутьКДанным, ТекущееЗначение)
	
	Если РеквизитПутьКДанным = "НаборКонстант.НациональнаяВалюта" Тогда
		ЭтаФорма.НаборКонстант.НациональнаяВалюта = ТекущееЗначение;
	КонецЕсли;
	
КонецПроцедуры // ВернутьЗначениеРеквизитаФормы()

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		ОповещениеФорм = Новый Структура("ИмяСобытия, Параметр, Источник", "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		Результат.Вставить("ОповещениеФорм", ОповещениеФорм);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЗакрытии формы.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры // ПриЗакрытии()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды СправочникВалюты.
//
&НаКлиенте
Процедура СправочникВалюты(Команда)
	
	ОткрытьФорму("Справочник.Валюты.ФормаСписка");
	
КонецПроцедуры // СправочникВалюты()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля НациональнаяВалюта.
//
&НаКлиенте
Процедура НациональнаяВалютаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры // НациональнаяВалютаПриИзменении()

// Процедура - обработчик события ПриИзменении поля РасчетыНеВВалютеДоговора.
//
&НаКлиенте
Процедура РасчетыНеВВалютеДоговораПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ВремяПечатиПКО.
//
&НаКлиенте
Процедура ВремяПечатиПКОПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

