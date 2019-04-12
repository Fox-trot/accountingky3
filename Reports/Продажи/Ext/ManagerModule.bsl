﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("Имя, Представление","ПродажиПоКонтрагентам", НСтр("ru = 'Продажи по контрагентам'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ПродажиПоКонтрагентамПоОплате", НСтр("ru = 'Продажи по контрагентам (по оплате)'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ПродажиПоНоменклатуре", НСтр("ru = 'Продажи по номенклатуре'")));
	Массив.Добавить(Новый Структура("Имя, Представление","ПродажиПоНоменклатурнымГруппам", НСтр("ru = 'Продажи по номенклатурным группам'")));
	Возврат Массив;
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПродажиПоНоменклатурнымГруппам");
	НастройкиВарианта.Описание = НСтр("ru = 'Продажи по номенклатурным группам'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПродажиПоНоменклатуре");
	НастройкиВарианта.Описание = НСтр("ru = 'Продажи по номенклатуре'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПродажиПоКонтрагентам");
	НастройкиВарианта.Описание = НСтр("ru = 'Продажи по контрагентам'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПродажиПоКонтрагентамПоОплате");
	НастройкиВарианта.Описание = НСтр("ru = 'Продажи по контрагентам по оплате'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Параметры.Вставить("ИспользоватьПослеКомпоновкиМакета",           Ложь);
	Параметры.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Параметры.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Параметры.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	Параметры.Вставить("ИспользоватьПривилегированныйРежим",          Истина);
	
	Возврат Параметры;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Если ПараметрыОтчета.КлючТекущегоВарианта = "ПродажиПоКонтрагентамПоОплате" Тогда
		ТекстПоОплате = " " + НСтр("ru='(по оплате)'");
	Иначе
		ТекстПоОплате = "";
	КонецЕсли;
	
	Возврат НСтр("ru='Продажи'") + ТекстПоОплате + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	СчетаКассы = Новый Массив;
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеСредстваВКассе);
	СчетаКассы.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеСредстваВБанке);
	СчетаКассы = БухгалтерскийУчетСервер.СформироватьМассивСубсчетов(СчетаКассы);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаКассы", СчетаКассы);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаВыручки", БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.Выручка));
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	СхемаЭталон = ПолучитьМакет("СхемаКомпоновкиДанных");
	ТекстЗапроса = СхемаЭталон.НаборыДанных.Продажи.Запрос;
	
	ПериодичностьОтчета = Новый Соответствие;
	ПериодичностьОтчета.Вставить(6, "ДЕНЬ");
	ПериодичностьОтчета.Вставить(9, "МЕСЯЦ");
	ПериодичностьОтчета.Вставить(10, "КВАРТАЛ");
	ПериодичностьОтчета.Вставить(11, "ПОЛУГОДИЕ");
	ПериодичностьОтчета.Вставить(12, "ГОД");
	
	Схема.НаборыДанных.Продажи.Запрос = СтрЗаменить(ТекстЗапроса, ".ПериодДень", ".Период" + ПериодичностьОтчета.Получить(Периодичность));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОпределятьСуммуПоОплате", ПараметрыОтчета.ПоказательОпределятьСуммуПоОплате);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "УчетПроизводстваПоНоменклатурнымГруппам", ПолучитьФункциональнуюОпцию("УчетПроизводстваПоНоменклатурнымГруппам"));
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Таблица   = Неопределено;
	ДиаграммаСумма = Неопределено;
	ДиаграммаКоличество = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
		Если ЭлементСтруктуры.Имя = "Таблица" Тогда
			Таблица = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "ДиаграммаСумма" Тогда
			ДиаграммаСумма = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "ДиаграммаКоличество" Тогда
			ДиаграммаКоличество = ЭлементСтруктуры;
		КонецЕсли;
	КонецЦикла;
	
	Если ДиаграммаСумма <> Неопределено Тогда
		
		Если ВыводитьДиаграмму И ПараметрыОтчета.ПоказательСумма Тогда
			
			ДиаграммаСумма.Точки.Очистить();
			ГруппировкаПериод = ДиаграммаСумма.Точки.Добавить();
			ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
			ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
			ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
			ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
			
			ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ПорядокПериод = ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
			ПорядокПериод.Поле = ПолеГруппировки.Поле;
			
			// Группировка
			ДиаграммаСумма.Серии.Очистить();
			Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
				Если ПолеВыбраннойГруппировки.Использование Тогда
					Группировка = ДиаграммаСумма.Серии.Добавить();
					ЗаполнитьГруппировкуДиаграммы(ПолеВыбраннойГруппировки, Группировка);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			УстановитьВыводЗаголовкаДиаграммы(ДиаграммаСумма, ПараметрыОтчета.ПоказательКоличество И ПараметрыОтчета.ПоказательСумма);
			
		Иначе
			
			ДиаграммаСумма.Использование = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДиаграммаКоличество <> Неопределено Тогда
		
		Если ВыводитьДиаграмму И ПараметрыОтчета.ПоказательКоличество И НЕ ПараметрыОтчета.ПоказательСумма Тогда
			
			ДиаграммаКоличество.Точки.Очистить();
			ГруппировкаПериод = ДиаграммаКоличество.Точки.Добавить();
			ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
			ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
			ПолеГруппировки.НачалоПериода =	НачалоДня(ПараметрыОтчета.НачалоПериода);
			ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
			
			ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ПорядокПериод = ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
			ПорядокПериод.Поле = ПолеГруппировки.Поле;
			
			// Группировка
			ДиаграммаКоличество.Серии.Очистить();
			Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
				Если ПолеВыбраннойГруппировки.Использование Тогда
					Группировка = ДиаграммаКоличество.Серии.Добавить();
					БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			УстановитьВыводЗаголовкаДиаграммы(ДиаграммаКоличество, ПараметрыОтчета.ПоказательКоличество И ПараметрыОтчета.ПоказательСумма);
			
		Иначе
			
			ДиаграммаКоличество.Использование = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Таблица <> Неопределено Тогда
		
		Таблица.Колонки.Очистить();
		ГруппировкаПериод = Таблица.Колонки.Добавить();
		ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ПорядокПериод = ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокПериод.Поле = ПолеГруппировки.Поле;
		
		// Группировка
		Таблица.Строки.Очистить();
		Группировка = Таблица.Строки;
		Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
			Если ПолеВыбраннойГруппировки.Использование Тогда
				
				Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
					Группировка = Группировка.Добавить();
				Иначе
					Группировка = Группировка.Структура.Добавить();
				КонецЕсли;
				БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
				
				ПолеОтбора = Новый ПолеКомпоновкиДанных("Сумма");
				НовыйЭлемент = Группировка.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				НовыйЭлемент.Использование  = Истина;
				НовыйЭлемент.ЛевоеЗначение  = ПолеОтбора;
				НовыйЭлемент.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
				НовыйЭлемент.ПравоеЗначение = 0;
				ПараметрВыводитьОтбор = Группировка.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
				ПараметрВыводитьОтбор.Использование = Истина;
				ПараметрВыводитьОтбор.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
				
			КонецЕсли;
		КонецЦикла;
		
		Если ПараметрыОтчета.ПоказательКоличество И ПараметрыОтчета.ПоказательСумма
			И НЕ ПараметрыОтчета.ПоказательОпределятьСуммуПоОплате Тогда
			ГруппировкаКолонки = Таблица.Колонки;
			Для Каждого ПолеВыбраннойГруппировки Из ГруппировкаКолонки Цикл
				Если ПолеВыбраннойГруппировки.Использование Тогда
					ПолеВыбраннойГруппировки.Имя = "ПериодКоличествоИСумма";
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ПолеКоличество = Новый ПолеКомпоновкиДанных("Количество");
		ПолеСумма = Новый ПолеКомпоновкиДанных("Сумма");
		
		Для Каждого ЭлементВыбора Из Таблица.Выбор.Элементы Цикл
			Если ЭлементВыбора.Поле = ПолеКоличество Тогда
				ЭлементВыбора.Использование = ПараметрыОтчета.ПоказательКоличество И НЕ ПараметрыОтчета.ПоказательОпределятьСуммуПоОплате;
			КонецЕсли;
			Если ЭлементВыбора.Поле = ПолеСумма Тогда
				ЭлементВыбора.Использование = ПараметрыОтчета.ПоказательСумма;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
		
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	ЗаголовокДиаграммыСумма = Результат.НайтиТекст("###Сумма###");
	Если ЗаголовокДиаграммыСумма <> Неопределено Тогда
		ЗаголовокДиаграммыСумма.Текст = Символы.ПС + НСтр("ru='Сумма'");
		НовыйШрифт = Новый Шрифт(ЗаголовокДиаграммыСумма.Шрифт,,11);
		ЗаголовокДиаграммыСумма.Шрифт = НовыйШрифт;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
		
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Попытка
			Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
				Рисунок.Объект.МаксимумСерий = МаксимумСерий.Ограничено;
				Рисунок.Объект.МаксимумСерийКоличество = 6; // 5 топовых + 1 прочие
				
				Рисунок.Объект.СводнаяСерия.Текст = НСтр("ru = 'Прочие'");
				Рисунок.Объект.СводнаяСерия.Цвет  = WebЦвета.ТусклоСерый;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список мунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполниим соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Соответствие;
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки ИЗ ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Прежде всего интересны данные группировочных полей
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		
		Если Группировка.Использование Тогда
			
			СоответствиеПолей.Вставить(Группировка.Поле);
			
		КонецЕсли;
		
	КонецЦикла;
	
	СоответствиеПолей.Вставить("Период");
		
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки", 	Истина);
	ДополнительныеСвойства.Вставить("Организация", 			ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода", 		ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода", 		ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",	ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",		ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",		ДанныеОтчета.Объект.МакетОформления);
	ДополнительныеСвойства.Вставить("Периодичность",		ДанныеОтчета.Объект.Периодичность);
	ДополнительныеСвойства.Вставить("ВыводитьДиаграмму",	Ложь);
	ДополнительныеСвойства.Вставить("ПоказательКоличество",	ДанныеОтчета.Объект.ПоказательКоличество);
	ДополнительныеСвойства.Вставить("ПоказательСумма",		ДанныеОтчета.Объект.ПоказательСумма);
	ДополнительныеСвойства.Вставить("КлючТекущегоВарианта",	ДанныеОтчета.Объект.КлючТекущегоВарианта);
	ДополнительныеСвойства.Вставить("ОчищатьТаблицуГруппировок", 		Истина);
	ДополнительныеСвойства.Вставить("ПоказательОпределятьСуммуПоОплате",ДанныеОтчета.Объект.ПоказательОпределятьСуммуПоОплате);
	
	// Получаем соответствие полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	Договор = Данные_Расшифровки.Получить("Договор");
	
	Если ЗначениеЗаполнено(Договор) Тогда
		
		ДополнительныеСвойства.Вставить("Организация", Договор.Организация);
		
	КонецЕсли;
	
	Период = Данные_Расшифровки.Получить("Период");
	
	Если ЗначениеЗаполнено(Период) Тогда
		
		Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ДанныеОтчета.Объект.Периодичность, ДанныеОтчета.Объект.НачалоПериода, ДанныеОтчета.Объект.КонецПериода);
		ДополнительныеСвойства.Вставить("Периодичность",		Периодичность);
		ДополнительныеСвойства.Вставить("КонецПериода", КонецДня(БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность)));
		ДополнительныеСвойства.Вставить("НачалоПериода", НачалоДня(БухгалтерскиеОтчетыКлиентСервер.НачалоПериода(Период, Периодичность)));

	КонецЕсли;
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		Если ЗначениеРасшифровки.Ключ <> "Период" Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Группировка = Новый Массив();
	ЕстьГруппировкаПоДокументу = Ложь;
	Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
			Группировка.Добавить(СтрокаДляРасшифровки);
			
			Если СтрокаГруппировки.Поле = "Документ" Тогда
				ЕстьГруппировкаПоДокументу = Истина;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЕстьГруппировкаПоДокументу Тогда
		
		СтрокаДляРасшифровки = Новый Структура();
		СтрокаДляРасшифровки.Вставить("Использование", 	Истина);
		СтрокаДляРасшифровки.Вставить("Поле", 			"Документ");
		СтрокаДляРасшифровки.Вставить("Представление", 	"Документ");
		СтрокаДляРасшифровки.Вставить("ТипГруппировки", 0);
		
		Группировка.Добавить(СтрокаДляРасшифровки);
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Группировка", Группировка);
	
	СписокПунктовМеню.Добавить("Продажи", "Продажи");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("Продажи", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Сумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Формирует таблицу данных для монитора руководителя по организации за период
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаКон - Дата - дата конца периода
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьПродажиДляМонитораРуководителя(Организация, ДатаКон) Экспорт
	
	НачалоГода            = НачалоГода(ДатаКон);
	НачалоМесяца          = НачалоМесяца(ДатаКон);
	НачалоПрошлогоМесяца  = ДобавитьМесяц(НачалоМесяца, -1);
	КонецПрошлогоМесяца   = КонецМесяца(НачалоПрошлогоМесяца);
	НачалоПрошлогоПериода = НачалоГода(НачалоПрошлогоМесяца);
	КонецПериода          = КонецДня(ДатаКон);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("НачалоГода",            НачалоГода);
	Запрос.УстановитьПараметр("НачалоМесяца",          НачалоМесяца);
	Запрос.УстановитьПараметр("НачалоПрошлогоМесяца",  НачалоПрошлогоМесяца);
	Запрос.УстановитьПараметр("НачалоПрошлогоПериода", НачалоПрошлогоПериода);
	Запрос.УстановитьПараметр("КонецПрошлогоМесяца",   КонецПрошлогоМесяца);
	Запрос.УстановитьПараметр("КонецПериода",          КонецПериода);
	Запрос.УстановитьПараметр("КонецПериодаГраница",   Новый Граница(КонецПериода));
	
	
	СчетаВыручки = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.Выручка);
	Запрос.УстановитьПараметр("СчетаВыручки", СчетаВыручки);
		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период = &НачалоМесяца
	|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
	|				ИНАЧЕ 0
	|			КОНЕЦ), 0) КАК ПродажиТекущийМесяц,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период МЕЖДУ &НачалоГода И &КонецПериода
	|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
	|				ИНАЧЕ 0
	|			КОНЕЦ), 0) КАК ПродажиТекущийГод,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период = &НачалоПрошлогоМесяца
	|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
	|				ИНАЧЕ 0
	|			КОНЕЦ), 0) КАК ПродажиПрошлыйМесяц,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период МЕЖДУ &НачалоПрошлогоПериода И &КонецПрошлогоМесяца
	|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
	|				ИНАЧЕ 0
	|			КОНЕЦ), 0) КАК ПродажиПрошлыйПериод
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПрошлогоПериода, &КонецПериодаГраница, Месяц, Счет В (&СчетаВыручки), , Организация = &Организация, , ) КАК ХозрасчетныйОборотыПоМесяцам";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	СуммаТекущийМесяц = 0;
	СуммаПрошлыйМесяц = 0;
	СуммаТекущийГод  = 0;
	СуммаПрошлыйПериод  = 0;
	
	Если Результат.Следующий() Тогда
		СуммаТекущийМесяц  = Результат.ПродажиТекущийМесяц;
		СуммаТекущийГод    = Результат.ПродажиТекущийГод;
		СуммаПрошлыйМесяц  = Результат.ПродажиПрошлыйМесяц;
		СуммаПрошлыйПериод = Результат.ПродажиПрошлыйПериод;
	Конецесли;
	
	ПредставлениеТекущегоМесяца            = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоМесяца, КонецПериода);
	ПредставлениеТекущегоМесяцаСНачалаГода = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоГода, КонецПериода);
	ПредставлениеПрошлогоМесяца            = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоПрошлогоМесяца, КонецПрошлогоМесяца);
	ПредставлениеПрошлогоМесяцаСНачалаГода = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоПрошлогоПериода, КонецПрошлогоМесяца);
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
		
	СтрокаТаблицы = ТаблицаДанных.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеТекущегоМесяца;
	СтрокаТаблицы.Сумма 		= СуммаТекущийМесяц;
	СтрокаТаблицы.Порядок		= ПорядокТекущегоМесяца();
	
	СтрокаТаблицы = ТаблицаДанных.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеТекущегоМесяцаСНачалаГода;
	СтрокаТаблицы.Сумма 		= СуммаТекущийГод;
	СтрокаТаблицы.Порядок		= ПорядокТекущегоМесяцаСНачалаГода();
	
	СтрокаТаблицы = ТаблицаДанных.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеПрошлогоМесяца;
	СтрокаТаблицы.Сумма 		= СуммаПрошлыйМесяц;
	СтрокаТаблицы.Порядок		= ПорядокПрошлогоМесяца();
	
	СтрокаТаблицы = ТаблицаДанных.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеПрошлогоМесяцаСНачалаГода;
	СтрокаТаблицы.Сумма 		= СуммаПрошлыйПериод;
	СтрокаТаблицы.Порядок		= ПорядокПрошлогоМесяцаСНачалаГода();
		
	Возврат ТаблицаДанных;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	Для Каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Вставить("Показатель" + Показатель, Ложь);
	КонецЦикла;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("Периодичность"                    , 0);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("НаборПоказателей"     , ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	ПараметрыОтчета.Вставить("КлючТекущегоВарианта" , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьВыводЗаголовкаДиаграммы(Диаграмма, ВыводитьЗаголовок)
	
	ПараметрВыводитьЗаголовок = Диаграмма.ПараметрыВывода.Элементы.Найти("ВыводитьЗаголовок");
	Если ПараметрВыводитьЗаголовок <> Неопределено Тогда
		Если ВыводитьЗаголовок Тогда
			ПараметрВыводитьЗаголовок.Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить;
		Иначе
			ПараметрВыводитьЗаголовок.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьГруппировкуДиаграммы(ПолеВыбраннойГруппировки, Группировка)
	
	ПолеГруппировки = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
	
	Если ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
		
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
		
	Иначе
		// Для типа группировки Иерахия, выводим только элементы,
		// чтобы группы не учавствовали в диаграмме наравне с элементами.
		
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		
	КонецЕсли;
	
	ЭлементВыбора = Группировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ЭлементВыбора.Поле = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
	
	Группировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
КонецПроцедуры

Функция ПорядокТекущегоМесяца() Экспорт
	
	Возврат 1;
	
КонецФункции

Функция ПорядокТекущегоМесяцаСНачалаГода() Экспорт
	
	Возврат 2;
	
КонецФункции

Функция ПорядокПрошлогоМесяца() Экспорт
	
	Возврат 3;
	
КонецФункции

Функция ПорядокПрошлогоМесяцаСНачалаГода() Экспорт
	
	Возврат 4;
	
КонецФункции

#КонецОбласти

#КонецЕсли