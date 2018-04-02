﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	Контрагент = ДанныеЗаполнения.Контрагент;
	Курс = ДанныеЗаполнения.Курс;
	Организация = ДанныеЗаполнения.Организация;
	ЗначениеСтавкиНДС = ДанныеЗаполнения.ЗначениеСтавкиНДС;
	ЗначениеСтавкиНСП = ДанныеЗаполнения.ЗначениеСтавкиНСП;
	СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	СчетРасчетов = ДанныеЗаполнения.СчетРасчетов;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.ДокументПоступления = ДанныеЗаполнения.Ссылка;
		//НоваяСтрока.СуммаРасходовНДС = СтрокаТабличнойЧасти.СуммаНДС;
		//НоваяСтрока.СуммаРасходовНСП = СтрокаТабличнойЧасти.СуммаНСП;		
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.ОС Цикл
		НоваяСтрока = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.ДокументПоступления = ДанныеЗаполнения.Ссылка;
		//НоваяСтрока.СуммаРасходовНДС = СтрокаТабличнойЧасти.СуммаНДС;
		//НоваяСтрока.СуммаРасходовНСП = СтрокаТабличнойЧасти.СуммаНСП;
		НоваяСтрока.Количество = 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);

КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	СуммаРезультатРаспределения = Товары.Итог("СуммаРасходов") + ОС.Итог("СуммаРасходов");
	
	СуммаРезультатРаспределенияССуммойНДС = СуммаРезультатРаспределения + СуммаНДС;
	
	Если НЕ СуммаРезультатРаспределенияССуммойНДС = СуммаДопРасходов Тогда
		ТекстСообщения = НСтр("ru = 'Сумма расходов не равна распределенной сумме по товарам и основным средствам.
			|Сумма расходов к распределению: %1.
			|Сумма результат распределения: %2.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, СуммаДопРасходов, СуммаДопРасходов);	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;

	Если Курс = 0 Или Кратность = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
			|что у валюты ""%1"" установлен курс на дату %2 или ранее.
			|Перевыберите договор и заново проведите документ.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;

	//Если ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС ИЛИ ПризнакСтраны = Перечисления.ПризнакиСтраны.ИмпортЭкспорт Тогда
	Если СуммаНДС = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СуммаРасходовНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СуммаРасходовНДС");
	КонецЕсли;	
	
	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = СуммаДопРасходов;
	
	// Заполнение документа основания для возможности изменения настройки.
	Если ПолучитьФункциональнуюОпцию("ДопРасходыНаОдноПоступление") Тогда 
		Для Каждого СтрокаТабличнойЧасти Из Товары Цикл 
			СтрокаТабличнойЧасти.ДокументПоступления = ДокументОснование;	
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ДополнительныеРасходы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПоступлениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрВвезенных(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ЗначенияСтавокНалогов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОПоступлении(ДополнительныеСвойства, Движения, Отказ);
	
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

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Процедура выполняет распределение затрат по количеству.
//
Процедура РаспределитьРасходы() Экспорт	
	
	Если СпособРаспределения = Перечисления.СпособыРаспределенияДопРасходов.ПоКоличеству Тогда 
		
		КоэффициентыРаспределенияВКолонкеТовары = Товары.ВыгрузитьКолонку("Количество");
		КоэффициентыРаспределенияВКолонкеОС = ОС.ВыгрузитьКолонку("Количество");
		
		ТоварыИтог = Товары.Итог("Количество");
		ОСИтог = ОС.Итог("Количество");
		
	ИначеЕсли СпособРаспределения = Перечисления.СпособыРаспределенияДопРасходов.ПоСумме Тогда	
		
		КоэффициентыРаспределенияВКолонкеТовары = Товары.ВыгрузитьКолонку("Сумма");
		КоэффициентыРаспределенияВКолонкеОС = ОС.ВыгрузитьКолонку("Сумма");
		
		ТоварыИтог = Товары.Итог("Сумма");
		ОСИтог = ОС.Итог("Сумма");
	КонецЕсли;
	
	// Обнуление сумм.
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл 
		СтрокаТабличнойЧасти.СуммаРасходов = 0;
	КонецЦикла;	
	
	Для Каждого СтрокаТабличнойЧасти Из ОС Цикл 
		СтрокаТабличнойЧасти.СуммаРасходов = 0;
	КонецЦикла;	
	
	МассивОбщихСумм = Новый Массив;
	МассивОбщихСумм.Добавить(ТоварыИтог);
	МассивОбщихСумм.Добавить(ОСИтог);
	
	// Сумма
	Если НЕ СуммаДопРасходов = 0 Тогда 
		МассивРаспределениеМеждуТабличнымиЧастями = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаДопРасходов - СуммаНДС, МассивОбщихСумм, 2);
		СуммаРасходовТовары 				= МассивРаспределениеМеждуТабличнымиЧастями[0];
		СуммаРасходовОС 					= МассивРаспределениеМеждуТабличнымиЧастями[1];
		МассивСуммРаспределенияТовары		= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРасходовТовары, КоэффициентыРаспределенияВКолонкеТовары, 2);
		МассивСуммРаспределенияОС			= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРасходовОС, КоэффициентыРаспределенияВКолонкеОС, 2);
	КонецЕсли;	
	
	// НДС
	Если НЕ СуммаНДС = 0 Тогда 
		МассивРаспределениеМеждуТабличнымиЧастями = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаНДС, МассивОбщихСумм, 2);
		СуммаРасходовНДСТовары 				= МассивРаспределениеМеждуТабличнымиЧастями[0];
		СуммаРасходовНДСОС 					= МассивРаспределениеМеждуТабличнымиЧастями[1];
		МассивСуммРаспределенияНДСТовары	= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРасходовНДСТовары, КоэффициентыРаспределенияВКолонкеТовары, 2);
		МассивСуммРаспределенияНДСОС		= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРасходовНДСОС, КоэффициентыРаспределенияВКолонкеОС, 2);
	КонецЕсли;	
	
	//// НСП
	//Если НЕ СуммаНСП = 0 Тогда 
	//	МассивРаспределениеМеждуТабличнымиЧастями = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаНСП, МассивОбщихСумм, 2);
	//	СуммаРасходовНСПТовары 				= МассивРаспределениеМеждуТабличнымиЧастями[0];
	//	СуммаРасходовНСПОС 					= МассивРаспределениеМеждуТабличнымиЧастями[1];
	//	МассивСуммРаспределенияНСПТовары	= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРасходовНСПТовары, КоэффициентыРаспределенияВКолонкеТовары, 2);
	//	МассивСуммРаспределенияНСПОС		= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРасходовНСПОС, КоэффициентыРаспределенияВКолонкеОС, 2);
	//КонецЕсли;	
	
	// Заполнение разультатов
	Если НЕ МассивСуммРаспределенияТовары = Неопределено Тогда
		Товары.ЗагрузитьКолонку(МассивСуммРаспределенияТовары, "СуммаРасходов");	
	КонецЕсли;
	
	Если НЕ МассивСуммРаспределенияНДСТовары = Неопределено Тогда 
		Товары.ЗагрузитьКолонку(МассивСуммРаспределенияНДСТовары, "СуммаРасходовНДС");
	КонецЕсли;
	
	//Если НЕ МассивСуммРаспределенияНСПТовары = Неопределено Тогда  
	//	Товары.ЗагрузитьКолонку(МассивСуммРаспределенияНСПТовары, "СуммаРасходовНСП");
	//КонецЕсли;	

	Если НЕ МассивСуммРаспределенияОС = Неопределено Тогда	
		ОС.ЗагрузитьКолонку(МассивСуммРаспределенияОС, "СуммаРасходов");
	КонецЕсли;	
	
	Если НЕ МассивСуммРаспределенияНДСОС = Неопределено Тогда 
		ОС.ЗагрузитьКолонку(МассивСуммРаспределенияНДСОС, "СуммаРасходовНДС");
	КонецЕсли;
	
	//Если НЕ МассивСуммРаспределенияНСПОС = Неопределено Тогда 
	//	ОС.ЗагрузитьКолонку(МассивСуммРаспределенияНСПОС, "СуммаРасходовНСП");
	//КонецЕсли;	
	
КонецПроцедуры // РаспределитьРасходы()

#КонецОбласти

#КонецЕсли