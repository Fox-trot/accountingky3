﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоСчетуНаОплатуПокупателю(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	Организация				= ДанныеЗаполнения.Организация;
	// Сведения о контрагенте
	Контрагент          	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  	= ДанныеЗаполнения.ДоговорКонтрагента;
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов 			= СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;			
	// Валюта
	ВалютаДокумента     	= ДанныеЗаполнения.ВалютаДокумента;
	Курс					= ДанныеЗаполнения.Курс;
	Кратность				= ДанныеЗаполнения.Кратность;
	// Налоги
	СтавкаНДС				= ДанныеЗаполнения.СтавкаНДС;
	СтавкаНСП				= ДанныеЗаполнения.СтавкаНСП;
	СтавкаНСПУслуги			= ДанныеЗаполнения.СтавкаНСПУслуги;
	СуммаВключаетНалоги		= ДанныеЗаполнения.СуммаВключаетНалоги;
	// Скидки
	ВидСкидкиНаценки    	= ДанныеЗаполнения.ВидСкидкиНаценки;
	ПроцентСкидкиНаценки 	= ДанныеЗаполнения.ПроцентСкидкиНаценки;
	Если ЗначениеЗаполнено(ВидСкидкиНаценки) Тогда 
		СчетУчетаСкидок 	= ПланыСчетов.Хозрасчетный.ВозвратПроданныхТоваровИСкидки;
	КонецЕсли;	
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрокаТабличнойЧасти = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		
		СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(Организация, СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СчетаУчетаНоменклатуры);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Услуги Цикл
		НоваяСтрокаТабличнойЧасти = Услуги.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		
		СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(Организация, СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СчетаУчетаНоменклатуры);
	КонецЦикла;

	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//
Процедура ЗаполнитьПоДвижениюМБП(ДанныеЗаполнения) Экспорт
	ДокументОснование 	= ДанныеЗаполнения;
	Организация 		= ДанныеЗаполнения.Организация;
	Дата 				= ДанныеЗаполнения.Дата;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.СчетНаОплатуПокупателю")] = "ЗаполнитьПоСчетуНаОплатуПокупателю";
	СтратегияЗаполнения[Тип("ДокументСсылка.ДвижениеМБП")] = "ЗаполнитьПоДвижениюМБП";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда		
		БанковскийСчет = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойБанковскийСчетОрганизации(Организация);		
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	// Проверка заполнения табличных частей
	Если Товары.Количество() = 0
		И Услуги.Количество() = 0
		И ОС.Количество() = 0 Тогда	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнен ни один список.'"),,,,Отказ)		
	ИначеЕсли Товары.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
	ИначеЕсли Услуги.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСПУслуги");
	КонецЕсли;
	
	Если Товары.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	// Проверка заполнения Скидки/Наценки
	Если НЕ ЗначениеЗаполнено(ВидСкидкиНаценки) Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаСкидок");
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
	
	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего") + ОС.Итог("Всего");
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.РеализацияТоваровУслуг.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСчетаФактурыВыписанные(ДополнительныеСвойства, Движения, Отказ);

	БухгалтерскийУчетСервер.ОтразитьБланкиСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьНДС(ДополнительныеСвойства, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьСобытияОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСостоянияОС(ДополнительныеСвойства, Движения, Отказ); 
	БухгалтерскийУчетСервер.ОтразитьДвижениеОСНУ(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьКорректировкиНУ(ДополнительныеСвойства, Движения, Отказ);

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
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
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
		|	ТаблицаДокумента.Номенклатура,
		|	ТаблицаДокумента.СчетУчета
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
		|			И ТаблицаДокумента1.СчетУчета = ТаблицаДокумента2.СчетУчета
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