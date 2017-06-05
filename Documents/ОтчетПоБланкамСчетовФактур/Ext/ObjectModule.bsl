﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = КонецМесяца(ТекущаяДата());
		Если ЕстьДокументВУказанныйПериод(Дата) Тогда
			Дата = Дата('00010101');
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
КонецПроцедуры

Функция ЕстьДокументВУказанныйПериод(Дата)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтчетПоНДС.Ссылка
		|ИЗ
		|	Документ.ОтчетПоНДС КАК ОтчетПоНДС
		|ГДЕ
		|	НЕ ОтчетПоНДС.ПометкаУдаления
		|	И КОНЕЦПЕРИОДА(ОтчетПоНДС.Дата, МЕСЯЦ) = &Дата";
	
	Запрос.УстановитьПараметр("Дата", Дата);		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество() > 0 	

КонецФункции 

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	""На начало месяца"" КАК Содержание,
		|	БланкиСФОстатки.Серия,
		|	СУММА(БланкиСФОстатки.КоличествоОстаток) КАК Количество,
		|	БланкиСФОстатки.Номер
		|ПОМЕСТИТЬ ВременнаяТаблицаОстатки
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ), Организация = &Организация) КАК БланкиСФОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОстатки.Серия,
		|	БланкиСФОстатки.Номер
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	""На конец месяца"",
		|	БланкиСФОстатки.Серия,
		|	СУММА(БланкиСФОстатки.КоличествоОстаток),
		|	БланкиСФОстатки.Номер
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Остатки(КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), Организация = &Организация) КАК БланкиСФОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	БланкиСФОстатки.Серия,
		|	БланкиСФОстатки.Номер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОстатки.Порядок КАК Порядок,
		|	ВременнаяТаблицаОстатки.Содержание,
		|	ВременнаяТаблицаОстатки.Серия КАК Серия,
		|	СУММА(ВременнаяТаблицаОстатки.Количество) КАК Количество,
		|	ВременнаяТаблицаОстатки.Номер КАК Номер
		|ИЗ
		|	ВременнаяТаблицаОстатки КАК ВременнаяТаблицаОстатки
		|ГДЕ
		|	ВременнаяТаблицаОстатки.Количество <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаОстатки.Серия,
		|	ВременнаяТаблицаОстатки.Номер,
		|	ВременнаяТаблицаОстатки.Содержание,
		|	ВременнаяТаблицаОстатки.Порядок
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок,
		|	Серия,
		|	Номер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	БланкиСФОбороты.Серия,
		|	БланкиСФОбороты.Номер,
		|	БланкиСФОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ), КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), , Организация = &Организация) КАК БланкиСФОбороты";		
			
	Запрос.УстановитьПараметр("Организация", 	Организация);	
	Запрос.УстановитьПараметр("Дата", 			Дата);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	БланкиСФОстатки.Загрузить(РезультатЗапроса[1].Выгрузить());
	БланкиСФОбороты.Загрузить(РезультатЗапроса[2].Выгрузить());
	
	Если БланкиСФОбороты.Количество() = 0 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'В период ""%1"" нет данных для заполнения'"), 
										ПредставлениеПериода(НачалоМесяца(Дата), КонецМесяца(Дата)));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "БланкиСФОбороты");
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

#КонецОбласти

#КонецЕсли