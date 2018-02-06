﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоИнвентаризацииОС(ДанныеЗаполнения) Экспорт

	ДокументОснование 	= ДанныеЗаполнения;
	МОЛ 				= ДанныеЗаполнения.МОЛ;
	Подразделение 		= ДанныеЗаполнения.Подразделение;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.ОС Цикл
		Если СтрокаТабличнойЧасти.НедостачаСумма = 0 Тогда 
			Продолжить;
		КонецЕсли;	
		НоваяСтрокаТабличнойЧасти = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти); 
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Комиссия Цикл
		НоваяСтрокаТабличнойЧасти = Комиссия.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
	КонецЦикла;

	УправлениеВнеоборотнымиАктивами.ЗаполнитьДанныеОсновныхСредствВТабличнойЧасти(Ссылка, ДанныеЗаполнения.Дата, ДанныеЗаполнения.Организация, ОС);
КонецПроцедуры

#КонецОбласти
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ИнвентаризацияОС")] = "ЗаполнитьПоИнвентаризацииОС";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.СписаниеОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.	
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);		
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
	
	// Инициализация дополнительных свойств для проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
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
		|	НЕ СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)
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
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Нельзя списывать основное средство не принятое к учету. Строка %1 списка ""Основные средства"".'"), 
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
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли