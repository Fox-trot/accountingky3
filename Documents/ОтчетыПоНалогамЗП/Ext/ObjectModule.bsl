﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПодоходныйНалог(ДанныеУчетнойПолитики) Экспорт
	
	Если ВидСубъекта = 2 Тогда
		// Крупный
		НачалоПериода = НачалоМесяца(Дата);
		КонецПериода = КонецМесяца(Дата);
	Иначе 
		// Малый, Средний
		НачалоПериода = НачалоКвартала(Дата);
		КонецПериода = КонецКвартала(Дата);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеОтчетаПоПНОбороты.СтрокаОтчета.НомерСтроки КАК СтрокаОтчетаНомерСтроки,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеОтчетаПоПНОбороты.ФизЛицо) КАК КоличествоОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот) КАК ВсегоНачисленоОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.НеоблагаемаяОборот) КАК НеоблагаемаяОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ПиИВычетыОборот) КАК ПиИВычетыОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ОблагаемаяОборот) КАК ОблагаемаяОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ПНСотрудникаОборот) КАК ПНСотрудникаОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ДоплатаПНОборот) КАК ДоплатаПНОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот) КАК ВсегоПНОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ПФРОборот) КАК ПФРОборот,
		|	СУММА(ДанныеОтчетаПоПНОбороты.ГНПФРОборот) КАК ГНПФРОборот
		|ПОМЕСТИТЬ ВременнаяТаблицаВсеСтроки
		|ИЗ
		|	РегистрНакопления.ДанныеОтчетаПоПН.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК ДанныеОтчетаПоПНОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеОтчетаПоПНОбороты.СтрокаОтчета.НомерСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, ИСТИНА) = ИСТИНА
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ 4
		|	КОНЕЦ,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХозрасчетныйОбороты.КорСубконто1),
		|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт * 10),
		|	0,
		|	0,
		|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт * 10),
		|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт),
		|	0,
		|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт),
		|	0,
		|	0
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Месяц, Счет = &СчетУчетаПоПНДляПрочихФизическихЛиц, , Организация = &Организация, , ) КАК ХозрасчетныйОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ХозрасчетныйОбороты.СуммаОборотКт, ИСТИНА) = ИСТИНА
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ 4
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаВсеСтроки.СтрокаОтчетаНомерСтроки КАК НомерСтрокиОтчета,
		|	СУММА(ВременнаяТаблицаВсеСтроки.КоличествоОборот) КАК Количество,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ВсегоНачисленоОборот КАК ЧИСЛО(15, 2))) КАК СуммаНачислено,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.НеоблагаемаяОборот КАК ЧИСЛО(15, 2))) КАК СуммаНеоблагаемая,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ПиИВычетыОборот КАК ЧИСЛО(15, 2))) КАК Вычеты,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ОблагаемаяОборот КАК ЧИСЛО(15, 2))) КАК СуммаОблагаемая,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ПНСотрудникаОборот КАК ЧИСЛО(15, 2))) КАК СуммаПНсСотрудника,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ДоплатаПНОборот КАК ЧИСЛО(15, 2))) КАК СуммаПНсМРД,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ВсегоПНОборот КАК ЧИСЛО(15, 2))) КАК СуммаПН,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ВсегоПНОборот КАК ЧИСЛО(15, 2))) КАК СальдоК,
		|	ВЫБОР
		|		КОГДА &НеЗаполнятьВыплатыПоЗП
		|			ТОГДА 0
		|		ИНАЧЕ СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаВсеСтроки.ВсегоНачисленоОборот - ВременнаяТаблицаВсеСтроки.ПФРОборот - ВременнаяТаблицаВсеСтроки.ГНПФРОборот - ВременнаяТаблицаВсеСтроки.ВсегоПНОборот КАК ЧИСЛО(15, 2)))
		|	КОНЕЦ КАК СуммаВыплачен
		|ИЗ
		|	ВременнаяТаблицаВсеСтроки КАК ВременнаяТаблицаВсеСтроки
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаВсеСтроки.СтрокаОтчетаНомерСтроки";
	
	Если Округление Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЧИСЛО(15, 2)", "ЧИСЛО(15, 0)");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);     
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);     
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НеЗаполнятьВыплатыПоЗП", НеЗаполнятьВыплатыПоЗП);
	Запрос.УстановитьПараметр("СчетУчетаПоПНДляПрочихФизическихЛиц", ДанныеУчетнойПолитики.СчетУчетаПоПНДляПрочихФизическихЛиц);
	
	РезультатЗапроса = Запрос.Выполнить();
	ПодоходныйНалог.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьПодоходныйНалогПриложение(ДанныеУчетнойПолитики) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеОтчетаПоПНОбороты.СтрокаОтчета.НомерСтроки КАК НомерСтрокиОтчета,
		|	ДанныеОтчетаПоПНОбороты.КоличествоОборот КАК Количество,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот КАК ЧИСЛО(15, 2)) КАК СуммаНачислено,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.НеоблагаемаяОборот КАК ЧИСЛО(15, 2)) КАК СуммаНеоблагаемая,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ПиИВычетыОборот КАК ЧИСЛО(15, 2)) КАК Вычеты,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ОблагаемаяОборот КАК ЧИСЛО(15, 2)) КАК СуммаОблагаемая,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ПНСотрудникаОборот КАК ЧИСЛО(15, 2)) КАК СуммаПНсСотрудника,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ДоплатаПНОборот КАК ЧИСЛО(15, 2)) КАК СуммаПНсМРД,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2)) КАК СуммаПН,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2)) КАК СальдоК,
		|	ВЫБОР
		|		КОГДА &НеЗаполнятьВыплатыПоЗП
		|			ТОГДА 0
		|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот - ДанныеОтчетаПоПНОбороты.ПФРОборот - ДанныеОтчетаПоПНОбороты.ГНПФРОборот - ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК СуммаВыплачен
		|ИЗ
		|	РегистрНакопления.ДанныеОтчетаПоПН.Обороты(НАЧАЛОПЕРИОДА(&НачалоКвартала, МЕСЯЦ), КОНЕЦПЕРИОДА(&НачалоКвартала, МЕСЯЦ), , Организация = &Организация) КАК ДанныеОтчетаПоПНОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХозрасчетныйОбороты.КорСубконто1),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт * 10 КАК ЧИСЛО(15, 2))),
		|	0,
		|	0,
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт * 10 КАК ЧИСЛО(15, 2))),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	0,
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	0
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(НАЧАЛОПЕРИОДА(&НачалоКвартала, МЕСЯЦ), КОНЕЦПЕРИОДА(&НачалоКвартала, МЕСЯЦ), , Счет = &СчетУчетаПоПНДляПрочихФизическихЛиц, , Организация = &Организация, , ) КАК ХозрасчетныйОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеОтчетаПоПНОбороты.СтрокаОтчета.НомерСтроки КАК НомерСтрокиОтчета,
		|	ДанныеОтчетаПоПНОбороты.КоличествоОборот КАК Количество,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот КАК ЧИСЛО(15, 2)) КАК СуммаНачислено,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.НеоблагаемаяОборот КАК ЧИСЛО(15, 2)) КАК СуммаНеоблагаемая,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ПиИВычетыОборот КАК ЧИСЛО(15, 2)) КАК Вычеты,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ОблагаемаяОборот КАК ЧИСЛО(15, 2)) КАК СуммаОблагаемая,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ПНСотрудникаОборот КАК ЧИСЛО(15, 2)) КАК СуммаПНсСотрудника,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ДоплатаПНОборот КАК ЧИСЛО(15, 2)) КАК СуммаПНсМРД,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2)) КАК СуммаПН,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2)) КАК СальдоК,
		|	ВЫБОР
		|		КОГДА &НеЗаполнятьВыплатыПоЗП
		|			ТОГДА 0
		|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот - ДанныеОтчетаПоПНОбороты.ПФРОборот - ДанныеОтчетаПоПНОбороты.ГНПФРОборот - ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК СуммаВыплачен
		|ИЗ
		|	РегистрНакопления.ДанныеОтчетаПоПН.Обороты(НАЧАЛОПЕРИОДА(&ВторойМесяц, МЕСЯЦ), КОНЕЦПЕРИОДА(&ВторойМесяц, МЕСЯЦ), , Организация = &Организация) КАК ДанныеОтчетаПоПНОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХозрасчетныйОбороты.КорСубконто1),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт * 10 КАК ЧИСЛО(15, 2))),
		|	0,
		|	0,
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт * 10 КАК ЧИСЛО(15, 2))),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	0,
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	0
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(НАЧАЛОПЕРИОДА(&ВторойМесяц, МЕСЯЦ), КОНЕЦПЕРИОДА(&ВторойМесяц, МЕСЯЦ), , Счет = &СчетУчетаПоПНДляПрочихФизическихЛиц, , Организация = &Организация, , ) КАК ХозрасчетныйОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеОтчетаПоПНОбороты.СтрокаОтчета.НомерСтроки КАК НомерСтрокиОтчета,
		|	ДанныеОтчетаПоПНОбороты.КоличествоОборот КАК Количество,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот КАК ЧИСЛО(15, 2)) КАК СуммаНачислено,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.НеоблагаемаяОборот КАК ЧИСЛО(15, 2)) КАК СуммаНеоблагаемая,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ПиИВычетыОборот КАК ЧИСЛО(15, 2)) КАК Вычеты,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ОблагаемаяОборот КАК ЧИСЛО(15, 2)) КАК СуммаОблагаемая,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ПНСотрудникаОборот КАК ЧИСЛО(15, 2)) КАК СуммаПНсСотрудника,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ДоплатаПНОборот КАК ЧИСЛО(15, 2)) КАК СуммаПНсМРД,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2)) КАК СуммаПН,
		|	ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2)) КАК СальдоК,
		|	ВЫБОР
		|		КОГДА &НеЗаполнятьВыплатыПоЗП
		|			ТОГДА 0
		|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеОтчетаПоПНОбороты.ВсегоНачисленоОборот - ДанныеОтчетаПоПНОбороты.ПФРОборот - ДанныеОтчетаПоПНОбороты.ГНПФРОборот - ДанныеОтчетаПоПНОбороты.ВсегоПНОборот КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК СуммаВыплачен
		|ИЗ
		|	РегистрНакопления.ДанныеОтчетаПоПН.Обороты(НАЧАЛОПЕРИОДА(&КонецКвартала, МЕСЯЦ), КОНЕЦПЕРИОДА(&КонецКвартала, МЕСЯЦ), , Организация = &Организация) КАК ДанныеОтчетаПоПНОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ХозрасчетныйОбороты.КорСубконто1),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт * 10 КАК ЧИСЛО(15, 2))),
		|	0,
		|	0,
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт * 10 КАК ЧИСЛО(15, 2))),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	0,
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	СУММА(ВЫРАЗИТЬ(ХозрасчетныйОбороты.СуммаОборотКт КАК ЧИСЛО(15, 2))),
		|	0
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(НАЧАЛОПЕРИОДА(&КонецКвартала, МЕСЯЦ), КОНЕЦПЕРИОДА(&КонецКвартала, МЕСЯЦ), , Счет = &СчетУчетаПоПНДляПрочихФизическихЛиц, , Организация = &Организация, , ) КАК ХозрасчетныйОбороты";
	Если Округление Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЧИСЛО(15, 2)", "ЧИСЛО(15, 0)");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоКвартала", НачалоКвартала(Дата));
	Запрос.УстановитьПараметр("ВторойМесяц", ДобавитьМесяц(НачалоКвартала(Дата),1));
	Запрос.УстановитьПараметр("КонецКвартала", КонецКвартала(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СчетУчетаПоПНДляПрочихФизическихЛиц", ДанныеУчетнойПолитики.СчетУчетаПоПНДляПрочихФизическихЛиц);
	Запрос.УстановитьПараметр("НеЗаполнятьВыплатыПоЗП", НеЗаполнятьВыплатыПоЗП);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ПодоходныйНалогПервыйМесяцКвартала.Загрузить(МассивРезультатов[0].Выгрузить());
	ПодоходныйНалогВторойМесяцКвартала.Загрузить(МассивРезультатов[1].Выгрузить());
	ПодоходныйНалогТретийМесяцКвартала.Загрузить(МассивРезультатов[2].Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьСоцфонд() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.Физлицо КАК ФизЛицо,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.Физлицо.Наименование КАК ФизЛицоНаименование,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.Категория КАК Категория,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ФОТОборот КАК ФондОплатыТруда,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ДопФОТОборот КАК ДополнительныйФондОплатыТруда,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.НачисленыеВзносыОборот КАК НачисленыеСтраховыеВзносы,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ГНПФРОборот КАК НачсиленыеВзносыПоНПФ,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.НормаДнейОборот КАК Дней,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ФактДнейОборот КАК ФактическиДней,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ПриведеннаяСЗПОборот КАК ПриведеннаяСЗПОборот
		|ПОМЕСТИТЬ ВременнаяТаблицаДанные
		|ИЗ
		|	РегистрНакопления.ДанныеДляОтчетаПоСФЕжемесячному.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК ДанныеДляОтчетаПоСФЕжемесячномуОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанные.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаДанные.ФизЛицоНаименование КАК ФизЛицоНаименование,
		|	ВременнаяТаблицаДанные.Категория КАК Категория,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда КАК ЧИСЛО(15, 2)) КАК ФондОплатыТруда,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ДополнительныйФондОплатыТруда КАК ЧИСЛО(15, 2)) КАК ДополнительныйФондОплатыТруда,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачисленыеСтраховыеВзносы КАК ЧИСЛО(15, 2)) КАК НачисленыеСтраховыеВзносы,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачсиленыеВзносыПоНПФ КАК ЧИСЛО(15, 2)) КАК НачсиленыеВзносыПоНПФ,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(СотрудникиПрием.Период, &НачалоПериода) < &НачалоПериода
		|			ТОГДА &НачалоПериода
		|		ИНАЧЕ ЕСТЬNULL(СотрудникиПрием.Период, &НачалоПериода)
		|	КОНЕЦ КАК ДатаНачалаРаботы,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(СотрудникиУвольнение.Период, &КонецПериода) > &НачалоПериода
		|			ТОГДА ЕСТЬNULL(СотрудникиУвольнение.Период, &КонецПериода)
		|		ИНАЧЕ &КонецПериода
		|	КОНЕЦ КАК ДатаОкончанияРаботы,
		|	ВременнаяТаблицаДанные.Дней КАК Дней,
		|	ВременнаяТаблицаДанные.ФактическиДней КАК ФактическиДней
		|ИЗ
		|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(
		|				&КонецПериода,
		|				ФизЛицо В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаДанные.ФизЛицо КАК ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные)
		|					И Организация = &Организация
		|					И ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)) КАК СотрудникиПрием
		|		ПО ВременнаяТаблицаДанные.ФизЛицо = СотрудникиПрием.ФизЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(
		|				&КонецПериода,
		|				ФизЛицо В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаДанные.ФизЛицо КАК ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные)
		|					И Организация = &Организация
		|					И ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)) КАК СотрудникиУвольнение
		|		ПО ВременнаяТаблицаДанные.ФизЛицо = СотрудникиУвольнение.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблицаДанные.ФизЛицоНаименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанные.Категория КАК Категория,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПриведеннаяСЗПОборот > ВременнаяТаблицаДанные.ФондОплатыТруда
		|				ТОГДА ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда КАК ЧИСЛО(15, 2))
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФОТМенее,
		|	СУММА(ВременнаяТаблицаДанные.ДополнительныйФондОплатыТруда) КАК ДопФОТ,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПриведеннаяСЗПОборот < ВременнаяТаблицаДанные.ФондОплатыТруда
		|				ТОГДА ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда КАК ЧИСЛО(15, 2))
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФОТБолее,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда + ВременнаяТаблицаДанные.ДополнительныйФондОплатыТруда КАК ЧИСЛО(15, 2))) КАК Итого,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДанные.ФизЛицо) КАК Численость
		|ИЗ
		|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаДанные.Категория
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачисленыеСтраховыеВзносы КАК ЧИСЛО(15, 2)) КАК СуммаКтПФ_МС_ФОТФ,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачсиленыеВзносыПоНПФ КАК ЧИСЛО(15, 2)) КАК СуммаКтГНПФ,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачисленыеСтраховыеВзносы + ВременнаяТаблицаДанные.НачсиленыеВзносыПоНПФ КАК ЧИСЛО(15, 2)) КАК ИтогоОбязательства
		|ИЗ
		|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК ЧИСЛО(15, 2)) КАК ОстатокСтраховыхВзносов
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет В (&СписокСчетов), , Организация = &Организация) КАК ХозрасчетныйОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК ЧИСЛО(15, 2)) КАК ОстатокПенсионногоФонда
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет = &Счет, , Организация = &Организация) КАК ХозрасчетныйОстатки";
	Если Округление Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЧИСЛО(15, 2)", "ЧИСЛО(15, 0)");
	КонецЕсли;
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(Дата, Организация);
	МассивСчетов = Новый Массив();
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовПФФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовМСФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовФОТФ);
	СчетГНПФР = ДанныеУчетнойПолитики.СчетУчетаРасчетовГНПФР;
	
	Если ДатаСдачиОтчета = '00010101' Тогда
		Запрос.УстановитьПараметр("Дата", КонецМесяца(Дата) + 1);
	Иначе
		Запрос.УстановитьПараметр("Дата", КонецДня(ДатаСдачиОтчета));
	КонецЕсли;
	Запрос.УстановитьПараметр("СписокСчетов", МассивСчетов);
	Запрос.УстановитьПараметр("Счет", СчетГНПФР);
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));            
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	СведенияОЗанятостиИЗаработнойПлате.Загрузить(РезультатЗапроса[1].Выгрузить());
	ФондОплатыТрудаПоКатегориям.Загрузить(РезультатЗапроса[2].Выгрузить());
	
	ОбязательстваПоСтраховымВзносам = 0;
	ОбязательстваПоПенсионномуФонду = 0;
	ПереплатаПоСтраховымВзносам 	= 0;
	ПереплатаПоПенсионномуФонду	 	= 0;
	
	СтраховыеВзносы = РезультатЗапроса[4].Выгрузить()[0].ОстатокСтраховыхВзносов;
	Если СтраховыеВзносы > 0 Тогда
		ПереплатаПоСтраховымВзносам = СтраховыеВзносы;
	ИначеЕсли СтраховыеВзносы < 0 Тогда
		ОбязательстваПоСтраховымВзносам = - СтраховыеВзносы;
	КонецЕсли;
	
	ПенсионныйФонд = РезультатЗапроса[5].Выгрузить()[0].ОстатокПенсионногоФонда;
	Если ПенсионныйФонд > 0 Тогда
		ПереплатаПоПенсионномуФонду = ПенсионныйФонд;
	ИначеЕсли ПенсионныйФонд < 0 Тогда
		ОбязательстваПоПенсионномуФонду = - ПенсионныйФонд;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли