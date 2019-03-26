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
	Склад					= ДанныеЗаполнения.Склад;
	БезналичныйРасчет		= ДанныеЗаполнения.БезналичныйРасчет;
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
		НоваяСтрокаТабличнойЧасти.СуммаДохода = НоваяСтрокаТабличнойЧасти.Всего - НоваяСтрокаТабличнойЧасти.СуммаНДС - НоваяСтрокаТабличнойЧасти.СуммаНСП;
		
		СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(Организация, СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СчетаУчетаНоменклатуры);
		НоваяСтрокаТабличнойЧасти.СчетСебестоимости = СчетаУчетаНоменклатуры.СчетРасхода;
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Услуги Цикл
		НоваяСтрокаТабличнойЧасти = Услуги.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		НоваяСтрокаТабличнойЧасти.СуммаДохода = НоваяСтрокаТабличнойЧасти.Всего - НоваяСтрокаТабличнойЧасти.СуммаНДС - НоваяСтрокаТабличнойЧасти.СуммаНСП;
		
		СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(Организация, СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СчетаУчетаНоменклатуры);
		
		НоваяСтрокаТабличнойЧасти.ДополнительныеСведения = СтрокаТабличнойЧасти.Номенклатура.Наименование;
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
 	Для каждого СтрокаТабличнойЧасти Из ДокументОснование.Товары Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.СчетСебестоимости = СтрокаТабличнойЧасти.СчетЗатрат;
	КонецЦикла;
	
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
	
	Если НЕ ЗначениеЗаполнено(ДатаСФ) Тогда 
		ДатаСФ = ТекущаяДатаСеанса();	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) И ДоговорКонтрагента.СтавкаНДС = Справочники.СтавкиНДС.Освобожденная Тогда
	 	СерияБланкаСФ = "ДПБУ";
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
	
	Если БезналичныйРасчет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
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

	// Если на реализацию выписан счет-фактура, то очищаем серию и номер.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СчетаФактурыВыписанные.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
		|ГДЕ
		|	СчетаФактурыВыписанные.Организация = &Организация
		|	И СчетаФактурыВыписанные.Документ = &Документ
		|	И НЕ СчетаФактурыВыписанные.Регистратор = &Документ";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Документ", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Если ЗначениеЗаполнено(СерияБланкаСФ)
			Или ЗначениеЗаполнено(НомерБланкаСФ) Тогда 
			СерияБланкаСФ = "";
			НомерБланкаСФ = "";
		КонецЕсли;	
	КонецЕсли;
	
	// Проверка заполнения СФ и номера.	
	Если ЗначениеЗаполнено(СерияБланкаСФ) И НЕ ЗначениеЗаполнено(НомерБланкаСФ) 
		И Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда 
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Номер бланка СФ"" или очистить поле ""Серия бланка СФ"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.НомерБланкаСФ",, Отказ);
	КонецЕсли;
	
	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВыполнитьПредварительныйКонтроль(Отказ);	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СерияБланкаСФ) 
		И ЗначениеЗаполнено(ДоговорКонтрагента) 
		И ДоговорКонтрагента.СтавкаНДС = Справочники.СтавкиНДС.Освобожденная Тогда
	 	СерияБланкаСФ = "ДПБУ";
	КонецЕсли;

	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего") + ОС.Итог("Всего");
	
	РассчитатьСуммыВРегламенитрованнойВалюте();
	
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
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеТовары, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ, ДополнительныеСвойства);
	УчетМБП.СформироватьДвиженияСписаниеМБП(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ, ДополнительныеСвойства);
		
	УправлениеВнеоборотнымиАктивами.СформироватьДвиженияСписаниеОС(ДополнительныеСвойства, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПродажиОсновныхСредств(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСчетаФактурыВыписанные(ДополнительныеСвойства, Движения, Отказ);

	БухгалтерскийУчетСервер.ОтразитьБланкиСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьНДС(ДополнительныеСвойства, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьСобытияОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСостоянияОС(ДополнительныеСвойства, Движения, Отказ); 
	БухгалтерскийУчетСервер.ОтразитьДвижениеОСНУ(ДополнительныеСвойства, Движения, Отказ);

	БухгалтерскийУчетСервер.ОтразитьСоставОС(ДополнительныеСвойства, Движения, Отказ);
	
	НалоговыйУчет.СформироватьДвиженияКорректировкаНУ(ДополнительныеСвойства, Движения, Отказ);
		
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
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Указанные серия и номер СФ уже использованы. %1.'"), ВыборкаДетальныеЗаписи.Регистратор);
					БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;			
	КонецЕсли;
	
	// Контроль ОС.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
		|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	&ТаблицаОС КАК ТаблицаОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СостоянияОССрезПоследних.НомерСтроки КАК НомерСтроки,
		|	СостоянияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СостоянияОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|					ИЗ
		|						ВременнаяТаблицаОС КАК ВременнаяТаблицаОС)
		|				И НЕ Регистратор = &Ссылка) КАК СостоянияОССрезПоследних
		|ГДЕ
		|	(СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.СнятоСУчета)
		|			ИЛИ СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.Передано))
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МестонахождениеОССрезПоследних.НомерСтроки КАК НомерСтроки,
		|	МестонахождениеОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.МестонахождениеОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|					ИЗ
		|						ВременнаяТаблицаОС КАК ВременнаяТаблицаОС)
		|				И НЕ Регистратор = &Ссылка) КАК МестонахождениеОССрезПоследних
		|ГДЕ
		|	НЕ(МестонахождениеОССрезПоследних.МОЛ = &МОЛ
		|				И МестонахождениеОССрезПоследних.Подразделение = &Подразделение)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаОСДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаОСДублиСтрок.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ТаблицаОСДублиСтрок
		|		ПО ВременнаяТаблицаОС.НомерСтроки <> ТаблицаОСДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаОС.ОсновноеСредство = ТаблицаОСДублиСтрок.ОсновноеСредство
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаОСДублиСтрок.ОсновноеСредство
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");                          	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Период",	Дата);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("МОЛ", МОЛ);
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Параметры.Вставить("ТаблицаОС", ОС.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Состояния ОС".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Нельзя реализовывать основное средство снятое с учета. Строка %1 списка ""Основные средства"".'"), 
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
	
	// Регистр "Местонахождение ОС".
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство протеворечит указанному местонахождению. Строка %1 списка ""Основные средства"".'"), 
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

	// Дубли строк.
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство указывается повторно в строке %1 списка ""Основные средства"".'"), 
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

КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

// Процедура рассчитывает суммы табличных частей в валюте регламентированного учета
//
Процедура РассчитатьСуммыВРегламенитрованнойВалюте()

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
		
		МассивТабличныхЧастей = Новый Массив();
		МассивТабличныхЧастей.Добавить(Товары);
		МассивТабличныхЧастей.Добавить(Услуги);
		МассивТабличныхЧастей.Добавить(ОС);
		
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
		ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация);	
		МассивТабличныхЧастей = Новый Массив();
		МассивТабличныхЧастей.Добавить(Товары);
		МассивТабличныхЧастей.Добавить(Услуги);
		МассивТабличныхЧастей.Добавить(ОС);
		
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл
			
			Если ТабличнаяЧасть = Товары Тогда
				СтавкаНСПДляРасчета = СтавкаНСП;
			ИначеЕсли ТабличнаяЧасть = Услуги Тогда
				СтавкаНСПДляРасчета = СтавкаНСПУслуги;
			Иначе
				СтавкаНСПДляРасчета = ПредопределенноеЗначение("Справочник.СтавкиНСП.Прочее");
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
				
				Если ТабличнаяЧасть = ОС Тогда
					Если СуммаВключаетНалоги Тогда
						Структура.Вставить("Сумма", 	 	Окр(СтрокаТабличнойЧасти.Сумма * Курс / Кратность, 2));
						Структура.Вставить("СуммаДохода", 	СтрокаТабличнойЧасти.СуммаДохода);	
					Иначе
						Структура.Вставить("Сумма", 	 	СтрокаТабличнойЧасти.Сумма);
						Структура.Вставить("СуммаДохода", 	Окр(СтрокаТабличнойЧасти.СуммаДохода * Курс / Кратность, 2));	
					КонецЕсли;	
					
				Иначе
					Структура.Вставить("Цена", 	 		Окр(СтрокаТабличнойЧасти.Цена * Курс / Кратность, 2));
					Структура.Вставить("Количество", 	СтрокаТабличнойЧасти.Количество);
					Структура.Вставить("Сумма", 	 	СтрокаТабличнойЧасти.Сумма);
					Структура.Вставить("СуммаДохода", 	СтрокаТабличнойЧасти.СуммаДохода);
				КонецЕсли;	
					
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
					Если ТабличнаяЧасть <> ОС Тогда
						ОбработкаТабличныхЧастейКлиентСервер.РассчитатьДоходСтрокиТабличнойЧасти(Структура, Ложь);
					КонецЕсли;	
						
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