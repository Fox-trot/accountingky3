﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет табличную часть Материалы на основании данных табличных частей Продукция и Услуги.
// Процедура добавляет строки, не очищая табличную часть перед заполнением.
// Счета учета не заполняются. При необходимости, об этом должен позаботиться вызывающий код.
// 
Процедура ЗаполнитьМатериалыПоПродукцииУслугам() Экспорт
	
	// Получим данные о сырье для заполнения табличной части
	ЭлементыТекстаЗапроса = Новый Массив;
	// Исходные данные
	ЭлементыТекстаЗапроса.Добавить(
		"ВЫБРАТЬ
		|	0 КАК НомерСписка,
		|	Продукция.НомерСтроки КАК НомерСтроки,
		|	Продукция.Номенклатура КАК Комплект,
		|	Продукция.Спецификация КАК Спецификация,
		|	Продукция.Количество КАК КоличествоПродукции
		|ПОМЕСТИТЬ Выпуск
		|ИЗ
		|	&Продукция КАК Продукция");
	
	// Данные о расходе.
	ЭлементыТекстаЗапроса.Добавить(УправлениеПроизводством.ТекстЗапросаВременнаяТаблицаЗатратыСырья());
	
	// Преобразуем в формат получателя
	ЭлементыТекстаЗапроса.Добавить(
		"ВЫБРАТЬ
		|	ЗатратыСырья.НомерСтрокиСпецификации КАК НомерСтрокиСпецификации,
		|	ЗатратыСырья.НомерСписка КАК НомерСписка,
		|	ЗатратыСырья.Комплект КАК Комплект,
		|	ЗатратыСырья.Коэффициент КАК Коэффициент,
		|	ЗатратыСырья.Номенклатура КАК Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование КАК НоменклатураПредставление,
		|	ЗатратыСырья.Количество КАК Количество,
		|	ЗатратыСырья.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ИЗ
		|	ЗатратыСырья КАК ЗатратыСырья
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСписка,
		|	НомерСтрокиСпецификации,
		|	НоменклатураПредставление");
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Продукция", Комплекты.Выгрузить());
	Запрос.Текст = СтрСоединить(ЭлементыТекстаЗапроса, ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета());
	
	Материалы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если ВидОперации = Перечисления.ВидыОперацийКомплектация.Комплектация Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Материалы.Коэффициент");
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	// Предварительный контроль	
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьДанные(Отказ, РежимПроведения);
	
	ОтразитьДвижения(Отказ, РежимПроведения);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
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

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	 	
	// Инициализация данных документа.
	Документы.КомплектацияНоменклатуры.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	УчетПроизводства.СформироватьДвиженияКомплектация(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОприходования,
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизитыОприходования, Движения, Отказ);
	
	// Списание материалов на расходы производства
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписания, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизитыСписания, Движения, Отказ);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
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
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДокумента1.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ТаблицаДокумента", Комплекты.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Дубли строк.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Номенклатура указывается повторно в строке %1 списка ""Комплекты"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Комплекты",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Номенклатура",
				Отказ);
		КонецЦикла;
	КонецЕсли;		

КонецПроцедуры

#КонецОбласти
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли