﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
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
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.ОС Цикл
		НоваяСтрока = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.ДокументПоступления = ДанныеЗаполнения.Ссылка;
		НоваяСтрока.Количество = 1;
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоАвансовомуОтчету(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	// Шпка.
	Организация = ДанныеЗаполнения.Организация;

	// Для запонения будет использоваться первая строка табличной части ОплатаПоставщикам.
	Если ДанныеЗаполнения.ОплатаПоставщикам.Количество() = 0 Тогда 
		Возврат;	
	КонецЕсли;	
	
	СтрокаОплатаПоставщикам = ДанныеЗаполнения.ОплатаПоставщикам[0];
	
	Контрагент = СтрокаОплатаПоставщикам.Контрагент;
	ДоговорКонтрагента = СтрокаОплатаПоставщикам.ДоговорКонтрагента;
	Валюта = СтрокаОплатаПоставщикам.Валюта;
	Курс = СтрокаОплатаПоставщикам.Курс;
	Кратность = СтрокаОплатаПоставщикам.Кратность;
	
	СуммаДокумента = СтрокаОплатаПоставщикам.Сумма;
	
	СчетРасчетов = СтрокаОплатаПоставщикам.СчетРасчетов;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.АвансовыйОтчет")] = "ЗаполнитьПоАвансовомуОтчету";
	
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
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;

	Если Курс = 0 Или Кратность = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
			|что у валюты ""%1"" установлен курс на дату %2 или ранее.
			|Перевыберите договор и заново проведите документ.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;

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

Процедура ПриКопировании(ОбъектКопирования)
	СерияБланкаСФ = "";
	НомерБланкаСФ = "";
	ДатаСФ = '00010101';
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготовливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ДополнительныеРасходы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПоступлениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ЗначенияСтавокНалогов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОПоступлении(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрПриобретенныхМатериальныхРесурсов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрЗакупок(ДополнительныеСвойства, Движения, Отказ);
	
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
	
	// Заполнение разультатов
	Если НЕ МассивСуммРаспределенияТовары = Неопределено Тогда
		Товары.ЗагрузитьКолонку(МассивСуммРаспределенияТовары, "СуммаРасходов");	
	КонецЕсли;
	
	Если НЕ МассивСуммРаспределенияНДСТовары = Неопределено Тогда 
		Товары.ЗагрузитьКолонку(МассивСуммРаспределенияНДСТовары, "СуммаРасходовНДС");
	КонецЕсли;

	Если НЕ МассивСуммРаспределенияОС = Неопределено Тогда	
		ОС.ЗагрузитьКолонку(МассивСуммРаспределенияОС, "СуммаРасходов");
	КонецЕсли;	
	
	Если НЕ МассивСуммРаспределенияНДСОС = Неопределено Тогда 
		ОС.ЗагрузитьКолонку(МассивСуммРаспределенияНДСОС, "СуммаРасходовНДС");
	КонецЕсли;
	
КонецПроцедуры // РаспределитьРасходы()

#КонецОбласти

#КонецЕсли