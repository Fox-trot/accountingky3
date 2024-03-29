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
	
	СправочникМенеджер = Справочники.Статусы;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ИмяПредопределенныхДанных", СтрокаТаблицыЗначений.ИмяПредопределенныхДанных);
		ЗначенияЗаполнения.Вставить("Предопределенный", ЗначениеЗаполнено(СтрокаТаблицыЗначений.ИмяПредопределенныхДанных));
		ЗначенияЗаполнения.Вставить("Наименование", СтрокаТаблицыЗначений.Наименование);
		ЗначенияЗаполнения.Вставить("Категория", Справочники.КатегорииСотрудников.НайтиПоКоду(СтрокаТаблицыЗначений.Категория));
		ЗначенияЗаполнения.Вставить("ВидЗанятости", Справочники.ВидыЗанятости[СтрокаТаблицыЗначений.ВидЗанятости]);
		ЗначенияЗаполнения.Вставить("МетодРасчетаПН", Перечисления.МетодыРасчетаПН[СтрокаТаблицыЗначений.МетодРасчетаПН]);
		ЗначенияЗаполнения.Вставить("МетодРасчетаСФ", Перечисления.МетодыРасчетаСФ[СтрокаТаблицыЗначений.МетодРасчетаСФ]);
		
		Элемент = Элементы.Добавить();
		ЗаполнитьЗначенияСвойств(Элемент, ЗначенияЗаполнения);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при начальном заполнении элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.Статусы - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецЕсли

