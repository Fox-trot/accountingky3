﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура - Заполнить шапку отчета
//
// Параметры:
//  НачалоПериода	 - 	 - 
//  КонецПериода	 - 	 - 
//  Организация		 - 	 - 
//  ОбластьШапка	 - 	 - 
//
Процедура ЗаполнитьШапкуОтчета(СтруктураПараметров, ОбластьШапка)
	
	Организация 	= СтруктураПараметров.Организация;
	НачалоПериода 	= СтруктураПараметров.НачалоПериода;
	КонецПериода 	= СтруктураПараметров.КонецПериода;	
	
	ОКПО              				= Организация.КодПоОКПО;
	ИНН 							= Организация.ИНН;
	КодГНС 							= СтруктураПараметров.ГНСКод;
	ОрганизацияНаменованиеПолное    = Организация.НаименованиеПолное
										+ ?(ЗначениеЗаполнено(Организация.НаименованиеПолное), Символы.ПС + " (", "")
										+ Организация.НаименованиеПолное
										+ ?(ЗначениеЗаполнено(Организация.НаименованиеПолное), ")", "");	
	
	КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Организация);
	
	Индекс           = КонтактныеДанные.Индекс;
	АдрОбластьГород  = КонтактныеДанные.АдрОбластьГород;
	ЮрАдрес	         = КонтактныеДанные.АдресОрганизации; 
	Телефон		     = КонтактныеДанные.Телефон;	
			
	ОбластьШапка.Параметры.ОрганизацияНаименованиеПолное = ОрганизацияНаменованиеПолное;
	Если ЗначениеЗаполнено(АдрОбластьГород) Тогда 
		ОбластьШапка.Параметры.АдресГород = АдрОбластьГород;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЮрАдрес) Тогда 
		ОбластьШапка.Параметры.АдресУлица = ЮрАдрес;
	КонецЕсли;
	
	ОбластьШапка.Параметры.Телефон = Телефон;
	
	Если ЗначениеЗаполнено(Индекс) ТОгда
		
		ОбластьШапка.Параметры.Индекс1 = Сред(Индекс,1,1);
		ОбластьШапка.Параметры.Индекс2 = Сред(Индекс,2,1);
		ОбластьШапка.Параметры.Индекс3 = Сред(Индекс,3,1);
		ОбластьШапка.Параметры.Индекс4 = Сред(Индекс,4,1);
		ОбластьШапка.Параметры.Индекс5 = Сред(Индекс,5,1);
		ОбластьШапка.Параметры.Индекс6 = Сред(Индекс,6,1);
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ОКПО) Тогда 
		ОбластьШапка.Параметры.ОКПО1 = Сред(ОКПО,1,1);
		ОбластьШапка.Параметры.ОКПО2 = Сред(ОКПО,2,1);
		ОбластьШапка.Параметры.ОКПО3 = Сред(ОКПО,3,1);
		ОбластьШапка.Параметры.ОКПО4 = Сред(ОКПО,4,1);
		ОбластьШапка.Параметры.ОКПО5 = Сред(ОКПО,5,1);
		ОбластьШапка.Параметры.ОКПО6 = Сред(ОКПО,6,1);
		ОбластьШапка.Параметры.ОКПО7 = Сред(ОКПО,7,1);
		ОбластьШапка.Параметры.ОКПО8 = Сред(ОКПО,8,1);
	КонецЕсли;
	
	ОбластьШапка.Параметры.ИНН1 = Сред(ИНН, 1, 1);
	ОбластьШапка.Параметры.ИНН2 = Сред(ИНН, 2, 1);
	ОбластьШапка.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
	ОбластьШапка.Параметры.ИНН4 = Сред(ИНН, 4, 1);
	ОбластьШапка.Параметры.ИНН5 = Сред(ИНН, 5, 1);
	ОбластьШапка.Параметры.ИНН6 = Сред(ИНН, 6, 1);
	ОбластьШапка.Параметры.ИНН7 = Сред(ИНН, 7, 1);
	ОбластьШапка.Параметры.ИНН8 = Сред(ИНН, 8, 1);
	ОбластьШапка.Параметры.ИНН9 = Сред(ИНН, 9, 1);
	ОбластьШапка.Параметры.ИНН10 = Сред(ИНН, 10, 1);
	ОбластьШапка.Параметры.ИНН11 = Сред(ИНН, 11, 1);
	ОбластьШапка.Параметры.ИНН12 = Сред(ИНН, 12, 1);
	ОбластьШапка.Параметры.ИНН13 = Сред(ИНН, 13, 1);
	ОбластьШапка.Параметры.ИНН14 = Сред(ИНН, 14, 1);
	
	ОбластьШапка.Параметры.Налоговая = СтруктураПараметров.ГНСНаименование;
	
	ОбластьШапка.Параметры.Код1 = Сред(КодГНС, 1, 1);
	ОбластьШапка.Параметры.Код2 = Сред(КодГНС, 2, 1);
	ОбластьШапка.Параметры.Код3 = Сред(КодГНС, 3, 1);
	
	ОбластьШапка.Параметры.ДатаН1 = Сред(НачалоПериода, 1, 1);	
	ОбластьШапка.Параметры.ДатаН2 = Сред(НачалоПериода, 2, 1);	
	ОбластьШапка.Параметры.ДатаН3 = Сред(НачалоПериода, 4, 1);	
	ОбластьШапка.Параметры.ДатаН4 = Сред(НачалоПериода, 5, 1);	
	ОбластьШапка.Параметры.ДатаН5 = Сред(НачалоПериода, 7, 1);	
	ОбластьШапка.Параметры.ДатаН6 = Сред(НачалоПериода, 8, 1);	
	ОбластьШапка.Параметры.ДатаН7 = Сред(НачалоПериода, 9, 1);	
	ОбластьШапка.Параметры.ДатаН8 = Сред(НачалоПериода, 10, 1);	
	
	ОбластьШапка.Параметры.ДатаК1 = Сред(КонецПериода, 1, 1);	
	ОбластьШапка.Параметры.ДатаК2 = Сред(КонецПериода, 2, 1);	
	ОбластьШапка.Параметры.ДатаК3 = Сред(КонецПериода, 4, 1);	
	ОбластьШапка.Параметры.ДатаК4 = Сред(КонецПериода, 5, 1);	
	ОбластьШапка.Параметры.ДатаК5 = Сред(КонецПериода, 7, 1);	
	ОбластьШапка.Параметры.ДатаК6 = Сред(КонецПериода, 8, 1);	
	ОбластьШапка.Параметры.ДатаК7 = Сред(КонецПериода, 9, 1);	
	ОбластьШапка.Параметры.ДатаК8 = Сред(КонецПериода, 10, 1);

