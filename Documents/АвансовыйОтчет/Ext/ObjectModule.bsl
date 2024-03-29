﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполнения ТЧ "ДвижениеДенежныхСредств" и "ТаблицаДокументов".
//
// Параметры:
//	ДатаДокумента - Дата - дата документа.
//
Процедура ЗаполнитьАвансы(ДатаДокумента) Экспорт
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	// Выборка валют
	ЗапросВалют = Новый Запрос();
	ЗапросВалют.Текст =
		"ВЫБРАТЬ
		|	Валюты.Ссылка КАК Валюта
		|ИЗ
		|	Справочник.Валюты КАК Валюты";
	Выборка = ЗапросВалют.Выполнить().Выбрать();
	
	// Выборка сумм из табличных частей с учетом валюты
	ЗапросСумм = Новый Запрос();
	ЗапросСумм.Текст =
		"ВЫБРАТЬ
		|	ТаблицаОплатаПоставщикам.Валюта,
		|   ТаблицаОплатаПоставщикам.Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаОплатаПоставщикам
		|ИЗ
		|	&ТаблицаОплатаПоставщикам КАК ТаблицаОплатаПоставщикам
		|;
		|
		|/////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|   ТаблицаВыплатаЗаработнойПлаты.Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаВыплатаЗаработнойПлаты
		|ИЗ
		|	&ТаблицаВыплатаЗаработнойПлаты КАК ТаблицаВыплатаЗаработнойПлаты
		|;
		|
		|/////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|   ТаблицаТоварыУслуги.Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаТоварыУслуги
		|ИЗ
		|	&ТаблицаТоварыУслуги КАК ТаблицаТоварыУслуги
		|;
		|
		|/////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаПрочее.Валюта,
		|   ТаблицаПрочее.Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочее
		|ИЗ
		|	&ТаблицаПрочее КАК ТаблицаПрочее
		|;
		|
		|/////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОплатаПоставщикам.Валюта КАК Валюта,
		|	ВременнаяТаблицаОплатаПоставщикам.Сумма КАК Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаСумм
		|ИЗ
		|	ВременнаяТаблицаОплатаПоставщикам КАК ВременнаяТаблицаОплатаПоставщикам
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПрочее.Валюта,
		|	ВременнаяТаблицаПрочее.Сумма
		|ИЗ
		|	ВременнаяТаблицаПрочее КАК ВременнаяТаблицаПрочее
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.Сумма
		|ИЗ
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ 
		|	&ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаТоварыУслуги.Сумма
		|ИЗ
		|	ВременнаяТаблицаТоварыУслуги КАК ВременнаяТаблицаТоварыУслуги
		|;
		|
		|////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|   ВременнаяТаблицаСумм.Валюта,
		|   СУММА(ВременнаяТаблицаСумм.Сумма) КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаСумм КАК ВременнаяТаблицаСумм	
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаСумм.Валюта";
	ЗапросСумм.УстановитьПараметр("ТаблицаОплатаПоставщикам", 		ОплатаПоставщикам.Выгрузить(,"Валюта,Сумма"));
	ЗапросСумм.УстановитьПараметр("ТаблицаВыплатаЗаработнойПлаты", 	ВыплатаЗаработнойПлаты.Выгрузить(,"Сумма"));
	ЗапросСумм.УстановитьПараметр("ТаблицаТоварыУслуги", 			ТоварыУслуги.Выгрузить(,"Сумма"));
	ЗапросСумм.УстановитьПараметр("ТаблицаПрочее", 					Прочее.Выгрузить(,"Валюта,Сумма"));
	ЗапросСумм.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	ТЗСумм = ЗапросСумм.Выполнить().Выгрузить();
	
	// Выборка сумм и валют из ТЧ "ОбменВалют"
	ЗапросОбменВалют = Новый Запрос();
	ЗапросОбменВалют.Текст = 
	    "ВЫБРАТЬ
		|	ТаблицаОбменВалют.ВалютаДо,
		|   ТаблицаОбменВалют.СуммаДо,
		|	ТаблицаОбменВалют.ВалютаПосле,
		|   ТаблицаОбменВалют.СуммаПосле
		|ПОМЕСТИТЬ ВременнаяТаблицаОбменВалют
		|ИЗ
		|	&ТаблицаОбменВалют КАК ТаблицаОбменВалют
		|;
		|
		|/////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОбменВалют.ВалютаДо КАК Валюта,
		|	СУММА(ВременнаяТаблицаОбменВалют.СуммаДо) КАК ОбменРасход
		|ИЗ
		|	ВременнаяТаблицаОбменВалют КАК ВременнаяТаблицаОбменВалют
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОбменВалют.ВалютаДо
		|;
		|
		|////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОбменВалют.ВалютаПосле КАК Валюта,
		|	СУММА(ВременнаяТаблицаОбменВалют.СуммаПосле) КАК ОбменПриход
		|ИЗ
		|	ВременнаяТаблицаОбменВалют КАК ВременнаяТаблицаОбменВалют
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОбменВалют.ВалютаПосле";	
	ЗапросОбменВалют.УстановитьПараметр("ТаблицаОбменВалют", ОбменВалют.Выгрузить(,"ВалютаДо,СуммаДо,ВалютаПосле,СуммаПосле"));
	МассивРезультатов = ЗапросОбменВалют.ВыполнитьПакет();
	ТЗОбменРасход = МассивРезультатов[1].Выгрузить();
	ТЗОбменПриход = МассивРезультатов[2].Выгрузить();
	
	// Сальдо начальное по счету 1520 или разница сальдо начального по счетам 1520 и его парному счету.
	ЗапросСальдоН = Новый Запрос;
	ЗапросСальдоН.УстановитьПараметр("Организация", Организация);
	ЗапросСальдоН.УстановитьПараметр("Период", ДатаДокумента);
	ЗапросСальдоН.УстановитьПараметр("ФизЛицо", ФизЛицо);
		
	ЗапросСальдоН.Текст =
	    // 1. Объединение полученных сальдо на начало по счетам 1520 и его парному счету;
		// 2. Группировка результатов по валюте.
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Валюта КАК Валюта,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток КАК Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаОстаткиПоСчетам
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период, 
		|			Счет = &ПарныйСчет, 
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций), 
		|			Организация = &Организация
		|				И Субконто1 = &ФизЛицо) КАК ХозрасчетныйОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Валюта,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период, 
		|			Счет = &СчетУчета, 
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций), 
		|			Организация = &Организация 
		|				И Субконто1 = &ФизЛицо) КАК ХозрасчетныйОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОстаткиПоСчетам.Валюта КАК Валюта,
		|	СУММА(ВременнаяТаблицаОстаткиПоСчетам.Сумма) КАК ОстатокНаНачало
		|ИЗ
		|	ВременнаяТаблицаОстаткиПоСчетам КАК ВременнаяТаблицаОстаткиПоСчетам
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОстаткиПоСчетам.Валюта";
	ЗапросСальдоН.УстановитьПараметр("СчетУчета", СчетУчета);
	ЗапросСальдоН.УстановитьПараметр("ПарныйСчет", СчетУчета.ПарныйСчет);
	ТЗСальдо = ЗапросСальдоН.Выполнить().Выгрузить();
	
	КлючСвязи = 1;
		
	ТЗСумм.Индексы.Добавить("Валюта");
	ТЗСальдо.Индексы.Добавить("Валюта");
	ТЗОбменПриход.Индексы.Добавить("Валюта");
	ТЗОбменРасход.Индексы.Добавить("Валюта");
	
	Пока Выборка.Следующий() Цикл
		
		Валюта = Выборка.Валюта;
		СуммаОстаткаПоВалюте = 0;
		
		ЕстьПолеСНеНулевойСуммой = Ложь;
	
		Отбор = Новый Структура();
		Отбор.Вставить("Валюта", Валюта);
		ОтобраннаяТзСальдо 	= ТЗСальдо.НайтиСтроки(Отбор);
		ОстатокНаНачало 	= 0;
		
		Если ОтобраннаяТзСальдо.Количество() <> 0 Тогда
			ОстатокНаНачало 		= ОтобраннаяТзСальдо[0].ОстатокНаНачало;
			СуммаОстаткаПоВалюте 	= ОстатокНаНачало;
			ЕстьПолеСНеНулевойСуммой = Истина;
		КонецЕсли;
		
		Отбор = Новый Структура();
		Отбор.Вставить("Валюта", Валюта);
		ОтобраннаяТзПрихода = ТЗОбменПриход.НайтиСтроки(Отбор);
		ОбменПриход 		= 0;
		
		Если ОтобраннаяТзПрихода.Количество() <> 0 Тогда	
			ОбменПриход = ОтобраннаяТзПрихода[0].ОбменПриход;
			ЕстьПолеСНеНулевойСуммой = Истина;
		КонецЕсли;
		
		Отбор = Новый Структура();
		Отбор.Вставить("Валюта", Валюта);
		ОтобраннаяТзРасхода = ТЗОбменРасход.НайтиСтроки(Отбор);
		ОбменРасход 		= 0;
		
		Если ОтобраннаяТзРасхода.Количество() <> 0 Тогда
			ОбменРасход = ОтобраннаяТзРасхода[0].ОбменРасход;
			ЕстьПолеСНеНулевойСуммой = Истина;
		КонецЕсли;
		
		Отбор = Новый Структура();
		Отбор.Вставить("Валюта", Валюта);
		ОтобраннаяТзСумм = ТЗСумм.НайтиСтроки(Отбор);
		Израсходовано 	 = 0;
		
		Если ОтобраннаяТзСумм.Количество() <> 0 Тогда
			Израсходовано = ОтобраннаяТзСумм[0].Сумма;
			ЕстьПолеСНеНулевойСуммой = Истина;
		КонецЕсли;
		
		Если ЕстьПолеСНеНулевойСуммой Тогда
			Итого 			= ОстатокНаНачало + ОбменПриход - ОбменРасход;
			ОстатокНаКонец  = Итого - Израсходовано;   
			
			СтрокаТабличнойЧасти = ДвижениеДенежныхСредств.Добавить();
			СтрокаТабличнойЧасти.Валюта 		 = Валюта;
			СтрокаТабличнойЧасти.ОстатокНаНачало = ОстатокНаНачало;
			СтрокаТабличнойЧасти.ОбменПриход 	 = ОбменПриход;
			СтрокаТабличнойЧасти.ОбменРасход 	 = ОбменРасход;
			СтрокаТабличнойЧасти.Израсходовано 	 = Израсходовано;	
			СтрокаТабличнойЧасти.Итого 			 = Итого;
			СтрокаТабличнойЧасти.ОстатокНаКонец  = ОстатокНаКонец;
			СтрокаТабличнойЧасти.КлючСвязи		 = КлючСвязи;
			
			Если ОстатокНаНачало <> 0 Тогда
				ЗаполнитьТаблицуДокументов(Валюта, ОстатокНаНачало, ДатаДокумента, КлючСвязи);
			КонецЕсли;
		КонецЕсли;
		
		КлючСвязи = КлючСвязи + 1;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти
	
