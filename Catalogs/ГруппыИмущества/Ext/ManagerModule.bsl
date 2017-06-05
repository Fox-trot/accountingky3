﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникМенеджер = Справочники.ГруппыИмущества;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("СтандартныеГруппы").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;     
	
	НаборЗаписей = РегистрыСведений.СтавкиНалогаНаИмущество.СоздатьНаборЗаписей();
	НаборЗаписей.Очистить();                 
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		Наименование = СокрЛП(СтрокаТаблицыЗначений.Наименование);
		НаименованиеПолное = СокрЛП(СтрокаТаблицыЗначений.НаименованиеПолное); 
		Ставка = СтрокаТаблицыЗначений.Ставка; 
		
		//Первая группа имущества
		Если СтрокаТаблицыЗначений.Наименование = "1 группа" Тогда
			СправочникСсылка = Справочники.ГруппыИмущества.ГИ1;
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		//Вторая группа имущества	
		ИначеЕсли СтрокаТаблицыЗначений.Наименование = "2 группа"  Тогда
			СправочникСсылка = Справочники.ГруппыИмущества.ГИ2;
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		//Третья группа имущества	
		ИначеЕсли СтрокаТаблицыЗначений.Наименование = "3 группа"  Тогда
			СправочникСсылка = Справочники.ГруппыИмущества.ГИ3;
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		//Четвертая группа имущества	
		ИначеЕсли СтрокаТаблицыЗначений.Наименование = "4 группа"  Тогда
			СправочникСсылка = Справочники.ГруппыИмущества.ГИ4;
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;	
			
		СправочникОбъект.Наименование = Наименование;
		СправочникОбъект.НаименованиеПолное	= НаименованиеПолное;
		
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
		
		// Добавление в регистр
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период 					= '2009.01.01';
		НоваяЗапись.ГруппаНалогаНаИмущество = СправочникСсылка;
		НоваяЗапись.Ставка 					= Ставка;
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
	КонецПопытки;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти
	
#КонецЕсли