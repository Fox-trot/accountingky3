﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру контактной информации по типу.
//
// Параметры:
//  ТипКИ - ПеречислениеСсылка.ТипыКонтактнойИнформации	 - тип контактной информации.
//  ФорматАдреса - Строка - Тип возвращаемой структуры в зависимости от формата адреса: "КЛАДР" или "ФИАС" информацию.
// 
// Возвращаемое значение:
//  Структура - пустая структура контактной информации, ключи - имена полей, значения поля.
//
Функция СтруктураКонтактнойИнформацииПоТипу(ТипКИ, ФорматАдреса = "КЛАДР") Экспорт
	
	Если ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Возврат СтруктураПолейАдреса(ФорматАдреса);
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		Возврат УправлениеКонтактнойИнформациейКлиентСервер.СтруктураПолейТелефона();
	Иначе
		Возврат Новый Структура;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XPath для района.
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathРайона() Экспорт
	
	Возврат "СвРайМО/Район";
	
КонецФункции

// Возвращает массив структур с информацией о частях адреса согласно приказу ФНС ММВ-7-1/525 от 31.08.2011.
//
// Возвращаемое значение:
//      Массив - содержит структуры - описания.
//
Функция ТипыОбъектовАдресацииАдресаРФ() Экспорт
	
	Результат = Новый Массив;
	
	// Код, Наименование, Тип, Порядок, КодФИАС
	// Тип: 1 - владение, 2 - здание, 3 - помещение.
	
	Результат.Добавить(СтрокаОбъектаАдресации("1010", НСтр("ru = 'Дом'"),          1, 1, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("1020", НСтр("ru = 'Владение'"),     1, 2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1030", НСтр("ru = 'Домовладение'"), 1, 3, 3));
	
	Результат.Добавить(СтрокаОбъектаАдресации("1050", НСтр("ru = 'Корпус'"),     2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1060", НСтр("ru = 'Строение'"),   2, 2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1080", НСтр("ru = 'Литера'"),     2, 3, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("1070", НСтр("ru = 'Сооружение'"), 2, 4, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("1040", НСтр("ru = 'Участок'"),    2, 5));
	
	Результат.Добавить(СтрокаОбъектаАдресации("2010", НСтр("ru = 'Квартира'"),  3, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("2030", НСтр("ru = 'Офис'"),      3, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("2040", НСтр("ru = 'Бокс'"),      3, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("2020", НСтр("ru = 'Помещение'"), 3, 4));
	Результат.Добавить(СтрокаОбъектаАдресации("2050", НСтр("ru = 'Комната'"),   3, 5));
	Результат.Добавить(СтрокаОбъектаАдресации("2060", НСтр("ru = 'Этаж'"),      3, 6));
	Результат.Добавить(СтрокаОбъектаАдресации("2070", НСтр("ru = 'А/я'"),       3, 7));
	Результат.Добавить(СтрокаОбъектаАдресации("2080", НСтр("ru = 'В/ч'"),       3, 8));
	Результат.Добавить(СтрокаОбъектаАдресации("2090", НСтр("ru = 'П/о'"),       3, 9));
	//  Наши сокращения для поддержки обратной совместимости при парсинге.
	Результат.Добавить(СтрокаОбъектаАдресации("2010", НСтр("ru = 'кв.'"),       3, 6));
	Результат.Добавить(СтрокаОбъектаАдресации("2030", НСтр("ru = 'оф.'"),       3, 7));
	
	// Уточняющие объекты
	Результат.Добавить(СтрокаОбъектаАдресации("10100000", НСтр("ru = 'Почтовый индекс'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10200000", НСтр("ru = 'Адресная точка'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10300000", НСтр("ru = 'Садовое товарищество'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10400000", НСтр("ru = 'Элемент улично-дорожной сети, планировочной структуры дополнительного адресного элемента'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10500000", НСтр("ru = 'Промышленная зона'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10600000", НСтр("ru = 'Гаражно-строительный кооператив'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10700000", НСтр("ru = 'Территория'")));
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает код дополнительной части адреса для сериализации.
//
//  Параметры:
//      СтрокаЗначения - Строка - значение для поиска, например "Дом", "Корпус", "Литера".
//
// Возвращаемое значение:
//      Число - код
// 
Функция КодСериализацииОбъектаАдресации(СтрокаЗначения) Экспорт
	
	Ключ = ВРег(СокрЛП(СтрокаЗначения));
	Для Каждого Элемент Из ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Ключ = Ключ Тогда
			Возврат Элемент.Код;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Возвращает код дополнительной части адреса для почтового индекса.
//
// Возвращаемое значение:
//      Строка - код
//
Функция КодСериализацииПочтовогоИндекса() Экспорт
	
	Возврат КодСериализацииОбъектаАдресации(НСтр("ru = 'Почтовый индекс'"));
	
КонецФункции

// Возвращает XPath для почтового индекса.
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathПочтовогоИндекса() Экспорт
	
	Возврат "ДопАдрЭл[ТипАдрЭл='" + КодСериализацииПочтовогоИндекса() + "']";
	
КонецФункции

Функция КодСериализацииДополнительногоОбъектаАдресации(Уровень, ТипаАдресногоЭлемента = "") Экспорт
	
	Если Уровень = 90 Тогда
		Если ВРег(ТипаАдресногоЭлемента) = "ГСК" Тогда
			Возврат "10600000";
		ИначеЕсли ВРег(ТипаАдресногоЭлемента) = "СНТ" Тогда
			Возврат "10300000";
		ИначеЕсли ВРег(ТипаАдресногоЭлемента) = "ТЕР" Тогда
			Возврат "10700000";
		Иначе
			Возврат "10200000";
		КонецЕсли;
	ИначеЕсли Уровень = 91 Тогда
		Возврат "10400000";
	КонецЕсли;
	
	// Все остальное - считаем ориентиром.
	Возврат "Местоположение";
КонецФункции

// Возвращает XPath для дополнительного объекта адресации по умолчанию.
//
//  Параметры;
//      Уровень - Число - уровень объекта. 90  - дополнительный(Варианты: ГСК, СНТ, ТЕР), 91 - подчиненный, -1 -
//                        Ориентир.
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathДополнительногоОбъектаАдресации(Уровень, ТипаАдресногоЭлемента = "") Экспорт
	КодСериализации = КодСериализацииДополнительногоОбъектаАдресации(Уровень, ТипаАдресногоЭлемента);
	Возврат "ДопАдрЭл[ТипАдрЭл='" + КодСериализации + "']";
КонецФункции

// Возвращает XPath для номера дополнительного объекта адресации.
//
//  Параметры;
//      СтрокаЗначения - Строка - искомый тип, например "Дом", "Корпус".
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathНомераДополнительногоОбъектаАдресации(СтрокаЗначения) Экспорт
	
	Код = КодСериализацииОбъектаАдресации(СтрокаЗначения);
	Если Код = Неопределено Тогда
		Код = СтрЗаменить(СтрокаЗначения, "'", "");
	КонецЕсли;
	
	Возврат "ДопАдрЭл/Номер[Тип='" + Код + "']";
КонецФункции

// Возвращает строку с описанием типа по коду части адреса.
//  Противоположность функции "КодСериализацииОбъектаАдресации".
//
// Параметры:
//      Код - Строка - код
//
// Возвращаемое значение:
//      Число - Тип
//
Функция ТипОбъектаПоКодуСериализации(Код) Экспорт
	Для Каждого Элемент Из ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Код = Код Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Возвращает массив вариантов наименований по типу (по признаку владения, строения, и т.п).
//
// Параметры:
//      Тип                  - Число  - запрашиваемый тип.
//      ДопускатьПовторыКода - Булево - Истина - будут возвращены все варианты с повторами ("квартира" - "кв." и т.п.).
//
// Возвращаемое значение:
//      Массив - содержит структуры - описания.
//
Функция НаименованияОбъектовАдресацииПоТипу(Тип, ДопускатьПовторыКода = Истина) Экспорт
	Результат = Новый Массив;
	Повторы   = Новый Соответствие;
	
	Для Каждого Элемент Из ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Тип = Тип Тогда
			Если ДопускатьПовторыКода Тогда
				Результат.Добавить(Элемент.Наименование);
			Иначе
				Если Повторы.Получить(Элемент.Код) = Неопределено Тогда
					Результат.Добавить(Элемент.Наименование);
				КонецЕсли;
				Повторы.Вставить(Элемент.Код, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции    

// Возвращает сокращения частей адреса
//
// Возвращаемое значение:
//      Соответствие - Список сокращений.
//
Функция СокращенияОбъектовАдресацииАдресаРФ() Экспорт
	
	Результат = Новый Соответствие;
	
	Результат.Вставить(НСтр("ru = 'Дом'"), НСтр("ru = 'Д.'"));
	Результат.Вставить(НСтр("ru = 'Владение'"), НСтр("ru = 'Вл.'"));
	Результат.Вставить(НСтр("ru = 'Домовладение'"), НСтр("ru = 'Домовл.'"));
	
	Результат.Вставить(НСтр("ru = 'Корпус'"), НСтр("ru = 'Корп.'"));
	Результат.Вставить(НСтр("ru = 'Строение'"), НСтр("ru = 'Стр.'"));
	Результат.Вставить(НСтр("ru = 'Литера'"), НСтр("ru = 'Лит.'"));
	Результат.Вставить(НСтр("ru = 'Сооружение'"), НСтр("ru = 'Сооруж.'"));
	Результат.Вставить(НСтр("ru = 'Участок'"), НСтр("ru = 'Уч.'"));
	
	Результат.Вставить(НСтр("ru = 'Квартира'"), НСтр("ru = 'Кв.'"));
	Результат.Вставить(НСтр("ru = 'Офис'"), НСтр("ru = 'Оф.'"));
	Результат.Вставить(НСтр("ru = 'Бокс'"), НСтр("ru = 'Бокс'"));
	Результат.Вставить(НСтр("ru = 'Помещение'"), НСтр("ru = 'Пом.'"));
	Результат.Вставить(НСтр("ru = 'Комната'"), НСтр("ru = 'Ком.'"));
	Результат.Вставить(НСтр("ru = 'Этаж'"), НСтр("ru = 'Этаж'"));
	Результат.Вставить(НСтр("ru = 'А/я'"), НСтр("ru = 'а/я'"));
	Результат.Вставить(НСтр("ru = 'П/о'"), НСтр("ru = 'п/о'"));
	Результат.Вставить(НСтр("ru = 'В/ч'"), НСтр("ru = 'в/ч'"));
	
	Возврат Результат;
КонецФункции

Функция СтрокаОбъектаАдресации(Код, Наименование, Тип = 0, Порядок = 0, КодФИАС = 0)
	
	СтруктураОбъектаАдресации = Новый Структура;
	СтруктураОбъектаАдресации.Вставить("Код", Код);
	СтруктураОбъектаАдресации.Вставить("Наименование", Наименование);
	СтруктураОбъектаАдресации.Вставить("Тип", Тип);
	СтруктураОбъектаАдресации.Вставить("Порядок", Порядок);
	СтруктураОбъектаАдресации.Вставить("КодФИАС", КодФИАС);
	СтруктураОбъектаАдресации.Вставить("Сокращение", НРег(Наименование));
	СтруктураОбъектаАдресации.Вставить("Ключ", ВРег(Наименование));
	Возврат СтруктураОбъектаАдресации;
	
КонецФункции

// Возвращает структуру, описывающую населенный пункт в иерархии младший-старший.
//
//  Параметры:
//      ВариантКлассификатора  Строка - Требуемый вид классификатора ФИАС, КЛАДР.
// 
// Возвращаемое значение:
//      Структура - описание населенного пункта.
//
Функция СтруктураЧастейАдресаНаселенногоПункта(ВариантКлассификатора = "ФИАС") Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("Регион",           ЭлементАдреснойСтруктуры(НСтр("ru = 'Регион'"),      НСтр("ru = 'Регион адреса'"),           "СубъектРФ",     1));
	Если ВариантКлассификатора = "ФИАС" Тогда
		Результат.Вставить("Округ",        ЭлементАдреснойСтруктуры(НСтр("ru = 'Округ'"),       НСтр("ru = 'Округ адреса'"),            "Округ",         2));
	КонецЕсли;
	Результат.Вставить("Район",            ЭлементАдреснойСтруктуры(НСтр("ru = 'Район'"),       НСтр("ru = 'Район адреса'"),            "СвРайМО/Район", 3));
	Результат.Вставить("Город",            ЭлементАдреснойСтруктуры(НСтр("ru = 'Город'"),       НСтр("ru = 'Город адреса'"),            "Город",         4));
	Если ВариантКлассификатора = "ФИАС" Тогда
		Результат.Вставить("ВнутригРайон", ЭлементАдреснойСтруктуры(НСтр("ru = 'Внутр. р-н.'"), НСтр("ru = 'Внутригородской район'"),   "ВнутригРайон",  5));
	КонецЕсли;
	Результат.Вставить("НаселенныйПункт", ЭлементАдреснойСтруктуры(НСтр("ru = 'Нас.пункт'"),
		НСтр("ru = 'Населенный пункт адреса'"), "НаселПункт",  6, Истина));
		
	Если ВариантКлассификатора <> "БезКлассификатора" Тогда
		Результат.Вставить("Улица", ЭлементАдреснойСтруктуры(НСтр("ru = 'Улица'"),
			НСтр("ru = 'Улица адреса'"), "Улица", 7));
		Результат.Вставить("ДополнительныйЭлемент", ЭлементАдреснойСтруктуры(НСтр("ru = 'ДополнительныйЭлемент'"),
			НСтр("ru = 'Дополнительный элемент адреса'"), "ДопАдрЭл[ТипАдрЭл='10200000']", 90));
		Результат.Вставить("ПодчиненныйЭлемент", ЭлементАдреснойСтруктуры(НСтр("ru = 'Подчиненный элемент'"),
			НСтр("ru = 'Подчиненный элемент адреса'"), "ДопАдрЭл[ТипАдрЭл='10400000']", 91));
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает полное наименование для населенного пункта. Под населенным пунктом понимается синтетическое 
//  поле, характеризующее все, что больше улицы.
//
//  Параметры:
//      ЧастиАдреса           - Структура - Описание текущего состояния адреса.
//      ВариантКлассификатора - Строка    - Вариант классификатора.
//
Функция ПредставлениеНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса, ВариантКлассификатора = "ФИАС") Экспорт
	
	Уровни = Новый Массив;
	Уровни.Добавить(1);
	Уровни.Добавить(3);
	Уровни.Добавить(4);
	Уровни.Добавить(6);
	Если ВариантКлассификатора = "ФИАС" Тогда
		Уровни.Добавить(2);
		Уровни.Добавить(5);
	КонецЕсли;
	Возврат ПредставлениеПоЧастямАдреса(ЧастиАдреса,Уровни);
	
КонецФункции

#Область ПрочиеСлужебныеПроцедурыИФункции

// Строка представления по частям адреса в нужном порядке.
//
Функция ПредставлениеПоЧастямАдреса(ЧастиАдреса, Уровни)
	
	Эталон = СтруктураЧастейАдресаНаселенногоПункта();
	
	Порядок = Новый СписокЗначений;
	Для Каждого КлючЗначение Из Эталон Цикл
		Если Уровни.Найти(КлючЗначение.Значение.Уровень) <> Неопределено Тогда
			Порядок.Добавить(КлючЗначение.Значение.Уровень, КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Порядок.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
	Результат = "";
	Для Каждого ЭлементСписка Из Порядок Цикл
		ИмяРеквизита = ЭлементСписка.Представление;
		Если ЧастиАдреса.Свойство(ИмяРеквизита) Тогда
			ЧастьПредставления = ЧастиАдреса[ИмяРеквизита].Представление;
			Если Не ПустаяСтрока(ЧастьПредставления) Тогда
				Результат = Результат + ", " + ЧастьПредставления;
			КонецЕсли;
		КонецЕсли
	КонецЦикла;
	
	Возврат СокрЛП(Сред(Результат, 2));
КонецФункции

// Конструктор внутренней структуры элемента адреса.
//
Функция ЭлементАдреснойСтруктуры(Заголовок, Подсказка, ПутьXPath, Уровень, Предопределенный = Ложь)
	
	Результат = Новый Структура("Наименование, Сокращение, Идентификатор, Представление");
	Результат.Вставить("Заголовок",        Заголовок);
	Результат.Вставить("Подсказка",        Подсказка);
	Результат.Вставить("ПутьXPath",        ПутьXPath);
	Результат.Вставить("Предопределенный", Предопределенный);
	Результат.Вставить("Уровень",          Уровень);
	
	Возврат Результат;
КонецФункции

// Возвращает пустую структура адреса.
//
// Возвращаемое значение:
//    Структура - адрес, ключи - имена полей, значения поля.
//
Функция СтруктураПолейАдреса(ФорматАдреса)
	
	СтруктураАдреса = Новый Структура;
	СтруктураАдреса.Вставить("Представление", "");
	СтруктураАдреса.Вставить("Страна", "");
	СтруктураАдреса.Вставить("НаименованиеСтраны", "");
	СтруктураАдреса.Вставить("КодСтраны","");
	СтруктураАдреса.Вставить("Индекс","");
	СтруктураАдреса.Вставить("Регион","");
	СтруктураАдреса.Вставить("РегионСокращение","");
	СтруктураАдреса.Вставить("Район","");
	СтруктураАдреса.Вставить("РайонСокращение","");
	СтруктураАдреса.Вставить("Город","");
	СтруктураАдреса.Вставить("ГородСокращение","");
	СтруктураАдреса.Вставить("НаселенныйПункт","");
	СтруктураАдреса.Вставить("НаселенныйПунктСокращение","");
	СтруктураАдреса.Вставить("Улица","");
	СтруктураАдреса.Вставить("УлицаСокращение","");
	СтруктураАдреса.Вставить("Дом","");
	СтруктураАдреса.Вставить("Корпус","");
	СтруктураАдреса.Вставить("Квартира","");
	СтруктураАдреса.Вставить("ТипДома","");
	СтруктураАдреса.Вставить("ТипКорпуса","");
	СтруктураАдреса.Вставить("ТипКвартиры","");
	СтруктураАдреса.Вставить("НаименованиеВида","");
	
	Если ВРег(ФорматАдреса) = "ФИАС" Тогда
		СтруктураАдреса.Вставить("Округ","");
		СтруктураАдреса.Вставить("ОкругСокращение","");
		СтруктураАдреса.Вставить("ВнутригородскойРайон","");
		СтруктураАдреса.Вставить("ВнутригородскойРайонСокращение","");
	КонецЕсли;
	
	Возврат СтруктураАдреса;
	
КонецФункции

// Возвращает строку списка полей.
//
// Параметры:
//    СоответствиеПолей - СписокЗначений - соответствия полей.
//    БезПустыхПолей    - Булево - необязательный флаг сохранения полей с пустыми значениями.
//
//  Возвращаемое значение:
//     Строка - результат, преобразованный из списка.
//
Функция ПреобразоватьСписокПолейВСтроку(СоответствиеПолей, БезПустыхПолей = Истина) Экспорт
	
	КвартираДобавлена = Ложь;
	КорпусДобавлен = Ложь;
	ПредыдущиеЗначение = Неопределено;
	
	СтруктураЗначенийПолей = Новый Структура;
	Для Каждого Элемент Из СоответствиеПолей Цикл
		
		Если Элемент.Представление = "Корпус" ИЛИ Элемент.Представление = "ТипКорпуса" Тогда
			Если ПредыдущиеЗначение <> Неопределено И ПредыдущиеЗначение.Представление = "ТипКорпуса"
				И ПредыдущиеЗначение.Значение = "Корпус" Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);
				КорпусДобавлен = Истина;
			ИначеЕсли НЕ КорпусДобавлен Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);
			КонецЕсли;
		ИначеЕсли Элемент.Представление = "Квартира" ИЛИ Элемент.Представление = "ТипКвартиры" Тогда
			Если ПредыдущиеЗначение <> Неопределено И ПредыдущиеЗначение.Представление = "ТипКвартиры"
				И ПредыдущиеЗначение.Значение = "Квартира" Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);
				КвартираДобавлена = Истина;
			ИначеЕсли НЕ КвартираДобавлена Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);				
			КонецЕсли;
		Иначе
			СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);	
		КонецЕсли;
		ПредыдущиеЗначение = Элемент;
	КонецЦикла;
	
	Возврат СтрокаПолей(СтруктураЗначенийПолей, БезПустыхПолей);
КонецФункции

//  Возвращает строку списка полей.
//
//  Параметры:
//    СтруктураЗначенийПолей - Структура - структура значений полей.
//    БезПустыхПолей         - Булево - необязательный флаг сохранения полей с пустыми значениями.
//
//  Возвращаемое значение:
///     Строка - результат преобразования из структуры.
//
Функция СтрокаПолей(СтруктураЗначенийПолей, БезПустыхПолей = Истина) Экспорт
	
	Результат = "";
	Для Каждого ЗначениеПоля Из СтруктураЗначенийПолей Цикл
		Если БезПустыхПолей И ПустаяСтрока(ЗначениеПоля.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат = Результат + ?(Результат = "", "", Символы.ПС)
		            + ЗначениеПоля.Ключ + "=" + СтрЗаменить(ЗначениеПоля.Значение, Символы.ПС, Символы.ПС + Символы.Таб);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции


#КонецОбласти

#КонецОбласти
