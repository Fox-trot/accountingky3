﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// БПКР
	УстановитьСтильКонфигурации(ИменаПараметровСеанса);
	// Конец БПКР
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	// ТехнологияСервиса
	ТехнологияСервиса.ВыполнитьДействияПриУстановкеПараметровСеанса(ИменаПараметровСеанса);
	// Конец ТехнологияСервиса

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСтильКонфигурации(ИменаПараметровСеанса)

	Если ИменаПараметровСеанса <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСтиляПриложения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ВРег("ИмяСтиляПриложения"), "ЗначениеПоУмолчанию", "ПоУмолчанию");
	Если ИмяСтиляПриложения = "ПоУмолчанию" Тогда 
		СтильПриложения = Новый Стиль;
	Иначе 
		СтильПриложения = БиблиотекаСтилей[ИмяСтиляПриложения];	
	КонецЕсли;	
	
	Попытка
		ГлавныйСтиль = СтильПриложения;
	Исключение
	    ПодробнаяИнформацияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстОшибки = СтрШаблон("Не удалось установить главный стиль ""%1"" по причине:
			|%2",
			СтильПриложения,
			ПодробнаяИнформацияОбОшибке);
		ЗаписьЖурналаРегистрации(
			"Установка главного стиля приложения",
			УровеньЖурналаРегистрации.Предупреждение,
			,,
			ТекстОшибки);
	КонецПопытки;	 

КонецПроцедуры

#КонецОбласти

#КонецЕсли