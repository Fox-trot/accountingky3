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
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЦеныНоменклатуры.Период КАК Период,
		|	ЦеныНоменклатуры.Организация КАК Организация,
		|	ЦеныНоменклатуры.ТипЦен КАК ТипЦен,
		|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|ГДЕ
		|	ЦеныНоменклатуры.Основание = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
	    НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.ТипЦен.Установить(Выборка.ТипЦен);
		НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
		
		Попытка
			НаборЗаписей.Записать();
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись по причине: %1'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
		
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
		МенеджерЗаписи = РегистрыСведений.ЦеныНоменклатуры.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.Период 		= Дата;
		МенеджерЗаписи.Организация 	= Организация;
		МенеджерЗаписи.ТипЦен 		= ТипЦен;
		МенеджерЗаписи.Номенклатура = СтрокаТабличнойЧасти.Номенклатура;
		МенеджерЗаписи.Валюта 		= ТипЦен.ВалютаЦены;
		МенеджерЗаписи.Цена 		= СтрокаТабличнойЧасти.Цена;
		МенеджерЗаписи.Основание 	= Ссылка;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись по причине: %1'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныНоменклатуры.Период,
		|	ЦеныНоменклатуры.Организация,
		|	ЦеныНоменклатуры.ТипЦен,
		|	ЦеныНоменклатуры.Номенклатура
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|ГДЕ
		|	ЦеныНоменклатуры.Основание = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
		НаборЗаписей.Отбор.Организация.Установить(ВыборкаДетальныеЗаписи.Организация);
		НаборЗаписей.Отбор.ТипЦен.Установить(ВыборкаДетальныеЗаписи.ТипЦен);
		НаборЗаписей.Отбор.Номенклатура.Установить(ВыборкаДетальныеЗаписи.Номенклатура);
		НаборЗаписей.Прочитать();                               
		НаборЗаписей.Очистить();
		
		Попытка
			НаборЗаписей.Записать();
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись по причине: %1'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	

КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)


КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Заполнить табличную часть
// Параметры:
//  Очистить		 - Булево - Очистить и перезаполнить табличную часть  
//  Обновить		 - Булево - Обновить цены по номенклатуре в табличной части, не добавляя новые строки. Если Ложь, то добавляем новые.  
//  ПоНоменклатуре	 - Булево - Заполняем из справочника Номенклатура без отбора по Типу цен. Если ложь, то ищем из спр. по выранному типу цен.
//
Процедура ЗаполнитьТабличнуюЧасть(Очистить, Обновить, ПоНоменклатуре = Ложь) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникНоменклатура.Ссылка КАК Номенклатура,
		|	ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) КАК Цена,
		|	ЕСТЬNULL(ЦеныНоменклатуры.Валюта, ТипыЦенСправочник.ВалютаЦены) КАК Валюта
		|ИЗ
		|	Справочник.Номенклатура КАК СправочникНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				&ДатаЦен,
		|				Организация = &Организация
		|					И ТипЦен = &ТипЦен) КАК ЦеныНоменклатуры
		|		ПО СправочникНоменклатура.Ссылка = ЦеныНоменклатуры.Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыЦенНоменклатуры КАК ТипыЦенСправочник
		|		ПО (ЦеныНоменклатуры.ТипЦен = ТипыЦенСправочник.Ссылка)
		|ГДЕ
		|	СправочникНоменклатура.ЭтоГруппа = ЛОЖЬ
		|	И ТипыЦенСправочник.Ссылка = &ТипЦен";
	
	Если ПоНоменклатуре Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"ТипыЦенСправочник.Ссылка = &ТипЦен","Истина");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	Запрос.УстановитьПараметр("ДатаЦен", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	Если Очистить Тогда 
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл	
			СтрокаТабличнойЧасти = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
			
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Валюта) Тогда
				СтрокаТабличнойЧасти.Валюта = ?(ЗначениеЗаполнено(ТипЦен.ВалютаЦены),ТипЦен.ВалютаЦены,ВалютаРегламентированногоУчета);		
			КонецЕсли;
		КонецЦикла;	
			
	Иначе
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураОтбора = Новый Структура();
			СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);	
			
			Если Обновить Тогда 
				СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОтбора);
				Если СтрокаТабличнойЧасти = Неопределено Тогда
					Продолжить;
				КонецЕсли;		
			Иначе 
				СтрокаТабличнойЧасти = Товары.Добавить();
				СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;			
			КонецЕсли;
			СтрокаТабличнойЧасти.Цена 	= Выборка.Цена;
			СтрокаТабличнойЧасти.Валюта = ?(ЗначениеЗаполнено(Выборка.Валюта),Выборка.Валюта,ТипЦен.ВалютаЦены);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

