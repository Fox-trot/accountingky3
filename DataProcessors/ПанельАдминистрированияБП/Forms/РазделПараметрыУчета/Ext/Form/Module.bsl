﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.Прочитать();
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии формы.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры // ПриЗакрытии()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды НастройкаУчетаПоОрганизациям
//
&НаКлиенте
Процедура НастройкаУчетаПоОрганизациям(Команда)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.НастройкаУчетаПоОрганизации");
КонецПроцедуры // НастройкаУчетаПоОрганизациям()

// Процедура - обработчик команды СправочникОрганизации.
//
&НаКлиенте
Процедура СправочникОрганизации(Команда)
	Если НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям Тогда 
		ОткрытьФорму("Справочник.Организации.ФормаСписка");
	Иначе 	
		Парам = Новый Структура("Ключ", БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация"));
		ОткрытьФорму("Справочник.Организации.ФормаОбъекта", Парам);
	КонецЕсли;	
КонецПроцедуры // СправочникОрганизации()

// Процедура - обработчик команды СправочникПодразделения.
//
&НаКлиенте
Процедура СправочникПодразделения(Команда)
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаСписка");
КонецПроцедуры // СправочникПодразделения()

&НаКлиенте
Процедура УчетнаяПолитика(Команда)
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаОрганизаций.ФормаСписка");
КонецПроцедуры

// Процедура - обработчик команды СправочникВалюты.
//
&НаКлиенте
Процедура СправочникВалюты(Команда)
	ОткрытьФорму("Справочник.Валюты.ФормаСписка");
КонецПроцедуры // СправочникВалюты()

&НаКлиенте
Процедура УчетнаяПолитикаПоПерсоналу(Команда)
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаПоПерсоналу.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаЗП(Команда)
	ОткрытьФорму("РегистрСведений.СчетаУчетаЗП.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ДенежныеСредства

// Процедура - обработчик события ПриИзменении поля ВалютаРегламентированногоУчета.
//
&НаКлиенте
Процедура ВалютаРегламентированногоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры // ВалютаРегламентированногоУчетаПриИзменении()

// Процедура - обработчик события ПриИзменении поля РасчетыНеВВалютеДоговора.
//
&НаКлиенте
Процедура УчетРасчетовВВалютеДоговораПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ВремяПечатиПКО.
//
&НаКлиенте
Процедура ВремяПечатиПКОПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОсновныеСредства

// Процедура - обработчик события ПриИзменении поля ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетДвиженияОСПоПодразделениямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ФункциональнаяОпцияУчетДвиженияОСПоМОЛ.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетДвиженияОСПоМОЛПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#Область ЗарплатаИПерсонал

// Процедура - обработчик события ПриИзменении поля КонтролироватьПоШтатномуРасписанию.
//
&НаКлиенте
Процедура ФункциональнаяОпцияВестиШтатноеРасписаниеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля УчетЗаработнойПлатыПоСтатьямЗатрат.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетЗаработнойПлатыПоСтатьямЗатратПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДоходыИРасходы

// Процедура - обработчик события ПриИзменении поля ввода ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.
//
&НаКлиенте
Процедура ФункциональнаяОпцияДопРасходыНаНесколькоПоступленийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Процедура - обработчик события ПриИзменении поля ввода МакетОформленияОтчетов.
//
&НаКлиенте
Процедура МакетОформленияОтчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КонтролироватьОстаткиПриПроведении.
//
&НаКлиенте
Процедура КонтролироватьОстаткиПриПроведенииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.
//
&НаКлиенте
Процедура ФункциональнаяОпцияИспользоватьПодключаемоеОборудованиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

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
	
	Если РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям" Тогда
		Если Константы.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.Получить() <> НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям Тогда
			ТекстОшибки = ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.Получить());
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ" Тогда
		Если Константы.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ.Получить() <> НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ Тогда
			ТекстОшибки = ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ.Получить());
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений" Тогда
		Если Константы.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.Получить() <> НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений
			И НЕ НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений Тогда
			ТекстОшибки = ОтказИзменитьФункциональнаяОпцияДопРасходыНаНесколькоПоступлений();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.Получить());
			КонецЕсли;
		КонецЕсли; 	
	КонецЕсли;
	
КонецФункции // ПроверитьВозможностьИзменитьЗначениеРеквизита()

// Проверка на возможность изменения ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.
//
Функция ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	МестонахождениеОС.Организация
		|ИЗ
		|	РегистрСведений.МестонахождениеОС КАК МестонахождениеОС";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть движения по регистру сведений ""Местонахождение ОС""! Изменение учета движений запрещено!'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям()

// Проверка на возможность изменения ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.
//
Функция ОтказИзменитьФункциональнаяОпцияДопРасходыНаНесколькоПоступлений()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДополнительныеРасходы.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДополнительныеРасходы КАК ДополнительныеРасходы
		|ГДЕ
		|	ДополнительныеРасходы.Проведен";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть проведенные документы ""Дополнительные расходы"". Изменение учета движений запрещено!'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьФункциональнаяОпцияДопРасходыНаНесколькоПоступлений()

// Процедура присваивает переданое значение реквизиту формы
//
// Используется в случае, если новое значение не прошло проверку
//
//
&НаСервере
Процедура ВернутьЗначениеРеквизитаФормы(РеквизитПутьКДанным, ТекущееЗначение)
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВалютаРегламентированногоУчета" Тогда
		ЭтаФорма.НаборКонстант.ВалютаРегламентированногоУчета = ТекущееЗначение;
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям" Тогда
		ЭтаФорма.НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям = ТекущееЗначение;
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ" Тогда
		ЭтаФорма.НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ = ТекущееЗначение;
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений" Тогда
		ЭтаФорма.НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений = ТекущееЗначение;
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
	
	// Изменение значений связанных констант.
	Если КонстантаИмя = "ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений" Тогда
		КонстантаМенеджер = Константы.ФункциональнаяОпцияДопРасходыНаОдноПоступление;
		КонстантаЗначение = НЕ НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти
