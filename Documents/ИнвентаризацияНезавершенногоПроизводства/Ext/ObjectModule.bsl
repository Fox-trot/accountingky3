﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьДанные(Отказ, РежимПроведения);
	
	ОтразитьДвижения(Отказ, РежимПроведения);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Добавить("ОстаткиНЗП");
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ИнвентаризацияНезавершенногоПроизводства.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНезавершенноеПроизводство(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура производит заполнение табличной части
//
Процедура ЗаполнитьТабличнуюЧасть(ДатаДокумента) Экспорт 
	
	// Остатки незавершенного производства на дату документа.	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Счет КАК СчетЗатрат,
		|	ХозрасчетныйОстатки.Субконто2 КАК НоменклатурнаяГруппа,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В ИЕРАРХИИ (&СчетаПрямыхРасходов),
		|			&ВидыСубконтоПрямыхРасходов,
		|			Организация = &Организация
		|				И Субконто1 = &Подразделение) КАК ХозрасчетныйОстатки";
	Запрос.УстановитьПараметр("Период", ДатаДокумента + 1);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("СчетаПрямыхРасходов", УчетПроизводства.ПредопределенныеСчетаПрямыхРасходов());
	
	ВидыСубконтоПрямыхРасходов = Новый Массив;
	ВидыСубконтоПрямыхРасходов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Подразделения);
	ВидыСубконтоПрямыхРасходов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы);
	Запрос.УстановитьПараметр("ВидыСубконтоПрямыхРасходов", ВидыСубконтоПрямыхРасходов);

	ОстаткиНЗП.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры 

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли