﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Заполнить по умолчанию
// Выполняет первоночальное заполнение
Процедура ЗаполнитьПоУмолчанию() Экспорт 
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	КлассификаторXML = РегистрыСведений.УчетнаяПолитикаПоПерсоналу.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	НаборЗаписей = РегистрыСведений.УчетнаяПолитикаПоПерсоналу.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();                 
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		Период = Дата(СтрокаТаблицыЗначений.Период);
		ДатаОграниченияНачисленияГНПФМужчины = Дата(СтрокаТаблицыЗначений.ДатаОграниченияНачисленияГНПФМужчины);
		ДатаОграниченияНачисленияГНПФЖенщины = Дата(СтрокаТаблицыЗначений.ДатаОграниченияНачисленияГНПФЖенщины);
		МинимальныйРасчетныйДоход = Число(СтрокаТаблицыЗначений.МинимальныйРасчетныйДоход);
		СчетУчетаРасходовПоДоплатеПН = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасходовПоДоплатеПН);
		СчетУчетаРасчетовПФФ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасчетовПФФ);
		СчетУчетаРасчетовМСФ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасчетовМСФ);
		СчетУчетаРасчетовФОТФ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасчетовФОТФ);
		СчетУчетаРасчетовПФР = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасчетовПФР);
		СчетУчетаРасчетовГНПФР = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасчетовГНПФР);
		СчетУчетаРасходовПоКорректировкеСФ = ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтрокаТаблицыЗначений.СчетУчетаРасходовПоКорректировкеСФ);
		СреднемесячнаяЗПСФ = Число(СтрокаТаблицыЗначений.СреднемесячнаяЗПСФ);
		ПроцентОтСЗПСФ = Число(СтрокаТаблицыЗначений.ПроцентОтСЗПСФ);
		КоличествоСотрудниковДляОтчетаСФ = СтрокаТаблицыЗначений.КоличествоСотрудниковДляОтчетаСФ;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = Период;
		НоваяЗапись.Организация = ОсновнаяОрганизация;
		
		НоваяЗапись.ДатаОграниченияНачисленияГНПФМужчины = ДатаОграниченияНачисленияГНПФМужчины;
		НоваяЗапись.ДатаОграниченияНачисленияГНПФЖенщины = ДатаОграниченияНачисленияГНПФЖенщины;
		НоваяЗапись.МинимальныйРасчетныйДоход = МинимальныйРасчетныйДоход;
		НоваяЗапись.ДоплатаПНЗаСчетФирмы = Истина;
		НоваяЗапись.СчетУчетаРасходовПоДоплатеПН = СчетУчетаРасходовПоДоплатеПН;
		НоваяЗапись.СчетУчетаРасчетовПФФ = СчетУчетаРасчетовПФФ;
		НоваяЗапись.СчетУчетаРасчетовМСФ = СчетУчетаРасчетовМСФ;
		НоваяЗапись.СчетУчетаРасчетовФОТФ = СчетУчетаРасчетовФОТФ;
		НоваяЗапись.СчетУчетаРасчетовПФР = СчетУчетаРасчетовПФР;
		НоваяЗапись.СчетУчетаРасчетовГНПФР = СчетУчетаРасчетовГНПФР;
		НоваяЗапись.СреднемесячнаяЗПСФ = СреднемесячнаяЗПСФ;
		НоваяЗапись.ПроцентОтСЗПСФ = ПроцентОтСЗПСФ;
		НоваяЗапись.СчетУчетаРасходовПоКорректировкеСФ = СчетУчетаРасходовПоКорректировкеСФ;
		НоваяЗапись.КоличествоСотрудниковДляОтчетаСФ = КоличествоСотрудниковДляОтчетаСФ;
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись учетной политики по персоналу по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;
КонецПроцедуры // ЗаполнитьПоУмолчанию()	

#КонецОбласти

#КонецЕсли