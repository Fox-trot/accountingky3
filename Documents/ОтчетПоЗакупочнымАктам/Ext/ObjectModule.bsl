﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = КонецКвартала(ТекущаяДатаСеанса());
	Иначе
		Дата = КонецКвартала(Дата);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтчетПоЗакупочнымАктам.Ссылка
		|ИЗ
		|	Документ.ОтчетПоЗакупочнымАктам КАК ОтчетПоЗакупочнымАктам
		|ГДЕ
		|	НЕ ОтчетПоЗакупочнымАктам.ПометкаУдаления
		|	И ОтчетПоЗакупочнымАктам.Дата = &Дата
		|	И ОтчетПоЗакупочнымАктам.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'За указанный квартал уже сформирован закупочный акт.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ПрогрманыеСлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеЗакупочныхАктовОбороты.Период КАК Дата,
		|	ДанныеЗакупочныхАктовОбороты.Регистратор КАК Документ,
		|	ДанныеЗакупочныхАктовОбороты.Контрагент КАК Контрагент,
		|	ДанныеЗакупочныхАктовОбороты.Товар КАК Товар,
		|	ДанныеЗакупочныхАктовОбороты.Номер КАК Номер,
		|	ДанныеЗакупочныхАктовОбороты.КоличествоОборот КАК Количество,
		|	ДанныеЗакупочныхАктовОбороты.СуммаОборот КАК Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаЗакупочныеАкты
		|ИЗ
		|	РегистрНакопления.ДанныеЗакупочныхАктов.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Организация = &Организация) КАК ДанныеЗакупочныхАктовОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаЗакупочныеАкты.Дата КАК Дата,
		|	ВременнаяТаблицаЗакупочныеАкты.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаЗакупочныеАкты.Товар КАК Товар,
		|	ВременнаяТаблицаЗакупочныеАкты.Номер КАК Номер,
		|	ВременнаяТаблицаЗакупочныеАкты.Количество КАК Количество,
		|	ВременнаяТаблицаЗакупочныеАкты.Сумма КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаЗакупочныеАкты КАК ВременнаяТаблицаЗакупочныеАкты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Номер,
		|	Товар
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаЗакупочныеАкты.Документ) КАК Количество
		|ИЗ
		|	ВременнаяТаблицаЗакупочныеАкты КАК ВременнаяТаблицаЗакупочныеАкты";
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоКвартала(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 	Дата);
	Запрос.УстановитьПараметр("Организация", 	Организация);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СуммаДокумента = 0;
	
	// Заполнение ТЧ "Закупочный акт".
	ТаблицаДанных = МассивРезультатов[1].Выгрузить();
	
	ЗакупочныйАкт.Загрузить(ТаблицаДанных);
		
	СуммаДокумента = ТаблицаДанных.Итог("Сумма");
	
	// Заполнение количества закучопных актов.
	Выборка = МассивРезультатов[2].Выбрать();
	
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли