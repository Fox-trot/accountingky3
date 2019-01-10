﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПлановоеУдержание.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержанияНачало(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержанияОкончание(ДополнительныеСвойства, Движения, Отказ);
	
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

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Удержания");
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Удержания.	
	// Табличная часть Сотрудники.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаУдержания.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаУдержания.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаУдержания.ВидРасчета КАК ВидРасчета,
		|	ВременнаяТаблицаУдержания.ВидДействия КАК ВидДействия
		|ПОМЕСТИТЬ ВременнаяТаблицаУдержания
		|ИЗ
		|	&ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания";
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	// РС Плановые удержания (Начало).
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	ВременнаяТаблицаУдержания.НомерСтроки КАК НомерСтроки,
		|	ПлановыеУдержания.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало КАК ПлановыеУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ПО ПлановыеУдержания.ФизЛицо = ВременнаяТаблицаУдержания.ФизЛицо
		|			И (ПлановыеУдержания.Период = &Период)
		|			И ПлановыеУдержания.ВидРасчета = ВременнаяТаблицаУдержания.ВидРасчета
		|			И (ПлановыеУдержания.Регистратор <> &Ссылка)
		|ГДЕ
		|	ВременнаяТаблицаУдержания.ВидДействия = ЗНАЧЕНИЕ(Перечисление.ВидыДействияНачисленийУдержаний.Начать)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	// РС Плановые удержания (Окончание).
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	ВременнаяТаблицаУдержания.НомерСтроки КАК НомерСтроки,
		|	ПлановыеУдержания.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияОкончание КАК ПлановыеУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ПО ПлановыеУдержания.ФизЛицо = ВременнаяТаблицаУдержания.ФизЛицо
		|			И ПлановыеУдержания.Период = &Период
		|			И ПлановыеУдержания.ВидРасчета = ВременнаяТаблицаУдержания.ВидРасчета
		|			И (ПлановыеУдержания.Регистратор <> &Ссылка)
		|
		|ГДЕ
		|	ВременнаяТаблицаУдержания.ВидДействия = ЗНАЧЕНИЕ(Перечисление.ВидыДействияНачисленийУдержаний.Прекратить)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	// Дубли строк.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаУдержанияДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаУдержанияДублиСтрок.ФизЛицо КАК ФизЛицо,
		|	ТаблицаУдержанияДублиСтрок.ВидРасчета КАК ВидРасчета
		|ИЗ
		|	ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ТаблицаУдержанияДублиСтрок
		|		ПО ВременнаяТаблицаУдержания.НомерСтроки <> ТаблицаУдержанияДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаУдержания.ФизЛицо = ТаблицаУдержанияДублиСтрок.ФизЛицо
		|			И ВременнаяТаблицаУдержания.ВидРасчета = ТаблицаУдержанияДублиСтрок.ВидРасчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаУдержанияДублиСтрок.ФизЛицо,
		|	ТаблицаУдержанияДублиСтрок.ВидРасчета
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("Период", Дата);
	Запрос.Параметры.Вставить("ВременнаяТаблицаУдержания", Сотрудники.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Плановые удержания".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Сотрудники"". По регистру ""Плановые удержания (начало)"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Регистр "Плановые удержания".
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Сотрудники"". По регистру ""Плановые начисления (окончание)"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;

	// Дубли строк.
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Вид удержания указывается повторно в строке %1 списка ""Сотрудники"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли