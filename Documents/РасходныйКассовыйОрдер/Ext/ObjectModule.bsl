﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения.Свойство("ВедомостьЗаработнойПлаты") Тогда 
		ЗаполнитьПоВедомостиЗП(ДанныеЗаполнения);
	ИначеЕсли ДанныеЗаполнения.Свойство("Командировка") Тогда
		ЗаполнитьДокументПоДокументуКомандировка(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВедомостиЗП(ДанныеЗаполнения) Экспорт
	// Общий 	
	Если ДанныеЗаполнения.Свойство("ТаблицаЗначений") Тогда 
		ДокументОснование = ДанныеЗаполнения.ВедомостьЗаработнойПлаты;
		ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗП;
		
		// Заполнение шапки
		Организация = ДанныеЗаполнения.Организация;
		СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		Касса = ДанныеЗаполнения.Касса;
		СчетРасчетов = ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата;
		Выдать = НСтр("ru = 'На зарплату'");
		
		НазваниеДокумента = НСтр("ru = 'Ведомость ЗП'");
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеЗаполнения.НомерВыплаты);
		Основание = СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),НазваниеДокумента, НомерНаПечать, Формат(ДанныеЗаполнения.Дата, "ДЛФ=DD"));
		
		ОбщаяСуммаДокумента = 0;
		// Заполнение Табличной части
		ВыплатаЗаработнойПлаты.Очистить();
		Для Каждого СтрокаТаблицы Из ДанныеЗаполнения.ТаблицаЗначений Цикл 
			СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
			СтрокаТабличнойЧасти.ФизЛицо = СтрокаТаблицы.ФизЛицо;
			СтрокаТабличнойЧасти.СуммаПлатежа = СтрокаТаблицы.СуммаПоКассе;
			ОбщаяСуммаДокумента = ОбщаяСуммаДокумента + СтрокаТаблицы.СуммаПоКассе;
		КонецЦикла;
		СуммаДокумента = ОбщаяСуммаДокумента;
		                  
	// Индивидуальные	
	Иначе 
		ДокументОснование = ДанныеЗаполнения.ВедомостьЗаработнойПлаты;
		ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗП;
		ИндивидуальныйРКО = Истина;
		
		// Заполнение шапки
		ФизЛицо = ДанныеЗаполнения.ФизЛицо;
		Организация = ДанныеЗаполнения.Организация;
		СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		Касса = ДанныеЗаполнения.Касса;
		СуммаДокумента = ДанныеЗаполнения.СуммаПоКассе;
		СчетРасчетов = ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата;
		
		НазваниеДокумента = НСтр("ru = 'Ведомость ЗП'");
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеЗаполнения.НомерВыплаты);
		Основание = СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),НазваниеДокумента, НомерНаПечать, Формат(ДанныеЗаполнения.Дата, "ДЛФ=DD"));
		
		Выдать = ДанныеЗаполнения.ФизЛицо;
		
		ВыплатаЗаработнойПлаты.Очистить();
		СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
		СтрокаТабличнойЧасти.ФизЛицо = ДанныеЗаполнения.ФизЛицо;
		СтрокаТабличнойЧасти.СуммаПлатежа = ДанныеЗаполнения.СуммаПоКассе;
	КонецЕсли;	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВыплатеЗП(ДанныеЗаполнения) Экспорт
	// Общий 	
	Если ДанныеЗаполнения.Свойство("ТаблицаЗначений") Тогда 
		ДокументОснование = ДанныеЗаполнения.ВыплатаЗП;
		ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗП; 
		
		// Заполнение шапки
		Организация = ДанныеЗаполнения.Организация;
		Касса = ДанныеЗаполнения.Касса;
		ПоВедомости = Ложь;
		СчетРасчетов = ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата;
		Выдать = НСтр("ru = 'На зарплату'");
		
		НазваниеДокумента = НСтр("ru = 'Ведомость ЗП'");
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеЗаполнения.НомерВыплаты);
		Основание = СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),НазваниеДокумента, НомерНаПечать, Формат(ДанныеЗаполнения.Дата, "ДЛФ=DD"));
		
		ОбщаяСуммаДокумента = 0;
		// Заполнение Табличной части
		ВыплатаЗаработнойПлаты.Очистить();
		Для Каждого СтрокаТаблицы Из ДанныеЗаполнения.ТаблицаЗначений Цикл 
			СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
			СтрокаТабличнойЧасти.ФизЛицо = СтрокаТаблицы.ФизЛицо;
			//СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
			СтрокаТабличнойЧасти.СуммаПлатежа = СтрокаТаблицы.СуммаКВыплате;
			//СтрокаТабличнойЧасти.Ведомость = ДанныеЗаполнения;
			ОбщаяСуммаДокумента = ОбщаяСуммаДокумента + СтрокаТаблицы.СуммаКВыплате;
		КонецЦикла;
		СуммаДокумента = ОбщаяСуммаДокумента;
		                  
	// Индивидуальные	
	Иначе 
		ДокументОснование = ДанныеЗаполнения.ВыплатаЗП;
		ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗП;
		ИндивидуальныРКО = Истина;
		
		// Заполнение шапки
		ФизЛицо = ДанныеЗаполнения.ФизЛицо;
		Организация = ДанныеЗаполнения.Организация;
		Касса = ДанныеЗаполнения.Касса;
		СуммаДокумента = ДанныеЗаполнения.СуммаКВыплате;
		ПоВедомости = Ложь;
		СчетРасчетов = ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата;
		
		НазваниеДокумента = НСтр("ru = 'Ведомость ЗП'");
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеЗаполнения.НомерВыплаты);
		Основание = СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),НазваниеДокумента, НомерНаПечать, Формат(ДанныеЗаполнения.Дата, "ДЛФ=DD"));
		
		Выдать = ДанныеЗаполнения.ФизЛицо;
		
		ВыплатаЗаработнойПлаты.Очистить();
		СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
		СтрокаТабличнойЧасти.ФизЛицо = ДанныеЗаполнения.ФизЛицо;
		//СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		СтрокаТабличнойЧасти.СуммаПлатежа = ДанныеЗаполнения.СуммаКВыплате;
		//СтрокаТабличнойЧасти.Ведомость = ДанныеЗаполнения.ВыплатаЗП;
	КонецЕсли;	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьДокументПоДокументуКомандировка(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	
	Организация = ДанныеЗаполнения.Организация;
	СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	
	Если ДанныеЗаполнения.Сотрудники.Количество() > 0 Тогда 
		ФизЛицо = ДанныеЗаполнения.Сотрудники[0].ФизЛицо;	
	КонецЕсли;	
	
	ВидОперации = Перечисления.ВидыОперацийРКО.ВыдачаПодотчетнику;

	Для Каждого СтрокаКомандировка Из ДанныеЗаполнения.Сотрудники Цикл
		СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
		СтрокаТабличнойЧасти.СуммаПлатежа = СтрокаКомандировка.СуммаВсего;	
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СтрокаКомандировка.СуммаВсего;	
	КонецЦикла;
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения.ДокументОснование;

	// Шапка
	ВидОперации = Перечисления.ВидыОперацийРКО.ОплатаПоставщику;			
	Организация = ДанныеЗаполнения.Организация;
	Касса = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнуюКассуОрганизации(Организация);
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;

	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	КурсыВалют = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, Дата);
	КурсВзаиморасчетов = КурсыВалют.Курс;
	КратностьВзаиморасчетов = КурсыВалют.Кратность;
	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего") + ДанныеЗаполнения.ОС.Итог("Всего");
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;

	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
	СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента * КурсВзаиморасчетов * КратностьВзаиморасчетов;	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоДополнительнымРасходам(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	// Шапка
	ВидОперации = Перечисления.ВидыОперацийРКО.ОплатаПоставщику;			
	Организация = ДанныеЗаполнения.Организация;
	Касса = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнуюКассуОрганизации(Организация);
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;

	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	КурсыВалют = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, Дата);
	КурсВзаиморасчетов = КурсыВалют.Курс;
	КратностьВзаиморасчетов = КурсыВалют.Кратность;
	СуммаДокумента = ДанныеЗаполнения.СуммаДопРасходов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;

	// Расшифровка платежа
	РасшифровкаПлатежа.Очистить();
	
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
	СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента * КурсВзаиморасчетов * КратностьВзаиморасчетов;	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВозвратуОтПокупателя(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	// Шапка
	ВидОперации = Перечисления.ВидыОперацийРКО.ВозвратПокупателю;			
	Организация = ДанныеЗаполнения.Организация;
	Касса = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнуюКассуОрганизации(Организация);
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;

	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	КурсыВалют = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, Дата);
	КурсВзаиморасчетов = КурсыВалют.Курс;
	КратностьВзаиморасчетов = КурсыВалют.Кратность;
	СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;

	// Расшифровка платежа
	РасшифровкаПлатежа.Очистить();
	
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
	СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента * КурсВзаиморасчетов * КратностьВзаиморасчетов;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВедомостьЗаработнойПлаты")] = "ЗаполнитьПоВедомостиЗП";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.Командировка")] = "ЗаполнитьДокументПоДокументуКомандировка";
	СтратегияЗаполнения[Тип("ДокументСсылка.ДополнительныеРасходы")] = "ЗаполнитьПоДополнительнымРасходам";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")] = "ЗаполнитьПоВозвратуОтПокупателя";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	ДатаДокумента = Дата(1,1,1);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") 
		И ДанныеЗаполнения.ВалютаДокумента <> ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета() Тогда
		Касса = ПолучитьКассу(ДанныеЗаполнения.ВалютаДокумента);
		ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Касса) Тогда
		ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	КонецЕсли;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	Если НЕ ЗначениеЗаполнено(Курс) Тогда
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
		Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
			Курс = КурсСтруктура.Курс;
			Кратность = КурсСтруктура.Кратность; 
		Иначе
			Курс = 1;
			Кратность = 1;
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа");

	МассивНепроверяемыхРеквизитов = Новый Массив;	
	
	Если ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасход Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		
		ПроверяемыеРеквизиты.Добавить("ПрочиеПлатежи");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ОплатаПоставщику
		Или ВидОперации = Перечисления.ВидыОперацийРКО.ВозвратПокупателю
		Или ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыПоЗаймам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗП Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");

		ПроверяемыеРеквизиты.Добавить("ВыплатаЗаработнойПлаты");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ВыдачаПодотчетнику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ВзносВБанк Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.Инкассация Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
	КонецЕсли;
	
	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасход
		И НЕ (РасшифровкаПлатежа.Количество() = 0
			И ВыплатаЗаработнойПлаты.Количество() = 0) Тогда 
		РасшифровкаПлатежа.Очистить();
		ВыплатаЗаработнойПлаты.Очистить();
	ИначеЕсли ВидОперации =  Перечисления.ВидыОперацийРКО.ВыплатаЗП	
		И НЕ (РасшифровкаПлатежа.Количество() = 0
			И ПрочиеПлатежи.Количество() = 0) Тогда 
		РасшифровкаПлатежа.Очистить();
		ПрочиеПлатежи.Очистить();
	ИначеЕсли НЕ (ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасход
			ИЛИ ВидОперации =  Перечисления.ВидыОперацийРКО.ВыплатаЗП)
			И НЕ (ВыплатаЗаработнойПлаты.Количество() = 0
			И ПрочиеПлатежи.Количество() = 0) Тогда 
		ВыплатаЗаработнойПлаты.Очистить();
		ПрочиеПлатежи.Очистить();
	КонецЕсли;
	
	СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа") + ВыплатаЗаработнойПлаты.Итог("СуммаПлатежа") + ПрочиеПлатежи.Итог("СуммаПлатежа");
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.РасходныйКассовыйОрдер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	УчетДенежныхСредств.СформироватьДвиженияОперационнаяКурсоваяРазница(ДополнительныеСвойства, Движения, Отказ, Ложь);
	БухгалтерскийУчетСервер.ОтразитьДДС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьДанныеРеестраГТД(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьАвансыПодотчетника(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВыплаченнаяЗарплата(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьОборотыПоДаннымЕдиногоНалога(ДополнительныеСвойства, Движения, Отказ);

	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - получение валютной кассы.
//
// Параметры:
//	Валюта - СправочникСсылка.Валюты - валюта документа основания.
//
// Возвращаемое значение:
//	Ссылка - СправочникСсылка.Кассы - найденная касса по валюте и организации или пустая ссылка.
//
Функция ПолучитьКассу(Валюта)

	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Кассы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|ГДЕ
		|	Кассы.Владелец = &Владелец
		|	И Кассы.ВалютаДенежныхСредств = &ВалютаДенежныхСредств";
	Запрос.УстановитьПараметр("Владелец", Организация);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", Валюта);
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;	
	Иначе	
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;	

КонецФункции // ПолучитьБанковскийСчет()

#КонецОбласти

#КонецЕсли