КонецПроцедуры

// Процедура - Заполнить шапку отчета
//
// Параметры:
//  НачалоПериода	 - 	 - 
//  КонецПериода	 - 	 - 
//  Организация		 - 	 - 
//  ОбластьШапка	 - 	 - 
//
Процедура ЗаполнитьШапкуПриложенияОтчета(СтруктураПараметров, ОбластьШапка)
	
	Организация 	= СтруктураПараметров.Организация;
	Дата		 	= СтруктураПараметров.Дата;
	
	ОКПО              				= Организация.КодПоОКПО;
	ИНН 							= Организация.ИНН;
	КодГНС 							= СтруктураПараметров.ГНСКод;
	ОрганизацияНаменованиеПолное    = Организация.НаименованиеПолное
										+ ?(ЗначениеЗаполнено(Организация.НаименованиеПолное), Символы.ПС + " (", "")
										+ Организация.НаименованиеПолное
										+ ?(ЗначениеЗаполнено(Организация.НаименованиеПолное), ")", "");	
										
	ОбластьШапка.Параметры.ОрганизацияНаименованиеПолное = ОрганизацияНаменованиеПолное;

	Если ЗначениеЗаполнено(ОКПО) Тогда 
		ОбластьШапка.Параметры.ОКПО1 = Сред(ОКПО,1,1);
		ОбластьШапка.Параметры.ОКПО2 = Сред(ОКПО,2,1);
		ОбластьШапка.Параметры.ОКПО3 = Сред(ОКПО,3,1);
		ОбластьШапка.Параметры.ОКПО4 = Сред(ОКПО,4,1);
		ОбластьШапка.Параметры.ОКПО5 = Сред(ОКПО,5,1);
		ОбластьШапка.Параметры.ОКПО6 = Сред(ОКПО,6,1);
		ОбластьШапка.Параметры.ОКПО7 = Сред(ОКПО,7,1);
		ОбластьШапка.Параметры.ОКПО8 = Сред(ОКПО,8,1);
	КонецЕсли;
	
	ОбластьШапка.Параметры.ИНН1 = Сред(ИНН, 1, 1);
	ОбластьШапка.Параметры.ИНН2 = Сред(ИНН, 2, 1);
	ОбластьШапка.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
	ОбластьШапка.Параметры.ИНН4 = Сред(ИНН, 4, 1);
	ОбластьШапка.Параметры.ИНН5 = Сред(ИНН, 5, 1);
	ОбластьШапка.Параметры.ИНН6 = Сред(ИНН, 6, 1);
	ОбластьШапка.Параметры.ИНН7 = Сред(ИНН, 7, 1);
	ОбластьШапка.Параметры.ИНН8 = Сред(ИНН, 8, 1);
	ОбластьШапка.Параметры.ИНН9 = Сред(ИНН, 9, 1);
	ОбластьШапка.Параметры.ИНН10 = Сред(ИНН, 10, 1);
	ОбластьШапка.Параметры.ИНН11 = Сред(ИНН, 11, 1);
	ОбластьШапка.Параметры.ИНН12 = Сред(ИНН, 12, 1);
	ОбластьШапка.Параметры.ИНН13 = Сред(ИНН, 13, 1);
	ОбластьШапка.Параметры.ИНН14 = Сред(ИНН, 14, 1);
	
	ОбластьШапка.Параметры.Налоговая = СтруктураПараметров.ГНСНаименование;
	
	ОбластьШапка.Параметры.Код1 = Сред(КодГНС, 1, 1);
	ОбластьШапка.Параметры.Код2 = Сред(КодГНС, 2, 1);
	ОбластьШапка.Параметры.Код3 = Сред(КодГНС, 3, 1);
	

