﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Наименование");
	БлокируемыеРеквизиты.Добавить("СчетУчета");
	БлокируемыеРеквизиты.Добавить("СтатьяДвиженияДенежныхСредств");
	БлокируемыеРеквизиты.Добавить("ВидОперации");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции 

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	СправочникМенеджер = Справочники.ОперацииРКО;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица  = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	             
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл 
		Имя    		= СокрЛП(СтрокаТаблицыЗначений.Имя);
		СчетУчета  	= ПланыСчетов.Хозрасчетный.НайтиПоКоду(СокрЛП(СтрокаТаблицыЗначений.СчетУчета));
		ВидОперации = Перечисления.ВидыОперацийРКО[СтрокаТаблицыЗначений.ВидОперации];
						
		СправочникСсылка = СправочникМенеджер[Имя];
		СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		
		СправочникОбъект.СчетУчета   = СчетУчета;
		СправочникОбъект.ВидОперации = ВидОперации;
		
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти	

#КонецЕсли
