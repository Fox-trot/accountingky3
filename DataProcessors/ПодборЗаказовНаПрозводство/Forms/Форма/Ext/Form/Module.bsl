﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.УникальныйИдентификаторФормыВладельца = Параметры.УникальныйИдентификаторФормыВладельца;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодобранныеРаботы.Заказ КАК Заказ,
		|	ПодобранныеРаботы.Номенклатура КАК Номенклатура,
		|	ПодобранныеРаботы.Операция КАК Операция
		|ПОМЕСТИТЬ ВременнаяТаблицаПодобранныеРаботы
		|ИЗ
		|	&ПодобранныеРаботы КАК ПодобранныеРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыполненныеРаботыСрезПоследних.Заказ КАК Заказ,
		|	ВыполненныеРаботыСрезПоследних.Номенклатура КАК Номенклатура,
		|	ВыполненныеРаботыСрезПоследних.Операция КАК Операция
		|ПОМЕСТИТЬ ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция
		|ИЗ
		|	РегистрСведений.ВыполненныеРаботы.СрезПоследних(&Период, Организация = &Организация) КАК ВыполненныеРаботыСрезПоследних
		|ГДЕ
		|	ВыполненныеРаботыСрезПоследних.Регистратор <> &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПодобранныеРаботы.Заказ,
		|	ВременнаяТаблицаПодобранныеРаботы.Номенклатура,
		|	ВременнаяТаблицаПодобранныеРаботы.Операция
		|ИЗ
		|	ВременнаяТаблицаПодобранныеРаботы КАК ВременнаяТаблицаПодобранныеРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СпецификацияНоменклатуры.Ссылка КАК Спецификация,
		|	СпецификацияНоменклатуры.Операция КАК Операция
		|ПОМЕСТИТЬ ВременнаяТаблицаОперацииСпецификации
		|ИЗ
		|	Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК СпецификацияНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказаннаяПродукцияСрезПоследних.Контрагент КАК Контрагент,
		|	ЗаказаннаяПродукцияСрезПоследних.Заказ КАК Заказ,
		|	ЗаказаннаяПродукцияСрезПоследних.Номенклатура КАК Номенклатура,
		|	ЗаказаннаяПродукцияСрезПоследних.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаОперацииСпецификации.Операция КАК Операция,
		|	ЗаказаннаяПродукцияСрезПоследних.Количество КАК Количество,
		|	ЗаказаннаяПродукцияСрезПоследних.Полуфабрикаты КАК Полуфабрикаты
		|ПОМЕСТИТЬ ВременнаяТаблицаЗаказаннаяПродукция
		|ИЗ
		|	РегистрСведений.ЗаказаннаяПродукция.СрезПоследних(&Период, Организация = &Организация) КАК ЗаказаннаяПродукцияСрезПоследних
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВременнаяТаблицаОперацииСпецификации КАК ВременнаяТаблицаОперацииСпецификации
		|		ПО ЗаказаннаяПродукцияСрезПоследних.Спецификация = ВременнаяТаблицаОперацииСпецификации.Спецификация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаЗаказаннаяПродукция.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаЗаказаннаяПродукция.Заказ КАК Заказ,
		|	ВременнаяТаблицаЗаказаннаяПродукция.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаЗаказаннаяПродукция.Операция КАК Операция,
		|	ВременнаяТаблицаЗаказаннаяПродукция.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаЗаказаннаяПродукция.Полуфабрикаты КАК Полуфабрикаты,
		|	ВременнаяТаблицаЗаказаннаяПродукция.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция.Операция ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ВыполненнаяОперация
		|ПОМЕСТИТЬ ВременнаяТаблицаНевыполненныеОперации
		|ИЗ
		|	ВременнаяТаблицаЗаказаннаяПродукция КАК ВременнаяТаблицаЗаказаннаяПродукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция КАК ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция
		|		ПО ВременнаяТаблицаЗаказаннаяПродукция.Заказ = ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция.Заказ
		|			И ВременнаяТаблицаЗаказаннаяПродукция.Номенклатура = ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция.Номенклатура
		|			И ВременнаяТаблицаЗаказаннаяПродукция.Операция = ВременнаяТаблицаИзготовленнаяИПодобраннаяПродукция.Операция
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаНевыполненныеОперации.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаНевыполненныеОперации.Заказ КАК Заказ,
		|	ВременнаяТаблицаНевыполненныеОперации.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаНевыполненныеОперации.Операция КАК Операция,
		|	ВременнаяТаблицаНевыполненныеОперации.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаНевыполненныеОперации.Полуфабрикаты КАК Полуфабрикаты,
		|	ВременнаяТаблицаНевыполненныеОперации.Количество КАК Количество
		|ИЗ
		|	ВременнаяТаблицаНевыполненныеОперации КАК ВременнаяТаблицаНевыполненныеОперации
		|ГДЕ
		|	НЕ ВременнаяТаблицаНевыполненныеОперации.ВыполненнаяОперация";
	Запрос.УстановитьПараметр("ПодобранныеРаботы", 	Параметры.ПодобранныеСтрокиИзДокумента.Выгрузить());
	Запрос.УстановитьПараметр("Период", 			Параметры.Период);
	Запрос.УстановитьПараметр("Организация", 		Параметры.Организация);
	Запрос.УстановитьПараметр("Регистратор", 		Параметры.Регистратор);
	
	Объект.СписокНевыполненныхРабот.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СформироватьСпискиВыбора();