КонецПроцедуры

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Органинизации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);

	Индекс = СведенияОбОрганизации.Индекс; 
	
	ГородНасПункт   = ?(СведенияОбОрганизации.Город  = "",СведенияОбОрганизации.НаселенныйПункт,СведенияОбОрганизации.Город);
	АдрОбластьГород = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
		+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон = СведенияОбОрганизации.Тел;
	
	Структура = Новый Структура("Индекс,АдрОбластьГород,АдресОрганизации,Телефон", Индекс,АдрОбластьГород,АдресОрганизации,Телефон);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

#КонецОбласти

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

// Функция формирует табличный документ с печатной формой НСП
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьОтчетаПоНСП(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	  "ВЫБРАТЬ
	  |	ОтчетПоНСП.Ссылка,
	  |	ОтчетПоНСП.Организация,
	  |	ОтчетПоНСП.ВидСубъекта,
	  |	ОтчетПоНСП.Дата,
	  |	ОтчетПоНСП.Номер,
	  |	ОтчетПоНСП.Организация.ГНС.Наименование КАК ГНСНаименование,
	  |	ОтчетПоНСП.Организация.ГНС.Код КАК ГНСКод,
	  |	ОтчетПоНСП.ОтчетОсновной.(
	  |		Строка,
	  |		Выручка,
	  |		СуммаНСП,
	  |		Ставка
	  |	)
	  |ИЗ
	  |	Документ.ОтчетПоНСП КАК ОтчетПоНСП
	  |ГДЕ
	  |	ОтчетПоНСП.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетПоНСП_ОтчетПоНСП";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетПоНСП.ПФ_MXL_ОтчетПоНСП");
	ОбластьШапка	= Макет.ПолучитьОбласть("Шапка");
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Пока ВыборкаШапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если ВыборкаШапка.ВидСубъекта = 1 Тогда
			НачалоПериода 	= НачалоКвартала(ВыборкаШапка.Дата);
			КонецПериода 	= КонецКвартала(ВыборкаШапка.Дата);
		Иначе 
			НачалоПериода 	= НачалоМесяца(ВыборкаШапка.Дата);
			КонецПериода 	= КонецМесяца(ВыборкаШапка.Дата);
		КонецЕсли; 

		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("НачалоПериода", 	НачалоПериода);
		СтруктураПараметров.Вставить("КонецПериода", 	КонецПериода);
		СтруктураПараметров.Вставить("Организация", 	ВыборкаШапка.Организация);
		СтруктураПараметров.Вставить("ГНСКод", 			ВыборкаШапка.ГНСКод);
		СтруктураПараметров.Вставить("ГНСНаименование", ВыборкаШапка.ГНСНаименование);		
				
		//1. Заполнение шапки
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ЗаполнитьШапкуОтчета(СтруктураПараметров, ОбластьШапка);
		
		Если ВыборкаШапка.ВидСубъекта = 0 Тогда 
			НомерSTI = "129";
			НомерПриложения = "1";
			Заголовок = НСтр("ru = 'ОТЧЕТ ПО НАЛОГУ С ПРОДАЖ
			|СУБЪЕКТА МАЛОГО ПРЕДПРИНИМАТЕЛЬСТВА'");
		ИначеЕсли ВыборкаШапка.ВидСубъекта = 1 Тогда 
			НомерSTI = "130";
			НомерПриложения = "2";
			Заголовок = НСтр("ru = 'ОТЧЕТ ПО НАЛОГУ С ПРОДАЖ
			|СУБЪЕКТА СРЕДНЕГО ПРЕДПРИНИМАТЕЛЬСТВА'");
		ИначеЕсли ВыборкаШапка.ВидСубъекта = 2 Тогда 
			НомерSTI = "131";
			НомерПриложения = "3";
			Заголовок = НСтр("ru = 'ОТЧЕТ ПО НАЛОГУ С ПРОДАЖ СУБЪЕКТА
			|(ЗА ИСКЛЮЧЕНИЕМ СУБЪЕКА МАЛОГО И СРЕДНЕГО ПРЕДПРИНИМАТЕЛЬСТВА)'");
		КонецЕсли;	
		
		ОбластьШапка.Параметры.НомерSTI = НомерSTI;
		ОбластьШапка.Параметры.НомерПриложения = НомерПриложения;
		ОбластьШапка.Параметры.Заголовок = Заголовок;
			
		КонтактныеДанные = ПолучитьКонтактнуюИнформацию(ВыборкаШапка.Организация);
		ОбластьШапка.Параметры.АдресГород = КонтактныеДанные.АдрОбластьГород;
		
		Выборка = ВыборкаШапка.ОтчетОсновной.Выбрать();
		
		НСПИтогРазделА = 0;
		НСПИтогРазделБ = 0;
		НСПИтогРазделВ = 0;
		Пока Выборка.Следующий() Цикл 
			// Раздел А
			Если Выборка.Строка = "050" Или Выборка.Строка = "053"
				Или Выборка.Строка = "056" Или Выборка.Строка = "059" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделА = НСПИтогРазделА + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел Б
			Если Выборка.Строка = "063" Или Выборка.Строка = "066"
				Или Выборка.Строка = "069" Или Выборка.Строка = "072" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделБ = НСПИтогРазделБ + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел В
			Если Выборка.Строка = "076" Или Выборка.Строка = "079" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделВ = НСПИтогРазделВ + Выборка.СуммаНСП;
			КонецЕсли;				
		КонецЦикла;
		
		ОбластьШапка.Параметры.НСПИтогРазделА = НСПИтогРазделА;
		ОбластьШапка.Параметры.НСПИтогРазделБ = НСПИтогРазделБ;
		ОбластьШапка.Параметры.НСПИтогРазделВ = НСПИтогРазделВ;
		ОбластьШапка.Параметры.НСПИтог = НСПИтогРазделА + НСПИтогРазделБ + НСПИтогРазделВ;
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой ПриложениеПоНСП
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПриложенияКОтчетуПоНСП(МассивОбъектов, ОбъектыПечати)
		
	Запрос = Новый Запрос;
	Запрос.Текст =	
	"ВЫБРАТЬ
	|	ОтчетПоНСП.Ссылка КАК Ссылка,
	|	ОтчетПоНСП.Дата,
	|	ОтчетПоНСП.Организация КАК Организация,
	|	ОтчетПоНСП.Организация.ГНС.Наименование КАК ГНСНаименование,
	|	ОтчетПоНСП.Организация.ГНС.Код КАК ГНСКод,
	|	ОтчетПоНСП.ПриложениеПервыйМесяцКвартала.(
	|		Строка КАК Строка,
	|		Содержание КАК Содержание,
	|		Выручка КАК Выручка,
	|		СуммаНСП КАК СуммаНСП,
	|		Ставка КАК Ставка
	|	),
	|	ОтчетПоНСП.ПриложениеВторойМесяцКвартала.(
	|		Строка КАК Строка,
	|		Содержание КАК Содержание,
	|		Выручка КАК Выручка,
	|		СуммаНСП КАК СуммаНСП,
	|		Ставка КАК Ставка
	|	),
	|	ОтчетПоНСП.ПриложениеТретийМесяцКвартала.(
	|		Строка КАК Строка,
	|		Содержание КАК Содержание,
	|		Выручка КАК Выручка,
	|		СуммаНСП КАК СуммаНСП,
	|		Ставка КАК Ставка
	|	)
	|ИЗ
	|	Документ.ОтчетПоНСП КАК ОтчетПоНСП
	|ГДЕ
	|	ОтчетПоНСП.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетПоНСП_ПриложениеКОтчетуПоНСП";      
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетПоНСП.ПФ_MXL_ПриложениеКОтчетуПоНСП");
	ОбластьШапка	= Макет.ПолучитьОбласть("Шапка");
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Пока ВыборкаШапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Дата", 			ВыборкаШапка.Дата);
		СтруктураПараметров.Вставить("Организация", 	ВыборкаШапка.Организация);
		СтруктураПараметров.Вставить("ГНСКод", 			ВыборкаШапка.ГНСКод);
		СтруктураПараметров.Вставить("ГНСНаименование", ВыборкаШапка.ГНСНаименование);		
				

		//1. Заполнение шапки
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ЗаполнитьШапкуПриложенияОтчета(СтруктураПараметров, ОбластьШапка);
				
		ОбластьШапка.Параметры.Дата1 = "" + Формат(НачалоКвартала(ВыборкаШапка.Дата),"ДФ='MMMM yyyy'")+ " " + "года"; 
		ОбластьШапка.Параметры.Дата2 = "" + Формат(	ДобавитьМесяц(НачалоКвартала(ВыборкаШапка.Дата),+1),"ДФ='MMMM yyyy'") + " " + "года"; 
		ОбластьШапка.Параметры.Дата3 = "" + Формат(КонецКвартала(ВыборкаШапка.Дата),"ДФ='MMMM yyyy'") + " " + "года"; 
		
		// 1й месяц квартала
		Выборка = ВыборкаШапка.ПриложениеПервыйМесяцКвартала.Выбрать();
				
		НСПИтогРазделА = 0;
		НСПИтогРазделБ = 0;
		НСПИтогРазделВ = 0;
		
		Пока Выборка.Следующий() Цикл 
			// Раздел А
			Если Выборка.Строка = "150" Или Выборка.Строка = "153"
				Или Выборка.Строка = "156" Или Выборка.Строка = "159" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделА = НСПИтогРазделА + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел Б
			Если Выборка.Строка = "163" Или Выборка.Строка = "166"
				Или Выборка.Строка = "169" Или Выборка.Строка = "172" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделБ = НСПИтогРазделБ + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел В
			Если Выборка.Строка = "176" Или Выборка.Строка = "179" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделВ = НСПИтогРазделВ + Выборка.СуммаНСП;
			КонецЕсли;				
		КонецЦикла;
		
		ОбластьШапка.Параметры.НСПИтогРазделА_1 = НСПИтогРазделА;
		ОбластьШапка.Параметры.НСПИтогРазделБ_1 = НСПИтогРазделБ;
		ОбластьШапка.Параметры.НСПИтогРазделВ_1 = НСПИтогРазделВ;
		ОбластьШапка.Параметры.НСПИтог1 = НСПИтогРазделА + НСПИтогРазделБ + НСПИтогРазделВ;
		
		
		// 2й месяц квартала
		Выборка = ВыборкаШапка.ПриложениеВторойМесяцКвартала.Выбрать();
				
		НСПИтогРазделА = 0;
		НСПИтогРазделБ = 0;
		НСПИтогРазделВ = 0;
		
		Пока Выборка.Следующий() Цикл 
			// Раздел А
			Если Выборка.Строка = "200" Или Выборка.Строка = "203"
				Или Выборка.Строка = "206" Или Выборка.Строка = "209" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделА = НСПИтогРазделА + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел Б
			Если Выборка.Строка = "213" Или Выборка.Строка = "216"
				Или Выборка.Строка = "219" Или Выборка.Строка = "222" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделБ = НСПИтогРазделБ + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел В
			Если Выборка.Строка = "226" Или Выборка.Строка = "229" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделВ = НСПИтогРазделВ + Выборка.СуммаНСП;
			КонецЕсли;				
		КонецЦикла;
		
		ОбластьШапка.Параметры.НСПИтогРазделА_2 = НСПИтогРазделА;
		ОбластьШапка.Параметры.НСПИтогРазделБ_2 = НСПИтогРазделБ;
		ОбластьШапка.Параметры.НСПИтогРазделВ_2 = НСПИтогРазделВ;
		ОбластьШапка.Параметры.НСПИтог2 = НСПИтогРазделА + НСПИтогРазделБ + НСПИтогРазделВ;

		// 3й месяц квартала
		Выборка = ВыборкаШапка.ПриложениеТретийМесяцКвартала.Выбрать();
				
		НСПИтогРазделА = 0;
		НСПИтогРазделБ = 0;
		НСПИтогРазделВ = 0;
		
		Пока Выборка.Следующий() Цикл 
			// Раздел А
			Если Выборка.Строка = "250" Или Выборка.Строка = "253"
				Или Выборка.Строка = "256" Или Выборка.Строка = "259" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделА = НСПИтогРазделА + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел Б
			Если Выборка.Строка = "263" Или Выборка.Строка = "266"
				Или Выборка.Строка = "269" Или Выборка.Строка = "272" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделБ = НСПИтогРазделБ + Выборка.СуммаНСП;
			КонецЕсли;
			
			// Раздел В
			Если Выборка.Строка = "276" Или Выборка.Строка = "279" Тогда
				ОбластьШапка.Параметры["Сумма_"+ Выборка.Строка] 	= Выборка.Выручка;
				ОбластьШапка.Параметры["Ставка_"+ Выборка.Строка] 	= Выборка.Ставка;
				ОбластьШапка.Параметры["НСП_"+ Выборка.Строка] 		= Выборка.СуммаНСП;
				НСПИтогРазделВ = НСПИтогРазделВ + Выборка.СуммаНСП;
			КонецЕсли;				
		КонецЦикла;
		
		ОбластьШапка.Параметры.НСПИтогРазделА_3 = НСПИтогРазделА;
		ОбластьШапка.Параметры.НСПИтогРазделБ_3 = НСПИтогРазделБ;
		ОбластьШапка.Параметры.НСПИтогРазделВ_3 = НСПИтогРазделВ;
		ОбластьШапка.Параметры.НСПИтог3 = НСПИтогРазделА + НСПИтогРазделБ + НСПИтогРазделВ;
		
		ТабличныйДокумент.Вывести(ОбластьШапка);

		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапка.Ссылка);
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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОтчетПоНСП") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ОтчетПоНСП", 
		НСтр("ru = 'Отчет по НСП'"), 
		ПечатьОтчетаПоНСП(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ОтчетПоНСП.ПФ_MXL_ОтчетПоНСП");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриложениеКОтчетуПоНСП") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПриложениеКОтчетуПоНСП", 
		НСтр("ru = 'Приложение к отчету по НСП'"), 
		ПечатьПриложенияКОтчетуПоНСП(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ОтчетПоНСП.ПФ_MXL_ПриложениеКОтчетуПоНСП");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОтчетПоНСП";
	КомандаПечати.Представление = НСтр("ru = 'Отчет по НСП'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриложениеКОтчетуПоНСП";
	КомандаПечати.Представление = НСтр("ru = 'Приложение к отчету по НСП'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли