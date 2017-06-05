﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьПоОстаткамОС() Экспорт 
	
	// 1. Параметры учета, Местонахождение, Период принятия к учету
	// 2. Остатки по счетам учета и амортизации
	
	ТекстЗапроса =	
		"ВЫБРАТЬ
		|	МестонахождениеОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	МестонахождениеОССрезПоследних.Подразделение КАК Подразделение,
		|	МестонахождениеОССрезПоследних.МОЛ КАК МОЛ,
		|	ПараметрыУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
		|	ПараметрыУчетаОССрезПоследних.СчетУчета.ПарныйСчет КАК СчетАмортизации,
		|	ПараметрыУчетаОССрезПоследних.СрокСлужбы КАК СрокСлужбы,
		|	ВЫБОР
		|		КОГДА СостоянияОССрезПоследних.Состояние ЕСТЬ NULL
		|			ТОГДА 0
		|		ИНАЧЕ РАЗНОСТЬДАТ(&Период, ДОБАВИТЬКДАТЕ(СостоянияОССрезПоследних.Период, МЕСЯЦ, ПараметрыУчетаОССрезПоследних.СрокСлужбы), МЕСЯЦ)
		|	КОНЕЦ КАК ОстаточныйСрокСлужбы
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	РегистрСведений.ПараметрыУчетаОС.СрезПоследних(&Период, Организация = &Организация) КАК ПараметрыУчетаОССрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(&Период, Организация = &Организация) КАК МестонахождениеОССрезПоследних
		|		ПО ПараметрыУчетаОССрезПоследних.ОсновноеСредство = МестонахождениеОССрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОС.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)) КАК СостоянияОССрезПоследних
		|		ПО ПараметрыУчетаОССрезПоследних.ОсновноеСредство = СостоянияОССрезПоследних.ОсновноеСредство
		|ГДЕ
		|	МестонахождениеОССрезПоследних.Подразделение В ИЕРАРХИИ(&Подразделение)
		|	И МестонахождениеОССрезПоследних.МОЛ = &МОЛ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство,
		|	СчетУчета,
		|	СчетАмортизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
		|	ВременнаяТаблицаОС.СчетУчета,
		|	ВременнаяТаблицаОС.Подразделение,
		|	ВременнаяТаблицаОС.МОЛ,
		|	ВременнаяТаблицаОС.СрокСлужбы,
		|	ВременнаяТаблицаОС.ОстаточныйСрокСлужбы,
		|	ИСТИНА КАК НаличиеПоДаннымУчета,
		|	ИСТИНА КАК НаличиеФактическое,
		|	ЕСТЬNULL(ТиповойОстатки.СуммаОстатокДт, 0) КАК СтоимостьПоДаннымУчета,
		|	ЕСТЬNULL(ТиповойОстатки.СуммаОстатокДт, 0) КАК СтоимостьФактическая,
		|	ЕСТЬNULL(ТиповойОстатки.СуммаОстатокДт, 0) КАК ПервоначальнаяСтоимость,
		|	ЕСТЬNULL(ТиповойОстаткиАмортизация.СуммаОстатокКт, 0) КАК НакопленнаяАмортизация
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&Период,
		|				Счет В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВременнаяТаблицаОС.СчетУчета
		|					ИЗ
		|						ВременнаяТаблицаОС КАК ВременнаяТаблицаОС),
		|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|				Организация = &Организация
		|					И Субконто1 В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаОС.ОсновноеСредство
		|						ИЗ
		|							ВременнаяТаблицаОС КАК ВременнаяТаблицаОС)) КАК ТиповойОстатки
		|		ПО ВременнаяТаблицаОС.ОсновноеСредство = ТиповойОстатки.Субконто1
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&Период,
		|				Счет В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВременнаяТаблицаОС.СчетАмортизации
		|					ИЗ
		|						ВременнаяТаблицаОС КАК ВременнаяТаблицаОС),
		|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|				Организация = &Организация
		|					И Субконто1 В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаОС.ОсновноеСредство
		|						ИЗ
		|							ВременнаяТаблицаОС КАК ВременнаяТаблицаОС)) КАК ТиповойОстаткиАмортизация
		|		ПО (ВременнаяТаблицаОС.ОсновноеСредство = ТиповойОстатки.Субконто1)";	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "МестонахождениеОССрезПоследних.Подразделение В ИЕРАРХИИ(&Подразделение)", "ИСТИНА");
	КонецЕсли;			
	
	Если НЕ ЗначениеЗаполнено(МОЛ) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "МестонахождениеОССрезПоследних.МОЛ = &МОЛ", "ИСТИНА");
	КонецЕсли;			
	
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("МОЛ", МОЛ);	
	
	ОС.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры // ЗаполнитьПоОстаткамОСНаСервере()

#КонецОбласти

#КонецЕсли