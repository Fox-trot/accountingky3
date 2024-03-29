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
	
	// проверка заполненого значения
	Если Не ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.Ликвидация Тогда 	
		ПроверяемыеРеквизиты.Добавить("ОС");				
	КонецЕсли;	
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
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
	Документы.КомплектацияОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьСоставОС(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПараметрыУчетаКомплектовОС(ДополнительныеСвойства, Движения, Отказ);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТабличнуюЧасть() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставОССрезПоследних.ОсновноеСредствоВСоставеКомплекта КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СоставОС.СрезПоследних(
		|			&Период,
		|			ОсновноеСредство = &Комплект
		|				И НЕ Регистратор = &Ссылка) КАК СоставОССрезПоследних
		|ГДЕ
		|	(СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация)
		|					ИЛИ СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление))";
	
	Запрос.УстановитьПараметр("Период", 	Дата);
	Запрос.УстановитьПараметр("Ссылка", 	Ссылка);	
	Запрос.УстановитьПараметр("Комплект", 	Комплект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ОС.Очистить();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТабличнойЧасти = ОС.Добавить();	
		СтрокаТабличнойЧасти.ОсновноеСредство = ВыборкаДетальныеЗаписи.ОсновноеСредство;
	КонецЦикла;

КонецПроцедуры

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	КонтрольДублейИПараметровУчета(Отказ);
	
	Если ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.ВыводИзКомплекта 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.Ликвидация Тогда		
		
		КонтрольПриВыводеИзКомплекта(Отказ);

	КонецЕсли;	
	
	КонтрольВхожденияВДругиеКомплекты(Отказ);
	КонтрольРодительскоеОСУжеПринятоКУчету(Отказ);
		
КонецПроцедуры

Процедура КонтрольДублейИПараметровУчета(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВременнаяТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаОС.ОсновноеСредство) КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаГруппировка
	|ИЗ
	|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаОС.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаГруппировка.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	ВременнаяТаблицаГруппировка КАК ВременнаяТаблицаГруппировка
	|ГДЕ
	|	ВременнаяТаблицаГруппировка.Количество > 1";
	
	Запрос.Параметры.Вставить("ТаблицаОС", ОС.Выгрузить());

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		// Снято с учета или передано
		Если ВыборкаДетальныеЗаписи.Состояние = Перечисления.ВидыСостоянийОС.СнятоСУчета
			Или ВыборкаДетальныеЗаписи.Состояние = Перечисления.ВидыСостоянийОС.Передано Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Дублирование в табличной части основного средство ""%1"".'"), 
				ВыборкаДетальныеЗаписи.ОсновноеСредство);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				,
				,
				Отказ);
		КонецЕсли;		
					
	КонецЕсли;	

	// Соответствие ОС в табличной части параметрам комплекта
	Запрос = Новый Запрос;
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВременнаяТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставОССрезПоследних.ОсновноеСредствоВСоставеКомплекта КАК ОсновноеСредствоВСоставеКомплекта,
	|	СоставОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ВременнаяТаблицаОСВКомплектах
	|ИЗ
	|	РегистрСведений.СоставОС.СрезПоследних(
	|			&Период,
	|			НЕ ОсновноеСредство = &ОсновноеСредство
	|				И НЕ Регистратор = &ДокументСсылка) КАК СоставОССрезПоследних
	|ГДЕ
	|	(СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация)
	|					ИЛИ СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	СостоянияОССрезПоследних.Состояние КАК Состояние,
	|	МестонахождениеОССрезПоследних.МОЛ КАК МОЛ,
	|	МестонахождениеОССрезПоследних.Подразделение КАК Подразделение,
	|	ПараметрыУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА ВременнаяТаблицаОСВКомплектах.ОсновноеСредствоВСоставеКомплекта ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ВходитВДругойКомплект,
	|	СостоянияОССрезПоследних.Регистратор КАК РегистраторСнятоСУчета,
	|	ВременнаяТаблицаОСВКомплектах.ОсновноеСредство КАК ДругойКомплект
	|ИЗ
	|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС.СрезПоследних(
	|				ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0),
	|				НЕ Регистратор = &ДокументСсылка
	|					И Организация = &Организация) КАК ПараметрыУчетаОССрезПоследних
	|		ПО ВременнаяТаблицаОС.ОсновноеСредство = ПараметрыУчетаОССрезПоследних.ОсновноеСредство
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОС.СрезПоследних(
	|				ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0),
	|				НЕ Регистратор = &ДокументСсылка
	|					И Организация = &Организация) КАК СостоянияОССрезПоследних
	|		ПО ВременнаяТаблицаОС.ОсновноеСредство = СостоянияОССрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОССрезПоследних
	|		ПО ВременнаяТаблицаОС.ОсновноеСредство = МестонахождениеОССрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаОСВКомплектах КАК ВременнаяТаблицаОСВКомплектах
	|		ПО ВременнаяТаблицаОС.ОсновноеСредство = ВременнаяТаблицаОСВКомплектах.ОсновноеСредствоВСоставеКомплекта
	|ГДЕ
	|	ВременнаяТаблицаОСВКомплектах.ОсновноеСредствоВСоставеКомплекта ЕСТЬ NULL";
	
	Запрос.Параметры.Вставить("Период", 			Дата);
	Запрос.Параметры.Вставить("ДокументСсылка", 	Ссылка);
	Запрос.Параметры.Вставить("Организация", 		Организация);	
	Запрос.Параметры.Вставить("ТаблицаОС", 			ОС.Выгрузить());
	Запрос.Параметры.Вставить("ОсновноеСредство", 	Комплект);	

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		// Снято с учета или передано
		Если ВыборкаДетальныеЗаписи.Состояние = Перечисления.ВидыСостоянийОС.СнятоСУчета
			Или ВыборкаДетальныеЗаписи.Состояние = Перечисления.ВидыСостоянийОС.Передано Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" снято с учета документом ""%2"".'"), 
				ВыборкаДетальныеЗаписи.ОсновноеСредство, ВыборкаДетальныеЗаписи.РегистраторСнятоСУчета);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				"ОсновноеСредство",
				Отказ);
		КонецЕсли;		
		
		// Входит в другой комплект
		Если ВыборкаДетальныеЗаписи.ВходитВДругойКомплект Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" входит в другой комплект ""%2"".'"), 
				ВыборкаДетальныеЗаписи.ОсновноеСредство, ВыборкаДетальныеЗаписи.ДругойКомплект);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				"ОсновноеСредство",
				Отказ);
		КонецЕсли;	
			
		// Не соответствие счета учета ОС в табличной части счету учета комплекта
		Если НЕ ВыборкаДетальныеЗаписи.СчетУчета = СчетУчета Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'У основного средства ""%1"" счет учета ""%2"".'"), 
				ВыборкаДетальныеЗаписи.ОсновноеСредство, ВыборкаДетальныеЗаписи.СчетУчета);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				"ОсновноеСредство",
				Отказ);
		КонецЕсли;
						
		// Не соответствие МОЛа ОС в табличной части МОЛу комплекта
		Если НЕ ВыборкаДетальныеЗаписи.МОЛ = МОЛ Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основного средство ""%1"" находится на учете у МОЛа ""%2"".'"), 
				ВыборкаДетальныеЗаписи.ОсновноеСредство, ВыборкаДетальныеЗаписи.МОЛ);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				"ОсновноеСредство",
				Отказ);
		КонецЕсли;				
						
		// Не соответствие подразделения ОС в табличной части подразделению комплекта
		Если НЕ ВыборкаДетальныеЗаписи.Подразделение = Подразделение Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основного средство ""%1"" находится на учете в подразделении ""%2"".'"), 
				ВыборкаДетальныеЗаписи.ОсновноеСредство, ВыборкаДетальныеЗаписи.Подразделение);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				"ОсновноеСредство",
				Отказ);
		КонецЕсли;			

	КонецЕсли;
	
