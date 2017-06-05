﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоИнвентаризацииТМЗ(ДанныеЗаполнения) Экспорт

	ДокументОснование = ДанныеЗаполнения;
	
	Организация	= ДанныеЗаполнения.Организация;
	Склад = ДанныеЗаполнения.Склад;

	Комиссия.Загрузить(ДанныеЗаполнения.Комиссия);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнвентаризацияТоваровТовары.Номенклатура,
		|	ИнвентаризацияТоваровТовары.Отклонение КАК Количество,
		|	ИнвентаризацияТоваровТовары.СчетУчета
		|ИЗ
		|	Документ.ИнвентаризацияТоваров.Товары КАК ИнвентаризацияТоваровТовары
		|ГДЕ
		|	ИнвентаризацияТоваровТовары.Отклонение > 0
		|	И ИнвентаризацияТоваровТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи); 
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ИнвентаризацияТоваров")] = "ЗаполнитьПоИнвентаризацииТМЗ";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// Предварительный контроль	
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	 	
	// Инициализация данных документа.
	Документы.СписаниеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	// ТМЗ.
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства, Движения, Отказ);
	УчетМБП.СформироватьДвиженияСписаниеМБП(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	// Инициализация дополнительных свойств для проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура,
		|	ТаблицаДокумента.СчетУчета
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаДокумента1.Номенклатура
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
		|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
		|			И ТаблицаДокумента1.Номенклатура = ТаблицаДокумента2.Номенклатура
		|			И ТаблицаДокумента1.СчетУчета = ТаблицаДокумента2.СчетУчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДокумента1.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ТаблицаДокумента", Товары);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Дубли строк.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Номенклатура указывается повторно в строке %1 списка ""Товары"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Товары",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Номенклатура",
				Отказ);
		КонецЦикла;
	КонецЕсли;		

КонецПроцедуры

#КонецОбласти
	
#КонецЕсли