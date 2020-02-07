﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);

	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда 
		ДатаНачала 	 = НачалоКвартала(Дата);
		ДатаОкончания = КонецКвартала(Дата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧастьОтчет() Экспорт
	
	// Квартальный отчет формируется только по сотрудникам,
	// на которых оформлен документ "Трудовое соглашение" (внештатные).
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиПоТрудовымСоглашениямСрезПоследних.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям
		|ИЗ
		|	РегистрСведений.СотрудникиПоТрудовымСоглашениям.СрезПоследних(&КонецПериода, Организация = &Организация) КАК СотрудникиПоТрудовымСоглашениямСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПодоходныйНалогОбороты.ФизЛицо КАК ФизЛицо,
		//|	ПодоходныйНалогОбороты.ОДПНОборот КАК ОДПН,
		|	ПодоходныйНалогОбороты.ОДПНОборот - ПодоходныйНалогОбороты.ПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ГНПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ВычетыОборот  КАК ОДПН,
		|	ПодоходныйНалогОбороты.ПНОборот КАК СуммаПН
		|ПОМЕСТИТЬ ВременнаяТаблицаПН
		|ИЗ
		|	РегистрНакопления.ПодоходныйНалог.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И ФизЛицо В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям.ФизЛицо КАК ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям КАК ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям)) КАК ПодоходныйНалогОбороты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГражданствоФизическихЛицСрезПоследних.ФизЛицо КАК Физлицо,
		|	ГражданствоФизическихЛицСрезПоследних.Страна КАК Страна
		|ПОМЕСТИТЬ ВременнаяТаблицаГражданство
		|ИЗ
		|	РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(
		|			&КонецПериода,
		|			ФизЛицо В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаПН.ФизЛицо
		|				ИЗ
		|					ВременнаяТаблицаПН КАК ВременнаяТаблицаПН)) КАК ГражданствоФизическихЛицСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПН.ФизЛицо КАК Физлицо,
		|	""001"" КАК КодДохода,
		|	ВременнаяТаблицаПН.ОДПН КАК ОДПН,
		|	ВременнаяТаблицаПН.СуммаПН КАК СуммаПН,
		|	ЕСТЬNULL(ВременнаяТаблицаГражданство.Страна.Код, """") КАК КодСтраны,
		|	ВременнаяТаблицаПН.ФизЛицо.ИНН КАК НомерНалоговойРегистрации
		|ИЗ
		|	ВременнаяТаблицаПН КАК ВременнаяТаблицаПН
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаГражданство КАК ВременнаяТаблицаГражданство
		|		ПО ВременнаяТаблицаПН.ФизЛицо = ВременнаяТаблицаГражданство.Физлицо";
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Отчет.Загрузить(Запрос.Выполнить().Выгрузить());
			
КонецПроцедуры // ЗаполнитьТабличнуюЧастьОтчет()

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧастьОтчетГодовой() Экспорт
	
	// Годовой отчет формируется только по сотрудникам,
	// на которых оформлен документ "Прием на работу" (штатные).
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&КонецПериода, Организация = &Организация) КАК СотрудникиСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПодоходныйНалогОбороты.ФизЛицо КАК Физлицо,
		//|	ПодоходныйНалогОбороты.ОДПНОборот КАК ОДПН,
		|	ПодоходныйНалогОбороты.ОДПНОборот - ПодоходныйНалогОбороты.ПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ГНПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ВычетыОборот  КАК ОДПН,
		|	ПодоходныйНалогОбороты.ПНОборот КАК СуммаПН,
		|	ПодоходныйНалогОбороты.ФизЛицо.ИНН КАК ИНН,
		|	""001"" КАК КодДохода,
		|	0 КАК СуммаМатериальнойВыгоды,
		|	0 КАК СуммаПНСМатериальнойВыгоды
		|ИЗ
		|	РегистрНакопления.ПодоходныйНалог.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И ФизЛицо В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСотрудники.ФизЛицо КАК ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники)) КАК ПодоходныйНалогОбороты";
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	ОтчетГодовой.Загрузить(Запрос.Выполнить().Выгрузить());
		
КонецПроцедуры // ЗаполнитьТабличнуюЧастьОтчетГодовой()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли