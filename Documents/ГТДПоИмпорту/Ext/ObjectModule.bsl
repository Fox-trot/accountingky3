﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(ДанныеЗаполнения) Экспорт
	Организация = ДанныеЗаполнения.Организация;
	КонтрагентПоПоступлению = ДанныеЗаполнения.Контрагент;
	Склад = ДанныеЗаполнения.Склад;
	
	// Если в док. поступления стоит галочка "ИспользоватьДопЕдиницы" то необходимо 
	// установить распределение акциза "ПоДопЕдиницам" в первой строке ТЧ "Разделы".
	Если ДанныеЗаполнения.ИспользоватьДопЕдиницы Тогда
		СтрокаТабличнойЧасти = Разделы.Добавить();
		СтрокаТабличнойЧасти.РаспределениеАкциза = Перечисления.СпособыРаспределенияДопРасходов.ПоДопЕдиницам;
	КонецЕсли;
	
	Для каждого СтрокаПоступления Из ДанныеЗаполнения.Товары Цикл
		СтрокаТабличнойЧасти = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаПоступления);
		СтрокаТабличнойЧасти.ДокументПоступления = ДанныеЗаполнения.Ссылка;
		СтрокаТабличнойЧасти.Вес 				 = 0;
		СтрокаТабличнойЧасти.КлючСвязи 			 = 1;	
	КонецЦикла;
	
	Для каждого СтрокаПоступления Из ДанныеЗаполнения.ОС Цикл
		СтрокаТабличнойЧасти = ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаПоступления);
		СтрокаТабличнойЧасти.ДокументПоступления = ДанныеЗаполнения.Ссылка;
		СтрокаТабличнойЧасти.КлючСвязи 			 = 1;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваровУслуг";

	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ГТДПоИмпорту.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОНДСНаИмпорт(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьОборотыГТД(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрВвезенных(ДополнительныеСвойства, Движения, Отказ);
	
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
	
	ВыполнитьПредварительныйКонтроль(Отказ);
		
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПредварительныйКонтроль(Отказ)

	Запрос = Новый Запрос();
	Запрос.Текст =
		// 1. Данные из ТЧ "Разделы".
		// 2. Данные из ТЧ "Товары".
		// 3. Данные из ТЧ "ОС".
		// 4. Данные из ТЧ "Допрасходы".
		// 5. Объединение данных о значениях реквизитов "КлючСвязи" из ТЧ "Товары" и "ОС".
		// 6. Левое соединение ТЧ "Разделы" с данными 5 пункта по ключу связи.
		// 7. Получение данных из 6 пункта с условием: ЕСТЬ NULL.
		// 8. Внутреннее соединение данных 2 пункта с самим собой по уникальному сочетанию, для выявления дублей строк.
		// 9. Внутреннее соединение данных 3 пункта с самим собой по уникальному сочетанию, для выявления дублей строк.
		// 10. Внутреннее соединение данных 4 пункта с самим собой по уникальному сочетанию, для выявления дублей строк.
		"ВЫБРАТЬ
		|	ТаблицаРазделы.КлючСвязи
		|ПОМЕСТИТЬ ВременнаяТаблицаРазделы
		|ИЗ
		|	&ТаблицаРазделы КАК ТаблицаРазделы
		|;
		|
		|///////////////////////////////////////////
		|ВЫБРАТЬ
		|   ТаблицаТовары.НомерСтроки,
		|   ТаблицаТовары.Номенклатура,
		|   ТаблицаТовары.ДокументПоступления,
		|	ТаблицаТовары.КлючСвязи
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|///////////////////////////////////////////
		|ВЫБРАТЬ
		|   ТаблицаОС.НомерСтроки,
		|   ТаблицаОС.ОсновноеСредство,
		|   ТаблицаОС.ДокументПоступления,
		|	ТаблицаОС.КлючСвязи
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	&ТаблицаОС КАК ТаблицаОС
		|;
		|
		|///////////////////////////////////////////
		|ВЫБРАТЬ
		|   ТаблицаДопрасходы.НомерСтроки,
		|   ТаблицаДопрасходы.ДокументДопрасходов,
		|	ТаблицаДопрасходы.КлючСвязи
		|ПОМЕСТИТЬ ВременнаяТаблицаДопрасходы
		|ИЗ
		|	&ТаблицаДопрасходы КАК ТаблицаДопрасходы
		|;
		|
		|///////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаТовары.КлючСвязи КАК КлючСвязи
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары_ОС
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ТаблицаТовары
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаОС.КлючСвязи
		|ИЗ
		|	ВременнаяТаблицаОС КАК ТаблицаОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаРазделы.КлючСвязи КАК КлючСвязиРазделы,
		|	ВременнаяТаблицаТовары_ОС.КлючСвязи КАК КлючСвязиТоварыОС
		|ПОМЕСТИТЬ ВременнаяТаблицаКлючиСвязи_Товары_ОС
		|ИЗ
		|	ВременнаяТаблицаРазделы КАК ВременнаяТаблицаРазделы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары_ОС КАК ВременнаяТаблицаТовары_ОС
		|		ПО ВременнаяТаблицаРазделы.КлючСвязи = ВременнаяТаблицаТовары_ОС.КлючСвязи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаКлючиСвязи_Товары_ОС.КлючСвязиРазделы
		|ИЗ
		|	ВременнаяТаблицаКлючиСвязи_Товары_ОС КАК ВременнаяТаблицаКлючиСвязи_Товары_ОС
		|ГДЕ
		|	ВременнаяТаблицаКлючиСвязи_Товары_ОС.КлючСвязиТоварыОС ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаТовары1.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаТовары1.Номенклатура КАК Номенклатура,
		|   ТаблицаТовары1.ДокументПоступления КАК Документ
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ТаблицаТовары1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ТаблицаТовары2
		|		ПО ТаблицаТовары1.НомерСтроки <> ТаблицаТовары2.НомерСтроки
		|			И ТаблицаТовары1.Номенклатура = ТаблицаТовары2.Номенклатура
		|			И ТаблицаТовары1.ДокументПоступления = ТаблицаТовары2.ДокументПоступления
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаТовары1.Номенклатура,
		|	ТаблицаТовары1.ДокументПоступления
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаОС1.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаОС1.ОсновноеСредство КАК ОсновноеСредство,
		|   ТаблицаОС1.ДокументПоступления КАК Документ
		|ИЗ
		|	ВременнаяТаблицаОС КАК ТаблицаОС1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ТаблицаОС2
		|		ПО ТаблицаОС1.НомерСтроки <> ТаблицаОС2.НомерСтроки
		|			И ТаблицаОС1.ОсновноеСредство = ТаблицаОС2.ОсновноеСредство
		|			И ТаблицаОС1.ДокументПоступления = ТаблицаОС2.ДокументПоступления
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаОС1.ОсновноеСредство,
		|	ТаблицаОС1.ДокументПоступления
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаДопрасходы1.НомерСтроки) КАК НомерСтроки,
		|   ТаблицаДопрасходы1.ДокументДопрасходов КАК Документ
		|ИЗ
		|	ВременнаяТаблицаДопрасходы КАК ТаблицаДопрасходы1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДопрасходы КАК ТаблицаДопрасходы2
		|		ПО ТаблицаДопрасходы1.НомерСтроки <> ТаблицаДопрасходы2.НомерСтроки
		|			И ТаблицаДопрасходы1.ДокументДопрасходов = ТаблицаДопрасходы2.ДокументДопрасходов
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДопрасходы1.ДокументДопрасходов
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ТаблицаРазделы", Разделы);
	Запрос.УстановитьПараметр("ТаблицаТовары", Товары);
	Запрос.УстановитьПараметр("ТаблицаОС", ОС);
	Запрос.УстановитьПараметр("ТаблицаДопрасходы", Допрасходы);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Незаполненные ТЧ "Товары", "ОС", "Допрасходы" по разделам.
	Если НЕ МассивРезультатов[6].Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В документе есть разделы с пустыми закладками ""Товары"" и ""ОС"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ)	
	КонецЕсли;
	
	// Дубли строк.
	Если НЕ МассивРезультатов[7].Пустой() Тогда
		ВыборкаТовары = МассивРезультатов[7].Выбрать();
		Пока ВыборкаТовары.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Номенклатура и документ поступления указываются повторно в строке %1 списка ""Товары"".'"), 
							ВыборкаТовары.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Товары",
				ВыборкаТовары.НомерСтроки,
				,
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ МассивРезультатов[8].Пустой() Тогда
		ВыборкаОС = МассивРезультатов[8].Выбрать();
		Пока ВыборкаОС.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство и документ поступления указываются повторно в строке %1 списка ""ОС"".'"), 
							ВыборкаОС.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ОС",
				ВыборкаОС.НомерСтроки,
				,
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ МассивРезультатов[9].Пустой() Тогда
		ВыборкаОС = МассивРезультатов[9].Выбрать();
		Пока ВыборкаОС.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Документ допрасходов указываются повторно в строке %1 списка ""Допрасходы"".'"), 
							ВыборкаОС.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Допрасходы",
				ВыборкаОС.НомерСтроки,
				"ДокументДопрасходов",
				Отказ);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ПолноеРаспределениеПоДокументу() Экспорт
	
	РаспределитьСуммуАкциза();
	РаспределитьСуммуСопровождения();
	РаспределитьСуммуДопрасходов();
	ПересчетСборовПошлинНалогов();
	РаспределитьПошлину();
	РаспределитьСуммуНДС();
	РаспределитьСуммуБазыНДС();

	Если ВводСуммГТДВручную Тогда
		РаспределитьТаможенныйСбор();
	КонецЕсли;	
КонецПроцедуры // РассчитатьИРаспределить()

Процедура РаспределитьСуммуАкциза()
	
	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		ИмяКолонкиИсточника = "";
		
		Если СтрокаТабличнойЧасти.РаспределениеАкциза = Перечисления.СпособыРаспределенияДопРасходов.ПоКоличеству Тогда
			ИмяКолонкиИсточника = "Количество";
			
		ИначеЕсли СтрокаТабличнойЧасти.РаспределениеАкциза = Перечисления.СпособыРаспределенияДопРасходов.ПоДопЕдиницам Тогда
			ИмяКолонкиИсточника = "КоличествоДопЕдиницы";	
			
		ИначеЕсли СтрокаТабличнойЧасти.РаспределениеАкциза = Перечисления.СпособыРаспределенияДопРасходов.ПоСумме Тогда
			ИмяКолонкиИсточника = "Сумма";
		КонецЕсли;
		
		Если ИмяКолонкиИсточника <> "" Тогда
			РаспределитьСумму(СтрокаТабличнойЧасти, "РаспределитьСуммуАкциза", ИмяКолонкиИсточника, "Акциз");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // РаспределитьСуммуАкциза()

Процедура РаспределитьСуммуСопровождения()
	
	Если РаспределениеСопровождения = Перечисления.СпособРаспределения.ПоВесу Тогда
		МассивКоэффициентов = Товары.ВыгрузитьКолонку("Вес");
		МассивОС = ОС.ВыгрузитьКолонку("Вес");
		
	ИначеЕсли РаспределениеСопровождения = Перечисления.СпособРаспределения.ПоКоличеству Тогда
		МассивКоэффициентов = Товары.ВыгрузитьКолонку("Количество");
		
	ИначеЕсли РаспределениеСопровождения = Перечисления.СпособРаспределения.ПоСумме Тогда
		МассивКоэффициентов = Товары.ВыгрузитьКолонку("Сумма");
		МассивОС = ОС.ВыгрузитьКолонку("Сумма");
	Иначе
		Возврат;
	КонецЕсли;

	Если РаспределениеСопровождения = Перечисления.СпособРаспределения.ПоКоличеству Тогда
		Для Каждого СтрокаТабличнойЧасти ИЗ ОС Цикл
			МассивКоэффициентов.Добавить(1);	
		КонецЦикла;
	Иначе
		Для Каждого СтрокаМассива ИЗ МассивОС Цикл
			МассивКоэффициентов.Добавить(СтрокаМассива);	
		КонецЦикла; 
	КонецЕсли;	
	
	МассивСуммРаспределения = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(Сопровождение, МассивКоэффициентов, 2);
	
	ИндексМассива = 0;
	
	// Заполнение реквизитов ТЧ "Товары" из массива распределенных сумм.
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
		Если МассивСуммРаспределения = Неопределено Тогда
			СтрокаТабличнойЧасти.Сопровождение = 0;
		Иначе
			СтрокаТабличнойЧасти.Сопровождение = МассивСуммРаспределения[ИндексМассива];
		КонецЕсли;	
			
		ИндексМассива = ИндексМассива + 1;	
	КонецЦикла;
	
	// Заполнение реквизитов ТЧ "ОС" из массива распределенных сумм.
	Для Каждого СтрокаТабличнойЧасти Из ОС Цикл
		Если МассивСуммРаспределения = Неопределено Тогда
			СтрокаТабличнойЧасти.Сопровождение = 0;
		Иначе
			СтрокаТабличнойЧасти.Сопровождение = МассивСуммРаспределения[ИндексМассива];
		КонецЕсли;
		
		ИндексМассива = ИндексМассива + 1;	
	КонецЦикла;
КонецПроцедуры // РаспределитьСуммуСопровождения()

Процедура РаспределитьСуммуДопрасходов()
	
	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		РаспределитьСумму(СтрокаТабличнойЧасти, "РаспределитьСуммуДопрасходов", "Сумма", "ДопРасходы");
	КонецЦикла;
	
КонецПроцедуры // РаспределитьСуммуДопрасходов()

Процедура РаспределитьПошлину()
	
	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		ИмяКолонкиИсточника = "";
		
		Если РаспределениеПошлины = Перечисления.СпособыРаспределенияПошлины.ПоКоличеству Тогда
			ИмяКолонкиИсточника = "Количество";
			
		ИначеЕсли РаспределениеПошлины = Перечисления.СпособыРаспределенияПошлины.ПоСумме Тогда
			ИмяКолонкиИсточника = "Сумма";
		КонецЕсли;
		
		Если ИмяКолонкиИсточника <> "" Тогда
			РаспределитьСумму(СтрокаТабличнойЧасти, "РаспределитьПошлину", ИмяКолонкиИсточника, "Пошлина");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // РаспределитьПошлину()

Процедура РаспределитьСуммуНДС()

	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		РаспределитьСумму(СтрокаТабличнойЧасти, "РаспределитьСуммуНДС", "Сумма", "СуммаНДС");
	КонецЦикла;	

КонецПроцедуры

Процедура РаспределитьСуммуБазыНДС() Экспорт

	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		РаспределитьСумму(СтрокаТабличнойЧасти, "РаспределитьСуммуБазыНДС", "Сумма", "СуммаБазыНДС");
	КонецЦикла;	

КонецПроцедуры

Процедура РаспределитьТаможенныйСбор()

	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		РаспределитьСумму(СтрокаТабличнойЧасти, "РаспределитьТаможенныйСбор", "Сумма", "ТаможенныйСбор");
	КонецЦикла;

КонецПроцедуры

// Процедура для распределения сумм.
//
// Параметры:
//	СтрокаТабличнойЧасти - ДокументТабличнаяЧастьСтрока - строка табличной части "Разделы".
//	ИмяРаспределения - Строка - наименование распределения.
//	ИмяКолонкиИсточника - Строка - наименование реквизита табличных частей "Товары" и "ОС".
//	ИмяКолонкиПриемника - Строка - наименование реквизита табличных частей "Товары" и "ОС".
Процедура РаспределитьСумму(СтрокаТабличнойЧасти, ИмяРаспределения, ИмяКолонкиИсточника, ИмяКолонкиПриемника)
	
	МассивКоэффициентов = Новый Массив();
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
	
	// Отбор строк ТЧ "Товары" и заполнение массива коэффициентов.
	МассивСтрокТоваров = Товары.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого СтрокаМассива Из МассивСтрокТоваров Цикл
		МассивКоэффициентов.Добавить(СтрокаМассива[ИмяКолонкиИсточника]);		
	КонецЦикла;
	
	// Отбор строк ТЧ "ОС" и заполнение массива коэффициентов.
	МассивСтрокОС = ОС.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого СтрокаМассива Из МассивСтрокОС Цикл
		Если ИмяКолонкиИсточника = "Количество" ИЛИ ИмяКолонкиИсточника = "КоличествоДопЕдиницы" Тогда
			МассивКоэффициентов.Добавить(1);
		Иначе	
			МассивКоэффициентов.Добавить(СтрокаМассива[ИмяКолонкиИсточника]);
		КонецЕсли;	
	КонецЦикла;
	
	Если МассивКоэффициентов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяРаспределения = "РаспределитьСуммуАкциза" Тогда
		Сумма = СтрокаТабличнойЧасти.Акциз;	
	ИначеЕсли ИмяРаспределения = "РаспределитьСуммуДопрасходов" Тогда
		Сумма = СтрокаТабличнойЧасти.ДопРасходы;
	ИначеЕсли ИмяРаспределения = "РаспределитьПошлину" Тогда
		Сумма = СтрокаТабличнойЧасти.Пошлина;
	ИначеЕсли ИмяРаспределения = "РаспределитьСуммуНДС" Тогда
		Сумма = СтрокаТабличнойЧасти.НДС;
	ИначеЕсли ИмяРаспределения = "РаспределитьСуммуБазыНДС" Тогда
		Сумма = СтрокаТабличнойЧасти.БазаНДС;
	ИначеЕсли ИмяРаспределения = "РаспределитьТаможенныйСбор" Тогда
		Сумма = СтрокаТабличнойЧасти.ТаможенныйСбор;
	КонецЕсли;
	
	МассивСуммРаспределения = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(Сумма, МассивКоэффициентов, 2);
	
	ИндексМассива = 0;
	
	// Заполнение реквизитов ТЧ "Товары" из массива распределенных сумм.
	Для Каждого СтрокаМассива Из МассивСтрокТоваров Цикл
		Если МассивСуммРаспределения = Неопределено Тогда
			СтрокаМассива[ИмяКолонкиПриемника] = 0;
		Иначе	
			СтрокаМассива[ИмяКолонкиПриемника] = МассивСуммРаспределения[ИндексМассива];
		КонецЕсли;	
			
		ИндексМассива = ИндексМассива + 1;	
	КонецЦикла;
	
	// Заполнение реквизитов ТЧ "ОС" из массива распределенных сумм.
	Для Каждого СтрокаМассива Из МассивСтрокОС Цикл
		Если МассивСуммРаспределения = Неопределено Тогда
			СтрокаМассива[ИмяКолонкиПриемника] = 0;
		Иначе
			СтрокаМассива[ИмяКолонкиПриемника] = МассивСуммРаспределения[ИндексМассива];
		КонецЕсли;
		
		ИндексМассива = ИндексМассива + 1;	
	КонецЦикла;
КонецПроцедуры

Процедура ПересчетСборовПошлинНалогов()

	Для Каждого СтрокаТабличнойЧасти Из Разделы Цикл
		
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
		
		МассивСтрокТоваров = Товары.НайтиСтроки(СтруктураОтбора);
		
		ФактурнаяСтоимостьИтог = 0;
		ТаможеннаяСтоимостьИтог = 0;
		ДопрасходыИтог = 0;
		АкцизИтог = 0;
		
		Для Каждого СтрокаМассива Из МассивСтрокТоваров Цикл
			ФактурнаяСтоимость 				 = Окр(СтрокаМассива.Сумма * Курс / Кратность, 2);  
			ТаможеннаяСтоимость				 = ФактурнаяСтоимость + СтрокаМассива.ДопРасходы + СтрокаМассива.Акциз;	
			СтрокаМассива.ТаможенныйСбор	 = Окр(ТаможеннаяСтоимость * СтрокаТабличнойЧасти.СтавкаСбора / 100, 2);
			
			АкцизИтог = АкцизИтог + СтрокаМассива.Акциз;
			ФактурнаяСтоимостьИтог = ФактурнаяСтоимостьИтог + ФактурнаяСтоимость;
			ТаможеннаяСтоимостьИтог = ТаможеннаяСтоимостьИтог + ТаможеннаяСтоимость;
		КонецЦикла;	
		
		МассивСтрокОС = ОС.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого СтрокаМассива Из МассивСтрокОС Цикл
			ФактурнаяСтоимость 				 = Окр(СтрокаМассива.Сумма * Курс / Кратность, 2);	
			ТаможеннаяСтоимость				 = ФактурнаяСтоимость + СтрокаМассива.ДопРасходы + СтрокаМассива.Акциз;	
			СтрокаМассива.ТаможенныйСбор	 = Окр(ТаможеннаяСтоимость * СтрокаТабличнойЧасти.СтавкаСбора / 100, 2);
			
			АкцизИтог = АкцизИтог + СтрокаМассива.Акциз;
			ФактурнаяСтоимостьИтог = ФактурнаяСтоимостьИтог + ФактурнаяСтоимость;
			ТаможеннаяСтоимостьИтог = ТаможеннаяСтоимостьИтог + ТаможеннаяСтоимость;
		КонецЦикла;
		
		МассивСтрокДопрасходов = Допрасходы.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого СтрокаМассива Из МассивСтрокДопрасходов Цикл
			ДопрасходыИтог = ДопрасходыИтог + СтрокаМассива.СуммаДопрасходов;	
		КонецЦикла;	
		
		Если ВводСуммГТДВручную Тогда
			ФактурнаяСтоимостьИтог = СтрокаТабличнойЧасти.ФактурнаяСтоимость;	
			ТаможеннаяСтоимостьИтог = ФактурнаяСтоимостьИтог + ДопрасходыИтог + АкцизИтог;
			СтрокаТабличнойЧасти.ТаможеннаяСтоимость = ТаможеннаяСтоимостьИтог;
			СтрокаТабличнойЧасти.СтавкаПошлины = СтрокаТабличнойЧасти.Пошлина * 100 / ?(ТаможеннаяСтоимостьИтог = 0, 1, ТаможеннаяСтоимостьИтог);
			
		Иначе
			СтрокаТабличнойЧасти.ФактурнаяСтоимость = ФактурнаяСтоимостьИтог;
			СтрокаТабличнойЧасти.ТаможеннаяСтоимость = ТаможеннаяСтоимостьИтог;
			СтрокаТабличнойЧасти.Пошлина = Окр(ТаможеннаяСтоимостьИтог * СтрокаТабличнойЧасти.СтавкаПошлины / 100, 2);
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти.НДСТолькоНаПошлину Тогда
			СтрокаТабличнойЧасти.БазаНДС = СтрокаТабличнойЧасти.Пошлина;
		Иначе
			СтрокаТабличнойЧасти.БазаНДС = ФактурнаяСтоимостьИтог + СтрокаТабличнойЧасти.Пошлина + ДопрасходыИтог + АкцизИтог;
		КонецЕсли;
		
		СтрокаТабличнойЧасти.ДопРасходы = ДопрасходыИтог;
		СтрокаТабличнойЧасти.НДС = Окр(СтрокаТабличнойЧасти.БазаНДС * СтрокаТабличнойЧасти.СтавкаНДС / 100, 2);
		                    
		Если ВводСуммГТДВручную Тогда
			СтрокаТабличнойЧасти.СтавкаСбора = СтрокаТабличнойЧасти.ТаможенныйСбор * 100 / ?(ТаможеннаяСтоимостьИтог = 0, 1, ТаможеннаяСтоимостьИтог);
		Иначе
			СтрокаТабличнойЧасти.ТаможенныйСбор = Окр(ТаможеннаяСтоимостьИтог * СтрокаТабличнойЧасти.СтавкаСбора / 100, 2);
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
