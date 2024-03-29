﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ВидПериодаПриИзменении(Элемент, Знач ВидПериода, НачалоПериода, КонецПериода, Период) Экспорт
	
	Если ВидПериода <> ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.ПроизвольныйПериод") Тогда
		Если ЗначениеЗаполнено(НачалоПериода) Тогда
			НачалоПериода = ВыборПериодаКлиентСервер.НачалоПериодаОтчета(ВидПериода, НачалоПериода);
			КонецПериода  = ВыборПериодаКлиентСервер.КонецПериодаОтчета(ВидПериода, НачалоПериода);
		Иначе
			НачалоПериода = Неопределено;
			КонецПериода  = Неопределено;
		КонецЕсли;
		
		Список = ВыборПериодаКлиентСервер.ДоступныеПериоды(НачалоПериода, ВидПериода);
		ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
		Если ЭлементСписка <> Неопределено Тогда
			Период = ЭлементСписка.Представление;
		Иначе
			Период = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПериодПриИзменении(Элемент, Знач Период, НачалоПериода, КонецПериода) Экспорт
	
	Если ПустаяСтрока(Период) Тогда
		НачалоПериода = Неопределено;
		КонецПериода  = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПериодНачалоВыбора(Форма, Элемент, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	Если НачалоПериода = '00010101' Тогда
		НачалоПериода = ВыборПериодаКлиентСервер.НачалоПериодаОтчета(ВидПериода, ТекущаяДата());
	КонецЕсли;
	ВыбранныйПериод      = ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, ВидПериода, НачалоПериода);
	СтандартнаяОбработка = Ложь;
	Если ВыбранныйПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период = ВыбранныйПериод.Представление;
	
	НачалоПериода = ВыбранныйПериод.Значение;
	КонецПериода  = ВыборПериодаКлиентСервер.КонецПериодаОтчета(ВидПериода, ВыбранныйПериод.Значение);
	
КонецПроцедуры

Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Дата") Тогда
		НачалоПериода = ВыборПериодаКлиентСервер.НачалоПериодаОтчета(ВидПериода, ВыбранноеЗначение);
		КонецПериода  = ВыборПериодаКлиентСервер.КонецПериодаОтчета(ВидПериода, ВыбранноеЗначение);
		
		ВыбранноеЗначение = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
			ВидПериода, НачалоПериода, КонецПериода);
			
		Период = ВыбранноеЗначение;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	ДанныеВыбора = ВыборПериодаКлиентСервер.ПодобратьПериодОтчета(ВидПериода, Текст, 
		НачалоПериода, КонецПериода);
		
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, ВидПериода, Период, НачалоПериода, КонецПериода) Экспорт
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = ВыборПериодаКлиентСервер.ПодобратьПериодОтчета(ВидПериода, Текст, 
		НачалоПериода, КонецПериода);
		
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, ВидПериода, НачалоПериода)
	
	Список = ВыборПериодаКлиентСервер.ДоступныеПериоды(НачалоПериода, ВидПериода);
	Если Список.Количество() = 0 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат Неопределено;
	КонецЕсли;
	
	ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
	ВыбранныйПериод = Форма.ВыбратьИзСписка(Список, Элемент, ЭлементСписка);
	
	Если ВыбранныйПериод = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Индекс = Список.Индекс(ВыбранныйПериод);
	Если Индекс = 0 ИЛИ Индекс = Список.Количество() - 1 Тогда
		ВыбранныйПериод = ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, ВидПериода, ВыбранныйПериод.Значение);
	КонецЕсли;
	
	Возврат ВыбранныйПериод;
	
КонецФункции

#КонецОбласти
