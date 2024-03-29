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
	
	// Контроль
	ВыполнитьКонтроль(ДополнительныеСвойства, Отказ);

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

	Если Период > ДатаОкончанияРаботы Тогда 
		ТекстСообщения = НСтр("ru = 'Дата начала работы не может превышать дату окончания.'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Период", Отказ);
	ИначеЕсли НЕ НачалоМесяца(Период) = НачалоМесяца(ДатаОкончанияРаботы) Тогда 
		ТекстСообщения = НСтр("ru = 'Дата начала и дата окончания работы должны быть в одном месяце.'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Период", Отказ);
	КонецЕсли;	
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

//// Процедура - обработчик события ПередЗаписью объекта.
////
//Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
//	
//	Если ОбменДанными.Загрузка Тогда
//		Возврат;
//	КонецЕсли;

//	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(Ссылка, Организация, ФизЛицо, Период);
//	Если Не РезультатПроверки.ИзмененияВозможны Тогда
//		ТекстСообщения = НСтр(
//			"ru = 'Документ недоступен для редактирования, т.к. зарегистрированы более поздние изменения по данному сотруднику.'");
//		БухгалтерскийУчетСервер.СообщитьОбОшибке(
//			ЭтотОбъект,
//			ТекстСообщения,
//			,
//			,
//			,
//			Отказ);
//	КонецЕсли;
//КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ТрудовоеСоглашение.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьСотрудникиПоТрудовымСоглашениям(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСтатусыСотрудников(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Отказ); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СотрудникиПоТрудовымСоглашениямСрезПоследних.Регистратор,
		|	СотрудникиПоТрудовымСоглашениямСрезПоследних.ФизЛицо
		|ИЗ
		|	РегистрСведений.СотрудникиПоТрудовымСоглашениям.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК СотрудникиПоТрудовымСоглашениямСрезПоследних
		|ГДЕ
		|	СотрудникиПоТрудовымСоглашениямСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)");
	Запрос.Параметры.Вставить("Период", Период);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "СотрудникиПоТрудовымСоглашениям".
	Если НЕ МассивРезультатов[0].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит трудовому соглашению ""%1"".'"), 
							ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				"Период",
				Отказ);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьКонтроль(ДополнительныеСвойства, Отказ)
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;

	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо,
		|	СотрудникиСрезПоследних.ВидСобытия КАК ВидСобытия
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Дата,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И НЕ Регистратор = &Ссылка) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	НЕ СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)");
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	// Сотрудник уже принят на работу на дату приема.
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр(
			"ru = 'Сотрудник %ФизЛицо% уже работает в организации %Организация%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ФизЛицо%", ФизЛицо); 
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Организация%", Организация);
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			ТекстСообщения,
			,
			,
			"ФизЛицо",
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли