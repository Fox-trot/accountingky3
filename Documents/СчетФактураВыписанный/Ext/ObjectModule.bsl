﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВозвратуОтПокупателя(ДанныеЗаполнения) Экспорт
	
	Организация			= ДанныеЗаполнения.Организация;
	Контрагент			= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаДокумента     = ДанныеЗаполнения.ВалютаДокумента;
	СуммаВключаетНалоги	= ДанныеЗаполнения.СуммаВключаетНалоги;	
	СуммаДокумента      = ДанныеЗаполнения.СуммаДокумента;
	СуммаВключаетНалоги	= ДанныеЗаполнения.СуммаВключаетНалоги;
	ВозвратТоваров		= Истина;
	ЭкспортнаяПоставка	= ДанныеЗаполнения.ЭкспортнаяПоставка;
	
	Если ДанныеЗаполнения.БезвозмезднаяПоставка Тогда
		ФормаОплаты = Перечисления.ФормыОплаты.БезвозмезднаяПоставка;	
	ИначеЕсли ДанныеЗаполнения.БезналичныйРасчет Тогда
		ФормаОплаты = Перечисления.ФормыОплаты.Безналичная;
	Иначе
		ФормаОплаты = Перечисления.ФормыОплаты.Наличная;
	КонецЕсли;
	
	Для Каждого СтрокаТабличнойЧастиТовары Из ДанныеЗаполнения.Товары Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиТовары);
		
		СтрокаТабличнойЧасти.Сумма 		 = -СтрокаТабличнойЧасти.Сумма;
		СтрокаТабличнойЧасти.СуммаНДС 	 = -СтрокаТабличнойЧасти.СуммаНДС;
		СтрокаТабличнойЧасти.СуммаНСП 	 = -СтрокаТабличнойЧасти.СуммаНСП;
		СтрокаТабличнойЧасти.СуммаДохода = -СтрокаТабличнойЧасти.СуммаДохода;
		СтрокаТабличнойЧасти.Всего		 = -СтрокаТабличнойЧасти.Всего;
		
		СтрокаТабличнойЧасти.ДокументОснование 	= ДанныеЗаполнения;
		СтрокаТабличнойЧасти.СтавкаНДС 			= ДанныеЗаполнения.СтавкаНДС;
		СтрокаТабличнойЧасти.СтавкаНСП 			= ДанныеЗаполнения.СтавкаНСП;
		СтрокаТабличнойЧасти.КлючСвязи			= 1;
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧастиУслуги Из ДанныеЗаполнения.Услуги Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиУслуги);
		
		СтрокаТабличнойЧасти.Сумма 		 = -СтрокаТабличнойЧасти.Сумма;
		СтрокаТабличнойЧасти.СуммаНДС 	 = -СтрокаТабличнойЧасти.СуммаНДС;
		СтрокаТабличнойЧасти.СуммаНСП 	 = -СтрокаТабличнойЧасти.СуммаНСП;
		СтрокаТабличнойЧасти.СуммаДохода = -СтрокаТабличнойЧасти.СуммаДохода;
		СтрокаТабличнойЧасти.Всего		 = -СтрокаТабличнойЧасти.Всего;
		
		СтрокаТабличнойЧасти.ДокументОснование 	= ДанныеЗаполнения;
		СтрокаТабличнойЧасти.СтавкаНДС 			= ДанныеЗаполнения.СтавкаНДС;
		СтрокаТабличнойЧасти.СтавкаНСП 			= ДанныеЗаполнения.СтавкаНСПУслуги;
		СтрокаТабличнойЧасти.КлючСвязи			= 1;
	КонецЦикла;
	
	СтрокаТабличнойЧастиДокументы = ДокументыОснования.Добавить();
	СтрокаТабличнойЧастиДокументы.ДокументОснование = ДанныеЗаполнения;
	СтрокаТабличнойЧастиДокументы.СтавкаНДС 		= ДанныеЗаполнения.СтавкаНДС;
	СтрокаТабличнойЧастиДокументы.КлючСвязи			= 1;
	СтрокаТабличнойЧастиДокументы.Сумма 			= -(ДанныеЗаполнения.Товары.Итог("Сумма") + ДанныеЗаполнения.Услуги.Итог("Сумма"));
	СтрокаТабличнойЧастиДокументы.СуммаНДС 			= -(ДанныеЗаполнения.Товары.Итог("СуммаНДС") + ДанныеЗаполнения.Услуги.Итог("СуммаНДС"));
	СтрокаТабличнойЧастиДокументы.СуммаНСП 			= -(ДанныеЗаполнения.Товары.Итог("СуммаНСП") + ДанныеЗаполнения.Услуги.Итог("СуммаНСП"));
	СтрокаТабличнойЧастиДокументы.Всего 			= -(ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего"));
	СтрокаТабличнойЧастиДокументы.СуммаДохода 		= -(ДанныеЗаполнения.Товары.Итог("СуммаДохода") + ДанныеЗаполнения.Услуги.Итог("СуммаДохода"));
	СтрокаТабличнойЧастиДокументы.Валюта			= ДанныеЗаполнения.ВалютаДокумента;
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	Организация			= ДанныеЗаполнения.Организация;
	Контрагент			= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаДокумента     = ДанныеЗаполнения.ВалютаДокумента;
	СуммаВключаетНалоги	= ДанныеЗаполнения.СуммаВключаетНалоги;	
	СуммаДокумента      = ДанныеЗаполнения.СуммаДокумента;
	СуммаВключаетНалоги	= ДанныеЗаполнения.СуммаВключаетНалоги;
	ЭкспортнаяПоставка	= ДанныеЗаполнения.ЭкспортнаяПоставка;
	
	Если ДанныеЗаполнения.БезвозмезднаяПоставка Тогда
		ФормаОплаты = Перечисления.ФормыОплаты.БезвозмезднаяПоставка;	
	ИначеЕсли ДанныеЗаполнения.БезналичныйРасчет Тогда
		ФормаОплаты = Перечисления.ФормыОплаты.Безналичная;
	Иначе
		ФормаОплаты = Перечисления.ФормыОплаты.Наличная;
	КонецЕсли;	
	
	Для Каждого СтрокаТабличнойЧастиТовары Из ДанныеЗаполнения.Товары Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиТовары);
		
		СтрокаТабличнойЧасти.ДокументОснование 	= ДанныеЗаполнения;
		СтрокаТабличнойЧасти.СтавкаНДС 			= ДанныеЗаполнения.СтавкаНДС;
		СтрокаТабличнойЧасти.СтавкаНСП 			= ДанныеЗаполнения.СтавкаНСП;
		СтрокаТабличнойЧасти.КлючСвязи			= 1;
	КонецЦикла;	
	
	Для Каждого СтрокаТабличнойЧастиУслуги Из ДанныеЗаполнения.Услуги Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиУслуги);
		
		СтрокаТабличнойЧасти.ДокументОснование 	= ДанныеЗаполнения;
		СтрокаТабличнойЧасти.СтавкаНДС 			= ДанныеЗаполнения.СтавкаНДС;
		СтрокаТабличнойЧасти.СтавкаНСП 			= ДанныеЗаполнения.СтавкаНСПУслуги;
		СтрокаТабличнойЧасти.КлючСвязи			= 1;
	КонецЦикла;
	
	СтрокаТабличнойЧастиДокументы = ДокументыОснования.Добавить();
	СтрокаТабличнойЧастиДокументы.ДокументОснование = ДанныеЗаполнения;
	СтрокаТабличнойЧастиДокументы.СтавкаНДС 		= ДанныеЗаполнения.СтавкаНДС;
	СтрокаТабличнойЧастиДокументы.КлючСвязи			= 1;
	СтрокаТабличнойЧастиДокументы.Сумма 			= ДанныеЗаполнения.Товары.Итог("Сумма") + ДанныеЗаполнения.Услуги.Итог("Сумма");
	СтрокаТабличнойЧастиДокументы.СуммаНДС 			= ДанныеЗаполнения.Товары.Итог("СуммаНДС") + ДанныеЗаполнения.Услуги.Итог("СуммаНДС");
	СтрокаТабличнойЧастиДокументы.СуммаНСП 			= ДанныеЗаполнения.Товары.Итог("СуммаНСП") + ДанныеЗаполнения.Услуги.Итог("СуммаНСП");
	СтрокаТабличнойЧастиДокументы.Всего 			= ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего");
	СтрокаТабличнойЧастиДокументы.СуммаДохода 		= ДанныеЗаполнения.Товары.Итог("СуммаДохода") + ДанныеЗаполнения.Услуги.Итог("СуммаДохода");
	СтрокаТабличнойЧастиДокументы.Валюта			= ДанныеЗаполнения.ВалютаДокумента;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт 
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")] = "ЗаполнитьПоВозвратуОтПокупателя";
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;	
	
	ПараметрыФО = Новый Структура();
	ПараметрыФО.Вставить("Организация", Организация);
	ПараметрыФО.Вставить("Период", Дата);
	
	ПлательщикНДС = ПолучитьФункциональнуюОпцию("ПлательщикНДС", ПараметрыФО);
	
	Если НЕ ПлательщикНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерияБланкаСФ");
		МассивНепроверяемыхРеквизитов.Добавить("НомерБланкаСФ");
	КонецЕсли;	
	
	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = ДокументыОснования.Итог("Сумма");	
	
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

Процедура ПриКопировании(ОбъектКопирования)
	СерияБланкаСФ = "";
	НомерБланкаСФ = "";
	ДатаПоставки = '00010101';
	ЭкспортнаяПоставка = Ложь;
	КодПоставкиНДС = Справочники.КодыПоставокНДС.ПустаяСсылка();
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
	Документы.СчетФактураВыписанный.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьБланкиСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	
	// Переход на ЭСФ.
	Если Дата < Дата(2020, 07, 01) Тогда 
		БухгалтерскийУчетСервер.ОтразитьСчетаФактурыВыписанные(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Проверка наличия серии и номера СФ в базе.
	Если ЗначениеЗаполнено(СерияБланкаСФ) И СерияБланкаСФ <> "ДПБУ" Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	БланкиСчетовФактурОбороты.СерияБланкаСФ КАК СерияБланкаСФ,
			|	БланкиСчетовФактурОбороты.Регистратор КАК Регистратор,
			|	ЕСТЬNULL(БланкиСчетовФактурОбороты.КоличествоРасход, 0) КАК КоличествоРасход,
			|	ЕСТЬNULL(БланкиСчетовФактурОбороты.КоличествоПриход, 0) КАК КоличествоПриход
			|ПОМЕСТИТЬ ВременнаяТаблицаБланкиСчетовФактур
			|ИЗ
			|	РегистрНакопления.БланкиСчетовФактур.Обороты(
			|			,
			|			&КонецПериода,
			|			Авто,
			|			Организация = &Организация
			|				И СерияБланкаСФ = &СерияБланкаСФ
			|				И НомерБланкаСФ = &НомерБланкаСФ) КАК БланкиСчетовФактурОбороты
			|ГДЕ
			|	НЕ БланкиСчетовФактурОбороты.Регистратор = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаБланкиСчетовФактур.СерияБланкаСФ КАК СерияБланкаСФ,
			|	ВременнаяТаблицаБланкиСчетовФактур.КоличествоПриход КАК КоличествоПриход
			|ИЗ
			|	ВременнаяТаблицаБланкиСчетовФактур КАК ВременнаяТаблицаБланкиСчетовФактур
			|ГДЕ
			|	ВременнаяТаблицаБланкиСчетовФактур.КоличествоПриход > 0
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаБланкиСчетовФактур.СерияБланкаСФ КАК СерияБланкаСФ,
			|	ВременнаяТаблицаБланкиСчетовФактур.Регистратор КАК Регистратор,
			|	ВременнаяТаблицаБланкиСчетовФактур.КоличествоРасход КАК КоличествоРасход
			|ИЗ
			|	ВременнаяТаблицаБланкиСчетовФактур КАК ВременнаяТаблицаБланкиСчетовФактур
			|ГДЕ
			|	ВременнаяТаблицаБланкиСчетовФактур.КоличествоРасход > 0";
		Запрос.УстановитьПараметр("КонецПериода", Дата);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("СерияБланкаСФ", СерияБланкаСФ);
		Запрос.УстановитьПараметр("НомерБланкаСФ", НомерБланкаСФ);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		              
		Если МассивРезультатов[1].Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Указанных серии или номера СФ нет в базе. Необходимо оформить документ ""Поступление бланков счетов-фактур"".'");
			БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
		ИначеЕсли НЕ МассивРезультатов[2].Пустой() Тогда
			ВыборкаДетальныеЗаписи = МассивРезультатов[2].Выбрать();
			ВыборкаДетальныеЗаписи.Следующий();
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Указанные серия и номер СФ уже использованы. %1.'"), ВыборкаДетальныеЗаписи.Регистратор);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
		КонецЕсли;			
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокументыОснования.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокументыОснования.Валюта КАК Валюта
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументыОснования
		|ИЗ
		|	&ТаблицаДокументыОснования КАК ТаблицаДокументыОснования
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаТовары.СтавкаНДС КАК СтавкаНДС
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДокументыОснования.НомерСтроки
		|ИЗ
		|	ВременнаяТаблицаДокументыОснования КАК ВременнаяТаблицаДокументыОснования
		|ГДЕ
		|	ВременнаяТаблицаДокументыОснования.Валюта <> &Валюта";
	Запрос.УстановитьПараметр("ТаблицаТовары", Товары);
	Запрос.УстановитьПараметр("ТаблицаДокументыОснования", ДокументыОснования);
	Запрос.УстановитьПараметр("Валюта", ВалютаДокумента);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[2].Выбрать();
	
	Если Выборка.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'В табличной части ""Документы"" находятся документы с разными ставками НДС.'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
	КонецЕсли;
	
	Выборка = МассивРезультатов[3].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = СтрШаблон(НСтр("ru = 'В табличной части ""Документы"" в строке номер %1 валюта отличается от валюты документа.'"), Выборка.НомерСтроки);
		БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);	
	КонецЦикла;
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

// Процедура заполнения табличной части "ДокументыОснования".
//
Процедура ЗаполнитьДокументыОснования() Экспорт

	// Заполнение массива контрагентов,
	// при включенной настройке добавляются филиалы.
	МассивКонтрагентов = Новый Массив;
	МассивКонтрагентов.Добавить(Контрагент);
	
	ПечататьСчетаФактурыСГоловнымКонтрагентом = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ПечататьСчетаФактурыСГоловнымКонтрагентом");
	Если ПечататьСчетаФактурыСГоловнымКонтрагентом ИЛИ ПоГоловномуКонтрагенту Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Контрагенты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.ГоловнойКонтрагент = &Контрагент";
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			МассивКонтрагентов.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	КонецЕсли;	
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Отбор документов по периоду, контрагенту и организации,
	// а также отсечение документов уже использованных в счет фактурах выписанных.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СчетаФактурыВыписанные.Документ КАК Документ
		|ПОМЕСТИТЬ ВременнаяТаблицаСчетаФактурыВыписанные
		|ИЗ
		|	РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
		|ГДЕ
		|	СчетаФактурыВыписанные.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И СчетаФактурыВыписанные.Регистратор ССЫЛКА Документ.СчетФактураВыписанный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПродажиОбороты.ДокументРеализации КАК ДокументОснование,
		|	ПродажиОбороты.БезналичныйРасчет КАК БезналичныйРасчет,
		|	ПродажиОбороты.СтавкаНДС КАК СтавкаНДС,
		|	ПродажиОбороты.БезвозмезднаяПоставка КАК БезвозмезднаяПоставка,
		|	ПродажиОбороты.Договор КАК ДоговорКонтрагента
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Контрагент В (&МассивКонтрагентов)) КАК ПродажиОбороты
		|ГДЕ
		|	НЕ ПродажиОбороты.ДокументРеализации В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаСчетаФактурыВыписанные.Документ
		|				ИЗ
		|					ВременнаяТаблицаСчетаФактурыВыписанные)";
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("НачалоПериода", 		НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 		КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 		Организация);
	Запрос.УстановитьПараметр("МассивКонтрагентов", МассивКонтрагентов);
	Запрос.Выполнить();
	
	Отбор = 
		"ВременнаяТаблицаДокументы.ДоговорКонтрагента.ВалютаРасчетов = &Валюта
		|	И ВЫБОР
		|		КОГДА &ДоговорКонтрагента = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ВременнаяТаблицаДокументы.ДоговорКонтрагента = &ДоговорКонтрагента
		|	КОНЕЦ
		|	И ВЫБОР
		|		КОГДА &ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.БезвозмезднаяПоставка)
		|			ТОГДА ВременнаяТаблицаДокументы.БезвозмезднаяПоставка = ИСТИНА
		|		КОГДА &ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|			ТОГДА ВременнаяТаблицаДокументы.БезналичныйРасчет = ЛОЖЬ
		|		КОГДА &ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|			ТОГДА ВременнаяТаблицаДокументы.БезналичныйРасчет = ИСТИНА
		|		КОГДА &ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Смешанная)
		|			ТОГДА ИСТИНА
		|	КОНЕЦ";
	
	КлючСвязи = 1;
	
	// Подбор документов "Возврат товаров от покупателя"
	Если ВозвратТоваров Тогда
		// Получение документов с отбором по ставкам и значению безналичного расчета.
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 		
			"ВЫБРАТЬ
			|	ВременнаяТаблицаДокументы.ДокументОснование,
			|	ВременнаяТаблицаДокументы.СтавкаНДС КАК СтавкаНДС,
			|	ВременнаяТаблицаДокументы.ДоговорКонтрагента.ВалютаРасчетов КАК Валюта
			|ИЗ
			|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
		 	|ГДЕ " + Отбор + " 
			|	И ВременнаяТаблицаДокументы.ДокументОснование ССЫЛКА Документ.ВозвратТоваровОтПокупателя";
		Запрос.УстановитьПараметр("Валюта", 			ВалютаДокумента);
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		Запрос.УстановитьПараметр("ФормаОплаты", 		ФормаОплаты);

		Выборка = Запрос.Выполнить().Выбрать();
		                        
		Если Выборка.Количество() > 0 Тогда
			
			Пока Выборка.Следующий() Цикл
            	СтрокаТабличнойЧасти = ДокументыОснования.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
				СтрокаТабличнойЧасти.КлючСвязи			= КлючСвязи;
				СтрокаТабличнойЧасти.Сумма 				= -(Выборка.ДокументОснование.Товары.Итог("Сумма")
															+ Выборка.ДокументОснование.Услуги.Итог("Сумма"));
				СтрокаТабличнойЧасти.СуммаНДС 			= -(Выборка.ДокументОснование.Товары.Итог("СуммаНДС")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНДС"));
				СтрокаТабличнойЧасти.СуммаНСП 			= -(Выборка.ДокументОснование.Товары.Итог("СуммаНСП")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНСП"));
				СтрокаТабличнойЧасти.СуммаДохода 		= -(Выборка.ДокументОснование.Товары.Итог("СуммаДохода")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаДохода"));
				СтрокаТабличнойЧасти.Всего 				= -(Выборка.ДокументОснование.Товары.Итог("Всего")
															+ Выборка.ДокументОснование.Услуги.Итог("Всего"));
															
				КлючСвязи = КлючСвязи + 1;																
			КонецЦикла;
			
			СуммаДокумента = ДокументыОснования.Итог("Сумма");
			
		Иначе
			// 1. Получение всех оставшихся документов, кроме полученных в первом пакете для
			// проверки наличия таковых и показа пользователю соответствующего сообщения.
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
			Запрос.Текст = 		
				"ВЫБРАТЬ
				|	ВременнаяТаблицаДокументы.ДокументОснование КАК ДокументОснование,
				|	ВременнаяТаблицаДокументы.СтавкаНДС КАК СтавкаНДС,
				|	ВременнаяТаблицаДокументы.ДоговорКонтрагента.ВалютаРасчетов КАК Валюта
				|ИЗ
				|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
				|ГДЕ
				|	 " + Отбор + "
				|	И ВременнаяТаблицаДокументы.ДокументОснование ССЫЛКА Документ.ВозвратТоваровОтПокупателя
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВременнаяТаблицаДокументы.ДокументОснование
				|ИЗ
				|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
				|ГДЕ
				|	НЕ(" + Отбор + ")
				|	И ВременнаяТаблицаДокументы.ДокументОснование ССЫЛКА Документ.ВозвратТоваровОтПокупателя";
			Запрос.УстановитьПараметр("Валюта", 			ВалютаДокумента);
			Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
			Запрос.УстановитьПараметр("ФормаОплаты", 		ФормаОплаты);

			РезультатЗапроса = Запрос.ВыполнитьПакет();
			
			Выборка = РезультатЗапроса[0].Выбрать();
			
			Пока Выборка.Следующий() Цикл
				СтрокаТабличнойЧасти = ДокументыОснования.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
				СтрокаТабличнойЧасти.КлючСвязи			= КлючСвязи;
				СтрокаТабличнойЧасти.Сумма 				= -(Выборка.ДокументОснование.Товары.Итог("Сумма")
															+ Выборка.ДокументОснование.Услуги.Итог("Сумма"));
				СтрокаТабличнойЧасти.СуммаНДС 			= -(Выборка.ДокументОснование.Товары.Итог("СуммаНДС")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНДС"));
				СтрокаТабличнойЧасти.СуммаНСП 			= -(Выборка.ДокументОснование.Товары.Итог("СуммаНСП")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНСП"));
				СтрокаТабличнойЧасти.СуммаДохода 		= -(Выборка.ДокументОснование.Товары.Итог("СуммаДохода")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаДохода"));
				СтрокаТабличнойЧасти.Всего 				= -(Выборка.ДокументОснование.Товары.Итог("Всего")
															+ Выборка.ДокументОснование.Услуги.Итог("Всего"));
				
				КлючСвязи = КлючСвязи + 1;	
			КонецЦикла;
			
			СуммаДокумента = ДокументыОснования.Итог("Сумма");
			
			Если НЕ РезультатЗапроса[1].Пустой() Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для контрагента %1 обнаружены документы возврата %2.'"), Контрагент, 
					?(ЗначениеЗаполнено(ДоговорКонтрагента), НСтр("ru = 'с другим договором'"), НСтр("ru = 'с другими ставками'")));
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);		
			КонецЕсли;		
		КонецЕсли;
		
	// Подбор документов "Реализация товаров услуг"
	Иначе
		Если ПолучитьФункциональнуюОпцию("ПлательщикНДС") Тогда
			ОтборПоСФ =
				"И СчетаФактурыВыписанные.СерияБланкаСФ = """"
				|	И СчетаФактурыВыписанные.НомерБланкаСФ = """"";
		Иначе
			ОтборПоСФ = "";
		КонецЕсли;	
		
		// Получение документов с отбором по ставкам, значению безналичного расчета,
		// и наличия пустых значений серии и номера бланка счет фактуры.
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 		
			"ВЫБРАТЬ
			|	ВременнаяТаблицаДокументы.ДокументОснование КАК ДокументОснование,
			|	ВременнаяТаблицаДокументы.СтавкаНДС КАК СтавкаНДС,
			|	ВременнаяТаблицаДокументы.ДоговорКонтрагента.ВалютаРасчетов КАК Валюта
			|ИЗ
			|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
			|		ПО ВременнаяТаблицаДокументы.ДокументОснование = СчетаФактурыВыписанные.Документ
			|			И НЕ СчетаФактурыВыписанные.Регистратор ССЫЛКА Документ.СчетФактураВыписанный
			|ГДЕ
			|	" + Отбор + "
			|	И ВременнаяТаблицаДокументы.ДокументОснование ССЫЛКА Документ.РеализацияТоваровУслуг
			|	" + ОтборПоСФ;	
		
		Запрос.УстановитьПараметр("Валюта", 			ВалютаДокумента);
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		Запрос.УстановитьПараметр("ФормаОплаты", 		ФормаОплаты);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() > 0 Тогда
			
			Пока Выборка.Следующий() Цикл
            	СтрокаТабличнойЧасти = ДокументыОснования.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
				СтрокаТабличнойЧасти.КлючСвязи			= КлючСвязи;
				СтрокаТабличнойЧасти.Сумма 				= Выборка.ДокументОснование.Товары.Итог("Сумма")
															+ Выборка.ДокументОснование.Услуги.Итог("Сумма");
				СтрокаТабличнойЧасти.СуммаНДС 			= Выборка.ДокументОснование.Товары.Итог("СуммаНДС")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНДС");
				СтрокаТабличнойЧасти.СуммаНСП 			= Выборка.ДокументОснование.Товары.Итог("СуммаНСП")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНСП");
				СтрокаТабличнойЧасти.СуммаДохода 		= Выборка.ДокументОснование.Товары.Итог("СуммаДохода")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаДохода");
				СтрокаТабличнойЧасти.Всего 				= Выборка.ДокументОснование.Товары.Итог("Всего")
															+ Выборка.ДокументОснование.Услуги.Итог("Всего");
															
				КлючСвязи = КлючСвязи + 1;											
			КонецЦикла;
			
			СуммаДокумента = ДокументыОснования.Итог("Сумма");
			
		Иначе
			// 1. Получение всех оставшихся документов, кроме полученных в первом пакете для
			// проверки наличия таковых и показа пользователю соответствующего сообщения.
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
			Запрос.Текст = 		
				"ВЫБРАТЬ
				|	ВременнаяТаблицаДокументы.ДокументОснование КАК ДокументОснование,
				|	ВременнаяТаблицаДокументы.СтавкаНДС КАК СтавкаНДС,
				|	ВременнаяТаблицаДокументы.ДоговорКонтрагента.ВалютаРасчетов КАК Валюта
				|ИЗ
				|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
				|		ПО ВременнаяТаблицаДокументы.ДокументОснование = СчетаФактурыВыписанные.Документ
				|			И НЕ СчетаФактурыВыписанные.Регистратор ССЫЛКА Документ.СчетФактураВыписанный
				|ГДЕ
				|	 " + Отбор + "
				|	И ВременнаяТаблицаДокументы.ДокументОснование ССЫЛКА Документ.РеализацияТоваровУслуг
				|	" + ОтборПоСФ + "
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВременнаяТаблицаДокументы.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
				|		ПО ВременнаяТаблицаДокументы.ДокументОснование = СчетаФактурыВыписанные.Документ
				|			И НЕ СчетаФактурыВыписанные.Регистратор ССЫЛКА Документ.СчетФактураВыписанный
				|ГДЕ
				|	НЕ( " + Отбор + " )
				|	И ВременнаяТаблицаДокументы.ДокументОснование ССЫЛКА Документ.РеализацияТоваровУслуг
				|	" + ОтборПоСФ;
			Запрос.УстановитьПараметр("Валюта", 			ВалютаДокумента);
			Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
			Запрос.УстановитьПараметр("ФормаОплаты", 		ФормаОплаты);
			
			РезультатЗапроса = Запрос.ВыполнитьПакет();
			
			Выборка = РезультатЗапроса[0].Выбрать();
			
			Пока Выборка.Следующий() Цикл
				СтрокаТабличнойЧасти = ДокументыОснования.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
				СтрокаТабличнойЧасти.КлючСвязи			= КлючСвязи;
				СтрокаТабличнойЧасти.Сумма 				= Выборка.ДокументОснование.Товары.Итог("Сумма")
															+ Выборка.ДокументОснование.Услуги.Итог("Сумма");
				СтрокаТабличнойЧасти.СуммаНДС 			= Выборка.ДокументОснование.Товары.Итог("СуммаНДС")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНДС");
				СтрокаТабличнойЧасти.СуммаНСП 			= Выборка.ДокументОснование.Товары.Итог("СуммаНСП")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаНСП");
				СтрокаТабличнойЧасти.СуммаДохода 		= Выборка.ДокументОснование.Товары.Итог("СуммаДохода")
															+ Выборка.ДокументОснование.Услуги.Итог("СуммаДохода");
				СтрокаТабличнойЧасти.Всего 				= Выборка.ДокументОснование.Товары.Итог("Всего")
															+ Выборка.ДокументОснование.Услуги.Итог("Всего");
				
				КлючСвязи = КлючСвязи + 1;	
			КонецЦикла;
			
			СуммаДокумента = ДокументыОснования.Итог("Сумма");
			
			Если НЕ РезультатЗапроса[1].Пустой() Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Для контрагента %1 обнаружены документы реализации %2.'"), Контрагент, 
					?(ЗначениеЗаполнено(ДоговорКонтрагента), НСтр("ru = 'с другим договором'"), НСтр("ru = 'с другими ставками'")));
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);		
			КонецЕсли;	
		КонецЕсли;			
	КонецЕсли;
КонецПроцедуры

// Процедура заполняет табличную часть "Товары" по документам,
// подобранным в табличной части "ДокументыПоступления".
//
// Параметры:
//	ВозвратОтПокупателя - Булево - реквизит "Возврат" данного документа 
//
Процедура ЗаполнитьПоПодобраннымДокументам() Экспорт

	МассивДокументов = ДокументыОснования.Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация);
	
	Запрос = Новый Запрос;         
	
	Если ВозвратТоваров Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВозвратТоваровОтПокупателяТовары.Ссылка КАК ДокументОснование,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА ВозвратТоваровОтПокупателяТовары.Ссылка.СтавкаНДС
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)
			|	КОНЕЦ КАК СтавкаНДС,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА ВозвратТоваровОтПокупателяТовары.Ссылка.СтавкаНСП
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкИНСП.ПустаяСсылка)
			|	КОНЕЦ КАК СтавкаНСП,
			|	ВозвратТоваровОтПокупателяТовары.Номенклатура КАК Номенклатура,
			|	ВозвратТоваровОтПокупателяТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
			|	-ВозвратТоваровОтПокупателяТовары.Количество КАК Количество,
			|	-ВозвратТоваровОтПокупателяТовары.Цена КАК Цена,
			|	-ВозвратТоваровОтПокупателяТовары.Сумма КАК Сумма,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА -ВозвратТоваровОтПокупателяТовары.СуммаНДС
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНДС,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА -ВозвратТоваровОтПокупателяТовары.СуммаНСП
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНСП,
			|	-ВозвратТоваровОтПокупателяТовары.Всего КАК Всего,
			|	-ВозвратТоваровОтПокупателяТовары.СуммаДохода КАК СуммаДохода,
			|	-ВозвратТоваровОтПокупателяТовары.СуммаСкидки КАК СуммаСкидки,
			|	-ВозвратТоваровОтПокупателяТовары.СуммаВВалютеРеглУчета КАК СуммаВВалютеРеглУчета,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА -ВозвратТоваровОтПокупателяТовары.СуммаНДСВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНДСВВалютеРеглУчета,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА -ВозвратТоваровОтПокупателяТовары.СуммаНСПВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНСПВВалютеРеглУчета,
			|	-ВозвратТоваровОтПокупателяТовары.ВсегоВВалютеРеглУчета КАК ВсегоВВалютеРеглУчета,
			|	-ВозвратТоваровОтПокупателяТовары.СуммаДоходаВВалютеРеглУчета КАК СуммаДоходаВВалютеРеглУчета,
			|	-ВозвратТоваровОтПокупателяТовары.СуммаСкидкиВВалютеРеглУчета КАК СуммаСкидкиВВалютеРеглУчета
			|ИЗ
			|	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
			|ГДЕ
			|	ВозвратТоваровОтПокупателяТовары.Ссылка В(&МассивДокументов)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ВозвратТоваровОтПокупателяУслуги.Ссылка,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА ВозвратТоваровОтПокупателяУслуги.Ссылка.СтавкаНДС
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА ВозвратТоваровОтПокупателяУслуги.Ссылка.СтавкаНСПУслуги
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкИНСП.ПустаяСсылка)
			|	КОНЕЦ,
			|	ВозвратТоваровОтПокупателяУслуги.Номенклатура,
			|	ВозвратТоваровОтПокупателяУслуги.Номенклатура.ЕдиницаИзмерения,
			|	-ВозвратТоваровОтПокупателяУслуги.Количество,
			|	-ВозвратТоваровОтПокупателяУслуги.Цена,
			|	-ВозвратТоваровОтПокупателяУслуги.Сумма,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА -ВозвратТоваровОтПокупателяУслуги.СуммаНДС
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА -ВозвратТоваровОтПокупателяУслуги.СуммаНСП
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	-ВозвратТоваровОтПокупателяУслуги.Всего,
			|	-ВозвратТоваровОтПокупателяУслуги.СуммаДохода,
			|	-ВозвратТоваровОтПокупателяУслуги.СуммаСкидки,
			|	-ВозвратТоваровОтПокупателяУслуги.СуммаВВалютеРеглУчета КАК СуммаВВалютеРеглУчета,
			
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА -ВозвратТоваровОтПокупателяУслуги.СуммаНДСВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА -ВозвратТоваровОтПокупателяУслуги.СуммаНСПВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	-ВозвратТоваровОтПокупателяУслуги.ВсегоВВалютеРеглУчета,
			|	-ВозвратТоваровОтПокупателяУслуги.СуммаДоходаВВалютеРеглУчета,
			|	-ВозвратТоваровОтПокупателяУслуги.СуммаСкидкиВВалютеРеглУчета
			|ИЗ
			|	Документ.ВозвратТоваровОтПокупателя.Услуги КАК ВозвратТоваровОтПокупателяУслуги
			|ГДЕ
			|	ВозвратТоваровОтПокупателяУслуги.Ссылка В(&МассивДокументов)";
	Иначе
		Запрос.Текст =		
			"ВЫБРАТЬ
			|	РеализацияТоваровУслугТовары.Ссылка КАК ДокументОснование,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА РеализацияТоваровУслугТовары.Ссылка.СтавкаНДС
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)
			|	КОНЕЦ КАК СтавкаНДС,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА РеализацияТоваровУслугТовары.Ссылка.СтавкаНСП
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкИНСП.ПустаяСсылка)
			|	КОНЕЦ КАК СтавкаНСП,
			|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
			|	РеализацияТоваровУслугТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
			|	РеализацияТоваровУслугТовары.Количество КАК Количество,
			|	РеализацияТоваровУслугТовары.Цена КАК Цена,
			|	РеализацияТоваровУслугТовары.Сумма КАК Сумма,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА РеализацияТоваровУслугТовары.СуммаНДС
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНДС,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА РеализацияТоваровУслугТовары.СуммаНСП
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНСП,
			|	РеализацияТоваровУслугТовары.Всего КАК Всего,
			|	РеализацияТоваровУслугТовары.СуммаДохода КАК СуммаДохода,
			|	РеализацияТоваровУслугТовары.СуммаСкидки КАК СуммаСкидки,
			|	РеализацияТоваровУслугТовары.СуммаВВалютеРеглУчета КАК СуммаВВалютеРеглУчета,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА РеализацияТоваровУслугТовары.СуммаНДСВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНДСВВалютеРеглУчета,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА РеализацияТоваровУслугТовары.СуммаНСПВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНСПВВалютеРеглУчета,
			|	РеализацияТоваровУслугТовары.ВсегоВВалютеРеглУчета КАК ВсегоВВалютеРеглУчета,
			|	РеализацияТоваровУслугТовары.СуммаДоходаВВалютеРеглУчета КАК СуммаДоходаВВалютеРеглУчета,
			|	РеализацияТоваровУслугТовары.СуммаСкидкиВВалютеРеглУчета КАК СуммаСкидкиВВалютеРеглУчета
			|ИЗ
			|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
			|ГДЕ
			|	РеализацияТоваровУслугТовары.Ссылка В(&МассивДокументов)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	РеализацияТоваровУслугУслуги.Ссылка,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА РеализацияТоваровУслугУслуги.Ссылка.СтавкаНДС
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА РеализацияТоваровУслугУслуги.Ссылка.СтавкаНСПУслуги
			|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкИНСП.ПустаяСсылка)
			|	КОНЕЦ,
			|	РеализацияТоваровУслугУслуги.Номенклатура,
			|	РеализацияТоваровУслугУслуги.Номенклатура.ЕдиницаИзмерения,
			|	РеализацияТоваровУслугУслуги.Количество,
			|	РеализацияТоваровУслугУслуги.Цена,
			|	РеализацияТоваровУслугУслуги.Сумма,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА РеализацияТоваровУслугУслуги.СуммаНДС
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА РеализацияТоваровУслугУслуги.СуммаНСП
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	РеализацияТоваровУслугУслуги.Всего,
			|	РеализацияТоваровУслугУслуги.СуммаДохода,
			|	РеализацияТоваровУслугУслуги.СуммаСкидки,
			|	РеализацияТоваровУслугУслуги.СуммаВВалютеРеглУчета,
			|	ВЫБОР
			|		КОГДА &ПлательщикНДС
			|			ТОГДА РеализацияТоваровУслугУслуги.СуммаНДСВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК СуммаНДСВВалютеРеглУчета,
			|	ВЫБОР
			|		КОГДА &ПлательщикНСП
			|			ТОГДА РеализацияТоваровУслугУслуги.СуммаНСПВВалютеРеглУчета
			|		ИНАЧЕ 0
			|	КОНЕЦ,
			|	РеализацияТоваровУслугУслуги.ВсегоВВалютеРеглУчета,
			|	РеализацияТоваровУслугУслуги.СуммаДоходаВВалютеРеглУчета,
			|	РеализацияТоваровУслугУслуги.СуммаСкидкиВВалютеРеглУчета
			|ИЗ
			|	Документ.РеализацияТоваровУслуг.Услуги КАК РеализацияТоваровУслугУслуги
			|ГДЕ
			|	РеализацияТоваровУслугУслуги.Ссылка В(&МассивДокументов)";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("НачалоПериода", 		НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 		КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 		Организация);
	Запрос.УстановитьПараметр("МассивДокументов", 	МассивДокументов);
	Запрос.УстановитьПараметр("ПлательщикНДС", 		ДанныеУчетнойПолитики.ПлательщикНДС);
	Запрос.УстановитьПараметр("ПлательщикНСП", 		ДанныеУчетнойПолитики.ПлательщикНСП);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаТабличнойЧасти = Товары.Добавить();
		
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка); 
		
		СтрокаТабличнойЧастиДокументы = ДокументыОснования.Найти(Выборка.ДокументОснование, "ДокументОснование");
		
		Если СтрокаТабличнойЧастиДокументы <> Неопределено Тогда
			СтрокаТабличнойЧасти.КлючСвязи = СтрокаТабличнойЧастиДокументы.КлючСвязи;	
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли