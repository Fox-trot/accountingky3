﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда 
		ПериодРегистрации = ?(ЗначениеЗаполнено(Дата), НачалоМесяца(Дата), НачалоМесяца(ТекущаяДатаСеанса()));
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.Профвзносы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьПрофвзносы(ДополнительныеСвойства, Движения, Отказ);
	
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

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Сотрудники");
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВременнаяТаблицаСотрудники.ФизЛицо,
		|	ВременнаяТаблицаСотрудники.НомерСтроки,
		|	ВременнаяТаблицаСотрудники.ВидДвижения
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	&ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСотрудники.ФизЛицо,
		|	МИНИМУМ(ВременнаяТаблицаСотрудники.НомерСтроки) КАК НомерСтроки,
		|	ЕСТЬNULL(ПрофвзносыСрезПоследних.Регистратор, ЗНАЧЕНИЕ(Документ.Профвзносы.ПустаяСсылка)) КАК Регистратор,
		|	ПрофвзносыСрезПоследних.ВидДвижения
		|ИЗ
		|	ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Профвзносы.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И (ФизЛицо) В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ВременнаяТаблицаСотрудники.ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники)
		|					И НЕ Регистратор = &Ссылка) КАК ПрофвзносыСрезПоследних
		|		ПО ВременнаяТаблицаСотрудники.ФизЛицо = ПрофвзносыСрезПоследних.ФизЛицо
		|ГДЕ
		|	(ВременнаяТаблицаСотрудники.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПоПрофсоюзам.Выход)
		|			ИЛИ ВременнаяТаблицаСотрудники.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПоПрофсоюзам.Переход))
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаСотрудники.ФизЛицо,
		|	ЕСТЬNULL(ПрофвзносыСрезПоследних.Регистратор, ЗНАЧЕНИЕ(Документ.Профвзносы.ПустаяСсылка)),
		|	ПрофвзносыСрезПоследних.ВидДвижения
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаСотрудникиДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаСотрудникиДублиСтрок.ФизЛицо
		|ИЗ
		|	ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ТаблицаСотрудникиДублиСтрок
		|		ПО ВременнаяТаблицаСотрудники.НомерСтроки <> ТаблицаСотрудникиДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаСотрудники.ФизЛицо = ТаблицаСотрудникиДублиСтрок.ФизЛицо
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаСотрудникиДублиСтрок.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
	Запрос.УстановитьПараметр("ВременнаяТаблицаСотрудники", Сотрудники.Выгрузить());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", ПериодРегистрации);
	Запрос.УстановитьПараметр("Организация", Организация);
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Контроль выхода или перехода.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			Если ВыборкаИзРезультатаЗапроса.Регистратор.Пустая() Тогда 
				ТекстСообщения = СтрШаблон(НСтр("ru = 'На сотрудника ""%1"" не найдено документа о вхождении.'"), 
								ВыборкаИзРезультатаЗапроса.ФизЛицо);
			ИначеЕсли ВыборкаИзРезультатаЗапроса.ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидыДвиженийПоПрофсоюзам.Выход") Тогда 
				ТекстСообщения = СтрШаблон(НСтр("ru = 'На сотрудника ""%1"" уже оформлен документ о выходе: ""%2"".'"), 
								ВыборкаИзРезультатаЗапроса.ФизЛицо, ВыборкаИзРезультатаЗапроса.Регистратор);
			Иначе 
				Продолжить;
			КонецЕсли;	
							
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ФизЛицо",
				Отказ);
		КонецЦикла;	
	КонецЕсли;		
	
	// Дубли строк.
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Сотрудник указывается повторно в строке %1 списка ""Сотрудники"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Соответствия",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"СчетУчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
