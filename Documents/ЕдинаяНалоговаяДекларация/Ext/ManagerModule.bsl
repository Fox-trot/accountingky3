﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой ЕНД
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьОсновнойФормы(МассивОбъектов, ОбъектыПечати)	
	
	Запрос = Новый Запрос;		
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ЕдинаяНалоговаяДекларация.Ссылка КАК Ссылка,
		|	ЕдинаяНалоговаяДекларация.Организация КАК Организация,
		|	ЕдинаяНалоговаяДекларация.НачалоПериода КАК НачалоПериода,
		|	ЕдинаяНалоговаяДекларация.КонецПериода КАК КонецПериода,
		|	ЕдинаяНалоговаяДекларация.СтрокиОтчета.(
		|		КодСтроки КАК КодСтроки,
		|		Сумма КАК Сумма
		|	) КАК СтрокиОтчета
		|ИЗ
		|	Документ.ЕдинаяНалоговаяДекларация КАК ЕдинаяНалоговаяДекларация
		|ГДЕ
		|	ЕдинаяНалоговаяДекларация.Ссылка В(&МассивОбъектов)
		|	И (ЕдинаяНалоговаяДекларация.СтрокиОтчета.КодСтроки = ""176""
		|			ИЛИ ЕдинаяНалоговаяДекларация.СтрокиОтчета.КодСтроки = ""263""
		|			ИЛИ ЕдинаяНалоговаяДекларация.СтрокиОтчета.КодСтроки = ""460"")";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ЕдинаяНалоговаяДекларация_ОсновнаяФорма";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЕдинаяНалоговаяДекларация.ПФ_MXL_ЕНД_ОсновнаяФорма_STI_101");

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура();

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Заполнение шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Организация", Шапка.Организация);
		СтруктураПараметров.Вставить("НачалоПериода", Шапка.НачалоПериода);
		СтруктураПараметров.Вставить("КонецПериода", Шапка.КонецПериода);
		
		ДополнитьДанныеПечати(СтруктураПараметров, ДанныеПечати);	
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Заполнение ячеек.
		ОбластьМакета = Макет.ПолучитьОбласть("Ячейки");
		
		ДанныеПечати.Вставить("Яч050", 0);
		ДанныеПечати.Вставить("Яч051", 0);
		ДанныеПечати.Вставить("Яч053", 0);
		
		ДанныеПечати.Вставить("Яч055", 0);
		ДанныеПечати.Вставить("Яч056", 0);
		ДанныеПечати.Вставить("Яч057", 0);
		ДанныеПечати.Вставить("Яч058", 0);
		ДанныеПечати.Вставить("Яч059", 0);
		ДанныеПечати.Вставить("Яч060", 0);
		ДанныеПечати.Вставить("Яч061", 0);
		ДанныеПечати.Вставить("Яч062", 0);
		ДанныеПечати.Вставить("Яч063", 0);
		ДанныеПечати.Вставить("Яч064", 0);
		ДанныеПечати.Вставить("Яч065", 0);
		
		ВыборкаСтрокиОтчета = Шапка.СтрокиОтчета.Выбрать();
		Пока ВыборкаСтрокиОтчета.Следующий() Цикл
			Если ВыборкаСтрокиОтчета.КодСтроки = "176" Тогда
				ДанныеПечати.Яч050 = ВыборкаСтрокиОтчета.Сумма;
			ИначеЕсли ВыборкаСтрокиОтчета.КодСтроки = "263" Тогда
				ДанныеПечати.Яч051 = ВыборкаСтрокиОтчета.Сумма;							
			ИначеЕсли ВыборкаСтрокиОтчета.КодСтроки = "460" Тогда
				ДанныеПечати.Яч053 = ВыборкаСтрокиОтчета.Сумма;
			КонецЕсли;				
		КонецЦикла;
		
		ДанныеПечати.Вставить("Яч052", ДанныеПечати.Яч050 - ДанныеПечати.Яч051);
		Если ДанныеПечати.Яч052 < 0 Тогда
			ДанныеПечати.Вставить("ЗнакЯч052", "-");
		КонецЕсли;
		
		ДанныеПечати.Вставить("Яч054", ДанныеПечати.Яч052 - ДанныеПечати.Яч053);
		Если ДанныеПечати.Яч054 <= 0 Тогда
			ДанныеПечати.Вставить("ЗнакЯч054", "-");
		Иначе
			
			ДанныеПечати.Яч057 = ДанныеПечати.Яч054 - ДанныеПечати.Яч055 - ДанныеПечати.Яч056;
			Если ДанныеПечати.Яч057 < 0 Тогда
				ДанныеПечати.Яч058 = ДанныеПечати.Яч057;	
			КонецЕсли;
			
			Если ДанныеПечати.Яч052 < 0 Тогда
				ДанныеПечати.Вставить("ЗнакЯч057", "-");
				ДанныеПечати.Яч057 = ДанныеПечати.Яч052;
			КонецЕсли;
			
			СтавкаНалогаНаПрибыль = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(Шапка.КонецПериода, Шапка.Организация).СтавкаНалогаНаПрибыль;
			ДанныеПечати.Яч059 = СтавкаНалогаНаПрибыль;
			
			ДанныеПечати.Яч060 = Окр(ДанныеПечати.Яч057 * ДанныеПечати.Яч059 / 100, 2);
			
			ДанныеПечати.Яч063 = ДанныеПечати.Яч060 - ДанныеПечати.Яч061 - ДанныеПечати.Яч062;
			Если ДанныеПечати.Яч063 < 0 Тогда
				ДанныеПечати.Вставить("ЗнакЯч063", "-");

				ДанныеПечати.Яч063 = -ДанныеПечати.Яч063;
				ДанныеПечати.Яч064 = ДанныеПечати.Яч063;
			Иначе
				ДанныеПечати.Яч065 = ДанныеПечати.Яч063;
			КонецЕсли;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;	
