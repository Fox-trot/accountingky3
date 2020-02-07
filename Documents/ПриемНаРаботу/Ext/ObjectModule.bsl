﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда 
		Период = ДатаДокумента;
	КонецЕсли;		
	Если ЗанимаемыхСтавок = 0 Тогда 
		ЗанимаемыхСтавок = 1;	
	КонецЕсли;		
	Если НЕ ЗначениеЗаполнено(ГрафикРаботы) Тогда 
		ГрафикРаботы = Справочники.ГрафикиРаботы.Основной;	
	КонецЕсли;		
	Если НЕ ЗначениеЗаполнено(Статус) Тогда 
		Статус = Справочники.Статусы.Основной;	
	КонецЕсли;	
	
КонецПроцедуры

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	ФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();	
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
	// Предварительный контроль.
	ВыполнитьПредварительныйКонтроль(Отказ);	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЗанимаемыхСтавок = 0 Тогда 
		ЗанимаемыхСтавок = 1;	
	КонецЕсли;		
	
	РезультатПроверки = СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(Ссылка, Организация, ФизЛицо, Период);
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
	Документы.ПриемНаРаботу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьСотрудники(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеНачисленияНачало(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеНачисленияОкончание(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСтатусыСотрудников(ДополнительныеСвойства,Движения,Отказ);
	БухгалтерскийУчетСервер.ОтразитьСтажиСотрудников(ДополнительныеСвойства,Движения,Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Начисления.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВременнаяТаблицаНачисления.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаНачисления.ВидРасчета КАК ВидРасчета,
		|	ВременнаяТаблицаНачисления.Валюта КАК Валюта
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	&ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.Регистратор КАК Регистратор
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
		|	ПлановыеНачисления.Регистратор КАК Регистратор
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
		|	ПлановыеНачисления.Регистратор КАК Регистратор
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
		|	ТаблицаНачисленияДублиСтрок.ВидРасчета КАК ВидРасчета
		|ИЗ
		|	ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаНачисленияДублиСтрок
		|		ПО ВременнаяТаблицаНачисления.НомерСтроки <> ТаблицаНачисленияДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаНачисления.ВидРасчета = ТаблицаНачисленияДублиСтрок.ВидРасчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаНачисленияДублиСтрок.ВидРасчета
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВременнаяТаблицаНачисления.НомерСтроки),
		|	ВременнаяТаблицаНачисления.ВидРасчета
		|ИЗ
		|	ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|ГДЕ
		|	ВременнаяТаблицаНачисления.ВидРасчета = &ВидРасчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаНачисления.ВидРасчета
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаНачисления.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаНачисления.ВидРасчета КАК ВидРасчета
		|ИЗ
		|	ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|ГДЕ
		|	ВременнаяТаблицаНачисления.ВидРасчета.СпособРасчета В(&СпособыРасчета)
		|	И НЕ ВременнаяТаблицаНачисления.Валюта = &Валюта
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки"); 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Период", Дата);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ФизЛицо", ФизЛицо);
	Запрос.Параметры.Вставить("ВидРасчета", ВидРасчета);
	Запрос.УстановитьПараметр("Валюта", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Запрос.Параметры.Вставить("ВременнаяТаблицаНачисления", Начисления.Выгрузить());
	
	СпособыРасчета = Новый СписокЗначений;
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.ГодоваяПремия);
	СпособыРасчета.Добавить(Перечисления.СпособыРасчетаНачислений.Процентом);
	Запрос.УстановитьПараметр("СпособыРасчета", СпособыРасчета);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Сотрудники".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%1"". По регистру ""Сотрудники"".'"), 
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
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Начисления"". По регистру ""Плановые начисления (начало)"".'"), 
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
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Начисления"". По регистру ""Плановые начисления (окончание)"".'"), 
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
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[4].Выбрать();
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
	
	Если ПолучитьФункциональнуюОпцию("УчетЗаработнойПлатыВВалюте") Тогда 
		// Контроль указания валюты для способа расчета "Процентом"
		// Разрешается только валюта регл.учета
		Если НЕ МассивРезультатов[5].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[5].Выбрать();
			Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для вида начисления указывается не верная валюта (нужно указать валюту регламентированного учета) в строке %1 списка ""Начисления"".'"), 
								ВыборкаИзРезультатаЗапроса.НомерСтроки);
				БухгалтерскийУчетСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					"Начисления",
					ВыборкаИзРезультатаЗапроса.НомерСтроки,
					"Валюта",
					Отказ);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ВестиШтатноеРасписание") Тогда
		
		Если Константы.ВвестиКонтрольЗапретаСтавкиПоШтатномуРасписанию.Получить() Тогда 
			Запрос = Новый Запрос();
			Запрос.Текст =
				"ВЫБРАТЬ
				|	СотрудникиСрезПоследних.Организация КАК Организация,
				|	СотрудникиСрезПоследних.Подразделение КАК Подразделение,
				|	СотрудникиСрезПоследних.Должность КАК Должность,
				|	СУММА(СотрудникиСрезПоследних.ЗанимаемыхСтавок) КАК ЗанимаемыхСтавок
				|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
				|ИЗ
				|	РегистрСведений.Сотрудники.СрезПоследних(
				|				&Период,
				|				Организация = &Организация
				|					И Подразделение = &Подразделение
				|					И Должность = &Должность) КАК СотрудникиСрезПоследних
				|ГДЕ
				|	СотрудникиСрезПоследних.Регистратор <> &Ссылка
				|	И СотрудникиСрезПоследних.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
				|
				|СГРУППИРОВАТЬ ПО
				|	СотрудникиСрезПоследних.Организация,
				|	СотрудникиСрезПоследних.Подразделение,
				|	СотрудникиСрезПоследних.Должность
				|;
				|
				|//////////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ШтатноеРасписаниеСрезПоследних.Организация КАК Организация,
				|	ШтатноеРасписаниеСрезПоследних.Подразделение КАК Подразделение,
				|	ШтатноеРасписаниеСрезПоследних.Должность КАК Должность,
				|	МАКСИМУМ(ШтатноеРасписаниеСрезПоследних.КоличествоСтавок) КАК КоличествоСтавок,
				|	СУММА(ЕСТЬNULL(ВременнаяТаблицаСотрудники.ЗанимаемыхСтавок, 0)) КАК ЗанимаемыхСтавок
				|ИЗ
				|	РегистрСведений.ШтатноеРасписание.СрезПоследних(
				|			&Период,
				|			Организация = &Организация
				|				И Должность = &Должность
				|				И Подразделение = &Подразделение) КАК ШтатноеРасписаниеСрезПоследних
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
				|		ПО (ВременнаяТаблицаСотрудники.Организация = ШтатноеРасписаниеСрезПоследних.Организация)
				|			И (ВременнаяТаблицаСотрудники.Подразделение = ШтатноеРасписаниеСрезПоследних.Подразделение)
				|			И (ВременнаяТаблицаСотрудники.Должность = ШтатноеРасписаниеСрезПоследних.Должность)
				|
				|СГРУППИРОВАТЬ ПО
				|	ШтатноеРасписаниеСрезПоследних.Организация,
				|	ШтатноеРасписаниеСрезПоследних.Подразделение,
				|	ШтатноеРасписаниеСрезПоследних.Должность";
			Запрос.УстановитьПараметр("Ссылка", 	 	Ссылка);
			Запрос.УстановитьПараметр("Период", 	 	Дата);
			Запрос.УстановитьПараметр("Организация", 	Организация);
			Запрос.УстановитьПараметр("Должность", 	 	Должность);
			Запрос.УстановитьПараметр("Подразделение", 	Подразделение);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Ошибка = Ложь;
			УказаноБольшеСтавок = Ложь;
			КоличествоСтавок = 0;
			ОставшихсяСтавок = 0;
			
			Если Выборка.Следующий() Тогда
				
				Если Выборка.КоличествоСтавок <= Выборка.ЗанимаемыхСтавок Тогда			
					Ошибка = Истина;
					КоличествоСтавок = Выборка.КоличествоСтавок;
					
				ИначеЕсли (Выборка.КоличествоСтавок - Выборка.ЗанимаемыхСтавок) < ЗанимаемыхСтавок Тогда
					Ошибка = Истина;
					КоличествоСтавок = Выборка.КоличествоСтавок;
					ОставшихсяСтавок = Выборка.КоличествоСтавок - Выборка.ЗанимаемыхСтавок;
					УказаноБольшеСтавок = Истина;
				КонецЕсли;
				
			Иначе
				Ошибка = Истина;
			КонецЕсли;
			
			Если Ошибка Тогда
				Если КоличествоСтавок <> 0 И УказаноБольшеСтавок Тогда
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Для указанных организации, подразделения и должности по штатному расписанию указано %1 ставок из них свободных осталось %2 ставок.'"), 
									КоличествоСтавок, ОставшихсяСтавок);
				ИначеЕсли КоличествоСтавок <> 0 Тогда
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Для указанных организации, подразделения и должности по штатному расписанию указано %1 ставок и все они уже заняты.'"), 
									КоличествоСтавок);
				Иначе			
					ТекстСообщения = НСтр("ru = 'Для указанных организации, подразделения и должности по штатному расписанию нет ставок.'")
				КонецЕсли;
			
				БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "ЗанимаемыхСтавок", Отказ);
			КонецЕсли;
		КонецЕсли;	
		
		// Контроль Размера оклада
		Если Константы.ВвестиКонтрольЗапретаРазмераПоШтатномуРасписанию.Получить()
			И не Отказ Тогда 
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ШтатноеРасписаниеСрезПоследних.МаксимальнаяТарифнаяСтавка КАК МаксимальнаяТарифнаяСтавка
				|ИЗ
				|	РегистрСведений.ШтатноеРасписание.СрезПоследних(
				|			&Период,
				|			Организация = &Организация
				|				И Подразделение = &Подразделение
				|				И Должность = &Должность) КАК ШтатноеРасписаниеСрезПоследних
				|ГДЕ
				|	ШтатноеРасписаниеСрезПоследних.ВидНачисления = &ВидНачисления
				|	И ШтатноеРасписаниеСрезПоследних.МаксимальнаяТарифнаяСтавка < &Размер";
			Запрос.УстановитьПараметр("Период", Период);
			Запрос.УстановитьПараметр("Организация", Организация);
			Запрос.УстановитьПараметр("Подразделение", Подразделение);
			Запрос.УстановитьПараметр("Должность", Должность);
			Запрос.УстановитьПараметр("ВидНачисления", ВидРасчета);
			Запрос.УстановитьПараметр("Размер", Размер);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Если НЕ РезультатЗапроса.Пустой() Тогда
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				ВыборкаДетальныеЗаписи.Следующий();
				 
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для указанных организации, подразделения и должности по штатному расписанию указана максимальная тарифная ставка: %1 .'"), 
								ВыборкаДетальныеЗаписи.МаксимальнаяТарифнаяСтавка);
								
				БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Размер", Отказ);
			КонецЕсли;	
		КонецЕсли;	
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
	
	Если ЗначениеЗаполнено(ДатаОкончанияРаботы) Тогда 
		// По сотруднику уже оформлены движения в будущем.
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СотрудникиСрезПервых.ФизЛицо КАК ФизЛицо,
			|	СотрудникиСрезПервых.Период КАК Период
			|ИЗ
			|	РегистрСведений.Сотрудники.СрезПервых(
			|			&Период,
			|			Организация = &Организация
			|				И ФизЛицо = &ФизЛицо
			|				И НЕ Регистратор = &Ссылка) КАК СотрудникиСрезПервых
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПлановыеНачисленияНачалоСрезПервых.ФизЛицо КАК ФизЛицо,
			|	ПлановыеНачисленияНачалоСрезПервых.Период КАК Период
			|ИЗ
			|	РегистрСведений.ПлановыеНачисленияНачало.СрезПервых(
			|			&Период,
			|			Организация = &Организация
			|				И ФизЛицо = &ФизЛицо
			|				И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияНачалоСрезПервых
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПлановыеНачисленияОкончаниеСрезПервых.ФизЛицо КАК ФизЛицо,
			|	ПлановыеНачисленияОкончаниеСрезПервых.Период КАК Период
			|ИЗ
			|	РегистрСведений.ПлановыеНачисленияОкончание.СрезПервых(
			|			&Период,
			|			Организация = &Организация
			|				И ФизЛицо = &ФизЛицо
			|				И НЕ Регистратор = &Ссылка) КАК ПлановыеНачисленияОкончаниеСрезПервых
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПлановыеУдержанияОкончаниеСрезПервых.ФизЛицо КАК ФизЛицо,
			|	ПлановыеУдержанияОкончаниеСрезПервых.Период КАК Период
			|ИЗ
			|	РегистрСведений.ПлановыеУдержанияОкончание.СрезПервых(
			|			&Период,
			|			Организация = &Организация
			|				И ФизЛицо = &ФизЛицо
			|				И НЕ Регистратор = &Ссылка) КАК ПлановыеУдержанияОкончаниеСрезПервых");
		Запрос.УстановитьПараметр("Период", Период);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		// По сотруднику есть движения после увольнения по регистру "Сотрудники".
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			ВыборкаИзРезультатаЗапроса.Следующий();
			ТекстСообщения = СтрШаблон(НСтр("ru = 'По сотруднику %1 есть кадровые движения %2 после даты увольнения. По регистру ""Сотрудники"".'"), 
							ВыборкаИзРезультатаЗапроса.ФизЛицо, Формат(ВыборкаИзРезультатаЗапроса.Период, "ДФ=dd.MM.yy"));
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				"ФизЛицо",
				Отказ);
		КонецЕсли; 
				
		// По сотруднику есть движения после увольнения по регистру "ПлановыеНачисления".
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			ВыборкаИзРезультатаЗапроса.Следующий(); 
			ТекстСообщения = СтрШаблон(НСтр("ru = 'По сотруднику %1 есть кадровые движения %2 после даты увольнения. По регистру ""Плановые начисления (начало)"".'"), 
							ВыборкаИзРезультатаЗапроса.ФизЛицо, Формат(ВыборкаИзРезультатаЗапроса.Период, "ДФ=dd.MM.yy"));
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				"ФизЛицо",
				Отказ);
		КонецЕсли; 
		
		// По сотруднику есть движения после увольнения по регистру "ПлановыеНачисленияОкончание".
		Если НЕ МассивРезультатов[2].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
			ВыборкаИзРезультатаЗапроса.Следующий(); 
			ТекстСообщения = СтрШаблон(НСтр("ru = 'По сотруднику %1 есть кадровые движения %2 после даты увольнения. По регистру ""Плановые начисления (окончание)"".'"), 
							ВыборкаИзРезультатаЗапроса.ФизЛицо, Формат(ВыборкаИзРезультатаЗапроса.Период, "ДФ=dd.MM.yy"));
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				"ФизЛицо",
				Отказ);
		КонецЕсли; 
				
		// По сотруднику есть движения после увольнения по регистру "ПлановыеУдержанияОкончание".
		Если НЕ МассивРезультатов[3].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
			ВыборкаИзРезультатаЗапроса.Следующий();
			ТекстСообщения = СтрШаблон(НСтр("ru = 'По сотруднику %1 есть кадровые движения %2 после даты увольнения. По регистру ""Плановые удержания (окончание)"".'"), 
							ВыборкаИзРезультатаЗапроса.ФизЛицо, Формат(ВыборкаИзРезультатаЗапроса.Период, "ДФ=dd.MM.yy"));
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				,
				,
				"ФизЛицо",
				Отказ);
		КонецЕсли; 
	КонецЕсли;	
КонецПроцедуры
	
#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли