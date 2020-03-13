﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника ПапкиФайлов.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением. Например:
//                                  Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                  ЭлементТЧ = Элемент.Ключи.Добавить();
//                                  ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	СправочникМенеджер = Справочники.ВидыТранспортаНалогНаИмущество;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполненияШкалаОценки").ПолучитьТекст();
	КлассификаторТаблицаШкалаОценки = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	КлассификаторТаблицаШкалаОценки.Индексы.Добавить("Наименование");
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", СтрокаТаблицыЗначений.Код);
		ЗначенияЗаполнения.Вставить("Наименование", СтрокаТаблицыЗначений.Наименование);
		ЗначенияЗаполнения.Вставить("НаименованиеПолное", СтрокаТаблицыЗначений.НаименованиеПолное);
		ЗначенияЗаполнения.Вставить("КатегорияАБВ", СтрокаТаблицыЗначений.КатегорияАБВ);
		
		// Добавление строка табличной части.
		ШкалаОценкиСтоимости = ТабличныеЧасти.ШкалаОценкиСтоимости.Скопировать();
		ШкалаОценкиСтоимости.Очистить();
		
		НайденныеСтроки = КлассификаторТаблицаШкалаОценки.НайтиСтроки(Новый Структура("Наименование", СтрокаТаблицыЗначений.Наименование));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
			СтрокаТабличнойЧасти = ШкалаОценкиСтоимости.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, НайденнаяСтрока);
		КонецЦикла;
		ЗначенияЗаполнения.Вставить("ШкалаОценкиСтоимости", ШкалаОценкиСтоимости);
		
		Элемент = Элементы.Добавить();
		ЗаполнитьЗначенияСвойств(Элемент, ЗначенияЗаполнения);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при начальном заполнении элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыТранспортаНалогНаИмущество - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецЕсли

