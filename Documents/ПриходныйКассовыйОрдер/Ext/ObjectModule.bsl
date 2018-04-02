﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоДоверенности(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	// Реквизиты печати.
	Приложение = ?(ЗначениеЗаполнено(ДанныеЗаполнения.СерияБланкаСФ), СтрШаблон(НСтр("ru = 'Серия СФ %1 № %2 от %3г.'"),
				ДанныеЗаполнения.СерияБланкаСФ, ДанныеЗаполнения.НомерБланкаСФ, Формат(ДанныеЗаполнения.ДатаСФ, "ДЛФ=D")), "");
				
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего") + ДанныеЗаполнения.ОС.Итог("Всего");
	
	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура("Валюта, Курс, Кратность, ПрямойКурс", ВалютаДокумента, Курс, Кратность, Ложь);
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		ОбработкаТабличныхЧастейКлиентСервер.УстановитьКурсыВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Денежные поступления от покупателей");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоСчетуНаОплатуПокупателю(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	// Реквизиты печати.
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего");
	
	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура("Валюта, Курс, Кратность, ПрямойКурс", ВалютаДокумента, Курс, Кратность, Ложь);
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		ОбработкаТабличныхЧастейКлиентСервер.УстановитьКурсыВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Денежные поступления от покупателей");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВозвратуТоваровПоставщику(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	// Реквизиты печати.
	Приложение = ?(ЗначениеЗаполнено(ДанныеЗаполнения.СерияБланкаСФ), СтрШаблон(НСтр("ru = 'Серия СФ %1 № %2 от %3г.'"),
				ДанныеЗаполнения.СерияБланкаСФ, ДанныеЗаполнения.НомерБланкаСФ, Формат(ДанныеЗаполнения.ДатаСФ, "ДЛФ=D")), "");
				
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего");
	
	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура("Валюта, Курс, Кратность, ПрямойКурс", ВалютаДокумента, Курс, Кратность, Ложь);
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		ОбработкаТабличныхЧастейКлиентСервер.УстановитьКурсыВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.Доверенность")] = "ЗаполнитьПоДоверенности";
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.СчетНаОплатуПокупателю")] = "ЗаполнитьПоСчетуНаОплатуПокупателю";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровПоставщику")] = "ЗаполнитьПоВозвратуТоваровПоставщику";

	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	ДатаДокумента = Дата(1,1,1);
	
	Если ЗначениеЗаполнено(Касса)
		И НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = Касса.ВалютаДенежныхСредств;
		
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
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Организация);
	
	Если НЕ ЗначениеЗаполнено(ВидДеятельности) И ДанныеУчетнойПолитики.ПлательщикЕН Тогда
			
		ВидДеятельности = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойВидДеятельности(); 	
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа");

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход Тогда 
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
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ОплатаОтПокупателя
		Или ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
		Или ВидОперации = Перечисления.ВидыОперацийПКО.РасчетыПоЗаймам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтСотрудника Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетника Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");

	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
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
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход
		И НЕ РасшифровкаПлатежа.Количество() = 0 Тогда 
		РасшифровкаПлатежа.Очистить();
	ИначеЕсли НЕ ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход
		И НЕ ПрочиеПлатежи.Количество() = 0 Тогда
		ПрочиеПлатежи.Очистить();
	КонецЕсли;
	
	СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа") + ПрочиеПлатежи.Итог("СуммаПлатежа");
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПриходныйКассовыйОрдер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	ЭтоКонвертация = ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация;
	УчетДенежныхСредств.СформироватьДвиженияОперационнаяКурсоваяРазница(ДополнительныеСвойства, Движения, Отказ, Истина, ЭтоКонвертация);
	
	БухгалтерскийУчетСервер.ОтразитьДДС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВозвратПодотчетником(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьАвансыПодотчетника(ДополнительныеСвойства, Движения, Отказ);
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
	
#КонецЕсли
