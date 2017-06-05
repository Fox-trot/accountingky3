﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаТарифы(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВТ_Шапка.Период,
		|	ВТ_Шапка.Организация,
		|	ВременнаяТаблицаТарифыКомандировочных.Страна,
		|	ВременнаяТаблицаТарифыКомандировочных.Город,
		|	ВременнаяТаблицаТарифыКомандировочных.Валюта,
		|	ВременнаяТаблицаТарифыКомандировочных.Суточные КАК Сумма,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыТарифовКомандировочных.Суточные) КАК ВидТарифаКомандировочных
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВТ_Шапка,
		|	ВременнаяТаблицаТарифыКомандировочных КАК ВременнаяТаблицаТарифыКомандировочных
		|ГДЕ
		|	ВременнаяТаблицаТарифыКомандировочных.Суточные <> 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_Шапка.Период,
		|	ВТ_Шапка.Организация,
		|	ВременнаяТаблицаТарифыКомандировочных.Страна,
		|	ВременнаяТаблицаТарифыКомандировочных.Город,
		|	ВременнаяТаблицаТарифыКомандировочных.Валюта,
		|	ВременнаяТаблицаТарифыКомандировочных.Питание,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыТарифовКомандировочных.Питание)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВТ_Шапка,
		|	ВременнаяТаблицаТарифыКомандировочных КАК ВременнаяТаблицаТарифыКомандировочных
		|ГДЕ
		|	ВременнаяТаблицаТарифыКомандировочных.Питание <> 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_Шапка.Период,
		|	ВТ_Шапка.Организация,
		|	ВременнаяТаблицаТарифыКомандировочных.Страна,
		|	ВременнаяТаблицаТарифыКомандировочных.Город,
		|	ВременнаяТаблицаТарифыКомандировочных.Валюта,
		|	ВременнаяТаблицаТарифыКомандировочных.Проживание,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыТарифовКомандировочных.Проживание)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВТ_Шапка,
		|	ВременнаяТаблицаТарифыКомандировочных КАК ВременнаяТаблицаТарифыКомандировочных
		|ГДЕ
		|	ВременнаяТаблицаТарифыКомандировочных.Проживание <> 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_Шапка.Период,
		|	ВТ_Шапка.Организация,
		|	ВременнаяТаблицаТарифыКомандировочных.Страна,
		|	ВременнаяТаблицаТарифыКомандировочных.Город,
		|	ВременнаяТаблицаТарифыКомандировочных.Валюта,
		|	ВременнаяТаблицаТарифыКомандировочных.Проездные,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыТарифовКомандировочных.Проездные)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВТ_Шапка,
		|	ВременнаяТаблицаТарифыКомандировочных КАК ВременнаяТаблицаТарифыКомандировочных
		|ГДЕ
		|	ВременнаяТаблицаТарифыКомандировочных.Проживание <> 0";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТарифыКомандировочных", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСотрудники()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УстановкаТарифовКомандировочных.Ссылка,
		|	УстановкаТарифовКомандировочных.ВерсияДанных,
		|	УстановкаТарифовКомандировочных.ПометкаУдаления,
		|	УстановкаТарифовКомандировочных.Номер,
		|	УстановкаТарифовКомандировочных.Дата КАК Период,
		|	УстановкаТарифовКомандировочных.Проведен,
		|	УстановкаТарифовКомандировочных.Организация КАК Организация,
		|	УстановкаТарифовКомандировочных.Комментарий,
		|	УстановкаТарифовКомандировочных.Автор,
		|	УстановкаТарифовКомандировочных.Страна,
		|	УстановкаТарифовКомандировочных.Город,
		|	УстановкаТарифовКомандировочных.ОднаСтрана,
		|	УстановкаТарифовКомандировочных.ОдинГород
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.УстановкаТарифовКомандировочных КАК УстановкаТарифовКомандировочных
		|ГДЕ
		|	УстановкаТарифовКомандировочных.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УстановкаТарифовКомандировочныхТарифы.Ссылка,
		|	УстановкаТарифовКомандировочныхТарифы.НомерСтроки,
		|	УстановкаТарифовКомандировочныхТарифы.Страна,
		|	УстановкаТарифовКомандировочныхТарифы.Город,
		|	УстановкаТарифовКомандировочныхТарифы.Суточные,
		|	УстановкаТарифовКомандировочныхТарифы.Питание,
		|	УстановкаТарифовКомандировочныхТарифы.Проживание,
		|	УстановкаТарифовКомандировочныхТарифы.Проездные,
		|	УстановкаТарифовКомандировочныхТарифы.Валюта
		|ПОМЕСТИТЬ ВременнаяТаблицаТарифыКомандировочных
		|ИЗ
		|	Документ.УстановкаТарифовКомандировочных.Тарифы КАК УстановкаТарифовКомандировочныхТарифы
		|ГДЕ
		|	УстановкаТарифовКомандировочныхТарифы.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаТарифы(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#КонецЕсли