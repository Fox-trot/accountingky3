﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	ДатаНачалаРабочегоГода 	 	= НачалоГода(ДатаДокумента);
	ДатаОкончанияРабочегоГода 	= КонецГода(ДатаДокумента);	
	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если МетодРасчета.ВидОтпуска = Перечисления.ВидыОтпусков.БезСодержания
		И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
		СреднийЗаработок.Очистить();
		Начисления.Очистить();		
		РассчитатьТабличнуюЧасть(0);
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.Отпуск.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Отказ);

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
	
	Если НЕ МетодРасчета.ВидОтпуска = Перечисления.ВидыОтпусков.БезСодержания Тогда 
		ПроверяемыеРеквизиты.Добавить("Начисления");
	КонецЕсли;	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт 
	// Определение количества месяцев.
	КоличествоМесяцев = МетодРасчета.ВидРасчета.ПериодРасчетаСреднегоЗаработка;
	Если КоличествоМесяцев = 0 Тогда 
		КоличествоМесяцев = 3;
	КонецЕсли;	
	
	НеполныеМесяцы = МетодРасчета.НеполныеМесяцы;
	
	// Корректировка скрытого периода.
	Если МетодРасчета.ВидОтпуска = Перечисления.ВидыОтпусков.Компенсация Тогда 
		ДатаНачала = Дата;
		ДатаОкончания = Дата;
	КонецЕсли;
	
	Если НеполныеМесяцы = ПредопределенноеЗначение("Перечисление.НеполныеМесяцы.Отбрасывать") Тогда 
		БазовыйПериодНачало = ДобавитьМесяц(НачалоМесяца(ДатаНачала), - 12);
		БазовыйПериодКонец = НачалоМесяца(ДатаНачала) - 1;
	Иначе 
		БазовыйПериодНачало = ДобавитьМесяц(НачалоМесяца(ДатаНачала), -КоличествоМесяцев);
		БазовыйПериодКонец = НачалоМесяца(ДатаНачала) - 1;
	КонецЕсли;	
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Дата, МЕСЯЦ) КАК ПериодРегистрации,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Дата, МЕСЯЦ) КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.Дата, МЕСЯЦ) КАК ПериодДействияКонец,
		|	&БазовыйПериодНачало,
		|	&БазовыйПериодКонец,
		|	ТаблицаДокумента.МетодРасчета.ВидРасчета КАК ВидРасчета,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ГрафикРаботы,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность
		|ИЗ
		|	Документ.Отпуск КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);	
	Запрос.УстановитьПараметр("БазовыйПериодНачало", БазовыйПериодНачало);	
	Запрос.УстановитьПараметр("БазовыйПериодКонец", БазовыйПериодКонец);	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисления", РезультатЗапроса.Выгрузить());
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Ложь);

	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
	Ошибки = Неопределено;
	ПроведениеРасчетовПоЗарплатеСервер.ЗаполнитьТабличнуюЧастьСреднийЗаработок(КоличествоМесяцев, БазовыйПериодНачало, БазовыйПериодКонец, 
							ГрафикРаботы, Ссылка, НеполныеМесяцы, СреднийЗаработок, Ошибки);
															
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	СреднийЗаработок.Сортировать("ПериодРегистрации");
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

// Процедура рассчитывает табличную часть
//
Процедура РассчитатьТабличнуюЧасть(РазмерСреднийЗаработок) Экспорт
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.ГрафикРаботы КАК ГрафикРаботы,
		|	&ВидРасчета КАК ВидРасчета,
		|	&Размер КАК Размер,
		|	ВЫБОР
		|		КОГДА &ЭтоКомпенсация
		|			ТОГДА &Дней * &Размер
		|		ИНАЧЕ ВложенныйЗапрос.ОтработаноДней * &Размер
		|	КОНЕЦ КАК Результат,
		|	ВложенныйЗапрос.ПериодРегистрации КАК ПериодРегистрации,
		|	ВЫБОР
		|		КОГДА &ЭтоКомпенсация
		|			ТОГДА &Дней
		|		ИНАЧЕ ВложенныйЗапрос.ОтработаноДней
		|	КОНЕЦ КАК ОтработаноДней,
		|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
		|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеПроизводственногоКалендаря.ГрафикРаботы КАК ГрафикРаботы,
		|		НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК ПериодРегистрации,
		|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.Дата) КАК ОтработаноДней,
		|		ВЫБОР
		|			КОГДА НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|				ТОГДА &НачалоПериода
		|			ИНАЧЕ НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|		КОНЕЦ КАК ДатаНачала,
		|		ВЫБОР
		|			КОГДА КОНЕЦПЕРИОДА(&КонецПериода, МЕСЯЦ) = КОНЕЦПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|				ТОГДА &КонецПериода
		|			ИНАЧЕ КОНЕЦПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|		КОНЕЦ КАК ДатаОкончания
		|	ИЗ
		|		РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|	ГДЕ
		|		ДанныеПроизводственногоКалендаря.ГрафикРаботы = &ГрафикРаботы
		|		И (ДанныеПроизводственногоКалендаря.Год = &ГодНачалоПериода
		|				ИЛИ ДанныеПроизводственногоКалендаря.Год = &ГодКонецПериода)
		|		И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|		И &РасчетПоРабочимДням
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеПроизводственногоКалендаря.ГрафикРаботы,
		|		НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ),
		|		ВЫБОР
		|			КОГДА НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|				ТОГДА &НачалоПериода
		|			ИНАЧЕ НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА КОНЕЦПЕРИОДА(&КонецПериода, МЕСЯЦ) = КОНЕЦПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|				ТОГДА &КонецПериода
		|			ИНАЧЕ КОНЕЦПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|		КОНЕЦ) КАК ВложенныйЗапрос
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПериодРегистрации";
	Если МетодРасчета.РасчетПоРабочимДням Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетПоРабочимДням",
			"(ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
			|ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))");
	Иначе 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетПоРабочимДням", "ИСТИНА");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ГодНачалоПериода", Год(ДатаНачала));
	Запрос.УстановитьПараметр("ГодКонецПериода", Год(ДатаОкончания));
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ДатаОкончания);
	Запрос.УстановитьПараметр("ВидРасчета", МетодРасчета.ВидРасчета);
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	Запрос.УстановитьПараметр("Размер", РазмерСреднийЗаработок);
	Запрос.УстановитьПараметр("ЭтоКомпенсация", МетодРасчета.ВидОтпуска = Перечисления.ВидыОтпусков.Компенсация);
	Запрос.УстановитьПараметр("Дней", Дней);
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтруктураОтбора = ПроведениеРасчетовПоЗарплатеСервер.СтруктураОтбораСпособыОтраженияЗаработнойПлаты();
	
	// Определение способа отражения.
	Для Каждого СтрокаТабличнойЧасти Из Начисления Цикл 
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТабличнойЧасти);
		СтруктураОтбора.Подразделение = Подразделение;
		СтрокаТабличнойЧасти.СпособОтражения = ПроведениеРасчетовПоЗарплатеСервер.СпособОтраженияЗаработнойПлаты(СтруктураОтбора);		
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
