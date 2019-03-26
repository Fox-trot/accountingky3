﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацияТоваровУслуг(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	Организация				= ДанныеЗаполнения.Организация;
	Склад               	= ДанныеЗаполнения.Склад;
	БезналичныйРасчет		= ДанныеЗаполнения.БезналичныйРасчет;
	// Сведения о контрагенте
	Контрагент          	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  	= ДанныеЗаполнения.ДоговорКонтрагента;
	СчетРасчетов 			= ДанныеЗаполнения.СчетРасчетов;			
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
	СчетУчетаСкидок 		= ПланыСчетов.Хозрасчетный.ВозвратПроданныхТоваровИСкидки;
	
	ЗаполнитьДанныеКорректировкиСФ(ДанныеЗаполнения);	
	
	ЗаполнитьТабличныеЧастиПоОснованию(ДанныеЗаполнения);

КонецПроцедуры

Процедура ЗаполнитьТабличныеЧастиПоОснованию(ДанныеЗаполнения)
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
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацияТоваровУслуг";
	
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
	КонецЕсли;

	// Указан документ реализации.
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Себестоимость");
	КонецЕсли;
	
	// Проверка заполнения Скидки/Наценки
	Если НЕ ЗначениеЗаполнено(ВидСкидкиНаценки) Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаСкидок");
	КонецЕсли;
	
	Если БезналичныйРасчет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
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
	
	Если РасчитатьСуммыВВалютеРеглУчета Тогда
		РассчитатьСуммыВРегламенитрованнойВалюте();
		РасчитатьСуммыВВалютеРеглУчета = Ложь;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ВозвратТоваровОтПокупателя.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеТовары, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);
	УчетМБП.СформироватьДвиженияСписаниеМБП(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП,
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьНДС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьБланкиСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСчетаФактурыВыписанные(ДополнительныеСвойства, Движения, Отказ);

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
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаДокумента1.Номенклатура КАК Номенклатура
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
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СерияБланкаСФ", СерияБланкаСФ);
	Запрос.УстановитьПараметр("НомерБланкаСФ", НомерБланкаСФ);
	
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
	
	// Проверка наличия серии и номера СФ в базе.
	Если ЗначениеЗаполнено(СерияБланкаСФ) И СерияБланкаСФ <> "ДПБУ" Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	БланкиСчетовФактурОбороты.СерияБланкаСФ КАК СерияБланкаСФ,
			|	БланкиСчетовФактурОбороты.Регистратор КАК Регистратор,
			|	ЕСТЬNULL(БланкиСчетовФактурОбороты.КоличествоРасход, 0) КАК КоличествоРасход,
			|	ЕСТЬNULL(БланкиСчетовФактурОбороты.КоличествоПриход, 0) КАК КоличествоПриход
			|ИЗ
			|	РегистрНакопления.БланкиСчетовФактур.Обороты(
			|			,
			|			,
			|			Авто,
			|			Организация = &Организация
			|				И СерияБланкаСФ = &СерияБланкаСФ
			|				И НомерБланкаСФ = &НомерБланкаСФ) КАК БланкиСчетовФактурОбороты
			|ГДЕ
			|	НЕ БланкиСчетовФактурОбороты.Регистратор = &Ссылка";
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("СерияБланкаСФ", СерияБланкаСФ);
		Запрос.УстановитьПараметр("НомерБланкаСФ", НомерБланкаСФ);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		              
		Если РезультатЗапроса.Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Указанных серии или номера СФ нет в базе. Необходимо оформить документ ""Поступление бланков счетов-фактур"".'");
			БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
		Иначе
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
				Если ВыборкаДетальныеЗаписи.КоличествоРасход > 0 Тогда 
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Указанные серия и номер СФ уже использованы: %1.'"), ВыборкаДетальныеЗаписи.Регистратор);
					БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;			
	КонецЕсли;	
КонецПроцедуры

// Процедура заполнения реквизитов "КорректировкаСерияБланкаСФ",
// "КорректировкаНомерБланкаСФ" и "КорректировкаДатаСФ".
Процедура ЗаполнитьДанныеКорректировкиСФ(ДокументРеализации) Экспорт

	Если ДокументРеализации.СерияБланкаСФ <> "" Тогда
		КорректировкаСерияБланкаСФ 	= ДокументРеализации.СерияБланкаСФ;
		КорректировкаНомерБланкаСФ 	= ДокументРеализации.НомерБланкаСФ;
		КорректировкаДатаСФ 		= ДокументРеализации.ДатаСФ;
		
	Иначе
		Запрос = Новый Запрос();
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СчетаФактурыВыписанные.Регистратор КАК Регистратор
			|ИЗ
			|	РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
			|ГДЕ
			|	СчетаФактурыВыписанные.Организация = &Организация
			|	И СчетаФактурыВыписанные.Документ = &Документ";
		Запрос.УстановитьПараметр("Организация", ДокументРеализации);
		Запрос.УстановитьПараметр("Документ", ДокументРеализации);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			КорректировкаСерияБланкаСФ 	= Выборка.Регистратор.СерияБланкаСФ;
			КорректировкаНомерБланкаСФ 	= Выборка.Регистратор.НомерБланкаСФ;
			КорректировкаДатаСФ 		= Выборка.Регистратор.ДатаСФ;	
		КонецЕсли;	
	КонецЕсли;	

КонецПроцедуры

// Процедура рассчитывает суммы табличных частей в валюте регламентированного учета
//
Процедура РассчитатьСуммыВРегламенитрованнойВалюте()

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
		
		МассивТабличныхЧастей = Новый Массив();
		МассивТабличныхЧастей.Добавить(Товары);
		МассивТабличныхЧастей.Добавить(Услуги);
		
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл
			Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл					
				СтрокаТабличнойЧасти.СуммаВВалютеРеглУчета 		 = СтрокаТабличнойЧасти.Сумма;
				СтрокаТабличнойЧасти.СуммаНДСВВалютеРеглУчета 	 = СтрокаТабличнойЧасти.СуммаНДС;
				СтрокаТабличнойЧасти.СуммаНСПВВалютеРеглУчета 	 = СтрокаТабличнойЧасти.СуммаНСП;
				СтрокаТабличнойЧасти.СуммаСкидкиВВалютеРеглУчета = СтрокаТабличнойЧасти.СуммаСкидки;
				СтрокаТабличнойЧасти.СуммаДоходаВВалютеРеглУчета = СтрокаТабличнойЧасти.СуммаДохода;
				СтрокаТабличнойЧасти.ВсегоВВалютеРеглУчета 		 = СтрокаТабличнойЧасти.Всего;
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		ДанныеУчетнойПолитики 	= БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация);	
		МассивТабличныхЧастей = Новый Массив();
		МассивТабличныхЧастей.Добавить(Товары);
		МассивТабличныхЧастей.Добавить(Услуги);
		
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл
			
			Если ТабличнаяЧасть = Товары Тогда
				СтавкаНСПДляРасчета = СтавкаНСП;
			ИначеЕсли ТабличнаяЧасть = Услуги Тогда
				СтавкаНСПДляРасчета = СтавкаНСПУслуги;
			КонецЕсли;
			
			Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		
				// Структура для пересчета и заполнения суммами в валюте регламетированного учета.
				Структура = Новый Структура();	
				Структура.Вставить("Всего", 	 			СтрокаТабличнойЧасти.Всего);
				Структура.Вставить("СуммаНДС", 				СтрокаТабличнойЧасти.СуммаНДС);
				Структура.Вставить("СуммаНСП", 				СтрокаТабличнойЧасти.СуммаНСП);
				Структура.Вставить("ПроцентСкидкиНаценки", 	СтрокаТабличнойЧасти.ПроцентСкидкиНаценки);
				Структура.Вставить("СтавкаНДС", 			?(ДанныеУчетнойПолитики.ПлательщикНДС, СтавкаНДС, ПредопределенноеЗначение("Справочник.СтавкиНДС.ПустаяСсылка")));
				Структура.Вставить("СтавкаНСП", 			?(ДанныеУчетнойПолитики.ПлательщикНСП, СтавкаНСПДляРасчета, ПредопределенноеЗначение("Справочник.СтавкиНСП.ПустаяСсылка")));
				
				Если ВидСкидкиНаценки = Перечисления.ВидыСкидокНаценок.СуммаПоСтроке Тогда
					Структура.Вставить("СуммаСкидки", Окр(СтрокаТабличнойЧасти.СуммаСкидки * Курс / Кратность, 2));	
				Иначе	
					Структура.Вставить("СуммаСкидки", СтрокаТабличнойЧасти.СуммаСкидки);
				КонецЕсли;
				
				Структура.Вставить("Цена", 	 		Окр(СтрокаТабличнойЧасти.Цена * Курс / Кратность, 2));
				Структура.Вставить("Количество", 	СтрокаТабличнойЧасти.Количество);
				Структура.Вставить("Сумма", 	 	СтрокаТабличнойЧасти.Сумма);
				Структура.Вставить("СуммаДохода", 	СтрокаТабличнойЧасти.СуммаДохода);	
					
				Если СуммаВключаетНалоги Тогда
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(Структура);
					
					Если ВидСкидкиНаценки <> Перечисления.ВидыСкидокНаценок.СуммаПоСтроке Тогда
						ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСкидкуСтрокиТабличнойЧасти(Структура);
					КонецЕсли;	
						
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
						Структура, 
						Дата,
						Организация, 
						Истина, 
						?(ДанныеУчетнойПолитики.ПлательщикНДС, СтавкаНДС, ПредопределенноеЗначение("Справочник.СтавкиНДС.ПустаяСсылка")),
						?(ДанныеУчетнойПолитики.ПлательщикНСП, СтавкаНСПДляРасчета, ПредопределенноеЗначение("Справочник.СтавкиНСП.ПустаяСсылка")), 
						БезналичныйРасчет);
					
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьВсегоСтрокиТабличнойЧасти(Структура, Истина);
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьДоходСтрокиТабличнойЧасти(Структура, Истина);
					
				Иначе
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьДоходСтрокиТабличнойЧасти(Структура, Ложь);
						
					СтруктураДопПараметров = Новый Структура();
					СтруктураДопПараметров.Вставить("Период", 			 Дата);
					СтруктураДопПараметров.Вставить("Организация", 		 Организация);
					СтруктураДопПараметров.Вставить("БезналичныйРасчет", БезналичныйРасчет);
					СтруктураДопПараметров.Вставить("СтавкаНДС", 		 СтавкаНДС);
					СтруктураДопПараметров.Вставить("СтавкаНСП", 		 СтавкаНСПДляРасчета);
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(Структура,, СтруктураДопПараметров);	
					
					Если ВидСкидкиНаценки <> Перечисления.ВидыСкидокНаценок.СуммаПоСтроке Тогда
						ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСкидкуСтрокиТабличнойЧасти(Структура);
					КонецЕсли;
					
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
						Структура, 
						Дата,
						Организация, 
						Истина, 
						?(ДанныеУчетнойПолитики.ПлательщикНДС, СтавкаНДС, ПредопределенноеЗначение("Справочник.СтавкиНДС.ПустаяСсылка")),
						?(ДанныеУчетнойПолитики.ПлательщикНСП, СтавкаНСПДляРасчета, ПредопределенноеЗначение("Справочник.СтавкиНСП.ПустаяСсылка")), 
						БезналичныйРасчет);
					
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьВсегоСтрокиТабличнойЧасти(Структура, Истина);
				КонецЕсли;
									
				СтрокаТабличнойЧасти.СуммаВВалютеРеглУчета 		 = Структура.Сумма;
				СтрокаТабличнойЧасти.СуммаНДСВВалютеРеглУчета 	 = Структура.СуммаНДС;
				СтрокаТабличнойЧасти.СуммаНСПВВалютеРеглУчета 	 = Структура.СуммаНСП;
				СтрокаТабличнойЧасти.СуммаСкидкиВВалютеРеглУчета = Структура.СуммаСкидки;
				СтрокаТабличнойЧасти.СуммаДоходаВВалютеРеглУчета = Структура.СуммаДохода;
				СтрокаТабличнойЧасти.ВсегоВВалютеРеглУчета 		 = Структура.Всего;
			КонецЦикла;	
		КонецЦикла;			
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти	

#КонецЕсли