// Процедура - Заполнить табличную часть по поступлению
// Выполняет заполнение табличной части копированием из выбранного пользователем документа Поступления.
//
// Параметры:
//  ДокументПоступление - Документ поступления, данными которого надо заполнить табличную часть.
//
Процедура ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ВалютаДокумента,
		|	ТаблицаДокумента.Контрагент,
		|	ТаблицаДокумента.ВидОперации,
		|	ТаблицаДокумента.Товары.(
		|		СУММА(НомерСтроки),
		|		Номенклатура,
		|		Цена
		|	)
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументПоступление
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДокумента.Товары.(Номенклатура,
		|	Цена)";
	
	Запрос.УстановитьПараметр("ДокументПоступление", ДокументПоступление);
	
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	Выборка = Шапка.Товары.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			СтрокаТабличнойЧасти = Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;			
		КонецЕсли;
		
		СтрокаТабличнойЧасти.Цена	= Выборка.Цена;
		СтрокаТабличнойЧасти.Валюта =  Шапка.ВалютаДокумента;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - Заполнить табличную часть по поступлению с ГТД
// Выполняет заполнение табличной части копированием из выбранного пользователем документа Поступления.
//
// Параметры:
//  ДокументПоступление - Документ поступления, данными которого надо заполнить табличную часть.
//
Процедура ЗаполнитьТабличнуюЧастьПоПоступлениюСГТД(МассивДокументов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ГТДПоИмпортуТовары.Номенклатура КАК Номенклатура,
		|	СУММА(ГТДПоИмпортуТовары.Акциз + ГТДПоИмпортуТовары.Пошлина + ГТДПоИмпортуТовары.Сопровождение + ГТДПоИмпортуТовары.ТаможенныйСбор) / СУММА(ГТДПоИмпортуТовары.Количество) КАК ЦенаГТД
		|ПОМЕСТИТЬ ВременнаяТаблицаГТДПоИмпорту
		|ИЗ
		|	Документ.ГТДПоИмпорту.Товары КАК ГТДПоИмпортуТовары
		|ГДЕ
		|	ГТДПоИмпортуТовары.ДокументПоступления В (&МассивДокументов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ГТДПоИмпортуТовары.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Цена * ПоступлениеТоваровУслугТовары.Ссылка.Курс / ПоступлениеТоваровУслугТовары.Ссылка.Кратность КАК Цена,
		|	ПоступлениеТоваровУслугТовары.Ссылка.ВалютаДокумента КАК ВалютаДокумента
		|ПОМЕСТИТЬ ВременнаяТаблицаПоступление
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка В (&МассивДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДополнительныеРасходыТовары.Номенклатура КАК Номенклатура,
		|	СУММА(ДополнительныеРасходыТовары.СуммаРасходов * ДополнительныеРасходыТовары.Ссылка.Курс / ДополнительныеРасходыТовары.Ссылка.Кратность / ДополнительныеРасходыТовары.Количество) КАК ЦенаДопрасход
		|ПОМЕСТИТЬ ВременнаяТаблицаДопраходы
		|ИЗ
		|	Документ.ДополнительныеРасходы.Товары КАК ДополнительныеРасходыТовары
		|ГДЕ
		|	ДополнительныеРасходыТовары.Ссылка.ДокументОснование В (&МассивДокументов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДополнительныеРасходыТовары.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПоступление.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаПоступление.Цена + ЕСТЬNULL(ВременнаяТаблицаГТДПоИмпорту.ЦенаГТД, 0) + ЕСТЬNULL(ВременнаяТаблицаДопраходы.ЦенаДопрасход, 0) КАК Цена,
		|	ВременнаяТаблицаПоступление.ВалютаДокумента КАК ВалютаДокумента
		|ИЗ
		|	ВременнаяТаблицаПоступление КАК ВременнаяТаблицаПоступление
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаГТДПоИмпорту КАК ВременнаяТаблицаГТДПоИмпорту
		|		ПО ВременнаяТаблицаПоступление.Номенклатура = ВременнаяТаблицаГТДПоИмпорту.Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаДопраходы КАК ВременнаяТаблицаДопраходы
		|		ПО ВременнаяТаблицаПоступление.Номенклатура = ВременнаяТаблицаДопраходы.Номенклатура";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			СтрокаТабличнойЧасти = Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;			
		КонецЕсли;
		
		СтрокаТабличнойЧасти.Цена	= Выборка.Цена;
		СтрокаТабличнойЧасти.Валюта =  Выборка.ВалютаДокумента;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - Заполнить табличную часть остатками
//
Процедура ЗаполнитьТабличнуюЧастьОстатками() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйОстатки.КоличествоОстаток = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВЫРАЗИТЬ(ХозрасчетныйОстатки.СуммаОстаток / ХозрасчетныйОстатки.КоличествоОстаток КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК Цена,
		|	&ВалютаРегламентированногоУчета КАК Валюта
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет В (&СчетаУчетаТоваров), ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура), Организация = &Организация) КАК ХозрасчетныйОстатки	
		|ГДЕ
		|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура) <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И ХозрасчетныйОстатки.СуммаОстаток <> 0
		|	И ХозрасчетныйОстатки.КоличествоОстаток <> 0";
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация); 
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	СчетаУчетаТоваровПредопределенные = Новый Массив;
	СчетаУчетаТоваровПредопределенные.Добавить(ПланыСчетов.Хозрасчетный.ТоварноМатериальныеЗапасы);       
	СчетаУчетаТоваровПредопределенные.Добавить(ПланыСчетов.Хозрасчетный.ЗапасыВспомогательныхМатериалов);       
	СчетаУчетаТоваров = БухгалтерскийУчетСервер.СформироватьМассивСубсчетов(СчетаУчетаТоваровПредопределенные);
	Запрос.УстановитьПараметр("СчетаУчетаТоваров", СчетаУчетаТоваров); 
	Результат = Запрос.Выполнить();
	
	Товары.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	&ВременнаяТаблицаТовары КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО ЦеныНоменклатуры.Номенклатура = ВременнаяТаблицаТовары.Номенклатура
		|ГДЕ
		|	ЦеныНоменклатуры.Период = &Период
		|	И ЦеныНоменклатуры.Организация = &Организация
		|	И ЦеныНоменклатуры.ТипЦен = &ТипЦен
		|	И НЕ ЦеныНоменклатуры.Основание = &Ссылка
		|	И ЦеныНоменклатуры.Номенклатура В
		|			(ВЫБРАТЬ
		|				ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура
		|			ИЗ
		|				ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВременнаяТаблицаТоварыДубли.НомерСтроки) КАК НомерСтроки,
		|	ВременнаяТаблицаТоварыДубли.Номенклатура КАК Номенклатура
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТоварыДубли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО ВременнаяТаблицаТоварыДубли.НомерСтроки <> ВременнаяТаблицаТовары.НомерСтроки
		|			И ВременнаяТаблицаТоварыДубли.Номенклатура = ВременнаяТаблицаТовары.Номенклатура
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаТоварыДубли.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ВременнаяТаблицаТовары", Товары.Выгрузить());
	Запрос.УстановитьПараметр("Период", НачалоДня(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Цены номенклатуры".
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'На указанную дату по выбранному типу цен цена уже установлена. Номенклатура: ""%1"" в строке %2.'"), 
				ВыборкаИзРезультатаЗапроса.Номенклатура, ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Товары",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Номенклатура",
				Отказ);
		КонецЦикла;		
	КонецЕсли;
		
	// Дубли строк.
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
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
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли