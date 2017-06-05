﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("СпособУстановкиКурса");
	Результат.Добавить("Наценка");
	Результат.Добавить("ОсновнаяВалюта");
	Результат.Добавить("ФормулаРасчетаКурса");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейсБПКР

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникМенеджер = Справочники.Валюты;
	
	КлассификаторXML = Справочники.Валюты.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица  = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл 
		Код					  	= СокрЛП(СтрокаТаблицыЗначений.Code);
		Наименование 		  	= СокрЛП(СтрокаТаблицыЗначений.CodeSymbol);
		НаименованиеПолное    	= СокрЛП(СтрокаТаблицыЗначений.Name);
		ЗагружаетсяИзИнтернета	= СокрЛП(СтрокаТаблицыЗначений.NBKRLoading);
		ПараметрыПрописи		= СокрЛП(СтрокаТаблицыЗначений.NumerationItemOptions);
		
		СправочникСсылка = СправочникМенеджер.НайтиПоКоду(Код);
		
		Если СправочникСсылка.Пустая() тогда
			СправочникОбъект = СправочникМенеджер.СоздатьЭлемент();
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;	
		
		СправочникОбъект.Код				  	= Код;
		СправочникОбъект.Наименование 	       	= Наименование;
		СправочникОбъект.НаименованиеПолное    	= НаименованиеПолное;
		СправочникОбъект.ЗагружаетсяИзИнтернета	= ?(ЗагружаетсяИзИнтернета = "Да", Истина, Ложь);
		СправочникОбъект.ПараметрыПрописи 		= ПараметрыПрописи;
		
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#КонецЕсли