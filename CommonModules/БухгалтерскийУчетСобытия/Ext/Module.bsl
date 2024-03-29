﻿
#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ПОДПИСКА НА СОБЫТИЯ

// Переопределяет стандартное представление ссылки.
//
Процедура ПолучитьПредставлениеПолейДокумента(Источник, Поля, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Ссылка");
	Поля.Добавить("Дата");
	Поля.Добавить("Номер");
	Поля.Добавить("Проведен");
	Поля.Добавить("ПометкаУдаления");
	
КонецПроцедуры // ПолучитьПредставлениеДокумента()

// Переопределяет стандартное представление ссылки.
//
Процедура ПолучитьПредставлениеПолейДокументаТолькоЗапись(Источник, Поля, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Ссылка");
	Поля.Добавить("Дата");
	Поля.Добавить("Номер");
	Поля.Добавить("ПометкаУдаления");
	
КонецПроцедуры // ПолучитьПредставлениеДокумента()

// Переопределяет стандартное представление ссылки.
//
Процедура ПолучитьПредставлениеДокумента(Источник, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Если Данные.Номер = Null
		ИЛИ Не ЗначениеЗаполнено(Данные.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Состояние = "";
	Если Данные.ПометкаУдаления Тогда
		Состояние = НСтр("ru = '(удален)'");
	ИначеЕсли Данные.Свойство("Проведен") И НЕ Данные.Проведен Тогда
		Состояние = НСтр("ru = '(не проведен)'");
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2 от %3 %4'"),
		Данные.Ссылка.Метаданные().Представление(),
		?(Данные.Свойство("Номер"), ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Данные.Номер, Истина, Истина), ""),
		Формат(Данные.Дата, "ДЛФ=D"),
		Состояние);
	
	КонецПроцедуры // ПолучитьПредставлениеДокумента()
	
#КонецОбласти
	