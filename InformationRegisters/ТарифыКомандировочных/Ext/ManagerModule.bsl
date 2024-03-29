﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт
	КлассификаторXML = РегистрыСведений.ТарифыКомандировочных.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УстановкаТарифовКомандировочных.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.УстановкаТарифовКомандировочных КАК УстановкаТарифовКомандировочных
		|ГДЕ
		|	УстановкаТарифовКомандировочных.Проведен";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		НовыйДокумент = Документы.УстановкаТарифовКомандировочных.СоздатьДокумент();
	Иначе 
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		НовыйДокумент = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	КонецЕсли;	
		
	НовыйДокумент.Заполнить(Неопределено);
	НовыйДокумент.Дата = НачалоГода(ТекущаяДатаСеанса());
	НовыйДокумент.Тарифы.Очистить();
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		СтрокаТабличнойЧасти = НовыйДокумент.Тарифы.Добавить();
		СтрокаТабличнойЧасти.Страна = Справочники.СтраныМира.НайтиПоКоду(СтрокаТаблицыЗначений.КодСтраны);
		СтрокаТабличнойЧасти.Город = Справочники.Города.НайтиПоНаименованию(СтрокаТаблицыЗначений.Город, Истина);
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