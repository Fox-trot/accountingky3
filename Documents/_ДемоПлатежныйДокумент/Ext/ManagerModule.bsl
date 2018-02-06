﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Платежное поручение
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПлатежноеПоручение";
	КомандаПечати.Представление = НСтр("ru = 'Платежное поручение'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПлатежноеПоручение") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПлатежноеПоручение",
			НСтр("ru='Платежное поручение'"),
			СформироватьПлатежноеПоручение(МассивОбъектов, ОбъектыПечати),
			,
			"Документ._ДемоПлатежныйДокумент.ПФ_MXL_ПлатежноеПоручение");			
	КонецЕсли;
		
КонецПроцедуры

Функция СформироватьПлатежноеПоручение(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеБезналичныхДенежныхСредств_ПлатежноеПоручение";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ._ДемоПлатежныйДокумент.ПФ_MXL_ПлатежноеПоручение");

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Документ.СчетОрганизации КАК СчетОрганизации,
	|	Документ.СчетКонтрагента КАК СчетКонтрагента
	|ПОМЕСТИТЬ БанковскиеСчета
	|ИЗ
	|	Документ._ДемоПлатежныйДокумент КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивДокументов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетОрганизации,
	|	СчетКонтрагента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка КАК Ссылка,
	|	БанковскиеСчета.Владелец КАК Владелец,
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	БанковскиеСчета.Банк.Наименование КАК НаименованиеБанка,
	|	БанковскиеСчета.Банк.Код КАК БИК
	|ПОМЕСТИТЬ БанковскиеСчетаКонтрагентов
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов = ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В
	|			(ВЫБРАТЬ
	|				БанковскиеСчета.СчетКонтрагента КАК БанковскийСчетКонтрагента
	|			ИЗ
	|				БанковскиеСчета КАК БанковскиеСчета)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Владелец,
	|	0,
	|	БанковскиеСчета.БанкДляРасчетов.Наименование,
	|	БанковскиеСчета.БанкДляРасчетов.Код
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов <> ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В
	|			(ВЫБРАТЬ
	|				БанковскиеСчета.СчетКонтрагента КАК БанковскийСчетКонтрагента
	|			ИЗ
	|				БанковскиеСчета КАК БанковскиеСчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка КАК Ссылка,
	|	БанковскиеСчета.Владелец КАК Владелец,
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	БанковскиеСчета.Банк.Наименование КАК НаименованиеБанка,
	|	БанковскиеСчета.Банк.Код КАК БИК
	|ПОМЕСТИТЬ БанковскиеСчетаОрганизаций
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов = ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В
	|			(ВЫБРАТЬ
	|				БанковскиеСчета.СчетОрганизации КАК БанковскийСчет
	|			ИЗ
	|				БанковскиеСчета КАК БанковскиеСчета)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Владелец,
	|	0,
	|	БанковскиеСчета.БанкДляРасчетов.Наименование,
	|	БанковскиеСчета.БанкДляРасчетов.Код
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов <> ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В
	|			(ВЫБРАТЬ
	|				БанковскиеСчета.СчетОрганизации КАК БанковскийСчет
	|			ИЗ
	|				БанковскиеСчета КАК БанковскиеСчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК ДатаДокумента,
	|	Документ.Организация.Наименование КАК ПлательщикНаименование,
	|	Документ.Организация КАК Организация,
	|	Документ.Организация.ИНН КАК ИННПлательщика,
	|	Документ.Организация.КПП КАК КПППлательщика,
	|	БанковскиеСчетаКонтрагентов.Владелец.Наименование КАК ПолучательНаименование,
	|	БанковскиеСчетаКонтрагентов.Владелец КАК Получатель,
	|	БанковскиеСчетаКонтрагентов.Владелец.ИНН КАК ИННПолучателя,
	|	БанковскиеСчетаКонтрагентов.Владелец.КПП КАК КПППолучателя,
	|	Документ.НазначениеПлатежа КАК НазначениеПлатежа,
	|	Документ.ВидПлатежа КАК ВидПлатежа,
	|	Документ.ОчередностьПлатежа КАК Очередность,
	|	Документ.Идентификатор КАК ИдентификаторПлатежа,
	|	Документ.КодБК КАК КодБК,
	|	Документ.КодОКАТО КАК КодОКАТО,
	|	Документ.ПоказательДаты КАК ПоказательДаты,
	|	Документ.ПоказательНомера КАК ПоказательНомера,
	|	Документ.ПоказательОснования КАК ПоказательОснования,
	|	Документ.ПоказательПериода КАК ПоказательПериода,
	|	Документ.ПоказательТипа КАК ПоказательТипа,
	|	Документ.СтатусСоставителя КАК СтатусСоставителя,
	|	Документ.СуммаДокумента КАК СуммаДокумента,
	|	Документ.ТипПлатежногоДокумента КАК ТипПлатежногоДокумента,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.НомерСчета, """") КАК НомерСчетаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.НаименованиеБанка, """") КАК НаименованиеБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.БИК, """") КАК БИКБанкаПолучателя,
	|	Документ.СчетОрганизации.БанкДляРасчетов.Наименование КАК БанкДляРасчетов,
	|	Документ.СчетОрганизации.НомерСчета КАК НомерСчета,
	|	Документ.СчетОрганизации.Банк.Наименование КАК Банк,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.НомерСчета, """") КАК НомерСчетаПлательщика,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.НаименованиеБанка, """") КАК НаименованиеБанкаПлательщика,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.БИК, """") КАК БИКБанкаПлательщика
	|ИЗ
	|	Документ._ДемоПлатежныйДокумент КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|		ПО Документ.СчетКонтрагента = БанковскиеСчетаКонтрагентов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|		ПО Документ.СчетОрганизации = БанковскиеСчетаОрганизаций.Ссылка
	|ГДЕ
	|	Документ.Ссылка В(&МассивДокументов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер");
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
				
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		
		ТекстПлательщика = Выборка.ПлательщикНаименование;
		Если ЗначениеЗаполнено(Выборка.БанкДляРасчетов) Тогда
			ТекстПлательщика = ТекстПлательщика
			+ " р/с " + СокрЛП(Выборка.НомерСчета)
			+ " в " + Строка(Выборка.Банк)
			+ " " + Выборка.Город;
		КонецЕсли;				
		
		ОбластьМакета.Параметры.ТекстПлательщика = ТекстПлательщика;
		
		Если ПустаяСтрока(ТекстПлательщика) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У организации %1 не заполнено поле ""Сокращенное наименование""'"),
				Выборка.Организация);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Выборка.Организация.ПолучитьОбъект(),
				"НаименованиеСокращенное");
		КонецЕсли;
		
		ТекстПолучателя = Выборка.ПолучательНаименование;
		ОбластьМакета.Параметры.ТекстПолучателя = ТекстПолучателя;
		
		
		// Заполним ИНН и КПП.
		ОбластьМакета.Параметры.ИННПлательщика = "ИНН " + ?(ПустаяСтрока(Выборка.ИННПлательщика), "0", Выборка.ИННПлательщика);
		ОбластьМакета.Параметры.КПППлательщика = "КПП " + ?(ПустаяСтрока(Выборка.КПППлательщика), "0", Выборка.КПППлательщика);
		ОбластьМакета.Параметры.ИННПолучателя = "ИНН " + ?(ПустаяСтрока(Выборка.ИННПолучателя), "0", Выборка.ИННПолучателя);
		ОбластьМакета.Параметры.КПППолучателя = "КПП " + ?(ПустаяСтрока(Выборка.КПППолучателя), "0", Выборка.КПППолучателя);
		
		НомерДокументаДляПечати = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Выборка.Номер, "0");
		ОбластьМакета.Параметры.НаименованиеНомер = НСтр("ru='ПЛАТЕЖНОЕ ПОРУЧЕНИЕ №'") + " " + НомерДокументаДляПечати;
		ОбластьМакета.Параметры.СуммаЧислом = Формат(Выборка.СуммаДокумента, "ЧДЦ=2");
		
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		ОбластьМакета.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
			Выборка.СуммаДокумента, ВалютаРегламентированногоУчета);
		
		ОбластьМакета.Параметры.ДатаДокумента = Формат(Выборка.ДатаДокумента, "ДЛФ=D");
			
		ТабличныйДокумент.Вывести(ОбластьМакета);
			
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли