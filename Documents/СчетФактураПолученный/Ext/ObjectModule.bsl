﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоДополнительнымРасходам(ДанныеЗаполнения) Экспорт
	
	Организация 		= ДанныеЗаполнения.Организация;
	Контрагент 			= ДанныеЗаполнения.Контрагент;
	СуммаДокумента 		= ДанныеЗаполнения.СуммаДокумента;
	ВалютаДокумента 	= ДанныеЗаполнения.ВалютаДокумента;
	ЗначениеСтавкиНДС 	= ДанныеЗаполнения.ЗначениеСтавкиНДС;
	ЗначениеСтавкиНСП 	= ДанныеЗаполнения.ЗначениеСтавкиНСП;
	БезналичныйРасчет 	= ДанныеЗаполнения.БезналичныйРасчет;
	
	СуммаВключаетНалоги = ДанныеЗаполнения.ДоговорКонтрагента.СуммаВключаетНалоги;
	
	СтрокаТабличнойЧастиТовары = Товары.Добавить();
	СтрокаТабличнойЧастиТовары.ЗачетНДС = ДанныеЗаполнения.ЗачетНДС;
	СтрокаТабличнойЧастиТовары.Количество = 1;
	СтрокаТабличнойЧастиТовары.Цена = ДанныеЗаполнения.СуммаДопРасходов;
	СтрокаТабличнойЧастиТовары.Сумма = ДанныеЗаполнения.СуммаДопРасходов;
	СтрокаТабличнойЧастиТовары.СуммаНДС = ДанныеЗаполнения.СуммаНДС;
	СтрокаТабличнойЧастиТовары.СуммаНСП = ДанныеЗаполнения.СуммаНСП;
	СтрокаТабличнойЧастиТовары.Всего = ?(СуммаВключаетНалоги, ДанныеЗаполнения.СуммаДопРасходов, ДанныеЗаполнения.СуммаДопРасходов + ДанныеЗаполнения.СуммаНДС + ДанныеЗаполнения.СуммаНСП);
	СтрокаТабличнойЧастиТовары.ДокументПоступления = ДанныеЗаполнения;
	
	СтрокаТабличнойЧастиДокументы = ДокументыПоступления.Добавить();
	СтрокаТабличнойЧастиДокументы.ДокументПоступления = ДанныеЗаполнения;
	СтрокаТабличнойЧастиДокументы.Сумма = ДанныеЗаполнения.СуммаДопРасходов;
	СтрокаТабличнойЧастиДокументы.СуммаНДС = ДанныеЗаполнения.СуммаНДС;
	СтрокаТабличнойЧастиДокументы.СуммаНСП = ДанныеЗаполнения.СуммаНСП;
	СтрокаТабличнойЧастиДокументы.Всего = ?(СуммаВключаетНалоги, ДанныеЗаполнения.СуммаДопРасходов, ДанныеЗаполнения.СуммаДопРасходов + ДанныеЗаполнения.СуммаНДС + ДанныеЗаполнения.СуммаНСП);
		
	КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	Организация 		= ДанныеЗаполнения.Организация;
	Контрагент 			= ДанныеЗаполнения.Контрагент;
	СуммаДокумента 		= ДанныеЗаполнения.СуммаДокумента;
	ВалютаДокумента 	= ДанныеЗаполнения.ВалютаДокумента;
	ЗначениеСтавкиНДС 	= ДанныеЗаполнения.ЗначениеСтавкиНДС;
	ЗначениеСтавкиНСП 	= ДанныеЗаполнения.ЗначениеСтавкиНСП;
	БезналичныйРасчет 	= ДанныеЗаполнения.БезналичныйРасчет;
	НДСНеПодтвержден	= ДанныеЗаполнения.НДСНеПодтвержден;
	
	Для Каждого СтрокаТабличнойЧастиТовары Из ДанныеЗаполнения.Товары Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиТовары);
		СтрокаТабличнойЧасти.ДокументПоступления 	= ДанныеЗаполнения;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СтрокаТабличнойЧастиТовары.Номенклатура.ЕдиницаИзмерения;
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧастиУслуги Из ДанныеЗаполнения.Услуги Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиУслуги);
		СтрокаТабличнойЧасти.ДокументПоступления 	= ДанныеЗаполнения;
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧастиОС Из ДанныеЗаполнения.ОС Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиОС);
		СтрокаТабличнойЧасти.Номенклатура 			= СтрокаТабличнойЧастиОС.ОсновноеСредство;
		СтрокаТабличнойЧасти.Цена					= СтрокаТабличнойЧастиОС.Сумма;
		СтрокаТабличнойЧасти.ДокументПоступления 	= ДанныеЗаполнения;
	КонецЦикла;
	
	СтрокаТабличнойЧастиДокументы = ДокументыПоступления.Добавить();
	СтрокаТабличнойЧастиДокументы.ДокументПоступления 	= ДанныеЗаполнения;
	СтрокаТабличнойЧастиДокументы.Сумма 				= ДанныеЗаполнения.Товары.Итог("Сумма") + ДанныеЗаполнения.Услуги.Итог("Сумма") + ДанныеЗаполнения.ОС.Итог("Сумма");
	СтрокаТабличнойЧастиДокументы.СуммаНДС 				= ДанныеЗаполнения.Товары.Итог("СуммаНДС") + ДанныеЗаполнения.Услуги.Итог("СуммаНДС") + ДанныеЗаполнения.ОС.Итог("СуммаНДС");
	СтрокаТабличнойЧастиДокументы.СуммаНСП 				= ДанныеЗаполнения.Товары.Итог("СуммаНСП") + ДанныеЗаполнения.Услуги.Итог("СуммаНСП") + ДанныеЗаполнения.ОС.Итог("СуммаНСП");
	СтрокаТабличнойЧастиДокументы.Всего 				= ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего") + ДанныеЗаполнения.ОС.Итог("Всего");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВозвратуТоваровПоставщику(ДанныеЗаполнения) Экспорт
	
	Организация 		= ДанныеЗаполнения.Организация;
	Контрагент 			= ДанныеЗаполнения.Контрагент;
	СуммаДокумента 		= ДанныеЗаполнения.Товары.Итог("Всего");
	ВалютаДокумента 	= ДанныеЗаполнения.ВалютаДокумента;
	ЗначениеСтавкиНДС 	= ДанныеЗаполнения.ЗначениеСтавкиНДС;
	ЗначениеСтавкиНСП 	= ДанныеЗаполнения.ЗначениеСтавкиНСП;
	БезналичныйРасчет 	= ДанныеЗаполнения.БезналичныйРасчет;
	ВозвратТоваров		= Истина;

	Для Каждого СтрокаТабличнойЧастиТовары Из ДанныеЗаполнения.Товары Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТабличнойЧастиТовары);
		СтрокаТабличнойЧасти.ДокументПоступления 	= ДанныеЗаполнения;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения		= СтрокаТабличнойЧастиТовары.Номенклатура.ЕдиницаИзмерения;
	КонецЦикла;
	
	СтрокаТабличнойЧастиДокументы = ДокументыПоступления.Добавить();
	СтрокаТабличнойЧастиДокументы.ДокументПоступления 	= ДанныеЗаполнения;
	СтрокаТабличнойЧастиДокументы.Сумма 				= ДанныеЗаполнения.Товары.Итог("Сумма");
	СтрокаТабличнойЧастиДокументы.СуммаНДС 				= ДанныеЗаполнения.Товары.Итог("СуммаНДС");
	СтрокаТабличнойЧастиДокументы.СуммаНСП 				= ДанныеЗаполнения.Товары.Итог("СуммаНСП");
	СтрокаТабличнойЧастиДокументы.Всего 				= ДанныеЗаполнения.Товары.Итог("Всего");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ДополнительныеРасходы")] = "ЗаполнитьПоДополнительнымРасходам";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровПоставщику")] = "ЗаполнитьПоВозвратуТоваровПоставщику";

	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.СчетФактураПолученный.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьСчетаФактурыПолученные(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрПриобретенных(ДополнительныеСвойства, Движения, Отказ);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть "Товары" по документам,
// подобранным в табличной части "ДокументыПоступления".
//
// Параметры:
//	ВозвратОтПокупателя - Булево - реквизит "Возврат" данного документа 
//
Процедура ЗаполнитьПоПодобраннымДокументам() Экспорт

	МассивДокументов = ДокументыПоступления.Выгрузить().ВыгрузитьКолонку("ДокументПоступления");
	
	Запрос = Новый Запрос;         
	
	Если ВозвратТоваров Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВозвратТоваровПоставщикуТовары.Ссылка КАК ДокументПоступления,
			|	ВозвратТоваровПоставщикуТовары.Номенклатура,
			|	ВозвратТоваровПоставщикуТовары.Номенклатура.ЕдиницаИзмерения,
			|	ВозвратТоваровПоставщикуТовары.Количество,
			|	ВозвратТоваровПоставщикуТовары.Цена,
			|	ВозвратТоваровПоставщикуТовары.Сумма,
			|	ВозвратТоваровПоставщикуТовары.Всего,
			|	ВозвратТоваровПоставщикуТовары.СуммаНДС,
			|	ВозвратТоваровПоставщикуТовары.СуммаНСП,
			|	ВозвратТоваровПоставщикуТовары.СчетУчета
			|ИЗ
			|	Документ.ВозвратТоваровПоставщику.Товары КАК ВозвратТоваровПоставщикуТовары
			|ГДЕ
			|   ВозвратТоваровПоставщикуТовары.Ссылка В(&МассивДокументов)";
	Иначе
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ПоступлениеТоваровУслугТовары.Ссылка КАК ДокументПоступления,
			|	ПоступлениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
			|	ПоступлениеТоваровУслугТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
			|	ПоступлениеТоваровУслугТовары.Количество КАК Количество,
			|	ПоступлениеТоваровУслугТовары.Цена КАК Цена,
		 	|	ПоступлениеТоваровУслугТовары.Сумма КАК Сумма,
			|	ПоступлениеТоваровУслугТовары.Всего КАК Всего,
			|	ПоступлениеТоваровУслугТовары.Ссылка.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
			|	ПоступлениеТоваровУслугТовары.Ссылка.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП,
			|	ПоступлениеТоваровУслугТовары.СуммаНДС КАК СуммаНДС,
			|	ПоступлениеТоваровУслугТовары.СуммаНСП КАК СуммаНСП,
			|	ПоступлениеТоваровУслугТовары.СчетУчета КАК СчетУчета,
			|	ПоступлениеТоваровУслугТовары.КоэффициентДопЕдиницы КАК КоэффициентДопЕдиницы,
			|	ПоступлениеТоваровУслугТовары.КоличествоДопЕдиницы КАК КоличествоДопЕдиницы,
			|	ПоступлениеТоваровУслугТовары.ЗачетНДС КАК ЗачетНДС
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
			|ГДЕ
			|   ПоступлениеТоваровУслугТовары.Ссылка В(&МассивДокументов)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ПоступлениеТоваровУслугУслуги.Ссылка,
			|	ПоступлениеТоваровУслугУслуги.Номенклатура,
			|	НЕОПРЕДЕЛЕНО,
			|	ПоступлениеТоваровУслугУслуги.Количество,
			|	ПоступлениеТоваровУслугУслуги.Цена,
			|	ПоступлениеТоваровУслугУслуги.Сумма,
			|	ПоступлениеТоваровУслугУслуги.Всего,
			|	ПоступлениеТоваровУслугУслуги.Ссылка.ЗначениеСтавкиНДС,
			|	ПоступлениеТоваровУслугУслуги.Ссылка.ЗначениеСтавкиНСП,
			|	ПоступлениеТоваровУслугУслуги.СуммаНДС,
			|	ПоступлениеТоваровУслугУслуги.СуммаНСП,
			|	НЕОПРЕДЕЛЕНО,
			|	НЕОПРЕДЕЛЕНО,
			|   НЕОПРЕДЕЛЕНО,
			|	ПоступлениеТоваровУслугУслуги.ЗачетНДС
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг.Услуги КАК ПоступлениеТоваровУслугУслуги
			|ГДЕ
			|   ПоступлениеТоваровУслугУслуги.Ссылка В(&МассивДокументов)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ПоступлениеТоваровУслугОС.Ссылка,
			|	ПоступлениеТоваровУслугОС.ОсновноеСредство,
			|	НЕОПРЕДЕЛЕНО,
			|	1,
			|	ПоступлениеТоваровУслугОС.Сумма,
			|	ПоступлениеТоваровУслугОС.Сумма,
			|	ПоступлениеТоваровУслугОС.Всего,
			|	ПоступлениеТоваровУслугОС.Ссылка.ЗначениеСтавкиНДС,
			|	ПоступлениеТоваровУслугОС.Ссылка.ЗначениеСтавкиНСП,
			|	ПоступлениеТоваровУслугОС.СуммаНДС,
			|	ПоступлениеТоваровУслугОС.СуммаНСП,
			|	ПоступлениеТоваровУслугОС.СчетУчета,
			|	НЕОПРЕДЕЛЕНО,
			|   НЕОПРЕДЕЛЕНО,
			|   НЕОПРЕДЕЛЕНО
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг.ОС КАК ПоступлениеТоваровУслугОС
			|ГДЕ
			|   ПоступлениеТоваровУслугОС.Ссылка В(&МассивДокументов)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДополнительныеРасходы.Ссылка,
			|	НЕОПРЕДЕЛЕНО,
			|	НЕОПРЕДЕЛЕНО,
			|	1,
			|	ДополнительныеРасходы.СуммаДопРасходов,
			|	ДополнительныеРасходы.СуммаДопРасходов,
			|	выбор когда ДополнительныеРасходы.ДоговорКонтрагента.СуммаВключаетНалоги тогда ДополнительныеРасходы.СуммаДопРасходов иначе  ДополнительныеРасходы.СуммаДопРасходов+ ДополнительныеРасходы.СуммаНДС + ДополнительныеРасходы.СуммаНСП конец,
			|	НЕОПРЕДЕЛЕНО,
			|   НЕОПРЕДЕЛЕНО,
			|	ДополнительныеРасходы.СуммаНДС,
			|	ДополнительныеРасходы.СуммаНСП,
			|	НЕОПРЕДЕЛЕНО,
			|	НЕОПРЕДЕЛЕНО,
			|	НЕОПРЕДЕЛЕНО,
			|	НЕОПРЕДЕЛЕНО
			|ИЗ
			|	Документ.ДополнительныеРасходы КАК ДополнительныеРасходы
			|ГДЕ
			|   ДополнительныеРасходы.Ссылка В(&МассивДокументов)";
	КонецЕсли;
			
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Товары.Загрузить(Запрос.Выполнить().Выгрузить()); 

КонецПроцедуры

// Процедура заполнения табличной части "ДокументыПоступления".
//
Процедура ЗаполнитьДокументыПоступления() Экспорт

	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Отбор документов по периоду, контрагенту и организации,
	// а также отсечение документов уже использованных в счет фактурах полученных.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровОбороты.Регистратор КАК ДокументПоступления,
		|	ПоступлениеТоваровОбороты.СуммаОборот КАК Сумма,
		|	ПоступлениеТоваровОбороты.СуммаНДСОборот КАК СуммаНДС,
		|	ПоступлениеТоваровОбороты.СуммаНСПОборот КАК СуммаНСП,
		|	ПоступлениеТоваровОбороты.БезналичныйРасчет КАК БезналичныйРасчет,
		|	ПоступлениеТоваровОбороты.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
		|	ПоступлениеТоваровОбороты.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП,
		|	ПоступлениеТоваровОбороты.СуммаОборот + ПоступлениеТоваровОбороты.СуммаНДСОборот + ПоступлениеТоваровОбороты.СуммаНСПОборот КАК Всего
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
		|ИЗ
		|	РегистрНакопления.ПоступлениеТоваров.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			Регистратор,
		|			Организация = &Организация
		|				И Контрагент = &Контрагент) КАК ПоступлениеТоваровОбороты
		|ГДЕ
		|	НЕ(ПоступлениеТоваровОбороты.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков
		|				И ПоступлениеТоваровОбороты.Регистратор В
		|					(ВЫБРАТЬ
		|						СчетаФактурыПолученные.Документ
		|					ИЗ
		|						РегистрСведений.СчетаФактурыПолученные КАК СчетаФактурыПолученные))";
	Запрос.УстановитьПараметр("ДатаНачала", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("Контрагент", 	Контрагент);
	Запрос.Выполнить();

	// Подбор документов "Возврат товаров поставщику"
	Если ВозвратТоваров Тогда
		// Получение документов с отбором по значениям ставок и значению безналичного расчета.
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 		
			"ВЫБРАТЬ
			|	ВременнаяТаблицаДокументы.ДокументПоступления,
			|	ВременнаяТаблицаДокументы.Сумма,
			|	ВременнаяТаблицаДокументы.СуммаНДС,
			|	ВременнаяТаблицаДокументы.СуммаНСП,
			|	ВременнаяТаблицаДокументы.Всего
			|ИЗ
			|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
			|ГДЕ
			|	ВременнаяТаблицаДокументы.БезналичныйРасчет = &БезналичныйРасчет
			|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС = &ЗначениеСтавкиНДС
			|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП = &ЗначениеСтавкиНСП
			|	И ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ВозвратТоваровПоставщику";
		Запрос.УстановитьПараметр("БезналичныйРасчет", БезналичныйРасчет);
		Запрос.УстановитьПараметр("ЗначениеСтавкиНДС", ЗначениеСтавкиНДС);
		Запрос.УстановитьПараметр("ЗначениеСтавкиНСП", ЗначениеСтавкиНСП);
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		                        
		Если ТаблицаДокументов.Количество() > 0 Тогда
			ДокументыПоступления.Загрузить(ТаблицаДокументов);
			СуммаДокумента = ТаблицаДокументов.Итог("Сумма");
		Иначе
			// Получение первого попавшегося документа, без отбора по значениям ставок и значению безналичного расчета.
			// Также из полученного документа происходит выбор значений ставок и безналичного расчета.
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
			Запрос.Текст = 		
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ВременнаяТаблицаДокументы.БезналичныйРасчет,
				|	ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС,
				|	ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП
				|ИЗ
				|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
				|ГДЕ
				|	ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ВозвратТоваровПоставщику";
			ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
			
			Если ТаблицаДокументов.Количество() > 0 Тогда
				ДанныеДокумента = ТаблицаДокументов[0];
				
				// Установка новых значений ставок и безналичного расчета.
				БезналичныйРасчет = ДанныеДокумента.БезналичныйРасчет;
				ЗначениеСтавкиНДС = ДанныеДокумента.ЗначениеСтавкиНДС;
				ЗначениеСтавкиНСП = ДанныеДокумента.ЗначениеСтавкиНСП;
				
				// 1. Получение документов с отбором по новым значения ставок и значению безналичного расчета.
				// 2. Получение всех оставшихся документов, кроме полученных в первом пакете для
				// проверки наличия таковых и показа пользователю соответствующего сообщения.
				Запрос = Новый Запрос;
				Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
				Запрос.Текст = 		
					"ВЫБРАТЬ
					|	ВременнаяТаблицаДокументы.ДокументПоступления КАК ДокументПоступления,
					|	ВременнаяТаблицаДокументы.Сумма КАК Сумма,
					|	ВременнаяТаблицаДокументы.СуммаНДС КАК СуммаНДС,
					|	ВременнаяТаблицаДокументы.СуммаНСП КАК СуммаНСП,
					|	ВременнаяТаблицаДокументы.Всего КАК Всего
					|ИЗ
					|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
					|ГДЕ
					|	ВременнаяТаблицаДокументы.БезналичныйРасчет = &БезналичныйРасчет
					|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС = &ЗначениеСтавкиНДС
					|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП = &ЗначениеСтавкиНСП
					|	И ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ВозвратТоваровПоставщику
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВременнаяТаблицаДокументы.ДокументПоступления
					|ИЗ
					|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
					|ГДЕ
					|	НЕ(ВременнаяТаблицаДокументы.БезналичныйРасчет = &БезналичныйРасчет
					|				И ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС = &ЗначениеСтавкиНДС
					|				И ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП = &ЗначениеСтавкиНСП)
					|	И ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ВозвратТоваровПоставщику";
				Запрос.УстановитьПараметр("БезналичныйРасчет", БезналичныйРасчет);
				Запрос.УстановитьПараметр("ЗначениеСтавкиНДС", ЗначениеСтавкиНДС);
				Запрос.УстановитьПараметр("ЗначениеСтавкиНСП", ЗначениеСтавкиНСП);
				РезультатЗапроса = Запрос.ВыполнитьПакет();
				
				ТаблицаДокументов = РезультатЗапроса[0].Выгрузить();
				
				ДокументыПоступления.Загрузить(ТаблицаДокументов);
				СуммаДокумента = ТаблицаДокументов.Итог("Сумма");
				
				Если НЕ РезультатЗапроса[1].Пустой() Тогда
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Для контрагента %1 обнаружены документы возврата с другими значениями ставок.'"), Контрагент);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
				КонецЕсли;		
			КонецЕсли				
		КонецЕсли;
		
		
	// Подбор документов "Поступление товаров услуг" и "Дополнительные расходы"
	Иначе
		// Получение документов с отбором по значениям ставок, значению безналичного расчета,
		// и наличия пустых (или "ДПБУ") значений серии бланка счет фактуры.
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 		
			"ВЫБРАТЬ
			|	ВременнаяТаблицаДокументы.ДокументПоступления КАК ДокументПоступления,
			|	ВременнаяТаблицаДокументы.Сумма КАК Сумма,
			|	ВременнаяТаблицаДокументы.СуммаНДС КАК СуммаНДС,
			|	ВременнаяТаблицаДокументы.СуммаНСП КАК СуммаНСП,
			|	ВременнаяТаблицаДокументы.Всего КАК Всего
			|ИЗ
			|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
			|		ПО ВременнаяТаблицаДокументы.ДокументПоступления = СведенияОПоступлении.ДокументСсылка
			|ГДЕ
			|	ВременнаяТаблицаДокументы.БезналичныйРасчет = &БезналичныйРасчет
			|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС = &ЗначениеСтавкиНДС
			|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП = &ЗначениеСтавкиНСП
			|	И (ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ПоступлениеТоваровУслуг
			|		ИЛИ ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ДополнительныеРасходы)
			|	И (СведенияОПоступлении.СерияБланкаСФ = """"
			|		ИЛИ СведенияОПоступлении.СерияБланкаСФ = ""ДПБУ"")";
		Запрос.УстановитьПараметр("БезналичныйРасчет", 	БезналичныйРасчет);
		Запрос.УстановитьПараметр("ЗначениеСтавкиНДС", 	ЗначениеСтавкиНДС);
		Запрос.УстановитьПараметр("ЗначениеСтавкиНСП", 	ЗначениеСтавкиНСП);
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		
		Если ТаблицаДокументов.Количество() > 0 Тогда
			ДокументыПоступления.Загрузить(ТаблицаДокументов);
			СуммаДокумента = ТаблицаДокументов.Итог("Сумма");
		Иначе
			// Получение первого попавшегося документа с отбором только по пустым (или "ДПБУ") значениям серии бланка счет фактуры.
			// Также из полученного документа происходит выбор значений ставок и безналичного расчета.
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
			Запрос.Текст = 		
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ВременнаяТаблицаДокументы.БезналичныйРасчет,
				|	ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС,
				|	ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП
				|ИЗ
				|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
				|		ПО ВременнаяТаблицаДокументы.ДокументПоступления = СведенияОПоступлении.ДокументСсылка
				|ГДЕ
				|	(ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ПоступлениеТоваровУслуг
				|		ИЛИ ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ДополнительныеРасходы)
				|	И (СведенияОПоступлении.СерияБланкаСФ = """"
				|		ИЛИ СведенияОПоступлении.СерияБланкаСФ = ""ДПБУ"")";
			ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
			
			Если ТаблицаДокументов.Количество() > 0 Тогда
				ДанныеДокумента 	= ТаблицаДокументов[0];
				
				// Установка новых значений ставок и безналичного расчета.
				БезналичныйРасчет 	= ДанныеДокумента.БезналичныйРасчет;
				ЗначениеСтавкиНДС 	= ДанныеДокумента.ЗначениеСтавкиНДС;
				ЗначениеСтавкиНСП 	= ДанныеДокумента.ЗначениеСтавкиНСП;
				
				// 1. Получение документов с отбором по новым значениям ставок, значению безналичного расчета
				// и наличия пустых (или "ДПБУ") значений серии бланка счет фактуры.
				// 2. Получение всех оставшихся документов, кроме полученных в первом пакете для
				// проверки наличия таковых и показа пользователю соответствующего сообщения.
				Запрос = Новый Запрос;
				Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
				Запрос.Текст = 		
					"ВЫБРАТЬ
					|	ВременнаяТаблицаДокументы.ДокументПоступления КАК ДокументПоступления,
					|	ВременнаяТаблицаДокументы.Сумма КАК Сумма,
					|	ВременнаяТаблицаДокументы.СуммаНДС КАК СуммаНДС,
					|	ВременнаяТаблицаДокументы.СуммаНСП КАК СуммаНСП,
					|	ВременнаяТаблицаДокументы.Всего КАК Всего
					|ИЗ
					|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
					|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
					|		ПО ВременнаяТаблицаДокументы.ДокументПоступления = СведенияОПоступлении.ДокументСсылка
					|ГДЕ
					|	ВременнаяТаблицаДокументы.БезналичныйРасчет = &БезналичныйРасчет
					|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС = &ЗначениеСтавкиНДС
					|	И ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП = &ЗначениеСтавкиНСП
					|	И (ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ПоступлениеТоваровУслуг
					|		ИЛИ ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ДополнительныеРасходы)
					|	И (СведенияОПоступлении.СерияБланкаСФ = """"
					|		ИЛИ СведенияОПоступлении.СерияБланкаСФ = ""ДПБУ"")
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВременнаяТаблицаДокументы.ДокументПоступления КАК ДокументПоступления
					|ИЗ
					|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
					|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
					|		ПО ВременнаяТаблицаДокументы.ДокументПоступления = СведенияОПоступлении.ДокументСсылка
					|ГДЕ
					|	НЕ(ВременнаяТаблицаДокументы.БезналичныйРасчет = &БезналичныйРасчет
					|				И ВременнаяТаблицаДокументы.ЗначениеСтавкиНДС = &ЗначениеСтавкиНДС
					|				И ВременнаяТаблицаДокументы.ЗначениеСтавкиНСП = &ЗначениеСтавкиНСП)
					|	И (ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ПоступлениеТоваровУслуг
					|		ИЛИ ВременнаяТаблицаДокументы.ДокументПоступления ССЫЛКА Документ.ДополнительныеРасходы)
					|	И (СведенияОПоступлении.СерияБланкаСФ = """"
					|		ИЛИ СведенияОПоступлении.СерияБланкаСФ = ""ДПБУ"")";
				Запрос.УстановитьПараметр("БезналичныйРасчет", 	БезналичныйРасчет);
				Запрос.УстановитьПараметр("ЗначениеСтавкиНДС", 	ЗначениеСтавкиНДС);
				Запрос.УстановитьПараметр("ЗначениеСтавкиНСП", 	ЗначениеСтавкиНСП);
				РезультатЗапроса = Запрос.ВыполнитьПакет();
				
				ТаблицаДокументов = РезультатЗапроса[0].Выгрузить();
				
				ДокументыПоступления.Загрузить(ТаблицаДокументов);
				СуммаДокумента = ТаблицаДокументов.Итог("Сумма");
				
				Если НЕ РезультатЗапроса[1].Пустой() Тогда
					ТекстСообщения = СтрШаблон(НСтр("ru = 'Для контрагента %1 обнаружены документы постулпнеия с другими значениями ставок.'"), Контрагент);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
				КонецЕсли;	
			КонецЕсли				
		КонецЕсли;			
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли