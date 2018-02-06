﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	Организация				= ДанныеЗаполнения.Организация;
	// Сведения о контрагенте
	Контрагент          	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  	= ДанныеЗаполнения.ДоговорКонтрагента;
	// Валюта
	ВалютаДокумента     	= ДанныеЗаполнения.ВалютаДокумента;
	Курс					= ДанныеЗаполнения.Курс;
	Кратность				= ДанныеЗаполнения.Кратность;
	// Налоги
	СтавкаНДС				= ДанныеЗаполнения.СтавкаНДС;
	СтавкаНСП				= ДанныеЗаполнения.СтавкаНСП;
	СтавкаНСПУслуги			= ДанныеЗаполнения.СтавкаНСПУслуги;
	СуммаВключаетНалоги		= ДанныеЗаполнения.СуммаВключаетНалоги;
	ВидПоставкиНДС      	= ДанныеЗаполнения.ВидПоставкиНДС;
	// Скидки
	ВидСкидкиНаценки    	= ДанныеЗаполнения.ВидСкидкиНаценкидСкидки;
	ПроцентСкидкиНаценки 	= ДанныеЗаполнения.ПроцентСкидкиНаценкиПроцент;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрокаТабличнойЧасти = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Услуги Цикл
		НоваяСтрокаТабличнойЧасти = Услуги.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
	КонецЦикла;

	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	// Проверка заполнения табличных частей
	Если Товары.Количество() = 0
		И Услуги.Количество() = 0 Тогда	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнен ни один список.'"),,,,Отказ)		
	ИначеЕсли Товары.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
	ИначеЕсли Услуги.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСПУслуги");
	КонецЕсли;
	
	Если Курс = 0 Или Кратность = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
			|что у валюты ""%1"" установлен курс на дату %2 или ранее.
			|Перевыберите договор и заново проведите документ.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;

	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаДокумента1.Номенклатура
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
		|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
		|			И ТаблицаДокумента1.Номенклатура = ТаблицаДокумента2.Номенклатура
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДокумента1.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ТаблицаДокумента", Товары);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Дубли строк.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Номенклатура указывается повторно в строке %1 списка ""Товары"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Товары",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Номенклатура",
				Отказ);
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти	

#КонецЕсли