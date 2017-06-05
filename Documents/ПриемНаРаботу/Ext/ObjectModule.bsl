﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	//ВидРасчетаДолжности = Должность.ВидРасчета;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВременнаяТаблицаНачисления.НомерСтроки,
		|	ВременнаяТаблицаНачисления.ВидРасчета
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	&ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.Регистратор
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Организация = &Организация
		|	И Сотрудники.ФизЛицо = &ФизЛицо
		|	И Сотрудники.Период = &Период
		|	И Сотрудники.Регистратор <> &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаНачисления.НомерСтроки КАК НомерСтроки,
		|	ПлановыеНачисления.Регистратор
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало КАК ПлановыеНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|		ПО (ПлановыеНачисления.ФизЛицо = &ФизЛицо)
		|			И ПлановыеНачисления.ВидРасчета = ВременнаяТаблицаНачисления.ВидРасчета
		|			И (ПлановыеНачисления.Период = &Период)
		|			И (ПлановыеНачисления.Регистратор <> &Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаНачисления.НомерСтроки КАК НомерСтроки,
		|	ПлановыеНачисления.Регистратор
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияОкончание КАК ПлановыеНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|		ПО (ПлановыеНачисления.ФизЛицо = &ФизЛицо)
		|			И ПлановыеНачисления.ВидРасчета = ВременнаяТаблицаНачисления.ВидРасчета
		|			И (ПлановыеНачисления.Период = &Период)
		|			И (ПлановыеНачисления.Регистратор <> &Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаНачисленияДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаНачисленияДублиСтрок.ВидРасчета
		|ИЗ
		|	ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаНачисленияДублиСтрок
		|		ПО ВременнаяТаблицаНачисления.НомерСтроки <> ТаблицаНачисленияДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаНачисления.ВидРасчета = ТаблицаНачисленияДублиСтрок.ВидРасчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаНачисленияДублиСтрок.ВидРасчета
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");                          	
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.Параметры.Вставить("Период", 			Дата);
	Запрос.Параметры.Вставить("Организация", 		Организация);
	Запрос.Параметры.Вставить("ФизЛицо", 			ФизЛицо);
	Запрос.Параметры.Вставить("ВременнаяТаблицаНачисления", 	Начисления.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Сотрудники".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%1"".'"), 
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

	// Регистр "Плановые начисления".
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Начисления"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Начисления",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Регистр "Плановые начисления".
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Начисления"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Начисления",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Дубли строк.
	Если НЕ МассивРезультатов[4].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Вид начисления указывается повторно в строке %1 списка ""Начисления"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Начисления",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

// Выполняет контроль противоречий.
//
Процедура ВыполнитьКонтроль(ДополнительныеСвойства, Отказ)
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;

	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудникиИзДокумента
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо,
		|	СотрудникиСрезПоследних.ВидСобытия
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Дата,
		|			Организация = &Организация
		|				И Регистратор <> &Ссылка
		|				И ФизЛицо В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСотрудникиИзДокумента.ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаСотрудникиИзДокумента КАК ВременнаяТаблицаСотрудникиИзДокумента)) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	НЕ СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)");
		
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	// Сотрудник уже принят на работу на дату приема.
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр(
			"ru = 'Сотрудник %ФизЛицо% уже работает в организации %Организация%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ФизЛицо%", Выборка.ФизЛицо); 
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

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектов.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда 
		Период = ДатаДокумента;
	КонецЕсли;		
	Если НЕ ЗначениеЗаполнено(ИспытательныйСрок) Тогда 
		ИспытательныйСрок = ДобавитьМесяц(Период, 3);
	КонецЕсли;		
	Если ЗанимаемыхСтавок = 0 Тогда 
		ЗанимаемыхСтавок = 1;	
	КонецЕсли;		
	Если НЕ ЗначениеЗаполнено(ГрафикРаботы) Тогда 
		ГрафикРаботы = Справочники.Календари.Основной;	
	КонецЕсли;		
	Если НЕ ЗначениеЗаполнено(Статус) Тогда 
		Статус = Справочники.Статусы.Основной;	
	КонецЕсли;	
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	ФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПриемНаРаботу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьСотрудники(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеНачисленияНачало(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеНачисленияОкончание(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержания(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСтатусыСотрудников(ДополнительныеСвойства,Движения,Отказ);
	
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
		
КонецПроцедуры

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Статус.Категория = Справочники.КатегорииСотрудников.ИностранныеГраждане Тогда 
		ПроверяемыеРеквизиты.Добавить("СчетУчетаРасчетовСФФРК");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаРасчетовПФРРК");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаРасчетовСНФРК");
	КонецЕсли;	
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#КонецЕсли