#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьДокументПоДокументуКомандировка(ДанныеЗаполнения) Экспорт
	ДокументОснование 		= ДанныеЗаполнения;
	Организация				= ДанныеЗаполнения.Организация;
	СуммаДокумента			= ДанныеЗаполнения.СуммаДокумента;
	ФизЛицо 				= ФизЛицоКомандировки(ДанныеЗаполнения);
	СчетУчета               = ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами;
	
	ЗаполнитьАвансы(КонецДня(ТекущаяДатаСеанса()));	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьДокументПоДокументуВедомостьЗаработнойПлаты(ДанныеЗаполнения) Экспорт
	ДокументОснование 		= ДанныеЗаполнения;
	Организация				= ДанныеЗаполнения.Организация;
	
	ЗаполнитьАвансы(КонецДня(ТекущаяДатаСеанса()));	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.Командировка")] = "ЗаполнитьДокументПоДокументуКомандировка";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВедомостьЗаработнойПлаты")] = "ЗаполнитьДокументПоДокументуВедомостьЗаработнойПлаты";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьДанные(Отказ, РежимПроведения);
	
	ОтразитьДвижения(Отказ, РежимПроведения);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)	
	
	БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ФизЛицо");
	БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СуммаДокумента");
	Если ОплатаПоставщикам.Количество() = 0 Тогда
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ОплатаПоставщикам.Контрагент");
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ОплатаПоставщикам.ДоговорКонтрагента");
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ОплатаПоставщикам.Сумма");			
	КонецЕсли;
	
	ВыполнитьПредварительныйКонтроль(Отказ);
	ВыполнитьКонтрольВТабличнойЧастиПрочееПоВременнымСчетам(Отказ);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = 0;
	
	Для Каждого СтрокаТабличнойЧасти Из ОплатаПоставщикам Цикл		
		СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧасти.Сумма 
									* ?(СтрокаТабличнойЧасти.Курс = 0, 1, СтрокаТабличнойЧасти.Курс)  
									/ ?(СтрокаТабличнойЧасти.Кратность = 0, 1, СтрокаТабличнойЧасти.Кратность);				
	КонецЦикла;	
	
	Для Каждого СтрокаТабличнойЧасти Из Прочее Цикл		
		СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧасти.Сумма
									* ?(СтрокаТабличнойЧасти.Курс = 0, 1, СтрокаТабличнойЧасти.Курс)  
									/ ?(СтрокаТабличнойЧасти.Кратность = 0, 1, СтрокаТабличнойЧасти.Кратность);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ОбменВалют Цикл		
		СтруктураВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(СтрокаТабличнойЧасти.ВалютаДо, Дата);		
		СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧасти.СуммаДо 
									* ?(СтруктураВалюты.Курс = 0, 1, СтруктураВалюты.Курс) 
									/ ?(СтруктураВалюты.Кратность = 0, 1, СтруктураВалюты.Кратность);
	КонецЦикла;	
		
	СуммаДокумента = СуммаДокумента + ВыплатаЗаработнойПлаты.Итог("Сумма");
	СуммаДокумента = СуммаДокумента + ТоварыУслуги.Итог("Сумма");
	
	Для Каждого СтрокаТабличнойЧасти Из ВладельцыПатентов Цикл
		// В случае если очистили дату, но не очистили вид документа.
		// Дата нужна для записи в РС "РеестрПриобретенныхМатериальныхРесурсов".
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДатаДокумента) Тогда
			СтрокаТабличнойЧасти.ДатаДокумента = Дата;	
		КонецЕсли;	
	КонецЦикла;		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.АвансовыйОтчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

КонецПроцедуры

// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	УчетТоваров.СформироватьДвиженияПоступлениеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаТовары, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);
	УчетМБП.СформироватьДвиженияПоступлениеМБП(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаМБП,
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);	
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьАвансыПодотчетника(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОПоступлении(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрПриобретенныхМатериальныхРесурсов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьКорректировкиНУ(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрЗакупок(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВыплаченнаяЗарплата(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьДанныеЗакупочныхАктов(ДополнительныеСвойства, Движения, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	ТипЗнчФизЛицо = ТипЗнч(Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ВидСубконто", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Местонахождение);

	Для каждого СтрокаТабличнойЧасти Из ТоварыУслуги Цикл
		Если СтрокаТабличнойЧасти.СчетУчета.ВидыСубконто.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
			Для НомерСубконто = 1 По 3 Цикл
				Если  ТипЗнч(СтрокаТабличнойЧасти["СубконтоДт" + НомерСубконто]) = ТипЗнчФизЛицо Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
						НСтр("ru = 'Субконто Дт'") + НомерСубконто, СтрокаТабличнойЧасти.НомерСтроки, НСтр("ru = 'Товары и услуги'"), ТекстСообщения);
						
					БухгалтерскийУчетСервер.СообщитьОбОшибке(
						ЭтотОбъект,
						ТекстСообщения + " " + НСтр("ru = 'Используйте местонахождение ""Склад"".'"),
						"ТоварыУслуги",
						СтрокаТабличнойЧасти.НомерСтроки,
						"СубконтоДт" + НомерСубконто,
						Отказ);
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;	
	КонецЦикла;	

КонецПроцедуры

Процедура ВыполнитьКонтрольВТабличнойЧастиПрочееПоВременнымСчетам(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АвансовыйОтчетПрочее.НомерСтроки КАК НомерСтроки,
		|	АвансовыйОтчетПрочее.СчетУчета КАК СчетУчета,
		|	АвансовыйОтчетПрочее.ВидУчетаНУ КАК ВидУчетаНУ
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочее
		|ИЗ
		|	&ТабличнаяЧастьПрочее КАК АвансовыйОтчетПрочее
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПрочее.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаПрочее.СчетУчета.Представление КАК СчетУчетаПредставление
		|ИЗ
		|	ВременнаяТаблицаПрочее КАК ВременнаяТаблицаПрочее
		|ГДЕ
		|	НЕ ВременнаяТаблицаПрочее.ВидУчетаНУ = ЗНАЧЕНИЕ(Перечисление.ВидыУчета.ПустаяСсылка)
		|	И НЕ ВременнаяТаблицаПрочее.СчетУчета.Временный";
	
	Запрос.Параметры.Вставить("ТабличнаяЧастьПрочее", Прочее.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
			НСтр("ru = 'Счет Дт'"), ВыборкаДетальныеЗаписи.НомерСтроки, НСтр("ru = 'Прочее'"), ТекстСообщения);		
			
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения + " " + НСтр("ru = 'Для заполненного Вида учета НУ Счет Дт может быть только временным.'"),
			"Прочее",
			ВыборкаДетальныеЗаписи.НомерСтроки,
			"СчетУчета",
			Отказ);
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьТаблицуДокументов(Валюта, СуммаОстатка, ДатаДокумента, КлючСвязи)
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 99
		|	АвансыПодотчетника.ДокументАванса КАК ДокументОплаты,
		|	АвансыПодотчетника.ДатаАванса КАК Дата,
		|	АвансыПодотчетника.Валюта КАК Валюта,
		|	АвансыПодотчетника.Сумма КАК СуммаДокумента
		|ИЗ
		|	РегистрСведений.АвансыПодотчетника КАК АвансыПодотчетника
		|ГДЕ
		|	АвансыПодотчетника.Организация = &Организация
		|	И АвансыПодотчетника.ФизЛицо = &ФизЛицо
		|	И АвансыПодотчетника.СчетУчета = &СчетУчета
		|	И АвансыПодотчетника.Валюта = &Валюта
		|	И АвансыПодотчетника.ДатаАванса < &Дата
		|	И ВЫБОР
		|			КОГДА &СуммаОстатка > 0
		|				ТОГДА АвансыПодотчетника.Сумма > 0
		|			ИНАЧЕ АвансыПодотчетника.Сумма < 0
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";

	Запрос.УстановитьПараметр("Дата", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("СуммаОстатка", СуммаОстатка);
	Запрос.УстановитьПараметр("СчетУчета", СчетУчета);
	
	ТЗДокументов = Запрос.Выполнить().Выгрузить();
	
	СуммаКРаспределению = СуммаОстатка;
	
	Для Каждого СтрокаТЗ Из ТЗДокументов Цикл
		СтрокаТабличнойЧасти = ТаблицаДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТЗ);
		
		СтрокаТабличнойЧасти.КлючСвязи = КлючСвязи;
		
		Если СуммаКРаспределению > 0 Тогда 
			Сумма = Мин(СтрокаТЗ.СуммаДокумента, СуммаКРаспределению); 	
			
			СтрокаТабличнойЧасти.Остаток = Сумма;
			
			СуммаКРаспределению = СуммаКРаспределению - Сумма;
			
			Если СуммаКРаспределению <= 0 Тогда
				Прервать;
			КонецЕсли;
		Иначе
			Сумма = Макс(СтрокаТЗ.СуммаДокумента, СуммаКРаспределению); 	
		
			СтрокаТабличнойЧасти.Остаток = Сумма;
			
			СуммаКРаспределению = СуммаКРаспределению - Сумма;
			
			Если СуммаКРаспределению >= 0 Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры // ПолучитьДанныеТаблицыДокументов()

Функция ФизЛицоКомандировки(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КомандировкаСотрудники.ФизЛицо
		|ИЗ
		|	Документ.Командировка.Сотрудники КАК КомандировкаСотрудники
		|ГДЕ
		|	КомандировкаСотрудники.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	КомандировкаСотрудники.ФизЛицо";
	
	Запрос.Параметры.Вставить("Ссылка", ДокументСсылка);	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат ВыборкаДетальныеЗаписи.ФизЛицо;
	Иначе	
		Возврат Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;	

КонецФункции // ()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли