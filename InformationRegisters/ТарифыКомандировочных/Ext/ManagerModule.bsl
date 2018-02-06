﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт
	СправочникМенеджер = Справочники.Номенклатура;
	
	КлассификаторXML = РегистрыСведений.ТарифыКомандировочных.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	НовыйДокумент = Документы.УстановкаТарифовКомандировочных.СоздатьДокумент();
	НовыйДокумент.Дата = НачалоГода(ТекущаяДатаСеанса());
	НовыйДокумент.Организация = Справочники.Организации.ОсновнаяОрганизация;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		СтрокаТабличнойЧасти = НовыйДокумент.Тарифы.Добавить();
		СтрокаТабличнойЧасти.Страна = Справочники.СтраныМира[СтрокаТаблицыЗначений.Страна];
		СтрокаТабличнойЧасти.Город = ?(ЗначениеЗаполнено(СтрокаТаблицыЗначений.Город), Справочники.Города.Бишкек, Справочники.Города.ПустаяСсылка());
		СтрокаТабличнойЧасти.Валюта = Справочники.Валюты.НайтиПоНаименованию(СтрокаТаблицыЗначений.Валюта);
		СтрокаТабличнойЧасти.Суточные = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаТаблицыЗначений.СуммаСуточные);
		СтрокаТабличнойЧасти.Проживание = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаТаблицыЗначений.СуммаПроживание);	
	КонецЦикла;
	
	Попытка
		НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить заполнение тарифов командировочных по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#КонецЕсли