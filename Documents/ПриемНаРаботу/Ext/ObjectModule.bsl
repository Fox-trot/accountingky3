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
	Если НЕ ЗначениеЗаполнено(ИспытательныйСрок) Тогда 
		ИспытательныйСрок = ДобавитьМесяц(Период, 3);
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
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержанияНачало(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПлановыеУдержанияОкончание(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСтатусыСотрудников(ДополнительныеСвойства,Движения,Отказ);
	БухгалтерскийУчетСервер.ОтразитьСтажиСотрудников(ДополнительныеСвойства,Движения,Отказ);
	
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

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// Предварительный контроль.
	ВыполнитьПредварительныйКонтроль(Отказ);	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

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
	
	// Удержания.	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВременнаяТаблицаУдержания.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаУдержания.ВидРасчета КАК ВидРасчета
		|ПОМЕСТИТЬ ВременнаяТаблицаУдержания
		|ИЗ
		|	&ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУдержания.НомерСтроки КАК НомерСтроки,
		|	ПлановыеУдержания.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало КАК ПлановыеУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ПО (ПлановыеУдержания.ФизЛицо = &ФизЛицо)
		|			И ПлановыеУдержания.ВидРасчета = ВременнаяТаблицаУдержания.ВидРасчета
		|			И (ПлановыеУдержания.Период = &Период)
		|			И (ПлановыеУдержания.Регистратор <> &Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУдержания.НомерСтроки КАК НомерСтроки,
		|	ПлановыеУдержания.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияОкончание КАК ПлановыеУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ПО (ПлановыеУдержания.ФизЛицо = &ФизЛицо)
		|			И ПлановыеУдержания.ВидРасчета = ВременнаяТаблицаУдержания.ВидРасчета
		|			И (ПлановыеУдержания.Период = &Период)
		|			И (ПлановыеУдержания.Регистратор <> &Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаУдержанияДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаУдержанияДублиСтрок.ВидРасчета КАК ВидРасчета
		|ИЗ
		|	ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ТаблицаУдержанияДублиСтрок
		|		ПО ВременнаяТаблицаУдержания.НомерСтроки <> ТаблицаУдержанияДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаУдержания.ВидРасчета = ТаблицаУдержанияДублиСтрок.ВидРасчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаУдержанияДублиСтрок.ВидРасчета
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки"); 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Период", Дата);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ФизЛицо", ФизЛицо);
	Запрос.Параметры.Вставить("ВременнаяТаблицаУдержания", Удержания.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Плановые удержания".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Удержания"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Удержания",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Регистр "Плановые удержания".
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период действия приказа противоречит кадровому приказу ""%2"" в строке %1 списка ""Удержания"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Удержания",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;

	// Дубли строк.
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Вид удержания указывается повторно в строке %1 списка ""Удержания"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Удержания",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ВидРасчета",
				Отказ);
		КонецЦикла;
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ВестиШтатноеРасписание") Тогда
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
			
			Если Константы.ВвестиКонтрольЗапретаПоШтатномуРасписанию.Получить() Тогда
				БухгалтерскийУчетСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					,
					,
					"ЗанимаемыхСтавок",
					Отказ);
				
			Иначе	
				БухгалтерскийУчетСервер.СообщитьОбОшибке(
					ЭтотОбъект,
					ТекстСообщения,
					,
					,
					"ЗанимаемыхСтавок");	
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
		"ВЫБРАТЬ
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

#КонецЕсли


