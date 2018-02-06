﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьСостояниеЗаказов(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Ссылка КАК Заказ,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказовПоПроизводству.Заказан) КАК Состояние,
		|	ВременнаяТаблицаШапка.Внутренний КАК Внутренний
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСостояниеЗаказов", Запрос.Выполнить().Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьЗаказаннаяПродукция(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Ссылка КАК Заказ,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	ВременнаяТаблицаПродукция.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаПродукция.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаПродукция.Количество КАК Количество
		|ИЗ
		|	ВременнаяТаблицаПродукция КАК ВременнаяТаблицаПродукция
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)";
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗаказаннаяПродукция", Запрос.Выполнить().Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.Склад КАК Склад,
		|	ТаблицаДокумента.Внутренний КАК Внутренний
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ЗаказНаПроизводство КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокументаПродукция.Номенклатура КАК Номенклатура,
		|	ТаблицаДокументаПродукция.Спецификация КАК Спецификация,
		|	ТаблицаДокументаПродукция.Количество КАК Количество
		|ПОМЕСТИТЬ ВременнаяТаблицаПродукция
		|ИЗ
		|	Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаДокументаПродукция
		|ГДЕ
		|	ТаблицаДокументаПродукция.Ссылка = &ДокументСсылка";
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьСостояниеЗаказов(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьЗаказаннаяПродукция(ДокументСсылка, СтруктураДополнительныеСвойства);
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