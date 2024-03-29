﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТабельПоЧасам(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// Определение минимальной и максимальной даты.
	// Для отборов в РС КалендариГрафиковРабот.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МИНИМУМ(ТаблицаДокумента.ДатаНачала) КАК ДатаНачала,
		|	МАКСИМУМ(ТаблицаДокумента.ДатаОкончания) КАК ДатаОкончания
		|ИЗ
		|	ВременнаяТаблицаСотрудники КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ДатаНачала = Выборка.ДатаНачала;
	ДатаОкончания = Выборка.ДатаОкончания;
	
	// Распределение по дням.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КалендариГрафиковРабот.Дата КАК Дата,
		|	КалендариГрафиковРабот.ГрафикРаботы КАК ГрафикРаботы,
		|	КалендариГрафиковРабот.ЗначениеДней КАК ЗначениеДней
		|ПОМЕСТИТЬ ВременнаяТаблицаКалендарь
		|ИЗ
		|	РегистрСведений.КалендариГрафиковРабот КАК КалендариГрафиковРабот
		|ГДЕ
		|	КалендариГрафиковРабот.ГрафикРаботы В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВременнаяТаблицаСотрудники.ГрафикРаботы
		|			ИЗ
		|				ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники)
		|	И КалендариГрафиковРабот.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И КалендариГрафиковРабот.Год МЕЖДУ &ГодНачалоПериода И &ГодКонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаКалендарь.Дата КАК Дата,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаСотрудники.ФизЛицо КАК ФизЛицо,
		|	1 КАК ДнейОтработки,
		|	ВременнаяТаблицаСотрудники.НормаЧасовЗаполнения КАК ЧасовОтработки
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаКалендарь КАК ВременнаяТаблицаКалендарь
		|		ПО (ВременнаяТаблицаСотрудники.ГрафикРаботы = ВременнаяТаблицаКалендарь.ГрафикРаботы)
		|			И (ВременнаяТаблицаКалендарь.Дата МЕЖДУ ВременнаяТаблицаСотрудники.ДатаНачала И ВременнаяТаблицаСотрудники.ДатаОкончания)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидДниЧасы = 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаСотрудники.ФизЛицо,
		|	0,
		|	ВременнаяТаблицаСотрудники.Часов
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидДниЧасы = 1";	
	Запрос.УстановитьПараметр("ГодНачалоПериода", Год(ДатаНачала));
	Запрос.УстановитьПараметр("ГодКонецПериода", Год(ДатаОкончания));
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ДатаОкончания);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТабельПоЧасам", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТабельПоЧасам()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидДниЧасы КАК ВидДниЧасы
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.Отработка КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.ГрафикРаботы КАК ГрафикРаботы,
		|	ТаблицаДокумента.ДатаНачала КАК ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания КАК ДатаОкончания,
		|	ТаблицаДокумента.Дней КАК Дней,
		|	ТаблицаДокумента.Часов КАК Часов,
		|	ТаблицаДокумента.ГрафикРаботы.НормаЧасовЗаполнения КАК НормаЧасовЗаполнения
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	Документ.Отработка.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТабельПоЧасам(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли
