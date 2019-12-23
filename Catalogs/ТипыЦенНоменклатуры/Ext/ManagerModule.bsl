﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникМенеджер = Справочники.ТипыЦенНоменклатуры;
	
	КлассификаторXML = Справочники.ТипыЦенНоменклатуры.ПолучитьМакет("ПервоначальноеЗаполнение").ПолучитьТекст();
	КлассификаторТаблица  = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл 
		Наименование    = СокрЛП(СтрокаТаблицыЗначений.Наименование);
		Валюта   	    = Справочники.Валюты.НайтиПоКоду(СокрЛП(СтрокаТаблицыЗначений.Валюта));
		НДС		   	    = ?(СокрЛП(СтрокаТаблицыЗначений.НДС) <> "", Истина, Ложь);
		ОкруглятьДо     = Число(СтрокаТаблицыЗначений.ОкруглятьДо);
				
		СправочникСсылка = СправочникМенеджер.НайтиПоНаименованию(Наименование, Истина);
		
		Если СправочникСсылка.Пустая() Тогда
			СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;	
		
		СправочникОбъект.Наименование       = Наименование;
		СправочникОбъект.ВалютаЦены         = Валюта;
		СправочникОбъект.ЦенаВключаетНалоги = НДС;
		СправочникОбъект.Точность           = ОкруглятьДо;
		
		БухгалтерскийУчетСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти	

#КонецЕсли
