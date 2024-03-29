﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "БазоваяФункциональность".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БТС.

#Область БазоваяФункциональность

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Параметры.Модули.Добавить(ВитриныКлиент);
	Параметры.Модули.Добавить(ОбменДаннымиВМоделиСервисаКлиент);
	
	ИменаПодсистем = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИменаПодсистем;
	Если ИменаПодсистем.Получить("ТехнологияСервиса.МиграцияПриложений") <> Неопределено Тогда
		Параметры.Модули.Добавить(Вычислить("МиграцияПриложенийКлиент"));
	КонецЕсли;
	
	Если ИменаПодсистем.Получить("ТехнологияСервиса.РаботаВМоделиСервиса.РасширенияВМоделиСервиса") <> Неопределено Тогда
		Параметры.Модули.Добавить(Вычислить("КаталогРасширенийКлиент"));		
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	ОбменДаннымиВМоделиСервисаКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеРаботыПользователей

// См. ИнтеграцияСТехнологиейСервисаКлиент.ПриНачалеРаботыСистемы.
Процедура ПриЗавершенииСеансов(ФормаВладелец, Знач НомераСеансов, СтандартнаяОбработка, Знач ОповещениеПослеЗавершенияСеанса = Неопределено) Экспорт
	
	УдаленноеАдминистрированиеБТСКлиент.ПриЗавершенииСеансов(ФормаВладелец, НомераСеансов, СтандартнаяОбработка, ОповещениеПослеЗавершенияСеанса);
	
КонецПроцедуры

#КонецОбласти

#Область ПрофилиБезопасности

// См. РаботаВБезопасномРежимеКлиентПереопределяемый.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов.
Процедура ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт

	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервисаКлиент.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(
		ИдентификаторыЗапросов, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обработка программных событий, возникающих в подсистемах БТС.
// Только для вызовов из библиотеки БТС в БСП.

// См. ВызовОнлайнПоддержкиКлиент.ОбработкаОповещения.
Процедура ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения(ИмяСобытия, Элемент) Экспорт
	
	ВызовОнлайнПоддержкиКлиент.ОбработкаОповещения(ИмяСобытия, Элемент);
	
КонецПроцедуры

#КонецОбласти
