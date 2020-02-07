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
		//КоэффициентыРаспределенияОС = ОС.ВыгрузитьКолонку("Сумма");
		// Итоги
		ИтогТовары = Товары.Итог("Сумма");
		ИтогУслуги = Услуги.Итог("Сумма");
		//ИтогОС = ОС.Итог("Сумма");
	ИначеЕсли СпособРаспределенияАкциза = "Количество" Тогда
		// Массивы
		КоэффициентыРаспределенияТовары = Товары.ВыгрузитьКолонку("Количество");
		КоэффициентыРаспределенияУслуги = Услуги.ВыгрузитьКолонку("Количество");
		//КоэффициентыРаспределенияОС = ОС.ВыгрузитьКолонку("Сумма");
		// Итоги
		ИтогТовары = Товары.Итог("Количество");
		ИтогУслуги = Услуги.Итог("Количество");
		// Заполнение ОС
		//ИтогОС = 0;
		//Для Каждого ЭлементМассива Из КоэффициентыРаспределенияОС Цикл 
		//	ЭлементМассива = 1;
		//	ИтогОС = ИтогОС + 1;
		//КонецЦикла;
	ИначеЕсли СпособРаспределенияАкциза = "Вес" Тогда
		// Массивы
		КоэффициентыРаспределенияТовары = Товары.ВыгрузитьКолонку("Вес");
		КоэффициентыРаспределенияУслуги = Услуги.ВыгрузитьКолонку("Вес");
		//КоэффициентыРаспределенияОС = ОС.ВыгрузитьКолонку("Вес");
		// Итоги
		ИтогТовары = Товары.Итог("Вес");
		ИтогУслуги = Услуги.Итог("Вес");
		//ИтогОС = ОС.Итог("Вес");
	Иначе // Обнуление
		Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
			СтрокаТабличнойЧасти.Вес = 0;
			СтрокаТабличнойЧасти.СуммаАкциза = 0;
		КонецЦикла;
		Для Каждого СтрокаТабличнойЧасти Из Услуги Цикл
			СтрокаТабличнойЧасти.Вес = 0;
			СтрокаТабличнойЧасти.СуммаАкциза = 0;
		КонецЦикла;
		//Для Каждого СтрокаТабличнойЧасти Из ОС Цикл
		//	СтрокаТабличнойЧасти.Вес = 0;
		//	СтрокаТабличнойЧасти.СуммаАкциза = 0;
		//КонецЦикла;
		Возврат;
	КонецЕсли;		
	
	// Распределения общей суммы акциза
	МассивОбщихСумм = Новый Массив;
	МассивОбщихСумм.Добавить(ИтогТовары);
	МассивОбщихСумм.Добавить(ИтогУслуги);
	//МассивОбщихСумм.Добавить(ИтогОС);

	МассивРаспределениеМеждуТабличнымиЧастями = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаАкциза, МассивОбщихСумм);
	Если МассивРаспределениеМеждуТабличнымиЧастями = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СуммаАкцизаТовары = МассивРаспределениеМеждуТабличнымиЧастями[0];
	СуммаАкцизаУслуги = МассивРаспределениеМеждуТабличнымиЧастями[1];
	//СуммаАкцизаОС = МассивРаспределениеМеждуТабличнымиЧастями[2];	
	
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
		
	ЗначенияСтавокНДСиНСП 	= УчетНДСВызовСервера.ПолучитьЗначенияСтавокНДСиНСП(ТекущаяДатаСеанса(), ДоговорКонтрагента); 
	ЗначениеСтавкиНДС 		= ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНДС;
	ЗначениеСтавкиНСП 		= ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНСП;
	ЗначениеСтавкиНСПДляОС 	= ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНСПДляОС;
	
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
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если Товары.Количество() = 0
		И Услуги.Количество() = 0
		И ОС.Количество() = 0 Тогда	
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не заполнен ни один список.'"),,,,Отказ)		
	КонецЕсли;
	
	Если НЕ (СуммаАкциза = Товары.Итог("СуммаАкциза") 
		+ Услуги.Итог("СуммаАкциза")) И ОС.Количество() = 0 Тогда
		//+ ОС.Итог("СуммаАкциза") Тогда 
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не верно распределена сумма акциза.'"),,,,Отказ)		
	КонецЕсли;	
	
	Если Товары.Количество() = 0 Тогда
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Склад");
	КонецЕсли;
	
	Если Курс = 0 Или Кратность = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
			|что у валюты ""%1"" установлен курс на дату %2 или ранее.
			|Перевыберите договор и заново проведите документ.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	// Контроль заполнения Контрагента ГНС.
	Если Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда 
		КонтрагентГНС = Организация.КонтрагентГНС;
		Если НЕ ЗначениеЗаполнено(КонтрагентГНС) Тогда 
			ТекстСообщения = НСтр("ru = 'Не заполнен Контрагент ГНС. Откройте организацию и проверьте, что поле Контрагент ГНС заполнено.
				|Заново проведите документ.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",, Отказ);
		Иначе 
			СписокВидовДоговора = Новый СписокЗначений;
			СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);
			ДоговорКонтрагентаГНС = Справочники.ДоговорыКонтрагентов.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(КонтрагентГНС, Организация, СписокВидовДоговора);
			
			Если НЕ ЗначениеЗаполнено(ДоговорКонтрагентаГНС) Тогда 
				ТекстСообщения = НСтр("ru = 'Не установлен основной договор у Контрагента ГНС.
					|Откройте организацию и перейдите к указанному Контрагенту ГНС. На вкладке Договоры контрагента установите основной договор.
					|Вид договора должен быть Прочее, валюта договора KGS. Заново проведите документ.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",, Отказ);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(СерияБланкаСФ) И НЕ ЗначениеЗаполнено(НомерБланкаСФ) 
		И Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР
		И ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Покупка 
		И ДанныеУчетнойПолитики.ПлательщикНДС Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Номер бланка СФ"" или очистить поле ""Серия бланка СФ"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.НомерБланкаСФ",, Отказ);	
	КонецЕсли;	
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ЗакупочныйАкт
		И НЕ ЗначениеЗаполнено(НомерАкта) Тогда
		
		ТекстСообщения = НСтр("ru = 'В поступлении с видом операции ""Закупочный акт"" необходимо заполнить поле ""Номер акта"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.НомерАкта",, Отказ);
	КонецЕсли;	
	
	// Проверка договора в валюте регламентированного учета при признаке страны контрагента "КР".
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР 
		И ДоговорКонтрагента.ВалютаРасчетов <> ВалютаРегламентированногоУчета Тогда
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Для контрагента с признаком страны ""КР"" необходимо выбрать договор с валютой %1.'"),
							ВалютаРегламентированногоУчета);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ДоговорКонтрагента",, Отказ);
	КонецЕсли;	
	
	// Проверка признака страны контрагента и вида операции.
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ЗакупочныйАкт
		И Контрагент.ПризнакСтраны <> Перечисления.ПризнакиСтраны.КР Тогда
		
		ТекстСообщения = НСтр("ru = 'В видом операции ""Закупочный акт"" контрагент должен быть с признаком страны ""КР"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Контрагент",, Отказ);
	КонецЕсли;	
	
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
	
	// В случае если очистили дату, но не очистили серию бланка СФ.
	// Дата нужна для записи в РС "РеестрПриобретенныхМатериальныхРесурсов".
	Если ЗначениеЗаполнено(СерияБланкаСФ)
		И НЕ ЗначениеЗаполнено(ДатаСф) Тогда
		//И НЕ НеВключатьВРеестрСФ Тогда 
		ДатаСф = Дата;				
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
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры // ОбработкаУдаленияПроведения()

Процедура ПриКопировании(ОбъектКопирования)
	СерияБланкаСФ = "";
	НомерБланкаСФ = "";
	НомерАкта = "";
	ДатаСФ = '00010101';
	
	СтруктураДанные = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаРасчетов, Дата);
	Курс      = ?(СтруктураДанные.Курс = 0, 1, СтруктураДанные.Курс);
	Кратность = ?(СтруктураДанные.Кратность = 0, 1, СтруктураДанные.Кратность);
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
	Документы.ПоступлениеТоваровУслуг.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
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
	// ОС
	БухгалтерскийУчетСервер.ОтразитьПараметрыУчетаОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСостоянияОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСобытияОС(ДополнительныеСвойства, Движения, Отказ);	
	
	// Прочее
	БухгалтерскийУчетСервер.ОтразитьПоступлениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрВвезенных(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрПриобретенныхМатериальныхРесурсов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОПоступлении(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ЗначенияСтавокНалогов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьНДСНаИмпорт(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияПоПоказателямИмпорта(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрЗакупок(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьДанныеЗакупочныхАктов(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

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
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетОСПоКомплектам") Тогда
	 	КонтрольЗапретаПоступленияКомплектовОС(Отказ);
	КонецЕсли;

КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

Процедура КонтрольЗапретаПоступленияКомплектовОС(Отказ)
	Для каждого СтрокаТабличнойЧасти Из ОС Цикл
		Если СтрокаТабличнойЧасти.ОсновноеСредство.ЭтоКомплект Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Поступление основного средства в строке %1 с признаком ""Это комплект"" запрещено.'"), 
								СтрокаТабличнойЧасти.НомерСтроки);
				БухгалтерскийУчетСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"ОС",
					СтрокаТабличнойЧасти.НомерСтроки,
					"ОсновноеСредство",
					Отказ);
			КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли