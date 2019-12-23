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

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ДатаНачала > ДатаОкончания Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Дата начала периода не может быть больше даты окончания.'"));
		Отказ = Истина;
	КонецЕсли;
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(Ссылка, Организация, ФизЛицо, ДатаНачала, Новый Структура("ПлановыеУдержания", Истина));
	Если Не РезультатПроверки.ИзмененияВозможны Тогда
		ТекстСообщения = НСтр(
			"ru = 'Документ недоступен для редактирования, т.к. зарегистрированы более поздние изменения по данному сотруднику.'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения,
			,
			,
			,
			Отказ);
	КонецЕсли;
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
	Документы.ИсполнительныйЛист.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержанияНачало(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержанияОкончание(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПлановыеУдержанияНачало.Регистратор КАК Регистратор,
		|	""Начало"" КАК Содержание,
		|	NULL КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаПроверок
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало КАК ПлановыеУдержанияНачало
		|ГДЕ
		|	ПлановыеУдержанияНачало.Организация = &Организация
		|	И ПлановыеУдержанияНачало.ФизЛицо = &ФизЛицо
		|	И ПлановыеУдержанияНачало.ВидРасчета = &ВидРасчета
		|	И ПлановыеУдержанияНачало.Период = &ДатаНачала
		|	И ПлановыеУдержанияНачало.Регистратор <> &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеУдержанияНачало.Регистратор,
		|	""Начало"",
		|	NULL
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало КАК ПлановыеУдержанияНачало
		|ГДЕ
		|	ПлановыеУдержанияНачало.Организация = &Организация
		|	И ПлановыеУдержанияНачало.ФизЛицо = &ФизЛицо
		|	И ПлановыеУдержанияНачало.ВидРасчета = &ВидРасчета
		|	И ПлановыеУдержанияНачало.Период = &ДатаОкончания
		|	И ПлановыеУдержанияНачало.Регистратор <> &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеУдержанияОкончание.Регистратор,
		|	""Окончание"",
		|	NULL
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияОкончание КАК ПлановыеУдержанияОкончание
		|ГДЕ
		|	ПлановыеУдержанияОкончание.Организация = &Организация
		|	И ПлановыеУдержанияОкончание.ФизЛицо = &ФизЛицо
		|	И ПлановыеУдержанияОкончание.ВидРасчета = &ВидРасчета
		|	И ПлановыеУдержанияОкончание.Период = &ДатаНачала
		|	И ПлановыеУдержанияОкончание.Регистратор <> &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеУдержанияОкончание.Регистратор,
		|	""Окончание"",
		|	NULL
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияОкончание КАК ПлановыеУдержанияОкончание
		|ГДЕ
		|	ПлановыеУдержанияОкончание.Организация = &Организация
		|	И ПлановыеУдержанияОкончание.ФизЛицо = &ФизЛицо
		|	И ПлановыеУдержанияОкончание.ВидРасчета = &ВидРасчета
		|	И ПлановыеУдержанияОкончание.Период = &ДатаОкончания
		|	И ПлановыеУдержанияОкончание.Регистратор <> &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&ДатаНачала,
		|			ФизЛицо = &ФизЛицо
		|				И Организация = &Организация) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.Период <= &ДатаНачала
		|	И (СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
		|			ИЛИ СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Перемещение))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТаблицаПроверок.Регистратор КАК Регистратор,
		|	ТаблицаПроверок.Содержание КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаПроверок КАК ТаблицаПроверок");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("ВидРасчета", ВидРасчета);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.ВыполнитьПакет();
	
	// 1.
	Если Результат[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = Результат[1].Выбрать();
		ВыборкаИзРезультатаЗапроса.Следующий();
		ТекстСообщения = НСтр("ru = 'На дату начала сотрудник еще не был принят на работу.'");
												
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения,
			,
			,
			"ДатаНачала",
			Отказ);			
	КонецЕсли;	

	// 2.
	Если НЕ Результат[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = Результат[2].Выбрать();
		ВыборкаИзРезультатаЗапроса.Следующий();
		Если ВыборкаИзРезультатаЗапроса.Содержание = "Начало" Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия этого документа противоречит документу ""%1"". По регистру ""Плановые удержания (начало)"".'"), 
							ВыборкаИзРезультатаЗапроса.Регистратор);
		Иначе
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия этого документа противоречит документу ""%1"". По регистру ""Плановые удержания (окончание)"".'"), 
							ВыборкаИзРезультатаЗапроса.Регистратор);
		КонецЕсли;
												
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения,
			,
			,
			"Период",
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли