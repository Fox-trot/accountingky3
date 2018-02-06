﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;

	Организация = ДанныеЗаполнения.Организация;
	Склад = ДанныеЗаполнения.Склад;
	СчетУчета = ДанныеЗаполнения.СчетРасчетов;

	// ОС.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаДокумента.ОсновноеСредство.Код КАК ИнвентарныйНомер,
		|	ТаблицаДокумента.Сумма КАК ПервоначальнаяСтоимость,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.Линейный) КАК СпособНачисленияАмортизации
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.ОС КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТабличнойЧасти = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);
	КонецЦикла;
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоИнвентаризацииОС(ДанныеЗаполнения) Экспорт

	Организация 		= ДанныеЗаполнения.Организация;
	ДокументОснование 	= ДанныеЗаполнения;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.ОС Цикл
		Если СтрокаТабличнойЧасти.ИзлишекСумма = 0 Тогда 
			Продолжить;
		КонецЕсли;	
		НоваяСтрокаТабличнойЧасти = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		НоваяСтрокаТабличнойЧасти.Подразделение = ДанныеЗаполнения.Подразделение;
		НоваяСтрокаТабличнойЧасти.ПервоначальнаяСтоимость = СтрокаТабличнойЧасти.ИзлишекСумма;
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
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.ИнвентаризацияОС")] = "ЗаполнитьПоИнвентаризацииОС";

	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Добавить("ОС");
	
	Если ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.ОсновныеСредства Тогда
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчета");
	КонецЕсли;	
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование") Тогда
		Если ВыбранноеКоличествоНоменклатуры <> ОС.Количество() Тогда
			ТекстСообщения = НСтр("ru = 'Количество строк записи должно совпадать с выбранным количеством номенклатуры.'");
			
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				Неопределено,
				Неопределено,
				Неопределено,
				Отказ);

		ИначеЕсли ОС.Итог("ПервоначальнаяСтоимость") <> СуммаВыбраннойНоменклатуры Тогда
			ТекстСообщения = НСтр("ru = 'Сумма первоначальной стоимости по всем строкам не совпадает с суммой выбранной номенклатуры.'");
			
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				Неопределено,
				Неопределено,
				Неопределено,
				Отказ);

		КонецЕсли;
	КонецЕсли;	

	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПринятиеКУчетуОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьПараметрыУчетаОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСостоянияОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьМестонахождениеОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСобытияОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОбИмуществе(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОТранспорте(ДополнительныеСвойства, Движения, Отказ);	
	БухгалтерскийУчетСервер.ОтразитьДвижениеОСНУ(ДополнительныеСвойства, Движения, Отказ); 
	
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);

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
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаДокумента.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
		|	ТаблицаДокумента.СпособНачисленияАмортизации КАК СпособНачисленияАмортизации,
		|	ТаблицаДокумента.СрокСлужбы КАК СрокСлужбы,
		|	ТаблицаДокумента.ОбъемПродукции КАК ОбъемПродукции
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВременнаяТаблицаОС1.НомерСтроки) КАК НомерСтроки,
		|	ВременнаяТаблицаОС1.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО ВременнаяТаблицаОС1.НомерСтроки <> ВременнаяТаблицаОС.НомерСтроки
		|			И ВременнаяТаблицаОС1.ОсновноеСредство = ВременнаяТаблицаОС.ОсновноеСредство
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОС1.ОсновноеСредство
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
		|	ЕСТЬNULL(СостоянияОССрезПоследних.Состояние, &ПустоеСостояние) КАК Состояние
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОС.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И ОсновноеСредство В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ВременнаяТаблицаОС.ОсновноеСредство
		|						ИЗ
		|							ВременнаяТаблицаОС КАК ВременнаяТаблицаОС)
		|					И НЕ Регистратор = &Ссылка) КАК СостоянияОССрезПоследних
		|		ПО ВременнаяТаблицаОС.ОсновноеСредство = СостоянияОССрезПоследних.ОсновноеСредство
		|ГДЕ
		|	(СостоянияОССрезПоследних.Состояние ЕСТЬ NULL
		|			ИЛИ НЕ СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.Поступило))
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|ГДЕ
		|	ВременнаяТаблицаОС.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.Линейный)
		|	И ВременнаяТаблицаОС.СрокСлужбы = 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|ГДЕ
		|	ВременнаяТаблицаОС.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.Производственный)
		|	И ВременнаяТаблицаОС.ОбъемПродукции = 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ТаблицаДокумента", ОС);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПустоеСостояние", НСтр("ru = 'Без поступления'"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Дубли строк ОС.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство указывается повторно в строке %1 списка ""ОС"".'"), 
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
	
	// Проверка состояния ОС.
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для основного средства ""%1"", указанного в строке %2 списка ""ОС"", текущее состояние ""%3"".'"), 
				ВыборкаИзРезультатаЗапроса.ОсновноеСредство,
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				ВыборкаИзРезультатаЗапроса.Состояние);
				
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ОС",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ОсновноеСредство",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Линейный. Должен быть указан срок службы.
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена колонка ""Срок службы"" в строке %1 списка ""ОС"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ОС",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"СрокСлужбы",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Производственный. Должен быть указан объем продукции.
	Если НЕ МассивРезультатов[4].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[4].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена колонка ""Объем продукции"" в строке %1 списка ""ОС"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ОС",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"ОбъемПродукции",
				Отказ);
		КонецЦикла;
	КонецЕсли;		
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

#КонецОбласти
	
#КонецЕсли