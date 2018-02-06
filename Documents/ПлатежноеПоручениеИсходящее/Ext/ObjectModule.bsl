﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения.Свойство("ВедомостьЗП") Тогда 
		ЗаполнитьПоВедомостиЗП(ДанныеЗаполнения, 2);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВедомостиЗП(ДанныеЗаполнения, ВидДокументаВыплаты = 1) Экспорт
	// Общий 
	Если ДанныеЗаполнения.Свойство("ТаблицаЗначений") Тогда 
		ДокументОснование = ДанныеЗаполнения.ВедомостьЗП;
		ВидОперации = Перечисления.ВидыОперацийППИ.ВыплатаЗП;
		
		// Заполнение шапки
		Организация = ДанныеЗаполнения.Организация;
		БанковскийСчет = ДанныеЗаполнения.БанковскийСчет;
		СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		ОбщийППИ = Истина;
		
		ОбщаяСуммаДокумента = 0;
		// Заполнение Табличной части
		ВыплатаЗаработнойПлаты.Очистить();
		Для Каждого СтрокаТаблицы Из ДанныеЗаполнения.ТаблицаЗначений Цикл
			СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
			СтрокаТабличнойЧасти.ФизЛицо = СтрокаТаблицы.ФизЛицо;
			СтрокаТабличнойЧасти.СуммаПлатежа = СтрокаТаблицы.СуммаПоКартСчету;
			ОбщаяСуммаДокумента = ОбщаяСуммаДокумента + СтрокаТаблицы.СуммаПоКартСчету;
		КонецЦикла;
		СуммаДокумента = ОбщаяСуммаДокумента;
		
	// Индивидуальные	
	Иначе 
		ДокументОснование = ДанныеЗаполнения.ВедомостьЗП;
		ВидОперации = Перечисления.ВидыОперацийППИ.ВыплатаЗП; 
		
		// Заполнение шапки
		Организация = ДанныеЗаполнения.Организация;
		БанковскийСчет = ДанныеЗаполнения.БанковскийСчет;
		СуммаДокумента = ДанныеЗаполнения.СуммаКВыплате;
		СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		
		ВыплатаЗаработнойПлаты.Очистить();
		СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
		СтрокаТабличнойЧасти.ФизЛицо = ДанныеЗаполнения.ФизЛицо;
		СтрокаТабличнойЧасти.СуммаПлатежа = ДанныеЗаполнения.СуммаКВыплате;
		СтрокаТабличнойЧасти.БанковскийСчет = ДанныеЗаполнения.БанковскийСчетПолучателя;
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
		ВидОперации = Перечисления.ВидыОперацийППИ.ВыплатаЗП; 
		
		// Заполнение шапки
		Организация = ДанныеЗаполнения.Организация;
		БанковскийСчет = ДанныеЗаполнения.БанковскийСчет;
		СчетУчета = ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата;
		Банк = ДанныеЗаполнения.ТаблицаЗначений[0].Банк;
		
		ОбщаяСуммаДокумента = 0;
		// Заполнение Табличной части
		ВыплатаЗаработнойПлаты.Очистить();
		Для Каждого СтрокаТаблицы Из ДанныеЗаполнения.ТаблицаЗначений Цикл
			СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
			СтрокаТабличнойЧасти.ФизЛицо = СтрокаТаблицы.ФизЛицо;
			//СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
			СтрокаТабличнойЧасти.СуммаПлатежа = СтрокаТаблицы.СуммаКВыплате;
			//СтрокаТабличнойЧасти.КартСчет = СтрокаТаблицы.КартСчет;
			СтрокаТабличнойЧасти.БанковскийСчет = СтрокаТаблицы.БанковскийСчет;
			//СтрокаТабличнойЧасти.Ведомость = ДанныеЗаполнения.ВыплатаЗП;
			ОбщаяСуммаДокумента = ОбщаяСуммаДокумента + СтрокаТаблицы.СуммаКВыплате;
		КонецЦикла;
		СуммаДокумента = ОбщаяСуммаДокумента;
		
	// Индивидуальные	
	Иначе 
		ДокументОснование = ДанныеЗаполнения.ВыплатаЗП;
		ВидОперации = Перечисления.ВидыОперацийППИ.ВыплатаЗП; 
		
		// Заполнение шапки
		Организация = ДанныеЗаполнения.Организация;
		БанковскийСчет = ДанныеЗаполнения.БанковскийСчет;
		СуммаДокумента = ДанныеЗаполнения.СуммаКВыплате;
		СчетУчета = ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата;
		Банк = ДанныеЗаполнения.Банк;
		
		ВыплатаЗаработнойПлаты.Очистить();
		СтрокаТабличнойЧасти = ВыплатаЗаработнойПлаты.Добавить();
		СтрокаТабличнойЧасти.ФизЛицо = ДанныеЗаполнения.ФизЛицо;
		//СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		СтрокаТабличнойЧасти.СуммаПлатежа = ДанныеЗаполнения.СуммаКВыплате;
		СтрокаТабличнойЧасти.БанковскийСчет = ДанныеЗаполнения.БанковскийСчетПолучателя;
		//СтрокаТабличнойЧасти.Ведомость = ДанныеЗаполнения.ВыплатаЗП;
	КонецЕсли;	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;	
	
	// Шапка
	Организация = ДанныеЗаполнения.Организация;
	ВидОперации = Перечисления.ВидыОперацийППИ.ОплатаПоставщику;
	Контрагент = ДанныеЗаполнения.Контрагент;
	БанковскийСчетПолучателя = Контрагент.ОсновнойБанковскийСчет;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	КурсыВалют = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, Дата);
	КурсВзаиморасчетов = КурсыВалют.Курс;
	КратностьВзаиморасчетов = КурсыВалют.Кратность;

	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего") + ДанныеЗаполнения.ОС.Итог("Всего");
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПоставщика;

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
	Организация = ДанныеЗаполнения.Организация;
	ВидОперации = Перечисления.ВидыОперацийППИ.ОплатаПоставщику;
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	БанковскийСчетПолучателя = Контрагент.ОсновнойБанковскийСчет;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	КурсыВалют = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, Дата);
	КурсВзаиморасчетов = КурсыВалют.Курс;
	КратностьВзаиморасчетов = КурсыВалют.Кратность;

	СуммаДокумента = ДанныеЗаполнения.Расходы.Итог("Сумма");
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПоставщика;

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
	
	ВидОперации = Перечисления.ВидыОперацийППИ.ВозвратПокупателю;
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	БанковскийСчетПолучателя = Контрагент.ОсновнойБанковскийСчет;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	КурсыВалют = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, Дата);
	КурсВзаиморасчетов = КурсыВалют.Курс;
	КратностьВзаиморасчетов = КурсыВалют.Кратность;

	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Сумма");
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
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
	СтратегияЗаполнения[Тип("ДокументСсылка.ВедомостьЗП")] = "ЗаполнитьПоВедомостиЗП";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.ДополнительныеРасходы")] = "ЗаполнитьПоДополнительнымРасходам";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")] = "ЗаполнитьПоВозвратуОтПокупателя";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	// Комиссия банка.
	Если ЗначениеЗаполнено(БанковскийСчет) 
		И ЗначениеЗаполнено(БанковскийСчет.СуммаКомиссияБанка)
		И НЕ ЗначениеЗаполнено(СуммаКомиссияБанка) Тогда
		
		СниматьКомиссиюБанка = Истина;
		СуммаКомиссияБанка = БанковскийСчет.СуммаКомиссияБанка;
		
		Если НЕ ЗначениеЗаполнено(СчетЗатратКомиссияБанка) Тогда
			СчетЗатратКомиссияБанка = ПланыСчетов.Хозрасчетный.ПрочиеОбщиеИАдминистративныеРасходы;	
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(БанковскийСчет)
		И НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = БанковскийСчет.ВалютаДенежныхСредств;
		
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

		Если ЗначениеЗаполнено(ВалютаДокумента)
			И НЕ ВалютаДокумента = ВалютаРегламентированногоУчета Тогда		
			
			ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());

			КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
			Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
				Курс = КурсСтруктура.Курс;
				Кратность = КурсСтруктура.Кратность; 
			Иначе
				Курс = 1;
				Кратность = 1;
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийППИ.ПрочийРасход")
		И НЕ (РасшифровкаПлатежа.Количество() = 0
		И ВыплатаЗаработнойПлаты.Количество() = 0) Тогда 
		РасшифровкаПлатежа.Очистить();
		ВыплатаЗаработнойПлаты.Очистить();
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийППИ.ВыплатаЗП")		
		И НЕ (РасшифровкаПлатежа.Количество() = 0
		И ПрочиеПлатежи.Количество() = 0) Тогда 
		РасшифровкаПлатежа.Очистить();
		ПрочиеПлатежи.Очистить();
	ИначеЕсли НЕ (ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийППИ.ПрочийРасход")
		ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийППИ.ВыплатаЗП"))
		И НЕ (ВыплатаЗаработнойПлаты.Количество() = 0
		И ПрочиеПлатежи.Количество() = 0) Тогда 
		ВыплатаЗаработнойПлаты.Очистить();
		ПрочиеПлатежи.Очистить();
	КонецЕсли;

	СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа") + ПрочиеПлатежи.Итог("СуммаПлатежа") + ВыплатаЗаработнойПлаты.Итог("СуммаПлатежа");

КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа");

	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если ВидОперации = Перечисления.ВидыОперацийППИ.ПрочийРасход Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчетПолучателя");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		
		ПроверяемыеРеквизиты.Добавить("ПрочиеПлатежи");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийППИ.ПереводНаДругойСчет Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		
		ПроверяемыеРеквизиты.Добавить("БанковскийСчетПолучателя");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийППИ.ВыплатаЗП Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		
		ПроверяемыеРеквизиты.Добавить("ВыплатаЗаработнойПлаты");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийППИ.ВыдачаПодотчетнику Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");

	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийППИ.ОплатаПоставщику
		Или ВидОперации = Перечисления.ВидыОперацийППИ.РасчетыПоЗаймам
		Или ВидОперации = Перечисления.ВидыОперацийППИ.ВозвратПокупателю Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийППИ.ОплатаНалогов Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;	
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПлатежноеПоручениеИсходящее.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	УчетДенежныхСредств.СформироватьДвиженияОперационнаяКурсоваяРазница(ДополнительныеСвойства, Движения, Отказ, Ложь);
	БухгалтерскийУчетСервер.ОтразитьДДС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВыплаченнаяЗарплата(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьДанныеРеестраГТД(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьАвансыПодотчетника(ДополнительныеСвойства, Движения, Отказ);
	
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


#КонецЕсли