﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина);

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Сведения о выписанных (оформленных) счетах-фактурах НДС по облагаемым поставкам.'");

	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("ru = 'КОД и НАИМЕНОВАНИЕ НАЛОГОВОГО ОРГАНА
			|ИДЕНТИФИКАЦИОННЫЙ НАЛОГОВЫЙ НОМЕР НАЛОГОПЛАТЕЛЬЩИКА'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("ru = 'НачалоПериода
		|КонецПериода
		|Организация'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Сведения о выписанных (оформленных) счетах-фактурах НДС по облагаемым поставкам'");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура формирования отчета.
//
// Параметры:
// ПараметрыОтчета - структура - набор параметров, необходимых для построения отчета.
// 	АдресХранилища - адрес временного хранилища.
Процедура Сформировать(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатФормирования = Новый Структура("Результат, ОписаниеОшибки", Неопределено, "");
	СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

// Процедура - Сформировать табличный документ
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета.
//  РезультатФормирования	 	- Структура - 
//
Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "СведенияОВыписанныхСчетахФактурахНДСПоОблагаемымПоставкам_ВыписанныеСчетаФактуры";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = ПолучитьМакет("ПФ_MXL_ВыписанныеСчетаФактуры");
	
	Организация 	= СтруктураПараметров.Организация;
	НачалоПериода 	= СтруктураПараметров.НачалоПериода;
	КонецПериода 	= СтруктураПараметров.КонецПериода;	
	
	// Заполнение шапки 
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ЗаполнитьШапкуРеестра(СтруктураПараметров, ОбластьШапка);	
	
	// Вывод таблицы 	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СчетаФактурыВыписанные.ДатаСФ КАК ДатаВыписки,
	|	СчетаФактурыВыписанные.СерияБланкаСФ КАК СерияСФ,
	|	СчетаФактурыВыписанные.НомерБланкаСФ КАК НомерСФ,
	|	ПОДСТРОКА(СчетаФактурыВыписанные.ВидПоставкиНДС.Код, 0, 3) КАК КодПоставки,
	|	СчетаФактурыВыписанные.Контрагент.НаименованиеПолное КАК КонтрагентНаименование,
	|	СчетаФактурыВыписанные.Контрагент.ИНН КАК ИННКонтрагента,
	|	ВЫБОР
	|		КОГДА СчетаФактурыВыписанные.Контрагент.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.КР)
	|			ТОГДА СчетаФактурыВыписанные.Контрагент.ГНС.Код
	|		ИНАЧЕ СчетаФактурыВыписанные.Контрагент.СтранаРезидентства.Код
	|	КОНЕЦ КАК КодГНС,
	|	СчетаФактурыВыписанные.Документ.Дата КАК ДатаПоставки,
	|	СчетаФактурыВыписанные.СуммаБезНДС КАК СтоимостьБезНДС,
	|	СчетаФактурыВыписанные.СуммаНДС КАК СуммаНДС,
	|	СчетаФактурыВыписанные.СуммаБезНДС + СчетаФактурыВыписанные.СуммаНДС КАК ОбщаяСтоимостьСНДС,
	|	ВЫБОР
	|		КОГДА СчетаФактурыВыписанные.Документ ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|			ТОГДА ВЫРАЗИТЬ(СчетаФактурыВыписанные.Документ КАК Документ.ВозвратТоваровОтПокупателя).ДокументОснование.СерияБланкаСФ
	|		ИНАЧЕ """"""""
	|	КОНЕЦ КАК КорСерияСФ,
	|	ВЫБОР
	|		КОГДА СчетаФактурыВыписанные.Документ ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	|			ТОГДА ВЫРАЗИТЬ(СчетаФактурыВыписанные.Документ КАК Документ.ВозвратТоваровОтПокупателя).ДокументОснование.НомерБланкаСФ
	|		ИНАЧЕ """"""""
	|	КОНЕЦ КАК КорНомерСФ,
	|	СчетаФактурыВыписанные.СуммаНеоблагаемая КАК СуммаНСП,
	|	СчетаФактурыВыписанные.СтавкаНДС КАК СтавкаНДС,
	|	СчетаФактурыВыписанные.Контрагент.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС) КАК КонтрагентСтранаРезидентстваЕАЭС
	|ИЗ
	|	РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
	|ГДЕ
	|	СчетаФактурыВыписанные.ДатаСФ МЕЖДУ &НачалоПериода И &КонецПериода
	|	И СчетаФактурыВыписанные.Организация = &Организация
	|	И СчетаФактурыВыписанные.СерияБланкаСФ <> """"""""
	|	И НЕ СчетаФактурыВыписанные.СерияБланкаСФ ПОДОБНО &ДПБУ";
	
	Запрос.УстановитьПараметр("ДПБУ", "%ДПБУ%");
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(НачалоПериода));            
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(КонецПериода));
	Запрос.УстановитьПараметр("Организация", 	Организация); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоОпераций = Выборка.Количество();
	
	ПараметрыДляКоличестваЛистов = Новый Структура;
	ПараметрыДляКоличестваЛистов.Вставить("ТабличныйДокумент", 	ТабличныйДокумент);	
	ПараметрыДляКоличестваЛистов.Вставить("Выборка", 			Выборка);
	ПараметрыДляКоличестваЛистов.Вставить("Макет", 				Макет);
	ПараметрыДляКоличестваЛистов.Вставить("КоличествоОпераций", КоличествоОпераций);
	ПараметрыДляКоличестваЛистов.Вставить("СтруктураПараметров", СтруктураПараметров);
	
	КоличествоЛистов = КоличествоЛистовОтчета(ПараметрыДляКоличестваЛистов); 
	
	Если КоличествоОпераций = 0 Тогда 
		СформироватьПустойБланк(СтруктураПараметров, ТабличныйДокумент); 
		РезультатФормирования.Результат = ТабличныйДокумент;
		Возврат;
	КонецЕсли;
	
	КолСтрока = Формат(КоличествоЛистов,"ЧЦ=3; ЧВН=");
	ОбластьШапка.Параметры.Кол1 = Лев(КолСтрока,1); 
	ОбластьШапка.Параметры.Кол2 = Сред(КолСтрока,2,1); 
	ОбластьШапка.Параметры.Кол3 = Сред(КолСтрока,3,1);
	
	ТабличныйДокумент.Вывести(ОбластьШапка);	
	
	ИтогоПоЛистуБНДС        		= 0; 	
	ИтогоПоЛистуНДС         		= 0; 	
	ИтогоПоЛистуОбщаяСтоимость		= 0; 	
	ИтогоПоРееструБНДС      		= 0;
	ИтогоПоРееструНДС       		= 0;
	ИтогоПоРееструОбщаяСтоимость  	= 0;
	
	// Вывод листов отчета
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ОбластьИтогиПоЛисту   = Макет.ПолучитьОбласть("ИтогиПоЛисту");
	ОбластьИтогиПоРеестру = Макет.ПолучитьОбласть("ИтогиПоРеестру");
	ОбластьПодвал		  = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодвалШтамп	  = Макет.ПолучитьОбласть("ПодвалШтамп");
	
	// Проверка вывода на одну страницу
	МассивПроверки = Новый Массив;
	МассивПроверки.Добавить(ОбластьШапка);
	МассивПроверки.Добавить(ОбластьШапкаТаблицы);
	
	КоличествоВывода = 0; // переменная для проверки сколько вывели строк. Для определения одна страница или больше, если одна то печатается итог по реестру и подвал, иначе итог по листу и подвал
	КоличесвтоТекушегоЛиста = 0;
	НомерЛиста = 1;
	ЭтоПерваяСтраница = Истина;
	Пока Выборка.Следующий() Цикл
		
		КоличествоВывода 		= КоличествоВывода + 1;
		КоличесвтоТекушегоЛиста = КоличесвтоТекушегоЛиста + 1;
		
		ВыводСтрокиРеестра(СтруктураПараметров, ТабличныйДокумент, Выборка, Макет, МассивПроверки);
		
		ИтогоПоЛистуБНДС        	= ИтогоПоЛистуБНДС 	   			+ Выборка.СтоимостьБезНДС;
		ИтогоПоЛистуНДС         	= ИтогоПоЛистуНДС  	   			+ Выборка.СуммаНДС;
		ИтогоПоЛистуОбщаяСтоимость	= ИтогоПоЛистуОбщаяСтоимость 	+ Выборка.ОбщаяСтоимостьСНДС;
		
		ИтогоПоРееструБНДС      	= ИтогоПоРееструБНДС 	   		+ Выборка.СтоимостьБезНДС;
		ИтогоПоРееструНДС       	= ИтогоПоРееструНДС  	   		+ Выборка.СуммаНДС;
		ИтогоПоРееструОбщаяСтоимость= ИтогоПоРееструОбщаяСтоимость	+ Выборка.ОбщаяСтоимостьСНДС;		
		
		Если КоличествоОпераций > КоличествоВывода И КоличествоВывода = 10 Тогда // больше чем одна страница и вывели 7 строк = количеству на первой странице
			// Вывод итогов по листу
			// Подвал С Итогами Первой Страницы
			ОбластьИтогиПоЛисту.Параметры.СтоимостьБезНДС 	= ИтогоПоЛистуБНДС;
			ОбластьИтогиПоЛисту.Параметры.СуммаНДС 			= ИтогоПоЛистуНДС;
			ОбластьИтогиПоЛисту.Параметры.ОбщаяСтоимостьСНДС = ИтогоПоЛистуОбщаяСтоимость;
			
			ТабличныйДокумент.Вывести(ОбластьИтогиПоЛисту);
			ТабличныйДокумент.Вывести(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			Если ЭтоПерваяСтраница Тогда
				ЭтоПерваяСтраница = Ложь;
			КонецЕсли;
			
			ИтогоПоЛистуБНДС        = 0;
			ИтогоПоЛистуНДС         = 0;
			ИтогоПоЛистуОбщаяСтоимость    = 0;  
			
			МассивПроверки = Новый Массив;
			МассивПроверки.Добавить(ОбластьШапкаТаблицы);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			Если КоличествоОпераций - КоличествоВывода <= 22 Тогда 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЗаключительногоЛиста");
			Иначе 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЛиста");
			КонецЕсли;
			
			НомерЛиста = НомерЛиста + 1;
			ОбластьНомерЛиста.Параметры.НомЛиста = НомерЛиста;
			ТабличныйДокумент.Вывести(ОбластьНомерЛиста);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);             			
			Продолжить;
			
		ИначеЕсли КоличествоОпераций = КоличествоВывода Тогда 
			ОбластьИтогиПоРеестру.Параметры.СтоимостьБезНДС		= ИтогоПоРееструБНДС;
			ОбластьИтогиПоРеестру.Параметры.СуммаНДС 			= ИтогоПоРееструНДС;
			ОбластьИтогиПоРеестру.Параметры.ОбщаяСтоимостьСНДС	= ИтогоПоРееструОбщаяСтоимость;
			
			МассивПроверки.Добавить(ОбластьИтогиПоРеестру);
			МассивПроверки.Добавить(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			
			Пока КоличесвтоТекушегоЛиста <= 10 Цикл 
				ОбластьСтрокаРеестра 	= Макет.ПолучитьОбласть("СтрокаРеестра");
				ТабличныйДокумент.Вывести(ОбластьСтрокаРеестра);
				КоличесвтоТекушегоЛиста = КоличесвтоТекушегоЛиста +1;
			КонецЦикла;
			
			ТабличныйДокумент.Вывести(ОбластьИтогиПоРеестру);
			ТабличныйДокумент.Вывести(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			Если ЭтоПерваяСтраница Тогда
				ЭтоПерваяСтраница = Ложь;
			КонецЕсли;			
			
			Прервать;
		КонецЕсли;
		
		МассивПроверки.Добавить(ОбластьИтогиПоЛисту);
		МассивПроверки.Добавить(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
		ТабдокПроверки = Новый ТабличныйДокумент;
		ТабдокПроверки.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		Если  ТабдокПроверки.ПроверитьВывод(МассивПроверки) И МассивПроверки.Количество() < 24 Тогда 
			МассивПроверки.Удалить(МассивПроверки.Количество() -1);
			МассивПроверки.Удалить(МассивПроверки.Количество() -1);
			Продолжить;
		Иначе 
			// Вывод подвала
			//Подвал Промежуточной Страницы С Итогами
			ОбластьИтогиПоЛисту.Параметры.СтоимостьБезНДС 	= ИтогоПоЛистуБНДС;
			ОбластьИтогиПоЛисту.Параметры.СуммаНДС 			= ИтогоПоЛистуНДС;
			ОбластьИтогиПоЛисту.Параметры.ОбщаяСтоимостьСНДС = ИтогоПоЛистуОбщаяСтоимость;
			
			ТабличныйДокумент.Вывести(ОбластьИтогиПоЛисту);
			ТабличныйДокумент.Вывести(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			Если ЭтоПерваяСтраница Тогда
				ЭтоПерваяСтраница = Ложь;
			КонецЕсли;
			
			ИтогоПоЛистуБНДС        = 0;
			ИтогоПоЛистуНДС         = 0;
			ИтогоПоЛистуОбщаяСтоимость    = 0;
			
			МассивПроверки = Новый Массив;
			МассивПроверки.Добавить(ОбластьШапкаТаблицы);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			Если КоличествоОпераций - КоличествоВывода <= 23 Тогда 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЗаключительногоЛиста");
			Иначе 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЛиста");
			КонецЕсли;
			
			НомерЛиста = НомерЛиста + 1;
			ОбластьНомерЛиста.Параметры.НомЛиста = НомерЛиста;
			МассивПроверки.Добавить(ОбластьНомерЛиста);
			ТабличныйДокумент.Вывести(ОбластьНомерЛиста);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			
		КонецЕсли;
		
	КонецЦикла;	
	
	РезультатФормирования.Результат = ТабличныйДокумент;
КонецПроцедуры

Процедура ЗаполнитьШапкуРеестра(СтруктураПараметров, ОбластьШапка)
	
	Организация 		= СтруктураПараметров.Организация;
	НачалоПериодаШапки 	= СтруктураПараметров.НачалоПериода;
	КонецПериодаШапки 	= СтруктураПараметров.КонецПериода;	
	
	ОКПО              				= Организация.КодПоОКПО;
	ИНН 							= Организация.ИНН;
	КодГНС 							= Организация.ГНС.Код;
	ОрганизацияНаменованиеПолное    = ?(ЗначениеЗаполнено(Организация.НаименованиеПолное), Организация.НаименованиеПолное, Организация.Наименование);
	
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
	
	ОбластьШапка.Параметры.НаименованиеНалоговой = Организация.ГНС;
	
	ОбластьШапка.Параметры.ГНС1 = Сред(КодГНС, 1, 1);
	ОбластьШапка.Параметры.ГНС2 = Сред(КодГНС, 2, 1);
	ОбластьШапка.Параметры.ГНС3 = Сред(КодГНС, 3, 1);
	
	ОбластьШапка.Параметры.ДатаН1 = Сред(НачалоПериодаШапки, 1, 1);	
	ОбластьШапка.Параметры.ДатаН2 = Сред(НачалоПериодаШапки, 2, 1);	
	ОбластьШапка.Параметры.ДатаН3 = Сред(НачалоПериодаШапки, 4, 1);	
	ОбластьШапка.Параметры.ДатаН4 = Сред(НачалоПериодаШапки, 5, 1);	
	ОбластьШапка.Параметры.ДатаН5 = Сред(НачалоПериодаШапки, 7, 1);	
	ОбластьШапка.Параметры.ДатаН6 = Сред(НачалоПериодаШапки, 8, 1);	
	ОбластьШапка.Параметры.ДатаН7 = Сред(НачалоПериодаШапки, 9, 1);	
	ОбластьШапка.Параметры.ДатаН8 = Сред(НачалоПериодаШапки, 10, 1);	
	
	ОбластьШапка.Параметры.ДатаК1 = Сред(КонецПериодаШапки, 1, 1);	
	ОбластьШапка.Параметры.ДатаК2 = Сред(КонецПериодаШапки, 2, 1);	
	ОбластьШапка.Параметры.ДатаК3 = Сред(КонецПериодаШапки, 4, 1);	
	ОбластьШапка.Параметры.ДатаК4 = Сред(КонецПериодаШапки, 5, 1);	
	ОбластьШапка.Параметры.ДатаК5 = Сред(КонецПериодаШапки, 7, 1);	
	ОбластьШапка.Параметры.ДатаК6 = Сред(КонецПериодаШапки, 8, 1);	
	ОбластьШапка.Параметры.ДатаК7 = Сред(КонецПериодаШапки, 9, 1);	
	ОбластьШапка.Параметры.ДатаК8 = Сред(КонецПериодаШапки, 10, 1);
	
КонецПроцедуры

Функция КоличествоЛистовОтчета(ПараметрыДляКоличестваЛистов)
	ТабличныйДокумент 	= ПараметрыДляКоличестваЛистов.ТабличныйДокумент;	
	Выборка				= ПараметрыДляКоличестваЛистов.Выборка;
	Макет				= ПараметрыДляКоличестваЛистов.Макет;
	КоличествоОпераций	= ПараметрыДляКоличестваЛистов.КоличествоОпераций;
	СтруктураПараметров = ПараметрыДляКоличестваЛистов.СтруктураПараметров;
	
	НомерЛиста = 1; 
	
	Если КоличествоОпераций = 0 Тогда 
		Возврат НомерЛиста;
	КонецЕсли;
	
	ОбластьШапка	= Макет.ПолучитьОбласть("Шапка");
	
	ТабличныйДокумент.Вывести(ОбластьШапка);	
	
	// Вывод листов отчета
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ОбластьИтогиПоЛисту   = Макет.ПолучитьОбласть("ИтогиПоЛисту");
	ОбластьИтогиПоРеестру = Макет.ПолучитьОбласть("ИтогиПоРеестру");
	ОбластьПодвал		  = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодвалШтамп	  = Макет.ПолучитьОбласть("ПодвалШтамп");
	
	// Проверка вывода на одну страницу
	МассивПроверки = Новый Массив;
	МассивПроверки.Добавить(ОбластьШапка);
	МассивПроверки.Добавить(ОбластьШапкаТаблицы);
	
	КоличествоВывода = 0; 
	КоличесвтоТекушегоЛиста = 0;
	НомерЛиста = 1;
	ЭтоПерваяСтраница = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоВывода 		= КоличествоВывода + 1;
		КоличесвтоТекушегоЛиста = КоличесвтоТекушегоЛиста + 1;
		
		ВыводСтрокиРеестра(СтруктураПараметров, ТабличныйДокумент, Выборка, Макет, МассивПроверки);
		
		Если КоличествоОпераций > КоличествоВывода И КоличествоВывода = 10 Тогда
			ТабличныйДокумент.Вывести(ОбластьИтогиПоЛисту);
			ТабличныйДокумент.Вывести(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			Если ЭтоПерваяСтраница Тогда
				ЭтоПерваяСтраница = Ложь;
			КонецЕсли;
			
			МассивПроверки = Новый Массив;
			МассивПроверки.Добавить(ОбластьШапкаТаблицы);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			Если КоличествоОпераций - КоличествоВывода <= 22 Тогда 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЗаключительногоЛиста");
			Иначе 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЛиста");
			КонецЕсли;
			
			НомерЛиста = НомерЛиста + 1;
			ОбластьНомерЛиста.Параметры.НомЛиста = НомерЛиста;
			ТабличныйДокумент.Вывести(ОбластьНомерЛиста);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);             			
			Продолжить;
			
		ИначеЕсли КоличествоОпераций = КоличествоВывода Тогда 
			МассивПроверки.Добавить(ОбластьИтогиПоРеестру);
			МассивПроверки.Добавить(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			
			Пока КоличесвтоТекушегоЛиста <= 10 Цикл 
				ОбластьСтрокаРеестра 	= Макет.ПолучитьОбласть("СтрокаРеестра");
				ТабличныйДокумент.Вывести(ОбластьСтрокаРеестра);
				КоличесвтоТекушегоЛиста = КоличесвтоТекушегоЛиста +1;
			КонецЦикла;
			
			ТабличныйДокумент.Вывести(ОбластьИтогиПоРеестру);
			ТабличныйДокумент.Вывести(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			Если ЭтоПерваяСтраница Тогда
				ЭтоПерваяСтраница = Ложь;
			КонецЕсли;			
			
			Прервать;
		КонецЕсли;
		
		МассивПроверки.Добавить(ОбластьИтогиПоЛисту);
		МассивПроверки.Добавить(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
		ТабдокПроверки = Новый ТабличныйДокумент;
		ТабдокПроверки.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		Если  ТабдокПроверки.ПРоверитьВывод(МассивПроверки) И МассивПроверки.Количество() < 24 Тогда 
			МассивПроверки.Удалить(МассивПроверки.Количество() -1);
			МассивПроверки.Удалить(МассивПроверки.Количество() -1);
			Продолжить;
		Иначе 
			// Вывод подвала
			ТабличныйДокумент.Вывести(ОбластьИтогиПоЛисту);
			ТабличныйДокумент.Вывести(?(ЭтоПерваяСтраница, ОбластьПодвалШтамп, ОбластьПодвал));
			Если ЭтоПерваяСтраница Тогда
				ЭтоПерваяСтраница = Ложь;
			КонецЕсли;
			МассивПроверки = Новый Массив;
			МассивПроверки.Добавить(ОбластьШапкаТаблицы);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			Если КоличествоОпераций - КоличествоВывода <= 23 Тогда 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЗаключительногоЛиста");
			Иначе 
				ОбластьНомерЛиста = Макет.ПолучитьОбласть("НомерЛиста");
			КонецЕсли;
			
			НомерЛиста = НомерЛиста + 1;
			ОбластьНомерЛиста.Параметры.НомЛиста = НомерЛиста;
			МассивПроверки.Добавить(ОбластьНомерЛиста);
			ТабличныйДокумент.Вывести(ОбластьНомерЛиста);
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТабличныйДокумент.Очистить();
	Выборка.Сбросить();
	
	Возврат НомерЛиста;
	
КонецФункции

Процедура ВыводСтрокиРеестра(СтруктураПараметров, ТабличныйДокумент, СтрокаТаблицы, Макет, МассивПроверки)
	
	ОбластьСтрокаРеестра 	= Макет.ПолучитьОбласть("СтрокаРеестра");
	ОбластьСтрокаРеестра.Параметры.Заполнить(СтрокаТаблицы);
	
	ИНН  	= СтрокаТаблицы.ИННКонтрагента;
	ДатаДок = СтрокаТаблицы.ДатаПоставки;
	
	ОбластьСтрокаРеестра.Параметры.ИНН1 	   = Сред(ИНН, 1, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН2 	   = Сред(ИНН, 2, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН3 	   = Сред(ИНН, 3, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН4 	   = Сред(ИНН, 4, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН5 	   = Сред(ИНН, 5, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН6 	   = Сред(ИНН, 6, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН7 		= Сред(ИНН, 7, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН8 		= Сред(ИНН, 8, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН9 		= Сред(ИНН, 9, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН10 		= Сред(ИНН, 10, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН11 		= Сред(ИНН, 11, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН12 		= Сред(ИНН, 12, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН13 		= Сред(ИНН, 13, 1);
	ОбластьСтрокаРеестра.Параметры.ИНН14 		= Сред(ИНН, 14, 1);
	
	Если ЗначениеЗаполнено(ДатаДок) Тогда
		ОбластьСтрокаРеестра.Параметры.ДатаДок1		= Сред(ДатаДок, 1, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок2		= Сред(ДатаДок, 2, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок3		= Сред(ДатаДок, 4, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок4		= Сред(ДатаДок, 5, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок5		= Сред(ДатаДок, 7, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок6		= Сред(ДатаДок, 8, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок7		= Сред(ДатаДок, 9, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаДок8		= Сред(ДатаДок, 10, 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаТаблицы.ДатаВыписки) Тогда
		ДатаВыписки = СтрокаТаблицы.ДатаВыписки;
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки1		= Сред(ДатаВыписки, 1, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки2		= Сред(ДатаВыписки, 2, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки3		= Сред(ДатаВыписки, 4, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки4		= Сред(ДатаВыписки, 5, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки5		= Сред(ДатаВыписки, 7, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки6		= Сред(ДатаВыписки, 8, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки7		= Сред(ДатаВыписки, 9, 1);
		ОбластьСтрокаРеестра.Параметры.ДатаВыписки8		= Сред(ДатаВыписки, 10, 1);
	КонецЕсли;		
	
	Если ЗначениеЗаполнено(СтрокаТаблицы.КодГНС) Тогда
		КодГНС = СтрокаТаблицы.КодГНС;
		ОбластьСтрокаРеестра.Параметры.КодГНС1 = Сред(КодГНС, 1, 1);
		ОбластьСтрокаРеестра.Параметры.КодГНС2 = Сред(КодГНС, 2, 1);
		ОбластьСтрокаРеестра.Параметры.КодГНС3 = Сред(КодГНС, 3, 1);	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаТаблицы.КодПоставки) Тогда
		КодПоставки = СтрокаТаблицы.КодПоставки;
		ОбластьСтрокаРеестра.Параметры.КодПоставки1 = Сред(КодПоставки, 1, 1);
		ОбластьСтрокаРеестра.Параметры.КодПоставки2 = Сред(КодПоставки, 2, 1);
		ОбластьСтрокаРеестра.Параметры.КодПоставки3 = Сред(КодПоставки, 3, 1);	
	КонецЕсли;
	
	ОбластьСтрокаРеестра.Параметры.НомерСФ = СтрокаТаблицы.НомерСФ;//НомерСФСтрокой;	
	ОбластьСтрокаРеестра.Параметры.СерияСФ = СтрокаТаблицы.СерияСФ;
	
	ТабличныйДокумент.Вывести(ОбластьСтрокаРеестра);
	МассивПроверки.Добавить(ОбластьСтрокаРеестра);
	
КонецПроцедуры	

// Процедура - Сформировать пустой бланк
//
// Параметры:
//  ТабличныйДокумент	- 	 - 
//  НачалоПериода	 	- 	 - 
//  КонецПериода	 	- 	 - 
//  Организация		 	- 	 - 
//
Процедура СформироватьПустойБланк(СтруктураПараметров, ТабличныйДокумент) Экспорт 
	
	ТабличныйДокумент.Очистить();
	Макет = ПолучитьМакет("ПФ_MXL_ВыписанныеСчетаФактуры");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ЗаполнитьШапкуРеестра(СтруктураПараметров, ОбластьШапка);
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	
	ОбластьИтогиПоЛисту   = Макет.ПолучитьОбласть("ИтогиПоЛисту");
	ОбластьИтогиПоРеестру = Макет.ПолучитьОбласть("ИтогиПоРеестру");
	ОбластьПодвал		  = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодвалШтамп	  = Макет.ПолучитьОбласть("ПодвалШтамп");
	ОбластьСтрокаРеестра  = Макет.ПолучитьОбласть("СтрокаРеестра");
	ОбластьНомерЛиста 	  = Макет.ПолучитьОбласть("НомерЗаключительногоЛиста");

	МассивПроверки = Новый Массив;
	МассивПроверки.Добавить(ОбластьШапка);
	МассивПроверки.Добавить(ОбластьШапкаТаблицы);
	МассивПроверки.Добавить(ОбластьИтогиПоЛисту);
	МассивПроверки.Добавить(ОбластьПодвалШтамп);
	
	Сч = 0;
	Пока не Сч = 7 Цикл
		МассивПроверки.Добавить(ОбластьСтрокаРеестра);
		Сч = Сч +1;
	КонецЦикла;
	
	МассивПроверки.Удалить(2);
	МассивПроверки.Удалить(2);
	МассивПроверки.Добавить(ОбластьИтогиПоЛисту);
	МассивПроверки.Добавить(ОбластьПодвалШтамп);
	
	Для Каждого Область Из МассивПроверки Цикл 
		ТабличныйДокумент.Вывести(Область);
	КонецЦикла;
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	МассивПроверки.Очистить();
	
	МассивПроверки = Новый Массив;
	МассивПроверки.Добавить(ОбластьНомерЛиста);
	МассивПроверки.Добавить(ОбластьШапкаТаблицы);
	МассивПроверки.Добавить(ОбластьИтогиПоРеестру);
	МассивПроверки.Добавить(ОбластьПодвал);
	
	Сч = 0;
	Пока не Сч = 19 Цикл
		МассивПроверки.Добавить(ОбластьСтрокаРеестра);
		Сч = Сч +1;
	КонецЦикла;
	
	МассивПроверки.Удалить(1);
	МассивПроверки.Удалить(1);
	МассивПроверки.Добавить(ОбластьИтогиПоРеестру);
	МассивПроверки.Добавить(ОбластьПодвал);
	
	Для Каждого Область Из МассивПроверки Цикл 
		ТабличныйДокумент.Вывести(Область);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
