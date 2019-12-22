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
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	// Контроль номеров.
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СокрЛП(ПервыйНомер)) Тогда 
		ТекстСообщения = НСтр("ru = 'Необходимо ввести только цифры.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ПервыйНомер",, Отказ);
	КонецЕсли;
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СокрЛП(ПоследнийНомер)) Тогда 
		ТекстСообщения = НСтр("ru = 'Необходимо ввести только цифры.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ПоследнийНомер",, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	Если НЕ СтрДлина(СокрЛП(ПервыйНомер)) = СтрДлина(СокрЛП(ПоследнийНомер)) Тогда 
		ТекстСообщения = НСтр("ru = 'Длина первого номера не совпадает с длиной последного номера. Возможно не хватает лидирующих нулей.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	ИначеЕсли СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ПервыйНомер) >  СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ПоследнийНомер) Тогда 
		ТекстСообщения = НСтр("ru = 'Первый номер не может быть больше последнего номера.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ПоследнийНомер",, Отказ);
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

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
	Документы.ПоступлениеБланковСчетовФактур.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьБланкиСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаНомераБланков.Номер КАК Номер
		|ПОМЕСТИТЬ ВременнаяТаблицаСпецификация
		|ИЗ
		|	&ТаблицаНомераБланков КАК ТаблицаНомераБланков
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	БланкиСчетовФактурОбороты.НомерБланкаСФ КАК НомерБланкаСФ,
		|	БланкиСчетовФактурОбороты.КоличествоПриход КАК КоличествоПриход,
		|	БланкиСчетовФактурОбороты.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.БланкиСчетовФактур.Обороты(
		|			,
		|			,
		|			Авто,
		|			Организация = &Организация
		|				И СерияБланкаСФ = &СерияБланкаСФ
		|				И НомерБланкаСФ В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСпецификация.Номер КАК Номер
		|					ИЗ
		|						ВременнаяТаблицаСпецификация КАК ВременнаяТаблицаСпецификация)) КАК БланкиСчетовФактурОбороты
		|ГДЕ
		|	БланкиСчетовФактурОбороты.Организация = &Организация
		|	И БланкиСчетовФактурОбороты.Регистратор <> &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерБланкаСФ");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СерияБланкаСФ", СерияБланкаСФ);
	Запрос.УстановитьПараметр("ТаблицаНомераБланков", Документы.ПоступлениеБланковСчетовФактур.ТаблицаНомеров(ПервыйНомер, ПоследнийНомер));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Бланки счетов фактур".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'По указанной серии ""%1"" номеру ""%2"" ранее оформлен документ ""%3"". По регистру ""Бланки счетов фактур"".'"), 
							СерияБланкаСФ,
							ВыборкаИзРезультатаЗапроса.НомерБланкаСФ,
							ВыборкаИзРезультатаЗапроса.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Серия", Отказ);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли