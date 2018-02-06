﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникМенеджер = Справочники.НастройкиРегламентированныхОтчетов;
	
	// Настроки строк Баланса.
	НаименованиеСправочника = НСтр("ru = 'Настройка строк Баланса (по умолчанию)'");
	СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(НаименованиеСправочника, Истина);
	Если СправочникСсылка.Пустая() тогда
		СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		СправочникОбъект.Наименование = НаименованиеСправочника;
		СправочникОбъект.Родитель = СправочникМенеджер.Баланс;
	Иначе
		СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		СправочникОбъект.СтрокиОтчета.Очистить();
		СправочникОбъект.НастройкиСтрок.Очистить();
	КонецЕсли;	
	
	СправочникОбъект.ЗаполнитьНастройкиБаланс();
	
	БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);

	// Настроки строк ОПУ (Отчет о прибылях и убытках).
	НаименованиеСправочника = НСтр("ru = 'Настройка строк ОПУ (по умолчанию)'");
	СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(НаименованиеСправочника, Истина);
	Если СправочникСсылка.Пустая() тогда
		СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		СправочникОбъект.Наименование = НаименованиеСправочника;
		СправочникОбъект.Родитель = СправочникМенеджер.ОПУ;
	Иначе
		СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		СправочникОбъект.СтрокиОтчета.Очистить();
		СправочникОбъект.НастройкиСтрок.Очистить();
	КонецЕсли;	
	
	СправочникОбъект.ЗаполнитьНастройкиОПУ();
	
	БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	
	// Настроки строк ОДДС (Отчет о движении денежных средств).
	НаименованиеСправочника = НСтр("ru = 'Настройка строк ОДДС (по умолчанию)'");
	СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(НаименованиеСправочника, Истина);
	Если СправочникСсылка.Пустая() тогда
		СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		СправочникОбъект.Наименование = НаименованиеСправочника;
		СправочникОбъект.Родитель = СправочникМенеджер.ДДС;
	Иначе
		СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		СправочникОбъект.СтрокиОтчета.Очистить();
		СправочникОбъект.НастройкиСтрок.Очистить();
	КонецЕсли;	
	
	СправочникОбъект.ЗаполнитьНастройкиОДДС();
	
	БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	
	// Настроки строк ОИК (Отчет об изменениях в капитале).
	НаименованиеСправочника = НСтр("ru = 'Настройка строк ОИК (по умолчанию)'");
	СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(НаименованиеСправочника, Истина);
	Если СправочникСсылка.Пустая() тогда
		СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		СправочникОбъект.Наименование = НаименованиеСправочника;
		СправочникОбъект.Родитель = СправочникМенеджер.ОИК;
	Иначе
		СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		СправочникОбъект.СтрокиОтчета.Очистить();
		СправочникОбъект.НастройкиСтрок.Очистить();
	КонецЕсли;	
	
	СправочникОбъект.ЗаполнитьНастройкиОИК();
	
	БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#КонецЕсли