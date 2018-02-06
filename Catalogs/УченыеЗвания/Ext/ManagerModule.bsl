﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт
	
	СправочникМенеджер = Справочники.УченыеЗвания;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;     
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		Наименование = СокрЛП(СтрокаТаблицыЗначений.Наименование);
		
		СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(Наименование, Истина);
		
		Если СправочникСсылка.Пустая() Тогда
			СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;	
		
		СправочникОбъект.Наименование = Наименование;
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект,,,,Истина);
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#КонецЕсли