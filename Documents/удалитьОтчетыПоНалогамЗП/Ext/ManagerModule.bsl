﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

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
	
	ГородНасПункт = СведенияОбОрганизации.Город;
	АдрОбластьГород = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
	+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон = СведенияОбОрганизации.Тел;
	
	ЭлПочта = СведенияОбОрганизации.Email;
	
	Структура = Новый Структура("Индекс,АдрОбластьГород,АдресОрганизации,Телефон,ЭлПочта", Индекс,АдрОбластьГород,АдресОрганизации,Телефон,ЭлПочта);
	
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

// Функция формирует табличный документ с печатной формой ПН
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПоПН(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	удалитьОтчетыПоНалогамЗП.Ссылка КАК Ссылка,
		|	удалитьОтчетыПоНалогамЗП.Дата КАК Дата,
		|	удалитьОтчетыПоНалогамЗП.Организация КАК Организация,
		|	удалитьОтчетыПоНалогамЗП.ВидСубъекта КАК ВидСубъекта,
		|	удалитьОтчетыПоНалогамЗП.ПодоходныйНалог.(
		|		Количество КАК Количество,
		|		СуммаНачислено КАК Начислено,
		|		СуммаНеоблагаемая КАК Необлагаемая,
		|		Вычеты КАК Вычеты,
		|		удалитьОтчетыПоНалогамЗП.ПодоходныйНалог.СуммаНачислено - удалитьОтчетыПоНалогамЗП.ПодоходныйНалог.СуммаНеоблагаемая - удалитьОтчетыПоНалогамЗП.ПодоходныйНалог.Вычеты КАК Облагаемая,
		|		СуммаПНсСотрудника КАК ПодоходныйСотрудника,
		|		СуммаПНсМРД КАК СМРД,
		|		СальдоК КАК ПодоходныйКОплате,
		|		СуммаПН КАК ВсегоПодоходный,
		|		ВЫБОР
		|			КОГДА удалитьОтчетыПоНалогамЗП.НеЗаполнятьВыплатыПоЗП
		|				ТОГДА 0
		|			ИНАЧЕ удалитьОтчетыПоНалогамЗП.ПодоходныйНалог.СуммаВыплачен
		|		КОНЕЦ КАК Выплачено,
		|		НомерСтрокиОтчета КАК НомерСтрокиОтчета
		|	) КАК ПодоходныйНалог
		|ИЗ
		|	Документ.удалитьОтчетыПоНалогамЗП КАК удалитьОтчетыПоНалогамЗП
		|ГДЕ
		|	удалитьОтчетыПоНалогамЗП.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);		
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	
	Пока Шапка.Следующий() Цикл             	
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Дата = Шапка.Дата;
		ВидСубъекта = Шапка.ВидСубъекта;
		Организация = Шапка.Организация;
		
		НачалоПериода = НачалоКвартала(Дата);
		КонецПериода  = КонецКвартала(Дата);

		Если ВидСубъекта = 0 Тогда 
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ПодоходныйНалогМалогоПредпринимательства");
			ТабличныйДокумент.КлючПараметровПечати = "ОтчетыПоНалогамЗП_ПодоходныйНалогМалогоПредпринимательства";
		ИначеЕсли ВидСубъекта = 1 Тогда	
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ПодоходныйНалогСреднегоПредпринимательства");
			ТабличныйДокумент.КлючПараметровПечати = "ОтчетыПоНалогамЗП_ПодоходныйНалогСреднегоПредпринимательства";	
		ИначеЕсли ВидСубъекта = 2 Тогда
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ПодоходныйНалогКрупногоПредпринимательства");
			НачалоПериода = НачалоМесяца(Дата);
			КонецПериода  = КонецМесяца(Дата);
			ТабличныйДокумент.КлючПараметровПечати = "ОтчетыПоНалогамЗП_ПодоходныйНалогКрупногоПредпринимательства";
		КонецЕсли;	 
		
		ОбластьМакета 			   = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ДанныеНалогоплательщика");
		
		ИНН = Организация.ИНН;
		ОбластьМакета.Параметры.ИНН1 	= Сред(ИНН,1,1);
		ОбластьМакета.Параметры.ИНН2 	= Сред(ИНН,2,1);
		ОбластьМакета.Параметры.ИНН3 	= Сред(ИНН,3,1);
		ОбластьМакета.Параметры.ИНН4 	= Сред(ИНН,4,1);
		ОбластьМакета.Параметры.ИНН5 	= Сред(ИНН,5,1);
		ОбластьМакета.Параметры.ИНН6 	= Сред(ИНН,6,1);
		ОбластьМакета.Параметры.ИНН7 	= Сред(ИНН,7,1);
		ОбластьМакета.Параметры.ИНН8 	= Сред(ИНН,8,1);
		ОбластьМакета.Параметры.ИНН9 	= Сред(ИНН,9,1);
		ОбластьМакета.Параметры.ИНН10	= Сред(ИНН,10,1);
		ОбластьМакета.Параметры.ИНН11 	= Сред(ИНН,11,1);
		ОбластьМакета.Параметры.ИНН12 	= Сред(ИНН,12,1);
		ОбластьМакета.Параметры.ИНН13 	= Сред(ИНН,13,1);
		ОбластьМакета.Параметры.ИНН14 	= Сред(ИНН,14,1);
		
		ОКПО = Организация.КодПоОКПО;
		ОбластьМакета.Параметры.ОКПО1 = Сред(ОКПО,1,1);
		ОбластьМакета.Параметры.ОКПО2 = Сред(ОКПО,2,1);
		ОбластьМакета.Параметры.ОКПО3 = Сред(ОКПО,3,1);
		ОбластьМакета.Параметры.ОКПО4 = Сред(ОКПО,4,1);
		ОбластьМакета.Параметры.ОКПО5 = Сред(ОКПО,5,1);
		ОбластьМакета.Параметры.ОКПО6 = Сред(ОКПО,6,1);
		ОбластьМакета.Параметры.ОКПО7 = Сред(ОКПО,7,1);
		ОбластьМакета.Параметры.ОКПО8 = Сред(ОКПО,8,1);

		ГНС = Организация.ГНС.Код;
		ОбластьМакета.Параметры.ГНИ1 = Сред(ГНС,1,1);
		ОбластьМакета.Параметры.ГНИ2 = Сред(ГНС,2,1);
		ОбластьМакета.Параметры.ГНИ3 = Сред(ГНС,3,1);
		ОбластьМакета.Параметры.Налоговая = Организация.ГНС;

		СтрокаДатаН = Формат(НачалоПериода,"ДЛФ=D");
		СтрокаДатаК = Формат(КонецПериода,"ДЛФ=D");
		
		ОбластьМакета.Параметры.ДатаН1 = Сред(СтрокаДатаН,1,1);
		ОбластьМакета.Параметры.ДатаН2 = Сред(СтрокаДатаН,2,1);
		ОбластьМакета.Параметры.ДатаН3 = Сред(СтрокаДатаН,4,1);
		ОбластьМакета.Параметры.ДатаН4 = Сред(СтрокаДатаН,5,1);
		ОбластьМакета.Параметры.ДатаН5 = Сред(СтрокаДатаН,7,1);
		ОбластьМакета.Параметры.ДатаН6 = Сред(СтрокаДатаН,8,1);
		ОбластьМакета.Параметры.ДатаН7 = Сред(СтрокаДатаН,9,1);
		ОбластьМакета.Параметры.ДатаН8 = Сред(СтрокаДатаН,10,1);
		
		ОбластьМакета.Параметры.ДатаК1 = Сред(СтрокаДатаК,1,1);
		ОбластьМакета.Параметры.ДатаК2 = Сред(СтрокаДатаК,2,1);
		ОбластьМакета.Параметры.ДатаК3 = Сред(СтрокаДатаК,4,1);
		ОбластьМакета.Параметры.ДатаК4 = Сред(СтрокаДатаК,5,1);
		ОбластьМакета.Параметры.ДатаК5 = Сред(СтрокаДатаК,7,1);
		ОбластьМакета.Параметры.ДатаК6 = Сред(СтрокаДатаК,8,1);
		ОбластьМакета.Параметры.ДатаК7 = Сред(СтрокаДатаК,9,1);
		ОбластьМакета.Параметры.ДатаК8 = Сред(СтрокаДатаК,10,1);

		КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Организация);
		
		Индекс          	 = КонтактныеДанные.Индекс;
		АдрОбластьГород 	 = КонтактныеДанные.АдрОбластьГород;
		ЮрАдрес	        	 = КонтактныеДанные.АдресОрганизации; 
		Телефон		     	 = КонтактныеДанные.Телефон;
		ЭлПочта				 = КонтактныеДанные.ЭлПочта;
		НаименованиеПолное	 = Организация.НаименованиеПолное;
		
		ДанныеПечати = Новый Структура; 
		ДанныеПечати.Вставить("Организация", НаименованиеПолное);
		ДанныеПечати.Вставить("Тел", Телефон);
		ДанныеПечати.Вставить("ЭлПочта", ЭлПочта);
		
		Если ЗначениеЗаполнено(АдрОбластьГород) Тогда 
			ДанныеПечати.Вставить("Область", АдрОбластьГород);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЮрАдрес) Тогда 
			ДанныеПечати.Вставить("Адрес", ЮрАдрес);
		КонецЕсли;
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		
		Если ЗначениеЗаполнено(Индекс) Тогда
			ОбластьМакета.Параметры.Индекс1 = Сред(Индекс,1,1);
			ОбластьМакета.Параметры.Индекс2 = Сред(Индекс,2,1);
			ОбластьМакета.Параметры.Индекс3 = Сред(Индекс,3,1);
			ОбластьМакета.Параметры.Индекс4 = Сред(Индекс,4,1);
			ОбластьМакета.Параметры.Индекс5 = Сред(Индекс,5,1);
			ОбластьМакета.Параметры.Индекс6 = Сред(Индекс,6,1);
		КонецЕсли;

		ТабличныйДокумент.Вывести(ОбластьМакета);	
		
		ОбластьМакета	= Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ВыборкаПодоходныйНалог = Шапка.ПодоходныйНалог.Выбрать();
			
		ДанныеПечатиИтоги = Новый Структура; 
		ДанныеПечатиИтоги.Вставить("Количество",0);
		ДанныеПечатиИтоги.Вставить("Начислено",0);
		ДанныеПечатиИтоги.Вставить("Необлагаемая",0);
		ДанныеПечатиИтоги.Вставить("Вычеты",0);
		ДанныеПечатиИтоги.Вставить("Облагаемая",0);
		ДанныеПечатиИтоги.Вставить("ПодоходныйСотрудника",0);
		ДанныеПечатиИтоги.Вставить("СМРД",0);
		ДанныеПечатиИтоги.Вставить("ВсегоПодоходный",0);
		ДанныеПечатиИтоги.Вставить("Выплачено",0);
		ДанныеПечатиИтоги.Вставить("ПодоходныйКОплате",0);
		
		Для СтрокаМакета = 1 По 4 Цикл
			
			ЗаполнитьСтроку = Ложь;
			ВыборкаПодоходныйНалог.Сбросить();
			Пока ВыборкаПодоходныйНалог.НайтиСледующий(Новый Структура("НомерСтрокиОтчета", СтрокаМакета)) Цикл
				ЗаполнитьСтроку = Истина;	
			КонецЦикла;
				
			// заполняем строки отчета
			Если СтрокаМакета = 1  Тогда 
				ОбластьМакета = Макет.ПолучитьОбласть("Строка1");
			ИначеЕсли СтрокаМакета = 2 Тогда 
				ОбластьМакета = Макет.ПолучитьОбласть("Строка2");			
			ИначеЕсли СтрокаМакета = 3 Тогда 
				ОбластьМакета = Макет.ПолучитьОбласть("Строка3");
			ИначеЕсли СтрокаМакета = 4 Тогда 
				ОбластьМакета = Макет.ПолучитьОбласть("Строка4");
			КонецЕсли;
			
			Если ЗаполнитьСтроку Тогда
				ОбластьМакета.Параметры.Заполнить(ВыборкаПодоходныйНалог);
				
				//собираем итоговые суммы
				ДанныеПечатиИтоги.Количество 	 	 	= ДанныеПечатиИтоги.Количество   		 + ВыборкаПодоходныйНалог.Количество;
				ДанныеПечатиИтоги.Начислено 		 	= ДанныеПечатиИтоги.Начислено 	 	     + ВыборкаПодоходныйНалог.Начислено;
				ДанныеПечатиИтоги.Необлагаемая 	 	 	= ДанныеПечатиИтоги.Необлагаемая 		 + ВыборкаПодоходныйНалог.Необлагаемая;
				ДанныеПечатиИтоги.Вычеты			 	= ДанныеПечатиИтоги.Вычеты 		 	     + ВыборкаПодоходныйНалог.Вычеты;
				ДанныеПечатиИтоги.Облагаемая      		= ДанныеПечатиИтоги.Облагаемая   		 + ВыборкаПодоходныйНалог.Облагаемая;
				ДанныеПечатиИтоги.ПодоходныйСотрудника 	= ДанныеПечатиИтоги.ПодоходныйСотрудника + ВыборкаПодоходныйНалог.ПодоходныйСотрудника;
				ДанныеПечатиИтоги.СМРД				 	= ДанныеПечатиИтоги.СМРД  			     + ВыборкаПодоходныйНалог.СМРД;
				ДанныеПечатиИтоги.ВсегоПодоходный      	= ДанныеПечатиИтоги.ВсегоПодоходный 	 + ВыборкаПодоходныйНалог.ПодоходныйКОплате;
				ДанныеПечатиИтоги.Выплачено            	= ДанныеПечатиИтоги.Выплачено            + ВыборкаПодоходныйНалог.Выплачено;
				ДанныеПечатиИтоги.ПодоходныйКОплате    	= ДанныеПечатиИтоги.ПодоходныйКОплате	 + ВыборкаПодоходныйНалог.ПодоходныйКОплате;
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		// итоги подвал	
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалОтчета");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой ПриложениеКОтчетуПН
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПриложенияКОтчетуПН(МассивОбъектов, ОбъектыПечати)	
	
	Запрос = Новый Запрос;
	Запрос.Текст =  
		"ВЫБРАТЬ
		|	удалитьОтчетыПоНалогамЗП.Ссылка КАК Ссылка,
		|	удалитьОтчетыПоНалогамЗП.Дата КАК Дата,
		|	удалитьОтчетыПоНалогамЗП.Организация КАК Организация,
		|	удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.(
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.Количество, 0) КАК Количество,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаНачислено, 0) КАК Начислено,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаНеоблагаемая, 0) КАК Необлагаемая,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.Вычеты, 0) КАК Вычеты,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаНачислено, 0) - ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаНеоблагаемая, 0) - ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.Вычеты, 0) КАК Облагаемая,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаПНсСотрудника, 0) КАК ПодоходныйСотрудника,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаПНсМРД, 0) КАК СМРД,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СальдоК, 0) КАК ПодоходныйКОплате,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаПН, 0) КАК ВсегоПодоходный,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.СуммаВыплачен, 0) КАК Выплачено,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогПервыйМесяцКвартала.НомерСтрокиОтчета, 0) КАК НомерСтрокиОтчета
		|	) КАК ПодоходныйНалогПервыйМесяцКвартала,
		|	удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.(
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.Количество, 0) КАК Количество,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаНачислено, 0) КАК Начислено,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаНеоблагаемая, 0) КАК Необлагаемая,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.Вычеты, 0) КАК Вычеты,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаНачислено, 0) - ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаНеоблагаемая, 0) - ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.Вычеты, 0) КАК Облагаемая,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаПНсСотрудника, 0) КАК ПодоходныйСотрудника,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаПНсМРД, 0) КАК СМРД,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СальдоК, 0) КАК ПодоходныйКОплате,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаПН, 0) КАК ВсегоПодоходный,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.СуммаВыплачен, 0) КАК Выплачено,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогВторойМесяцКвартала.НомерСтрокиОтчета, 0) КАК НомерСтрокиОтчета
		|	) КАК ПодоходныйНалогВторойМесяцКвартала,
		|	удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.(
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.Количество, 0) КАК Количество,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаНачислено, 0) КАК Начислено,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаНеоблагаемая, 0) КАК Необлагаемая,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.Вычеты, 0) КАК Вычеты,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаНачислено, 0) - ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаНеоблагаемая, 0) - ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.Вычеты, 0) КАК Облагаемая,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаПНсСотрудника, 0) КАК ПодоходныйСотрудника,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаПНсМРД, 0) КАК СМРД,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СальдоК, 0) КАК ПодоходныйКОплате,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаПН, 0) КАК ВсегоПодоходный,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.СуммаВыплачен, 0) КАК Выплачено,
		|		ЕСТЬNULL(удалитьОтчетыПоНалогамЗП.ПодоходныйНалогТретийМесяцКвартала.НомерСтрокиОтчета, 0) КАК НомерСтрокиОтчета
		|	) КАК ПодоходныйНалогТретийМесяцКвартала
		|ИЗ
		|	Документ.удалитьОтчетыПоНалогамЗП КАК удалитьОтчетыПоНалогамЗП
		|ГДЕ
		|	удалитьОтчетыПоНалогамЗП.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетыПоНалогамЗП_ПриложениеКОтчетуПН";
	ТабличныйДокумент.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ПриложениеКОтчетуПН");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Организация = Шапка.Организация;
		Дата = Шапка.Дата;
				
		ОбластьМакета 			  	   = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ДанныеНалогоплательщика");
		
		ИНН = Организация.ИНН;
		ОбластьМакета.Параметры.ИНН1 	= Сред(ИНН,1,1);
		ОбластьМакета.Параметры.ИНН2 	= Сред(ИНН,2,1);
		ОбластьМакета.Параметры.ИНН3 	= Сред(ИНН,3,1);
		ОбластьМакета.Параметры.ИНН4 	= Сред(ИНН,4,1);
		ОбластьМакета.Параметры.ИНН5 	= Сред(ИНН,5,1);
		ОбластьМакета.Параметры.ИНН6 	= Сред(ИНН,6,1);
		ОбластьМакета.Параметры.ИНН7 	= Сред(ИНН,7,1);
		ОбластьМакета.Параметры.ИНН8 	= Сред(ИНН,8,1);
		ОбластьМакета.Параметры.ИНН9 	= Сред(ИНН,9,1);
		ОбластьМакета.Параметры.ИНН10	= Сред(ИНН,10,1);
		ОбластьМакета.Параметры.ИНН11 	= Сред(ИНН,11,1);
		ОбластьМакета.Параметры.ИНН12 	= Сред(ИНН,12,1);
		ОбластьМакета.Параметры.ИНН13 	= Сред(ИНН,13,1);
		ОбластьМакета.Параметры.ИНН14 	= Сред(ИНН,14,1);
		
		ОбластьМакета.Параметры.Организация = Организация.НаименованиеПолное;
		
		ОКПО = Организация.КодПоОКПО;
		ОбластьМакета.Параметры.ОКПО1 = Сред(ОКПО,1,1);
		ОбластьМакета.Параметры.ОКПО2 = Сред(ОКПО,2,1);
		ОбластьМакета.Параметры.ОКПО3 = Сред(ОКПО,3,1);
		ОбластьМакета.Параметры.ОКПО4 = Сред(ОКПО,4,1);
		ОбластьМакета.Параметры.ОКПО5 = Сред(ОКПО,5,1);
		ОбластьМакета.Параметры.ОКПО6 = Сред(ОКПО,6,1);
		ОбластьМакета.Параметры.ОКПО7 = Сред(ОКПО,7,1);
		ОбластьМакета.Параметры.ОКПО8 = Сред(ОКПО,8,1);

		ГНС = Организация.ГНС.Код;
		ОбластьМакета.Параметры.ГНИ1 = Сред(ГНС,1,1);
		ОбластьМакета.Параметры.ГНИ2 = Сред(ГНС,2,1);
		ОбластьМакета.Параметры.ГНИ3 = Сред(ГНС,3,1);
		ОбластьМакета.Параметры.Налоговая = Организация.ГНС;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьТаблицаПН = Макет.ПолучитьОбласть("ТаблицаПН");			
		
		//Вывод по месяцам квартала
		Для Сч = 1 По 3 Цикл   
			
			ДанныеПечатиИтоги = Новый Структура; 
			ДанныеПечатиИтоги.Вставить("Количество",0);
			ДанныеПечатиИтоги.Вставить("Начислено",0);
			ДанныеПечатиИтоги.Вставить("Необлагаемая",0);
			ДанныеПечатиИтоги.Вставить("Вычеты",0);
			ДанныеПечатиИтоги.Вставить("Облагаемая",0);
			ДанныеПечатиИтоги.Вставить("ПодоходныйСотрудника",0);
			ДанныеПечатиИтоги.Вставить("СМРД",0);
			ДанныеПечатиИтоги.Вставить("ВсегоПодоходный",0);
			ДанныеПечатиИтоги.Вставить("Выплачено",0);
			ДанныеПечатиИтоги.Вставить("ПодоходныйКОплате",0);
			
			//Определим даты с 1го месяца квартала
			Если  Сч = 1 Тогда 
				НачалоПериода = НачалоКвартала(Дата);
				ВыборкаТабличнойЧасти = Шапка.ПодоходныйНалогПервыйМесяцКвартала.Выбрать();
			ИначеЕсли Сч = 2 Тогда 
				НачалоПериода = ДобавитьМесяц(НачалоКвартала(Дата),1);
				ВыборкаТабличнойЧасти = Шапка.ПодоходныйНалогВторойМесяцКвартала.Выбрать();
			ИначеЕсли Сч = 3 Тогда  
				НачалоПериода = ДобавитьМесяц(НачалоКвартала(Дата),2);
				ВыборкаТабличнойЧасти = Шапка.ПодоходныйНалогТретийМесяцКвартала.Выбрать();
			КонецЕсли;
			
			ОбластьТаблицаПН.Параметры.Месяц = "" + Формат(НачалоПериода,"ДФ=MMMM") +" "+ Год(НачалоПериода);
			ТабличныйДокумент.Вывести(ОбластьТаблицаПН);		
									
			Для СтрокаМакета = 1 По 4 Цикл
				
				ЗаполнитьСтроку = Ложь;
				ВыборкаТабличнойЧасти.Сбросить();
				Пока ВыборкаТабличнойЧасти.НайтиСледующий(Новый Структура("НомерСтрокиОтчета", СтрокаМакета)) Цикл
					ЗаполнитьСтроку = Истина;	
				КонецЦикла;
					
				// заполняем строки отчета
				Если СтрокаМакета = 1  Тогда 
					ОбластьМакета = Макет.ПолучитьОбласть("Строка1");
				ИначеЕсли СтрокаМакета = 2 Тогда 
					ОбластьМакета = Макет.ПолучитьОбласть("Строка2");
				ИначеЕсли СтрокаМакета = 3 Тогда 
					ОбластьМакета = Макет.ПолучитьОбласть("Строка3");
				ИначеЕсли СтрокаМакета = 4 Тогда 
					ОбластьМакета = Макет.ПолучитьОбласть("Строка4");
				КонецЕсли;
				
				Если ЗаполнитьСтроку Тогда
					ОбластьМакета.Параметры.Заполнить(ВыборкаТабличнойЧасти);
					
					//собираем итоговые суммы
					ДанныеПечатиИтоги.Количество 	 	 	 = ДанныеПечатиИтоги.Количество   			+ ВыборкаТабличнойЧасти.Количество;
					ДанныеПечатиИтоги.Начислено 		 	 = ДанныеПечатиИтоги.Начислено 	 	   	 	+ ВыборкаТабличнойЧасти.Начислено;
					ДанныеПечатиИтоги.Необлагаемая 	 		 = ДанныеПечатиИтоги.Необлагаемая 			+ ВыборкаТабличнойЧасти.Необлагаемая;
					ДанныеПечатиИтоги.Вычеты			 	 = ДанныеПечатиИтоги.Вычеты 		 	    + ВыборкаТабличнойЧасти.Вычеты;
					ДанныеПечатиИтоги.Облагаемая      		 = ДанныеПечатиИтоги.Облагаемая   			+ ВыборкаТабличнойЧасти.Облагаемая;
					ДанныеПечатиИтоги.ПодоходныйСотрудника	 = ДанныеПечатиИтоги.ПодоходныйСотрудника 	+ ВыборкаТабличнойЧасти.ПодоходныйСотрудника;
					ДанныеПечатиИтоги.СМРД					 = ДанныеПечатиИтоги.СМРД  			    	+ ВыборкаТабличнойЧасти.СМРД;
					ДанныеПечатиИтоги.ВсегоПодоходный     	 = ДанныеПечатиИтоги.ВсегоПодоходный 	    + ВыборкаТабличнойЧасти.ПодоходныйКОплате;
					ДанныеПечатиИтоги.Выплачено           	 = ДанныеПечатиИтоги.Выплачено           	+ ВыборкаТабличнойЧасти.Выплачено;
					ДанныеПечатиИтоги.ПодоходныйКОплате   	 = ДанныеПечатиИтоги.ПодоходныйКОплате		+ ВыборкаТабличнойЧасти.ПодоходныйКОплате;
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;

			// итоги подвал	
			ОбластьМакета = Макет.ПолучитьОбласть("Итого");
			ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;

		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалОтчета");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой ЕжемесячныйПоСФ
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьЕжемесячногоПоСФ(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	удалитьОтчетыПоНалогамЗП.Ссылка КАК Ссылка,
		|	удалитьОтчетыПоНалогамЗП.Дата КАК Дата,
		|	удалитьОтчетыПоНалогамЗП.Организация КАК Организация,
		|	удалитьОтчетыПоНалогамЗП.Организация.ОсновнойБанковскийСчет.НомерСчета КАК ОрганизацияОсновнойБанковскийСчетНомерСчета,
		|	удалитьОтчетыПоНалогамЗП.Организация.ОсновнойБанковскийСчет.Банк.Наименование КАК ОрганизацияОсновнойБанковскийСчетБанк,
		|	удалитьОтчетыПоНалогамЗП.Организация.НаименованиеГКЭД КАК ОрганизацияНаименованиеГКЭД,
		|	удалитьОтчетыПоНалогамЗП.Контрагент КАК Контрагент,
		|	удалитьОтчетыПоНалогамЗП.ОбязательстваПоСтраховымВзносам КАК СуммаКтПФ_МС_ФОТФ,
		|	удалитьОтчетыПоНалогамЗП.ОбязательстваПоПенсионномуФонду КАК СуммаКтГНПФ,
		|	удалитьОтчетыПоНалогамЗП.ПереплатаПоСтраховымВзносам КАК СуммаДтПФ_МС_ФОТФ,
		|	удалитьОтчетыПоНалогамЗП.ПереплатаПоПенсионномуФонду КАК СуммаДтГНПФ,
		|	удалитьОтчетыПоНалогамЗП.ОбязательстваПоСтраховымВзносам + удалитьОтчетыПоНалогамЗП.ОбязательстваПоПенсионномуФонду КАК ИтогоОбязательства,
		|	удалитьОтчетыПоНалогамЗП.ПереплатаПоСтраховымВзносам + удалитьОтчетыПоНалогамЗП.ПереплатаПоПенсионномуФонду КАК ИтогоПереплата,
		|	удалитьОтчетыПоНалогамЗП.СведенияОЗанятостиИЗаработнойПлате.(
		|		НомерСтроки КАК НомерСтроки,
		|		ФизЛицо КАК ФизЛицо,
		|		ФизЛицо.ИНН КАК ИНН,
		|		ДатаНачалаРаботы КАК ДатаНачала,
		|		ДатаОкончанияРаботы КАК ДатаОкончания,
		|		Дней КАК ДнейНорма,
		|		ФактическиДней КАК ДнейФакт,
		|		ФондОплатыТруда КАК ФОТ,
		|		ДополнительныйФондОплатыТруда КАК ДопФОТ,
		|		НачисленыеСтраховыеВзносы КАК СтраховыеВзносы,
		|		НачсиленыеВзносыПоНПФ КАК ГНПФР,
		|		Категория КАК Категория
		|	) КАК СведенияОЗанятостиИЗаработнойПлате,
		|	удалитьОтчетыПоНалогамЗП.ФондОплатыТрудаПоКатегориям.(
		|		Категория КАК Категория,
		|		Численость КАК Численность,
		|		ФОТБолее КАК ФОТБольше40Процентов,
		|		ФОТМенее КАК ФОТМеньше40Процентов,
		|		ДопФОТ КАК ДопФОТ,
		|		Итого КАК Всего
		|	) КАК ФондОплатыТрудаПоКатегориям
		|ИЗ
		|	Документ.удалитьОтчетыПоНалогамЗП КАК удалитьОтчетыПоНалогамЗП
		|ГДЕ
		|	удалитьОтчетыПоНалогамЗП.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
		
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетыПоНалогамЗП_ЕжемесячныйОтчетПоСФ";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ЕжемесячныйОтчетПоСФ");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Дата = Шапка.Дата;
		Организация = Шапка.Организация;
		
		КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Организация);
		ДанныеПечати = Новый Структура; 
		ДанныеПечати.Вставить("Плательщик",  Организация.НаименованиеПолное);
		ДанныеПечати.Вставить("ИНН", 		 Организация.ИНН);
		ДанныеПечати.Вставить("РегНомер", 	 Организация.РегНомерСоцФонда);
		ДанныеПечати.Вставить("ОКПО", 		 Организация.КодПоОКПО);
		ДанныеПечати.Вставить("ОтделениеСФ", Шапка.Контрагент);
		ДанныеПечати.Вставить("Дата", 		 Формат(Дата,"ДФ='ММММ гггг'"));
		ДанныеПечати.Вставить("ДатаДок", 	 Нрег(Формат(ДобавитьМесяц(Дата, 1),"ДФ='ММММ гггг'")));
		ДанныеПечати.Вставить("Адрес", 		 КонтактныеДанные.АдресОрганизации);
		ДанныеПечати.Вставить("Телефон", 	 КонтактныеДанные.Телефон);
		
		ДанныеПечати.Вставить("НаименованиеБанка", Шапка.ОрганизацияОсновнойБанковскийСчетБанк);
		ДанныеПечати.Вставить("БанковскийСчет", Шапка.ОрганизацияОсновнойБанковскийСчетНомерСчета);
		ДанныеПечати.Вставить("ВидДеятельности", Шапка.ОрганизацияНаименованиеГКЭД);
		
		Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата);
		ДанныеПечати.Вставить("Руководитель", Руководители.Руководитель);
		ДанныеПечати.Вставить("ГлавныйБухгалтер", Руководители.ГлавныйБухгалтер);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);	
		ТабличныйДокумент.Вывести(ОбластьМакета);	
		
		ВыборкаСведенийОЗанятостиИЗП = Шапка.СведенияОЗанятостиИЗаработнойПлате.Выбрать();
		
		ДанныеПечатиИтоги = Новый Структура; 
		ДанныеПечатиИтоги.Вставить("ФОТ",0);
		ДанныеПечатиИтоги.Вставить("ДопФОТ",0);
		ДанныеПечатиИтоги.Вставить("СтраховыеВзносы",0);
		ДанныеПечатиИтоги.Вставить("ГНПФР",0);
		ДанныеПечатиИтоги.Вставить("Численность",0);
		ДанныеПечатиИтоги.Вставить("ФОТБольше40Процентов",0);
		ДанныеПечатиИтоги.Вставить("ФОТМеньше40Процентов",0);
		ДанныеПечатиИтоги.Вставить("Всего",0);

		Пока ВыборкаСведенийОЗанятостиИЗП.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ДеталиСведенияОЗП");
			ОбластьМакета.Параметры.Заполнить(ВыборкаСведенийОЗанятостиИЗП);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечатиИтоги.ФОТ 				= ДанныеПечатиИтоги.ФОТ 			+ ВыборкаСведенийОЗанятостиИЗП.ФОТ;
			ДанныеПечатиИтоги.ДопФОТ 			= ДанныеПечатиИтоги.ДопФОТ 			+ ВыборкаСведенийОЗанятостиИЗП.ДопФОТ;
			ДанныеПечатиИтоги.СтраховыеВзносы 	= ДанныеПечатиИтоги.СтраховыеВзносы + ВыборкаСведенийОЗанятостиИЗП.СтраховыеВзносы;
			ДанныеПечатиИтоги.ГНПФР 			= ДанныеПечатиИтоги.ГНПФР 			+ ВыборкаСведенийОЗанятостиИЗП.ГНПФР;
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоСведенияОЗП");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаФОТПоКатегориям");
		ТабличныйДокумент.Вывести(ОбластьМакета);
						
		ВыборкаФондОплатыТруда = Шапка.ФондОплатыТрудаПоКатегориям.Выбрать();
		
		// Обнуляется значение "ДопФОТ" для нового заполнения.
		ДанныеПечатиИтоги.ДопФОТ = 0;
		
		Пока ВыборкаФондОплатыТруда.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ДеталиФОТПоКатегориям");
			ОбластьМакета.Параметры.Заполнить(ВыборкаФондОплатыТруда);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечатиИтоги.Численность 		 	= ДанныеПечатиИтоги.Численность 		 + ВыборкаФондОплатыТруда.Численность;
			ДанныеПечатиИтоги.ФОТБольше40Процентов 	= ДанныеПечатиИтоги.ФОТБольше40Процентов + ВыборкаФондОплатыТруда.ФОТБольше40Процентов;
			ДанныеПечатиИтоги.ФОТМеньше40Процентов	= ДанныеПечатиИтоги.ФОТМеньше40Процентов + ВыборкаФондОплатыТруда.ФОТМеньше40Процентов;
			ДанныеПечатиИтоги.ДопФОТ 				= ДанныеПечатиИтоги.ДопФОТ 				 + ВыборкаФондОплатыТруда.ДопФОТ;
			ДанныеПечатиИтоги.Всего 				= ДанныеПечатиИтоги.Всего 				 + ВыборкаФондОплатыТруда.Всего;
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоФОТПоКатегориям");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Коды");	
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Обязательства");	
		ОбластьМакета.Параметры.Заполнить(Шапка);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");	
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);		
		ТабличныйДокумент.Вывести(ОбластьМакета);		
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
		
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатьЕжемесячногоПоСФ()

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
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПодоходныйНалог") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПодоходныйНалог", НСтр("ru = 'Печать отчета по подоходному налогу'"), ПечатьПоПН(МассивОбъектов, ОбъектыПечати),,
		"Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ПодоходныйНалог");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриложениеКОтчетуПН") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПриложениеКОтчетуПН", НСтр("ru = 'Печать приложения к отчету по подоходному налогу'"), ПечатьПриложенияКОтчетуПН(МассивОбъектов, ОбъектыПечати),,
		"Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ПриложениеКОтчетуПН");

	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЕжемесячныйОтчетСФ") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЕжемесячныйОтчетСФ", НСтр("ru = 'Печать ежемесячного отчета по СФ'"), ПечатьЕжемесячногоПоСФ(МассивОбъектов, ОбъектыПечати),,
		"Документ.удалитьОтчетыПоНалогамЗП.ПФ_MXL_ЕжемесячныйОтчетПоСФ");
	КонецЕсли;	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПодоходныйНалог";
	КомандаПечати.Представление = НСтр("ru = 'Печать отчета по подоходному налогу'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриложениеКОтчетуПН";
	КомандаПечати.Представление = НСтр("ru = 'Печать приложения к отчету по подоходному налогу'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "ВидСубъекта", 1);

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЕжемесячныйОтчетСФ";
	КомандаПечати.Представление = НСтр("ru = 'Печать ежемесячного отчета по СФ'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 3;
			
КонецПроцедуры

#КонецОбласти

#КонецЕсли