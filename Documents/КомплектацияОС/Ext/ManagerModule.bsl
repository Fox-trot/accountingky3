﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСоставОС(ДокументСсылка, СтруктураДополнительныеСвойства) 
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Комплект КАК ОсновноеСредство,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредствоВСоставеКомплекта,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация) КАК СостояниеВСоставеОС,
		|	&НазваниеДокументаКомплектацияОС КАК НазваниеДокумента
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Комплектация)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Комплект,
		|	ВременнаяТаблицаОС.ОсновноеСредство,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление),
		|	&НазваниеДокументаДобавлениеОС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Добавление)
		|	И ВременнаяТаблицаОС.Изменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Комплект,
		|	ВременнаяТаблицаОС.ОсновноеСредство,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Ликвидация),
		|	&НазваниеДокументаЛиквидацияКомплектаОС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.Ликвидация)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Комплект,
		|	ВременнаяТаблицаОС.ОсновноеСредство,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.ВыводИзКомплекта),
		|	&НазваниеДокументаВыводИзКомплектаОС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКомплектацияОС.ВыводИзКомплекта)
		|	И ВременнаяТаблицаОС.Изменение";
	
	Запрос.УстановитьПараметр("НазваниеДокументаКомплектацияОС", 		НСтр("ru = 'Комплектация ОС'"));
	Запрос.УстановитьПараметр("НазваниеДокументаДобавлениеОС", 			НСтр("ru = 'Добавление ОС'"));
	Запрос.УстановитьПараметр("НазваниеДокументаЛиквидацияКомплектаОС", НСтр("ru = 'Ликвидация комплекта ОС'"));
	Запрос.УстановитьПараметр("НазваниеДокументаВыводИзКомплектаОС", 	НСтр("ru = 'Вывод из комплекта ОС'"));
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСоставОС", РезультатЗапроса.Выгрузить());
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьПараметрыУчетаКомплектовОС(ДокументСсылка, СтруктураДополнительныеСвойства) 
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Комплект КАК Комплект,
		|	ВременнаяТаблицаШапка.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаШапка.МОЛ КАК МОЛ,
		|	ВременнаяТаблицаШапка.Подразделение КАК Подразделение
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПараметрыУчетаКомплектовОС", РезультатЗапроса.Выгрузить());
КонецПроцедуры 

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.Комплект КАК Комплект,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.Подразделение КАК Подразделение,
		|	ТаблицаДокумента.МОЛ КАК МОЛ,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.КомплектацияОС КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаДокумента.Изменение КАК Изменение
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	Документ.КомплектацияОС.ОС КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();    		
			
	СформироватьТаблицаСоставОС(ДокументСсылка, СтруктураДополнительныеСвойства); 
	СформироватьПараметрыУчетаКомплектовОС(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

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