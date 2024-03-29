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
		
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Начисления");
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
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
	Документы.РазовоеУдержание.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьУдержания(ДополнительныеСвойства, Движения, Отказ); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт 
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Сотрудники.ФизЛицо КАК ФизЛицо,
		|	Сотрудники.Подразделение КАК Подразделение,
		|	Сотрудники.Должность КАК Должность
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Подразделение В ИЕРАРХИИ (&Подразделение)
		|	И Сотрудники.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Сотрудники.ФизЛицо,
		|	Сотрудники.Подразделение,
		|	Сотрудники.Должность
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период > &НачалоПериода
		|	И Сотрудники.Период <= &КонецПериода
		|	И Сотрудники.Подразделение В ИЕРАРХИИ (&Подразделение)
		|	И Сотрудники.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаСотрудники.ФизЛицо,
		|	ВременнаяТаблицаСотрудники.Подразделение,
		|	ВременнаяТаблицаСотрудники.Должность,
		|	&ВидРасчета КАК ВидРасчета,
		|	&Размер КАК Размер
		|ИЗ
		|	ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Сотрудники.Подразделение = &Подразделение", "ИСТИНА");
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));	
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("ВидРасчета", ВидРасчета);
	Запрос.УстановитьПараметр("Размер", Размер);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Удержания.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

// Процедура рассчитывает табличную часть
//
Процедура РассчитатьТабличнуюЧасть() Экспорт

	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.РазовоеУдержание.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьУдержания(ДополнительныеСвойства, Движения, Ложь);

	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
	Ошибки = Неопределено;
	ПроведениеРасчетовПоЗарплатеСервер.РассчитатьЗаписиРегистраРасчета("Удержания", Движения.Удержания, Удержания, Ошибки);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // РассчитатьТабличнуюЧасть()

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли