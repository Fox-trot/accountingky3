﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
//
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	РегистрыСведенийМенеджер = РегистрыСведений.СтавкиНалоговЗаработнойПлаты;
	
	КлассификаторXML = РегистрыСведенийМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;     
	
	НаборЗаписей = РегистрыСведенийМенеджер.СоздатьНаборЗаписей();
	НаборЗаписей.Очистить();                 
	Период = Дата(2018,01,01);
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		Наименование = СокрЛП(СтрокаТаблицыЗначений.Наименование);
		СправочникСсылка = Справочники.Статусы.НайтиПоНаименованию(Наименование, Истина);
		
		Если СправочникСсылка.Пустая() Тогда
			Продолжить;
		КонецЕсли;	
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТаблицыЗначений); 
		НоваяЗапись.Период = Период;
		НоваяЗапись.Статус = СправочникСсылка;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры // ЗаполнитьПоУмолчанию()	


#КонецОбласти

#КонецЕсли