КонецПроцедуры

&НаСервере
Процедура СформироватьСпискиВыбора()

	Элементы.Контрагент.СписокВыбора.Очистить();
	Элементы.Заказ.СписокВыбора.Очистить();
	Элементы.Номенклатура.СписокВыбора.Очистить();
	Элементы.Операция.СписокВыбора.Очистить();

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаВыбораРабот.Контрагент КАК Контрагент,
		|	ТаблицаВыбораРабот.Заказ КАК Заказ,
		|	ТаблицаВыбораРабот.Номенклатура КАК Номенклатура,
		|	ТаблицаВыбораРабот.Операция КАК Операция
		|ПОМЕСТИТЬ ВременнаяТаблицаВыбораРабот
		|ИЗ
		|	&ТаблицаВыбораРабот КАК ТаблицаВыбораРабот
		|ГДЕ
		|	ТаблицаВыбораРабот.Контрагент = &Контрагент
		|	И ТаблицаВыбораРабот.Заказ = &Заказ
		|	И ТаблицаВыбораРабот.Номенклатура = &Номенклатура
		|	И ТаблицаВыбораРабот.Операция = &Операция
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаВыбораРабот.Контрагент КАК Контрагент
		|ИЗ
		|	ВременнаяТаблицаВыбораРабот КАК ВременнаяТаблицаВыбораРабот
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаВыбораРабот.Заказ КАК Заказ
		|ИЗ
		|	ВременнаяТаблицаВыбораРабот КАК ВременнаяТаблицаВыбораРабот
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаВыбораРабот.Номенклатура КАК Номенклатура
		|ИЗ
		|	ВременнаяТаблицаВыбораРабот КАК ВременнаяТаблицаВыбораРабот
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаВыбораРабот.Операция КАК Операция
		|ИЗ
		|	ВременнаяТаблицаВыбораРабот КАК ВременнаяТаблицаВыбораРабот";
	Запрос.УстановитьПараметр("ТаблицаВыбораРабот", Объект.СписокНевыполненныхРабот.Выгрузить());
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТаблицаВыбораРабот.Контрагент = &Контрагент", "ИСТИНА");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Заказ) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ТаблицаВыбораРабот.Заказ = &Заказ", "И ИСТИНА");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ТаблицаВыбораРабот.Номенклатура = &Номенклатура", "И ИСТИНА");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Операция) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ТаблицаВыбораРабот.Операция = &Операция", "И ИСТИНА");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Контрагент", 	Объект.Контрагент);
	Запрос.УстановитьПараметр("Заказ", 			Объект.Заказ);
	Запрос.УстановитьПараметр("Номенклатура", 	Объект.Номенклатура);
	Запрос.УстановитьПараметр("Операция", 		Объект.Операция);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаКонтрагенты = МассивРезультатов[1].Выбрать();
	
	Пока ВыборкаКонтрагенты.Следующий() Цикл
		Элементы.Контрагент.СписокВыбора.Добавить(ВыборкаКонтрагенты.Контрагент);	
	КонецЦикла;	
	
	ВыборкаЗаказы = МассивРезультатов[2].Выбрать();
	
	Пока ВыборкаЗаказы.Следующий() Цикл
		Элементы.Заказ.СписокВыбора.Добавить(ВыборкаЗаказы.Заказ);	
	КонецЦикла;
	
	ВыборкаНоменклатура = МассивРезультатов[3].Выбрать();
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		Элементы.Номенклатура.СписокВыбора.Добавить(ВыборкаНоменклатура.Номенклатура);	
	КонецЦикла;
	
	ВыборкаОперации = МассивРезультатов[4].Выбрать();
	
	Пока ВыборкаОперации.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаОперации.Операция) Тогда
			Элементы.Операция.СписокВыбора.Добавить(ВыборкаОперации.Операция);	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьОтборНаСписокНевыполненныхРабот();
	СформироватьСпискиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказПриИзменении(Элемент)
	
	УстановитьОтборНаСписокНевыполненныхРабот();
	СформироватьСпискиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	УстановитьОтборНаСписокНевыполненныхРабот();
	СформироватьСпискиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	
	УстановитьОтборНаСписокНевыполненныхРабот();
	СформироватьСпискиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНаСписокНевыполненныхРабот()

	СтрокаОтбора = "";
	ЗначенияОтбора = Новый Массив();
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		СтрокаОтбора = "Контрагент";	
		ЗначенияОтбора.Добавить(Объект.Контрагент);
	КонецЕсли;

	Если ЗначениеЗаполнено(Объект.Заказ) Тогда
		
		Если СтрокаОтбора = "" Тогда
			СтрокаОтбора = "Заказ";
		Иначе
			СтрокаОтбора = СтрокаОтбора + ",Заказ";
		КонецЕсли;	
			
		ЗначенияОтбора.Добавить(Объект.Заказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		
		Если СтрокаОтбора = "" Тогда
			СтрокаОтбора = "Номенклатура";
		Иначе
			СтрокаОтбора = СтрокаОтбора + ",Номенклатура";
		КонецЕсли;	
			
		ЗначенияОтбора.Добавить(Объект.Номенклатура);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Операция) Тогда
		
		Если СтрокаОтбора = "" Тогда
			СтрокаОтбора = "Операция";
		Иначе
			СтрокаОтбора = СтрокаОтбора + ",Операция";
		КонецЕсли;	
			
		ЗначенияОтбора.Добавить(Объект.Операция);
	КонецЕсли;
	
	ДанныеОтбора = Неопределено;
	
	Если ЗначенияОтбора.Количество() = 1 Тогда
		ДанныеОтбора = Новый ФиксированнаяСтруктура(СтрокаОтбора, ЗначенияОтбора[0]);
		
	ИначеЕсли ЗначенияОтбора.Количество() = 2 Тогда
		ДанныеОтбора = Новый ФиксированнаяСтруктура(СтрокаОтбора, 
									ЗначенияОтбора[0],
									ЗначенияОтбора[1]);
									
	ИначеЕсли ЗначенияОтбора.Количество() = 3 Тогда
		ДанныеОтбора = Новый ФиксированнаяСтруктура(СтрокаОтбора, 
									ЗначенияОтбора[0],
									ЗначенияОтбора[1],
									ЗначенияОтбора[2]);
									
	ИначеЕсли ЗначенияОтбора.Количество() = 4 Тогда
		ДанныеОтбора = Новый ФиксированнаяСтруктура(СтрокаОтбора, 
									ЗначенияОтбора[0],
									ЗначенияОтбора[1],
									ЗначенияОтбора[2],
									ЗначенияОтбора[3]);
	КонецЕсли;
	
	Элементы.СписокНевыполненныхРабот.ОтборСтрок = ДанныеОтбора;
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Закрыть(ЗаписатьПодборВХранилище());
	
КонецПроцедуры

// Процедура записывает выбранные строки в хранилище.
//
// Возвращаемое значение:
//  Структура - адрес в хранилище и идентификатор формы владельца.
//
&НаСервере
Функция ЗаписатьПодборВХранилище()
	ТаблицаСтрок = Объект.СписокНевыполненныхРабот.Выгрузить();
	ТаблицаСтрок.Очистить();
	
	Для Каждого СтрокаТабличнойЧасти Из Элементы.СписокНевыполненныхРабот.ВыделенныеСтроки Цикл
		СтрокаТаблицы = ТаблицаСтрок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Объект.СписокНевыполненныхРабот.НайтиПоИдентификатору(СтрокаТабличнойЧасти));
	КонецЦикла;	

	АдресКорзиныВХранилище = ПоместитьВоВременноеХранилище(ТаблицаСтрок, Объект.УникальныйИдентификаторФормыВладельца);
	Возврат Новый Структура("АдресКорзиныВХранилище, УникальныйИдентификаторФормыВладельца", АдресКорзиныВХранилище, Объект.УникальныйИдентификаторФормыВладельца);
	
КонецФункции
