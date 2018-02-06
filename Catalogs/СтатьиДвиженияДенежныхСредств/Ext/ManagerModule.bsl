﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникМенеджер = Справочники.СтатьиДвиженияДенежныхСредств;
	
	КлассификаторXML = Справочники.СтатьиДвиженияДенежныхСредств.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица  = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл 
		Наименование = СокрЛП(СтрокаТаблицыЗначений.Наименование);
		Родитель   	 = СокрЛП(СтрокаТаблицыЗначений.Родитель);
		
		СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(Наименование, Истина);
		
		Если СправочникСсылка.Пустая() тогда
			Если СтрокаТаблицыЗначений.Группа <> "" Тогда 
				СправочникОбъект = СправочникМенеджер.СоздатьГруппу();
			Иначе 
				СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
			КонецЕсли;	
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;	
		
		СправочникОбъект.Наименование = Наименование;
		
		Если Родитель <> "" Тогда 
			РодительЭлемента = СправочникМенеджер.НайтиПоНаименованию(Родитель, Истина);
			СправочникОбъект.Родитель = РодительЭлемента;
		КонецЕсли;	
		
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект,,,,Истина);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#КонецЕсли