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
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина);

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Свод по счету.'");

	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("ru = 'Свод по счету'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("ru = 'НачалоПериода
		|КонецПериода
		|Организация
		|Счет'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Свод по счету'");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура формирования отчета.
//
// Параметры:
//   ПараметрыОтчета - структура - набор параметров, необходимых для построения отчета.
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
	ТабличныйДокумент.КлючПараметровПечати = "СводПоСчету_СводПоСчету";
	
	Макет = ПолучитьМакет("ПФ_MXL_СводПоСчету");
	
	Организация 	= СтруктураПараметров.Организация;
	Счет 			= СтруктураПараметров.Счет;
	НачалоПериода 	= СтруктураПараметров.НачалоПериода;
	КонецПериода 	= ?(СтруктураПараметров.КонецПериода = Дата(0001, 01, 01), Дата(3999, 01, 01), СтруктураПараметров.КонецПериода);		
	СчетАктивный	= Счет.Вид = ВидСчета.Активный;
	СчетВалютный 	= Счет.Валютный;
	
	// 1. Остатки на начало.
	// 2. Обороты за период.
	// 3. Остатки на конец.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Валюта КАК Валюта,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток КАК СуммаВалютна
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&НачалоПериода, Счет = &Счет, , Организация = &Организация) КАК ХозрасчетныйОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОборотыДтКт.СчетДт КАК СчетДт,
		|	ХозрасчетныйОборотыДтКт.СчетКт КАК СчетКт,
		|	ХозрасчетныйОборотыДтКт.ВалютаДт КАК Валюта,
		|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК ДебетСумма,
		|	0 КАК КредитСумма,
		|	ЕСТЬNULL(ХозрасчетныйОборотыДтКт.ВалютнаяСуммаОборотДт, 0) КАК ДебетСуммаВалютная,
		|	ЕСТЬNULL(ХозрасчетныйОборотыДтКт.ВалютнаяСуммаОборотКт, 0) КАК КредитСуммаВалютная
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , СчетДт = &Счет, , , , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХозрасчетныйОборотыДтКт.СчетДт,
		|	ХозрасчетныйОборотыДтКт.СчетКт,
		|	ХозрасчетныйОборотыДтКт.ВалютаКт,
		|	0,
		|	ХозрасчетныйОборотыДтКт.СуммаОборот,
		|	ЕСТЬNULL(ХозрасчетныйОборотыДтКт.ВалютнаяСуммаОборотДт, 0),
		|	ЕСТЬNULL(ХозрасчетныйОборотыДтКт.ВалютнаяСуммаОборотКт, 0)
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , , , СчетКт = &Счет, , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
		|
		|УПОРЯДОЧИТЬ ПО
		|	Валюта,
		|	КредитСумма
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Валюта КАК Валюта,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток КАК СуммаВалютна
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецПериодаОстатки, Счет = &Счет, , Организация = &Организация) КАК ХозрасчетныйОстатки";
	
	Если Организация = Справочники.Организации.ПустаяСсылка() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация = &Организация", ""); 	
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("НачалоПериода", 		 НачалоМесяца(НачалоПериода));            
	Запрос.УстановитьПараметр("КонецПериода", 		 КонецМесяца(КонецПериода));
	Запрос.УстановитьПараметр("КонецПериодаОстатки", КонецМесяца(КонецПериода) + 1);
	Запрос.УстановитьПараметр("Организация", 		 Организация);
	Запрос.УстановитьПараметр("Счет", 				 Счет);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаОстаткиНаНачало = МассивРезультатов[0].Выгрузить();
	
	Если СчетВалютный Тогда
		ТаблицаОборотыЗаПериод = МассивРезультатов[1].Выгрузить();
	Иначе
		Выборка = МассивРезультатов[1].Выбрать();
	КонецЕсли;	
		
	ТаблицаОстаткиНаКонец = МассивРезультатов[2].Выгрузить();

	Если СчетВалютный Тогда
		ТаблицаОстаткиНаНачало.Индексы.Добавить("Валюта");
		ТаблицаОстаткиНаКонец.Индексы.Добавить("Валюта");
	КонецЕсли;
	
	Заголовок = СтрШаблон(НСтр("ru = 'Свод по счету %1 - %2'"), Счет.Код, Счет.Наименование);
										
	Период = СтрШаблон(НСтр("ru = 'с %1 по %2'"),
						Формат(НачалоПериода, "ДЛФ=D"),
						Формат(КонецПериода, "ДЛФ=D"));										
										
	СтруктураЗаголовка = Новый Структура();
	СтруктураЗаголовка.Вставить("Заголовок", Заголовок);
	СтруктураЗаголовка.Вставить("Период", Период);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(СтруктураЗаголовка);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Если СчетВалютный Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыСом");
	КонецЕсли;	
		
	ТабличныйДокумент.Вывести(ОбластьМакета);         
	
	// Структура для заполнения итогов.
	СтруктураИтогов = Новый Структура();
	
	Если СчетВалютный Тогда
		СтруктураИтогов.Вставить("Валюта", 				"");
		СтруктураИтогов.Вставить("ДебетСуммаВалютная", 	0);
		СтруктураИтогов.Вставить("КредитСуммаВалютная", 0);
	КонецЕсли;
	
	СтруктураИтогов.Вставить("ЗаголовокСтроки", "");
	СтруктураИтогов.Вставить("ДебетСумма", 		0);
	СтруктураИтогов.Вставить("КредитСумма", 	0);
	
	Если СчетВалютный Тогда
		ОбластьИтоги  = Макет.ПолучитьОбласть("ИтогиТаблицы");
		ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицы");
	Иначе
		ОбластьИтоги  = Макет.ПолучитьОбласть("ИтогиТаблицыСом");
		ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицыСом");		
	КонецЕсли;	
		
	// Вывод общих итогов.
	СтруктураИтогов.ЗаголовокСтроки = НСтр("ru = 'Сальдо на начало'");	
	СуммаОстатокНаНачало = ТаблицаОстаткиНаНачало.Итог("Сумма");
	
	Если СчетАктивный Тогда		
		Если СуммаОстатокНаНачало > 0 Тогда
			СтруктураИтогов.ДебетСумма = СуммаОстатокНаНачало;	
		Иначе
			СтруктураИтогов.КредитСумма = -СуммаОстатокНаНачало;
		КонецЕсли;				
	Иначе
		Если СуммаОстатокНаНачало > 0 Тогда
			СтруктураИтогов.КредитСумма = СуммаОстатокНаНачало;	
		Иначе
			СтруктураИтогов.ДебетСумма = -СуммаОстатокНаНачало;
		КонецЕсли;
	КонецЕсли;	
	
	ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
	ТабличныйДокумент.Вывести(ОбластьИтоги);
	
	// Заполнение строк и итогов по оборотам макета если счет НЕ валютный.
	Если НЕ СчетВалютный Тогда		
		ДебетСумма  = 0;
		КредитСумма = 0;
		
		Пока Выборка.Следующий() Цикл
			ОбластьСтрока.Параметры.Заполнить(Выборка);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
			ДебетСумма  = ДебетСумма + Выборка.ДебетСумма;
			КредитСумма = КредитСумма + Выборка.КредитСумма;
		КонецЦикла;	
		
		СтруктураИтогов.ЗаголовокСтроки = НСтр("ru = 'Итого обороты'");
		СтруктураИтогов.ДебетСумма  = ДебетСумма;
		СтруктураИтогов.КредитСумма = КредитСумма;
		
	Иначе
		СтруктураИтогов.ЗаголовокСтроки = НСтр("ru = 'Обороты'");
		СтруктураИтогов.ДебетСумма  = ТаблицаОборотыЗаПериод.Итог("ДебетСумма");
		СтруктураИтогов.КредитСумма = ТаблицаОборотыЗаПериод.Итог("КредитСумма");
	КонецЕсли;	
	
	ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
	ТабличныйДокумент.Вывести(ОбластьИтоги);
	
	СтруктураИтогов.ДебетСумма = 0;
	СтруктураИтогов.КредитСумма = 0;
	
	СтруктураИтогов.ЗаголовокСтроки = НСтр("ru = 'Сальдо на конец'");	
	СуммаОстатокНаКонец = ТаблицаОстаткиНаКонец.Итог("Сумма");
	
	Если СчетАктивный Тогда		
		Если СуммаОстатокНаКонец > 0 Тогда
			СтруктураИтогов.ДебетСумма = СуммаОстатокНаКонец;	
		Иначе
			СтруктураИтогов.КредитСумма = -СуммаОстатокНаКонец;
		КонецЕсли;				
	Иначе
		Если СуммаОстатокНаКонец > 0 Тогда
			СтруктураИтогов.КредитСумма = СуммаОстатокНаКонец;	
		Иначе
			СтруктураИтогов.ДебетСумма = -СуммаОстатокНаКонец;
		КонецЕсли;
	КонецЕсли;	
	
	ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
	ТабличныйДокумент.Вывести(ОбластьИтоги);
	
	// Заполнение строк и итогов по валютам макета если счет валютный.
	Если СчетВалютный Тогда
		Валюта = Неопределено;
		НомерСтроки = 1;
		КоличествоСтрок = ТаблицаОборотыЗаПериод.Количество();
		
		// Вывод оборотов с итогами по валютам.
		Для Каждого СтрокаТаблицы Из ТаблицаОборотыЗаПериод Цикл
					
			Если Валюта <> СтрокаТаблицы.Валюта Тогда
				
				Если НомерСтроки <> 1 Тогда
					СтруктураИтогов.Валюта				= "";
					СтруктураИтогов.ЗаголовокСтроки		= НСтр("ru = 'Итого обороты'");
					ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
					ТабличныйДокумент.Вывести(ОбластьИтоги);
					
					СтруктураИтогов.ДебетСумма			= 0;
					СтруктураИтогов.ДебетСуммаВалютная	= 0;
					СтруктураИтогов.КредитСумма			= 0;
					СтруктураИтогов.КредитСуммаВалютная	= 0;
					
					СтруктураИтогов.Валюта				= "";
					СтруктураИтогов.ЗаголовокСтроки		= НСтр("ru = 'Сальдо на конец'");			
					
					СтрокаТаблицыКонец = ТаблицаОстаткиНаКонец.Найти(Валюта, "Валюта");
					
					Если СтрокаТаблицыКонец <> Неопределено Тогда
						Если СчетАктивный Тогда		
							Если СтрокаТаблицыКонец.Сумма > 0 Тогда
								СтруктураИтогов.ДебетСумма 			= СтрокаТаблицыКонец.Сумма;
								СтруктураИтогов.ДебетСуммаВалютная 	= СтрокаТаблицыКонец.СуммаВалютна;
							Иначе
								СтруктураИтогов.КредитСумма 		= -СтрокаТаблицыКонец.Сумма;
								СтруктураИтогов.КредитСуммаВалютная = -СтрокаТаблицыКонец.СуммаВалютна;
							КонецЕсли;				
						Иначе
							Если СтрокаТаблицыКонец.Сумма > 0 Тогда
								СтруктураИтогов.КредитСумма 		= СтрокаТаблицыКонец.Сумма;
								СтруктураИтогов.КредитСуммаВалютная = СтрокаТаблицыКонец.СуммаВалютна;
							Иначе
								СтруктураИтогов.ДебетСумма 			= -СтрокаТаблицыКонец.Сумма;
								СтруктураИтогов.ДебетСуммаВалютная 	= -СтрокаТаблицыКонец.СуммаВалютна;
							КонецЕсли;
						КонецЕсли;
						
						ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
						ТабличныйДокумент.Вывести(ОбластьИтоги);
					КонецЕсли;
					
					СтруктураИтогов.ДебетСумма			= 0;
					СтруктураИтогов.ДебетСуммаВалютная	= 0;
					СтруктураИтогов.КредитСумма			= 0;
					СтруктураИтогов.КредитСуммаВалютная	= 0;
				КонецЕсли;
				
				СтрокаТаблицыНачало = ТаблицаОстаткиНаНачало.Найти(СтрокаТаблицы.Валюта, "Валюта");
				
				СтруктураИтогов.Валюта = СтрокаТаблицы.Валюта;
				СтруктураИтогов.ЗаголовокСтроки = НСтр("ru = 'Сальдо на начало'");
				
				Если СтрокаТаблицыНачало <> Неопределено Тогда
					Если СчетАктивный Тогда		
						Если СтрокаТаблицыНачало.Сумма > 0 Тогда
							СтруктураИтогов.ДебетСумма 			= СтрокаТаблицыНачало.Сумма;
							СтруктураИтогов.ДебетСуммаВалютная 	= СтрокаТаблицыНачало.СуммаВалютна;
						Иначе
							СтруктураИтогов.КредитСумма 		= -СтрокаТаблицыНачало.Сумма;
							СтруктураИтогов.КредитСуммаВалютная = -СтрокаТаблицыНачало.СуммаВалютна;
						КонецЕсли;				
					Иначе
						Если СтрокаТаблицыНачало.Сумма > 0 Тогда
							СтруктураИтогов.КредитСумма 		= СтрокаТаблицыНачало.Сумма;
							СтруктураИтогов.КредитСуммаВалютная = СтрокаТаблицыНачало.СуммаВалютна;
						Иначе
							СтруктураИтогов.ДебетСумма 			= -СтрокаТаблицыНачало.Сумма;
							СтруктураИтогов.ДебетСуммаВалютная 	= -СтрокаТаблицыНачало.СуммаВалютна;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
				ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
				ТабличныйДокумент.Вывести(ОбластьИтоги);
				
				СтруктураИтогов.ДебетСумма			= 0;
				СтруктураИтогов.ДебетСуммаВалютная	= 0;
				СтруктураИтогов.КредитСумма			= 0;
				СтруктураИтогов.КредитСуммаВалютная	= 0;
			КонецЕсли;	
				
			ОбластьСтрока.Параметры.Заполнить(СтрокаТаблицы);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
			СтруктураИтогов.ДебетСумма 			= СтруктураИтогов.ДебетСумма + СтрокаТаблицы.ДебетСумма;
			СтруктураИтогов.ДебетСуммаВалютная 	= СтруктураИтогов.ДебетСуммаВалютная + СтрокаТаблицы.ДебетСуммаВалютная;
			СтруктураИтогов.КредитСумма 		= СтруктураИтогов.КредитСумма + СтрокаТаблицы.КредитСумма;
			СтруктураИтогов.КредитСуммаВалютная = СтруктураИтогов.КредитСуммаВалютная + СтрокаТаблицы.КредитСуммаВалютная;	
			
			Если НомерСтроки = КоличествоСтрок Тогда
				СтруктураИтогов.Валюта				= "";
				СтруктураИтогов.ЗаголовокСтроки		= НСтр("ru = 'Итого обороты'");
				ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
				ТабличныйДокумент.Вывести(ОбластьИтоги);
				
				СтруктураИтогов.ДебетСумма			= 0;
				СтруктураИтогов.ДебетСуммаВалютная	= 0;
				СтруктураИтогов.КредитСумма			= 0;
				СтруктураИтогов.КредитСуммаВалютная	= 0;
				
				СтруктураИтогов.Валюта				= "";
				СтруктураИтогов.ЗаголовокСтроки		= НСтр("ru = 'Сальдо на конец'");			
				
				СтрокаТаблицыКонец = ТаблицаОстаткиНаКонец.Найти(СтрокаТаблицы.Валюта, "Валюта");
				
				Если СтрокаТаблицыКонец <> Неопределено Тогда
					Если СчетАктивный Тогда		
						Если СтрокаТаблицыКонец.Сумма > 0 Тогда
							СтруктураИтогов.ДебетСумма 			= СтрокаТаблицыКонец.Сумма;
							СтруктураИтогов.ДебетСуммаВалютная 	= СтрокаТаблицыКонец.СуммаВалютна;
						Иначе
							СтруктураИтогов.КредитСумма 		= -СтрокаТаблицыКонец.Сумма;
							СтруктураИтогов.КредитСуммаВалютная = -СтрокаТаблицыКонец.СуммаВалютна;
						КонецЕсли;				
					Иначе
						Если СтрокаТаблицыКонец.Сумма > 0 Тогда
							СтруктураИтогов.КредитСумма 		= СтрокаТаблицыКонец.Сумма;
							СтруктураИтогов.КредитСуммаВалютная = СтрокаТаблицыКонец.СуммаВалютна;
						Иначе
							СтруктураИтогов.ДебетСумма 			= -СтрокаТаблицыКонец.Сумма;
							СтруктураИтогов.ДебетСуммаВалютная 	= -СтрокаТаблицыКонец.СуммаВалютна;
						КонецЕсли;
					КонецЕсли;
					
					ОбластьИтоги.Параметры.Заполнить(СтруктураИтогов);
					ТабличныйДокумент.Вывести(ОбластьИтоги);
				КонецЕсли;
				
				СтруктураИтогов.ДебетСумма			= 0;
				СтруктураИтогов.ДебетСуммаВалютная	= 0;
				СтруктураИтогов.КредитСумма			= 0;
				СтруктураИтогов.КредитСуммаВалютная	= 0;
			КонецЕсли;	
				
			Валюта = СтрокаТаблицы.Валюта;
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;	
	КонецЕсли;	
		
	РезультатФормирования.Результат = ТабличныйДокумент;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