КонецПроцедуры

Процедура КонтрольПриВыводеИзКомплекта(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.Изменение КАК Изменение,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВременнаяТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Изменение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставОССрезПоследних.ОсновноеСредствоВСоставеКомплекта КАК ОсновноеСредствоВСоставеКомплекта,
	|	СоставОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ВременнаяТаблицаОСВКомплектах
	|ИЗ
	|	РегистрСведений.СоставОС.СрезПоследних(
	|			&Период,
	|			ОсновноеСредство = &ОсновноеСредство
	|				И НЕ Регистратор = &Ссылка) КАК СоставОССрезПоследних
	|ГДЕ
	|	(СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация)
	|					ИЛИ СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаОСВКомплектах КАК ВременнаяТаблицаОСВКомплектах
	|		ПО ВременнаяТаблицаОС.ОсновноеСредство = ВременнаяТаблицаОСВКомплектах.ОсновноеСредствоВСоставеКомплекта
	|ГДЕ
	|	ВременнаяТаблицаОСВКомплектах.ОсновноеСредствоВСоставеКомплекта ЕСТЬ NULL";
		
	Запрос.Параметры.Вставить("Период", 			Дата);	
	Запрос.Параметры.Вставить("Ссылка", 			Ссылка);
	Запрос.Параметры.Вставить("ТаблицаОС", 			ОС.Выгрузить());
	Запрос.Параметры.Вставить("ОсновноеСредство", 	Комплект);	

	Если ВидОперации = Перечисления.ВидыОперацийКомплектацияОС.Ликвидация Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТаблицаОС.Изменение", "ИСТИНА");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" не входит в комплект.'"), 
			ВыборкаДетальныеЗаписи.ОсновноеСредство);		
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
			ЭтотОбъект,   
			ТекстСообщения,
			"ОС",
			ВыборкаДетальныеЗаписи.НомерСтроки,
			"ОсновноеСредство",
			Отказ);	
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтрольВхожденияВДругиеКомплекты(Отказ)
	// МассивОсновныхСредствИсключения - массив ОС, которые входят в другие комплекты
	МассивОсновныхСредствИсключения = Новый Массив;
	МассивОсновныхСредствИсключения = ПолучитьОсновныеСредстваВходящиеВДругиеКомплекты(Комплект, ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	
	Для Каждого СтрокаЗагрузки Из ОС Цикл
		НомерИндексаИсключенияОС = МассивОсновныхСредствИсключения.Найти(СтрокаЗагрузки.ОсновноеСредство);
		Если НомерИндексаИсключенияОС <> Неопределено Тогда 
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" входит в другой комплект.'"), 
				СтрокаЗагрузки.ОсновноеСредство);		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"ОС",
				СтрокаЗагрузки.НомерСтроки,
				"ОсновноеСредство",
				Отказ);				
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура КонтрольРодительскоеОСУжеПринятоКУчету(Отказ)
	
	РодительскоеОСУжеПринятоКУчету = РодительскоеОСУжеПринятоКУчету(Дата, Комплект);
	Если РодительскоеОСУжеПринятоКУчету Тогда
		ТекстСообщения = НСтр("ru = 'Выбранное в качестве комплекта Основное средство уже принято к учету. Выберите другое ОС.'");		
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,   
				ТекстСообщения,
				"",
				,
				"ОсновноеСредство",
				Отказ);				
	КонецЕсли;

КонецПроцедуры

// Проверка на вхождение в другие комплекты ОС
//
// Параметры:
//  Комплект  - ОсновноеСредство - Основное средство, для которого собирается комплект ОС
//  МассивОсновныхСредств  - массив - массив ОС, которые проверяются на вхождение в другие комплекты
//
Функция ПолучитьОсновныеСредстваВходящиеВДругиеКомплекты(Комплект, МассивОсновныхСредств)
	МассивИсключенияОС = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СоставОС.СрезПоследних(&Период, НЕ ОсновноеСредство = &Комплект) КАК СоставОССрезПоследних
		|ГДЕ
		|	СоставОССрезПоследних.ОсновноеСредствоВСоставеКомплекта В (&МассивОсновныхСредств)
		|	И (СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация)
		|					ИЛИ СоставОССрезПоследних.СостояниеВСоставеОС = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление))";
	
	Запрос.УстановитьПараметр("Период", 	Дата);
	Запрос.УстановитьПараметр("Комплект", 	Комплект);
	Запрос.УстановитьПараметр("МассивОсновныхСредств", МассивОсновныхСредств);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивИсключенияОС.Добавить(ВыборкаДетальныеЗаписи.ОсновноеСредство);
	КонецЦикла;
	
	Возврат МассивИсключенияОС;	
	
КонецФункции //

Функция РодительскоеОСУжеПринятоКУчету(Дата, ОсновноеСредство)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	СостоянияОССрезПоследних.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.СостоянияОС.СрезПоследних(&Период, ОсновноеСредство = &ОсновноеСредство) КАК СостоянияОССрезПоследних
		|ГДЕ
		|	СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)";
	
	Запрос.УстановитьПараметр("Период", 			Дата);
	Запрос.УстановитьПараметр("ОсновноеСредство", 	ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции // РодительскоеОСУжеПринятоКУчету()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли