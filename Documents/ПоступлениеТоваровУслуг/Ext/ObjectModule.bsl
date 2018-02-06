﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Распределить акциз
// Сумма акциза распределяется между 3-мя табличными частями по выбранному способу распределения.
//
Процедура РаспределитьАкциз() Экспорт
	// Массивы коэффициентов распределения
	Если СпособРаспределенияАкциза = "Сумма" Тогда
		// Массивы
		КоэффициентыРаспределенияТовары = Товары.ВыгрузитьКолонку("Сумма");
		КоэффициентыРаспределенияУслуги = Услуги.ВыгрузитьКолонку("Сумма");
		КоэффициентыРаспределенияОС = ОС.ВыгрузитьКолонку("Сумма");
		// Итоги
		ИтогТовары = Товары.Итог("Сумма");
		ИтогУслуги = Услуги.Итог("Сумма");
		ИтогОС = ОС.Итог("Сумма");
	ИначеЕсли СпособРаспределенияАкциза = "Количество" Тогда
		// Массивы
		КоэффициентыРаспределенияТовары = Товары.ВыгрузитьКолонку("Количество");
		КоэффициентыРаспределенияУслуги = Услуги.ВыгрузитьКолонку("Количество");
		КоэффициентыРаспределенияОС = ОС.ВыгрузитьКолонку("Сумма");
		// Итоги
		ИтогТовары = Товары.Итог("Количество");
		ИтогУслуги = Услуги.Итог("Количество");
		// Заполнение ОС
		ИтогОС = 0;
		Для Каждого ЭлементМассива Из КоэффициентыРаспределенияОС Цикл 
			ЭлементМассива = 1;
			ИтогОС = ИтогОС + 1;
		КонецЦикла;
	ИначеЕсли СпособРаспределенияАкциза = "Вес" Тогда
		// Массивы
		КоэффициентыРаспределенияТовары = Товары.ВыгрузитьКолонку("Вес");
		КоэффициентыРаспределенияУслуги = Услуги.ВыгрузитьКолонку("Вес");
		КоэффициентыРаспределенияОС = ОС.ВыгрузитьКолонку("Вес");
		// Итоги
		ИтогТовары = Товары.Итог("Вес");
		ИтогУслуги = Услуги.Итог("Вес");
		ИтогОС = ОС.Итог("Вес");
	Иначе // Обнуление
		Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
			СтрокаТабличнойЧасти.Вес = 0;
			СтрокаТабличнойЧасти.СуммаАкциза = 0;
		КонецЦикла;
		Для Каждого СтрокаТабличнойЧасти Из Услуги Цикл
			СтрокаТабличнойЧасти.Вес = 0;
			СтрокаТабличнойЧасти.СуммаАкциза = 0;
		КонецЦикла;
		Для Каждого СтрокаТабличнойЧасти Из ОС Цикл
			СтрокаТабличнойЧасти.Вес = 0;
			СтрокаТабличнойЧасти.СуммаАкциза = 0;
		КонецЦикла;
		Возврат;
	КонецЕсли;		
	
	// Распределения общей суммы акциза
	МассивОбщихСумм = Новый Массив;
	МассивОбщихСумм.Добавить(ИтогТовары);
	МассивОбщихСумм.Добавить(ИтогУслуги);
	МассивОбщихСумм.Добавить(ИтогОС);

	МассивРаспределениеМеждуТабличнымиЧастями = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаАкциза, МассивОбщихСумм);
	Если МассивРаспределениеМеждуТабличнымиЧастями = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СуммаАкцизаТовары = МассивРаспределениеМеждуТабличнымиЧастями[0];
	СуммаАкцизаУслуги = МассивРаспределениеМеждуТабличнымиЧастями[1];
	СуммаАкцизаОС = МассивРаспределениеМеждуТабличнымиЧастями[2];	
	
	// Распределения суммы акциза табличной части
	// Товары
	Если СуммаАкцизаТовары > 0 Тогда  
		РезультатРаспределения = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаАкцизаТовары, КоэффициентыРаспределенияТовары);
		Если НЕ РезультатРаспределения = Неопределено Тогда
			ИндексСтроки = 0;
			Для Каждого ЭлементМассива Из РезультатРаспределения Цикл 
				Товары[ИндексСтроки].СуммаАкциза = ЭлементМассива;
				ИндексСтроки = ИндексСтроки + 1;
			КонецЦикла;	
		КонецЕсли;		
	КонецЕсли;
	// Услуги
	Если СуммаАкцизаУслуги > 0 Тогда  
		РезультатРаспределения = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаАкцизаУслуги, КоэффициентыРаспределенияУслуги);
		Если НЕ РезультатРаспределения = Неопределено Тогда
			ИндексСтроки = 0;
			Для Каждого ЭлементМассива Из РезультатРаспределения Цикл 
				Услуги[ИндексСтроки].СуммаАкциза = ЭлементМассива;
				ИндексСтроки = ИндексСтроки + 1;
			КонецЦикла;	
		КонецЕсли;		
	КонецЕсли;
	// ОС
	Если СуммаАкцизаОС > 0 Тогда  
		РезультатРаспределения = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаАкцизаОС, КоэффициентыРаспределенияОС);
		Если НЕ РезультатРаспределения = Неопределено Тогда
			ИндексСтроки = 0;
			Для Каждого ЭлементМассива Из РезультатРаспределения Цикл 
				ОС[ИндексСтроки].СуммаАкциза = ЭлементМассива;
				ИндексСтроки = ИндексСтроки + 1;
			КонецЦикла;	
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ПроцедурыЗаполненияДокумента

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
	ВалютаДокумента = ДоговорКонтрагента.ВалютаРасчетов;
	
	ВалютаРасчетовКурсКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ТекущаяДатаСеанса());
	Курс      = ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
	Кратность = ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1, ВалютаРасчетовКурсКратность.Кратность);

	СуммаВключаетНалоги = ДоговорКонтрагента.СуммаВключаетНалоги;
	
	СчетаУчета = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаУчета.СчетРасчетовПоставщика;
		
	ЗначенияСтавокНДСиНСП = УчетНДСВызовСервера.ПолучитьЗначенияСтавокНДСиНСП(ТекущаяДатаСеанса(), Контрагент, ДоговорКонтрагента); 
	ЗначениеСтавкиНДС = ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНДС;
	ЗначениеСтавкиНСП = ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНСП;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		
		СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(Организация, НоваяСтрока.Номенклатура);
		НоваяСтрока.СчетУчета = СчетаУчетаНоменклатуры.СчетУчета;
	КонецЦикла;

	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.ОсновныеСредства Цикл
		НоваяСтрока = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.Доверенность")] = "ЗаполнитьПоДоверенности";

	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если Товары.Количество() = 0
		И Услуги.Количество() = 0
		И ОС.Количество() = 0 Тогда	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнен ни один список.'"),,,,Отказ)		
	КонецЕсли;
	
	Если НЕ СуммаАкциза = Товары.Итог("СуммаАкциза") 
		+ Услуги.Итог("СуммаАкциза")
		+ ОС.Итог("СуммаАкциза") Тогда 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не верно распределена сумма акциза.'"),,,,Отказ)		
	КонецЕсли;	
	
	Если Товары.Количество() = 0 
		И ОС.Количество() = 0 Тогда
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Склад");
	КонецЕсли;
	
	Если НЕ ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.РасходыБудущихПериодов Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("РБП");	
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
	
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма") + ОС.Итог("Сумма");
	
	Если НЕ ЗначениеЗаполнено(СерияБланкаСФ) 
		И НЕ НеВключатьВРеестрСФ Тогда 
		СерияБланкаСФ = "ДПБУ";	
		НомерБланкаСФ = Прав(Номер, 6);
		ДатаСф = Дата;				
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	// Инициализация данных документа.
	Документы.ПоступлениеТоваровУслуг.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УчетТоваров.СформироватьДвиженияПоступлениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	УчетМБП.СформироватьДвиженияПоступлениеМБП(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	// ОС
	БухгалтерскийУчетСервер.ОтразитьПараметрыУчетаОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСостоянияОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСобытияОС(ДополнительныеСвойства, Движения, Отказ);	
	БухгалтерскийУчетСервер.ОтразитьМестонахождениеОС(ДополнительныеСвойства, Движения, Отказ);
	// Прочее
	БухгалтерскийУчетСервер.ОтразитьПоступлениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрВвезенных(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОПоступлении(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьЗначенияСтавокНалоговНДСиНСП(ДополнительныеСвойства, Движения, Отказ);
	
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
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Проверка ОС
	Если ОС.Количество() > 0  Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
			|	ТаблицаДокумента.ОсновноеСредство,
			|	ТаблицаДокумента.Сумма
			|ПОМЕСТИТЬ ТаблицаДокумента
			|ИЗ
			|	&ТаблицаДокумента КАК ТаблицаДокумента
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
			|	ТаблицаДокумента1.ОсновноеСредство
			|ИЗ
			|	ТаблицаДокумента КАК ТаблицаДокумента1
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
			|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
			|			И ТаблицаДокумента1.ОсновноеСредство = ТаблицаДокумента2.ОсновноеСредство
			|
			|СГРУППИРОВАТЬ ПО
			|	ТаблицаДокумента1.ОсновноеСредство
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
			|	ТаблицаДокумента.ОсновноеСредство,
			|	СостоянияОССрезПоследних.Состояние
			|ИЗ
			|	ТаблицаДокумента КАК ТаблицаДокумента
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОС.СрезПоследних(
			|				&Период,
			|				Организация = &Организация
			|					И ОсновноеСредство В
			|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|							ТаблицаДокумента.ОсновноеСредство
			|						ИЗ
			|							ТаблицаДокумента КАК ТаблицаДокумента)
			|					И НЕ Регистратор = &Ссылка) КАК СостоянияОССрезПоследних
			|		ПО ТаблицаДокумента.ОсновноеСредство = СостоянияОССрезПоследних.ОсновноеСредство
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		Запрос.УстановитьПараметр("ТаблицаДокумента", ОС);
		Запрос.УстановитьПараметр("Период", Дата);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		// Дубли строк ОС.
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство указывается повторно в строке %1 списка ""ОС"".'"), 
								ВыборкаИзРезультатаЗапроса.НомерСтроки);
				БухгалтерскийУчетСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"ОС",
					ВыборкаИзРезультатаЗапроса.НомерСтроки,
					"ОсновноеСредство",
					Отказ);
			КонецЦикла;
		КонецЕсли;		
		
		// Проверка состояния ОС.
		Если НЕ МассивРезультатов[2].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
			Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для основного средства ""%1"", указанного в строке %2 списка ""ОС"", текущее состояние ""%3"".'"), 
					ВыборкаИзРезультатаЗапроса.ОсновноеСредство,
					ВыборкаИзРезультатаЗапроса.НомерСтроки,
					ВыборкаИзРезультатаЗапроса.Состояние);
					
				БухгалтерскийУчетСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"ОС",
					ВыборкаИзРезультатаЗапроса.НомерСтроки,
					"ОсновноеСредство",
					Отказ);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

#КонецОбласти

#КонецЕсли