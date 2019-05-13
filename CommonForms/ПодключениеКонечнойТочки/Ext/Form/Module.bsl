﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СобытиеЖурналаРегистрацииПодключениеКонечнойТочки = ОбменСообщениямиВнутренний.СобытиеЖурналаРегистрацииПодключениеКонечнойТочки();
	
	СтандартныеПодсистемыСервер.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьИЗакрыть", ЭтотОбъект);
	ТекстПредупреждения = НСтр("ru = 'Отменить подключение конечной точки?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьКонечнуюТочку(Команда)
	
	ПодключитьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Отказ = Ложь;
	ОшибкаЗаполнения = Ложь;
	
	ПодключитьКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения);
	
	Если ОшибкаЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'При подключении конечной точки возникли ошибки.
		|Перейти в журнал регистрации?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьЖурналРегистрации", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияДобавленаКонечнаяТочка());
	
	ПоказатьОповещениеПользователя(,,НСтр("ru = 'Подключение конечной точки успешно завершено.'"));
	
	Модифицированность = Ложь;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииПодключениеКонечнойТочки);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьКонечнуюТочкуНаСервере(Отказ, ОшибкаЗаполнения)
	
	Если Не ПроверитьЗаполнение() Тогда
		ОшибкаЗаполнения = Истина;
		Возврат;
	КонецЕсли;
	
	НастройкиПодключенияОтправителя = ОбменДаннымиСервер.СтруктураПараметровWS();
	НастройкиПодключенияОтправителя.WSURLВебСервиса   = НастройкиОтправителяWSURLВебСервиса;
	НастройкиПодключенияОтправителя.WSИмяПользователя = НастройкиОтправителяWSИмяПользователя;
	НастройкиПодключенияОтправителя.WSПароль          = НастройкиОтправителяWSПароль;
	
	НастройкиПодключенияПолучателя = ОбменДаннымиСервер.СтруктураПараметровWS();
	НастройкиПодключенияПолучателя.WSURLВебСервиса   = НастройкиПолучателяWSURLВебСервиса;
	НастройкиПодключенияПолучателя.WSИмяПользователя = НастройкиПолучателяWSИмяПользователя;
	НастройкиПодключенияПолучателя.WSПароль          = НастройкиПолучателяWSПароль;
	
	ОбменСообщениями.ПодключитьКонечнуюТочку(
		Отказ,
		НастройкиПодключенияОтправителя,
		НастройкиПодключенияПолучателя);
	
КонецПроцедуры

#КонецОбласти