КонецФункции

// Функция формирует табличный документ с печатной формой Приложение1ПоНП
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПриложения1(МассивОбъектов, ОбъектыПечати)	
	
	Запрос = Новый Запрос;		
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ЕдинаяНалоговаяДекларация.Ссылка КАК Ссылка,
		|	ЕдинаяНалоговаяДекларация.Организация КАК Организация,
		|	ЕдинаяНалоговаяДекларация.НачалоПериода КАК НачалоПериода,
		|	ЕдинаяНалоговаяДекларация.КонецПериода КАК КонецПериода,
		|	ЕдинаяНалоговаяДекларация.СтрокиОтчета.(
		|		""Яч"" + КодСтроки КАК КодСтроки,
		|		Сумма КАК Сумма
		|	) КАК СтрокиОтчета
		|ИЗ
		|	Документ.ЕдинаяНалоговаяДекларация КАК ЕдинаяНалоговаяДекларация
		|ГДЕ
		|	ЕдинаяНалоговаяДекларация.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ЕдинаяНалоговаяДекларация_Приложение1";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЕдинаяНалоговаяДекларация.ПФ_MXL_ЕНД_Приложение1");

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура();

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Заполнение шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Организация", Шапка.Организация);
		СтруктураПараметров.Вставить("НачалоПериода", Шапка.НачалоПериода);
		СтруктураПараметров.Вставить("КонецПериода", Шапка.КонецПериода);
		
		ДополнитьДанныеПечати(СтруктураПараметров, ДанныеПечати);	
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Заполнение ячеек.
		ОбластьМакета = Макет.ПолучитьОбласть("Ячейки");
		
		ВыборкаСтрокиОтчета = Шапка.СтрокиОтчета.Выбрать();
		Пока ВыборкаСтрокиОтчета.Следующий() Цикл
			ДанныеПечати.Вставить(ВыборкаСтрокиОтчета.КодСтроки, ВыборкаСтрокиОтчета.Сумма);			
		КонецЦикла;
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой Приложение2ПоНП
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПриложения2(МассивОбъектов, ОбъектыПечати)	
	
	Запрос = Новый Запрос;		
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ЕдинаяНалоговаяДекларация.Ссылка КАК Ссылка,
		|	ЕдинаяНалоговаяДекларация.Организация КАК Организация,
		|	ЕдинаяНалоговаяДекларация.НачалоПериода КАК НачалоПериода,
		|	ЕдинаяНалоговаяДекларация.КонецПериода КАК КонецПериода,
		|	ЕдинаяНалоговаяДекларация.СтрокиОтчета.(
		|		""Яч"" + КодСтроки КАК КодСтроки,
		|		Сумма КАК Сумма
		|	) КАК СтрокиОтчета
		|ИЗ
		|	Документ.ЕдинаяНалоговаяДекларация КАК ЕдинаяНалоговаяДекларация
		|ГДЕ
		|	ЕдинаяНалоговаяДекларация.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ЕдинаяНалоговаяДекларация_Приложение2";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЕдинаяНалоговаяДекларация.ПФ_MXL_ЕНД_Приложение2");

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура();

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Заполнение шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Организация", Шапка.Организация);
		СтруктураПараметров.Вставить("НачалоПериода", Шапка.НачалоПериода);
		СтруктураПараметров.Вставить("КонецПериода", Шапка.КонецПериода);
		
		ДополнитьДанныеПечати(СтруктураПараметров, ДанныеПечати);	
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Заполнение ячеек.
		ОбластьМакета = Макет.ПолучитьОбласть("Ячейки");
		
		ВыборкаСтрокиОтчета = Шапка.СтрокиОтчета.Выбрать();
		Пока ВыборкаСтрокиОтчета.Следующий() Цикл
			ДанныеПечати.Вставить(ВыборкаСтрокиОтчета.КодСтроки, ВыборкаСтрокиОтчета.Сумма);			
		КонецЦикла;
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОсновнаяФормаОтчета") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ОсновнаяФормаОтчета", 
		НСтр("ru = 'Основная форма'"), 
		ПечатьОсновнойФормы(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ЕдинаяНалоговаяДекларация.ПФ_MXL_ЕНД_ОсновнаяФорма_STI_101");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Приложение1") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"Приложение1", 
		НСтр("ru = 'Приложение 1'"), 
		ПечатьПриложения1(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ЕдинаяНалоговаяДекларация.ПФ_MXL_ЕНД_Приложение1");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Приложение2") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"Приложение2", 
		НСтр("ru = 'Приложение 2'"), 
		ПечатьПриложения2(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ЕдинаяНалоговаяДекларация.ПФ_MXL_ЕНД_Приложение2");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОсновнаяФормаОтчета";
	КомандаПечати.Представление = НСтр("ru = 'Основная форма'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Приложение1";
	КомандаПечати.Представление = НСтр("ru = 'Приложение 1 (Совокупный годовой доход)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Приложение2";
	КомандаПечати.Представление = НСтр("ru = 'Приложение 2 (Расходы, подлежащие вычету)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 3;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Дополнить данные печати
//
// Параметры:
//  ДанныеПечати	 - Структура - 
//
Процедура ДополнитьДанныеПечати(СтруктураПараметров, ДанныеПечати)

	КонтактныеДанные = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСведенияОбОрганизации(СтруктураПараметров.Организация, СтруктураПараметров.КонецПериода);

	ДанныеПечати.Вставить("ОрганизацияНаменованиеПолное", КонтактныеДанные.НаименованиеПолное);
	ДанныеПечати.Вставить("Налоговая", КонтактныеДанные.ГНСНаименование);
	ДанныеПечати.Вставить("АдресГород", КонтактныеДанные.Город);
	ДанныеПечати.Вставить("АдресУлица", КонтактныеДанные.Улица);
	ДанныеПечати.Вставить("Телефон", КонтактныеДанные.Тел);
	
	ОКПО = КонтактныеДанные.ОКПО;
	ДанныеПечати.Вставить("ОКПО1", Сред(ОКПО,1,1));
	ДанныеПечати.Вставить("ОКПО2", Сред(ОКПО,2,1));
	ДанныеПечати.Вставить("ОКПО3", Сред(ОКПО,3,1));
	ДанныеПечати.Вставить("ОКПО4", Сред(ОКПО,4,1));
	ДанныеПечати.Вставить("ОКПО5", Сред(ОКПО,5,1));
	ДанныеПечати.Вставить("ОКПО6", Сред(ОКПО,6,1));
	ДанныеПечати.Вставить("ОКПО7", Сред(ОКПО,7,1));
	ДанныеПечати.Вставить("ОКПО8", Сред(ОКПО,8,1));

	ИНН = КонтактныеДанные.ИНН;
	ДанныеПечати.Вставить("ИНН1", Сред(ИНН, 1, 1));
	ДанныеПечати.Вставить("ИНН2", Сред(ИНН, 2, 1));
	ДанныеПечати.Вставить("ИНН3", Сред(ИНН, 3, 1));                           
	ДанныеПечати.Вставить("ИНН4", Сред(ИНН, 4, 1));
	ДанныеПечати.Вставить("ИНН5", Сред(ИНН, 5, 1));
	ДанныеПечати.Вставить("ИНН6", Сред(ИНН, 6, 1));
	ДанныеПечати.Вставить("ИНН7", Сред(ИНН, 7, 1));
	ДанныеПечати.Вставить("ИНН8", Сред(ИНН, 8, 1));
	ДанныеПечати.Вставить("ИНН9", Сред(ИНН, 9, 1));
	ДанныеПечати.Вставить("ИНН10", Сред(ИНН, 10, 1));
	ДанныеПечати.Вставить("ИНН11", Сред(ИНН, 11, 1));
	ДанныеПечати.Вставить("ИНН12", Сред(ИНН, 12, 1));
	ДанныеПечати.Вставить("ИНН13", Сред(ИНН, 13, 1));
	ДанныеПечати.Вставить("ИНН14", Сред(ИНН, 14, 1));         
	
	КодГНС = КонтактныеДанные.ГНСКод;
	ДанныеПечати.Вставить("ГНС1", Сред(КодГНС, 1, 1));
	ДанныеПечати.Вставить("ГНС2", Сред(КодГНС, 2, 1));
	ДанныеПечати.Вставить("ГНС3", Сред(КодГНС, 3, 1));
	
	НачалоПериода = СтруктураПараметров.НачалоПериода;
	ДанныеПечати.Вставить("ДатаН1", Сред(НачалоПериода, 1, 1));	
	ДанныеПечати.Вставить("ДатаН2", Сред(НачалоПериода, 2, 1));	
	ДанныеПечати.Вставить("ДатаН3", Сред(НачалоПериода, 4, 1));	
	ДанныеПечати.Вставить("ДатаН4", Сред(НачалоПериода, 5, 1));	
	ДанныеПечати.Вставить("ДатаН5", Сред(НачалоПериода, 7, 1));	
	ДанныеПечати.Вставить("ДатаН6", Сред(НачалоПериода, 8, 1));	
	ДанныеПечати.Вставить("ДатаН7", Сред(НачалоПериода, 9, 1));	
	ДанныеПечати.Вставить("ДатаН8", Сред(НачалоПериода, 10, 1));	
	
	КонецПериода = СтруктураПараметров.КонецПериода;		
	ДанныеПечати.Вставить("ДатаК1", Сред(КонецПериода, 1, 1));	
	ДанныеПечати.Вставить("ДатаК2", Сред(КонецПериода, 2, 1));	
	ДанныеПечати.Вставить("ДатаК3", Сред(КонецПериода, 4, 1));	
	ДанныеПечати.Вставить("ДатаК4", Сред(КонецПериода, 5, 1));	
	ДанныеПечати.Вставить("ДатаК5", Сред(КонецПериода, 7, 1));	
	ДанныеПечати.Вставить("ДатаК6", Сред(КонецПериода, 8, 1));	
	ДанныеПечати.Вставить("ДатаК7", Сред(КонецПериода, 9, 1));	
	ДанныеПечати.Вставить("ДатаК8", Сред(КонецПериода, 10, 1));
	
	Индекс = КонтактныеДанные.Индекс;
	ДанныеПечати.Вставить("ИНД1", Сред(Индекс, 1, 1));	
	ДанныеПечати.Вставить("ИНД2", Сред(Индекс, 2, 1));	
	ДанныеПечати.Вставить("ИНД3", Сред(Индекс, 4, 1));	
	ДанныеПечати.Вставить("ИНД4", Сред(Индекс, 5, 1));	
	ДанныеПечати.Вставить("ИНД5", Сред(Индекс, 7, 1));	
	ДанныеПечати.Вставить("ИНД6", Сред(Индекс, 8, 1));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли