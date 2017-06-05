﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПредварительныйКонтрольСпособовОценки(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Если Товары.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;	
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.СчетУчета
	|ПОМЕСТИТЬ ВременнаяТаблицаТовары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаТовары.НомерСтроки,
	|	ВременнаяТаблицаТовары.СчетУчета,
	|	СпособыОценкиЗапасов.СпособОценки
	|ПОМЕСТИТЬ ВременнаяТаблицаСпособыОценкиВсехСтрок
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособыОценкиЗапасов КАК СпособыОценкиЗапасов
	|		ПО ВременнаяТаблицаТовары.СчетУчета = СпособыОценкиЗапасов.СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаТовары.НомерСтроки,
	|	ВременнаяТаблицаТовары.СчетУчета,
	|	ВременнаяТаблицаТовары.СпособОценки
	|ПОМЕСТИТЬ СпособОценкиВПервойСтроке
	|ИЗ
	|	ВременнаяТаблицаСпособыОценкиВсехСтрок КАК ВременнаяТаблицаТовары
	|ГДЕ
	|	ВременнаяТаблицаТовары.НомерСтроки = 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаСпособыОценкиВсехСтрок.НомерСтроки,
	|	ВременнаяТаблицаСпособыОценкиВсехСтрок.СчетУчета,
	|	ВременнаяТаблицаСпособыОценкиВсехСтрок.СпособОценки
	|ИЗ
	|	ВременнаяТаблицаСпособыОценкиВсехСтрок КАК ВременнаяТаблицаСпособыОценкиВсехСтрок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СпособОценкиВПервойСтроке КАК СпособОценкиВПервойСтроке
	|		ПО ВременнаяТаблицаСпособыОценкиВсехСтрок.СпособОценки <> СпособОценкиВПервойСтроке.СпособОценки";
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если Не МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке %1 табличной части ""Товары"" указан счет учета со способом оценки отличным от способа оценки в первой строке табличной части.'"), 
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
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектов.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.ДляПроведения.Вставить("СпособОценки", 	Ссылка.Товары[0].СпособОценки);
	ДополнительныеСвойства.ДляПроведения.Вставить("СкладРасход", 	Ссылка.СкладОтправитель);
	ДополнительныеСвойства.ДляПроведения.Вставить("ПодборНоменклатурыПоПартии",	Ссылка.ПодборНоменклатурыПоПартии);
	
	// Инициализация данных документа.
	Документы.ПеремещениеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	// Установка исключительной блокировки контролируемых остатков запасов.
	Движения.Запасы.БлокироватьДляИзменения = Истина;
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	БухгалтерскийУчетСервер.ВыполнитьКонтрольЗапасы(Ссылка, ДополнительныеСвойства, Отказ);	
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Список Тогда
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СкладПолучатель");
	Иначе
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Товары.СкладПолучатель");
	КонецЕсли;
	
	// Предварительный контроль	
	ВыполнитьПредварительныйКонтрольСпособовОценки(Отказ);
	
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
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#КонецЕсли