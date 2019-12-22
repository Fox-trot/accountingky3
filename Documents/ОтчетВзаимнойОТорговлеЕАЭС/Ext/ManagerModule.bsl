﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой ПечатьНакладной
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьОсновнойФормы(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос();                  
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтчетВзаимнойОТорговлеЕАЭС.Ссылка КАК Ссылка,
		|	ОтчетВзаимнойОТорговлеЕАЭС.Дата КАК Дата,
		|	ОтчетВзаимнойОТорговлеЕАЭС.Организация КАК Организация
		|ИЗ
		|	Документ.ОтчетВзаимнойОТорговлеЕАЭС КАК ОтчетВзаимнойОТорговлеЕАЭС
		|ГДЕ
		|	ОтчетВзаимнойОТорговлеЕАЭС.Ссылка В (&СписокДокументов)";		
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетОТорговлеЕАЭС_ОсновнаяФорма";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетВзаимнойОТорговлеЕАЭС.ПФ_MXL_ОтчетОВзаимнойТорговлеЕАЭС");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
		СтруктураПоиска = Новый Структура();
		СтруктураПоиска.Вставить("Ссылка", Шапка.Ссылка);
		
		// Заполнение областей основного макета
		ОбластьМакета = Макет.ПолучитьОбласть("АдреснаяЧасть");
		
		Организация = Шапка.Организация;
		Период 		= Шапка.Дата;
		
		КонтактныеДанные = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСведенияОбОрганизации(Организация, Период);

		Если Месяц(Период) = 1 Тогда
			Месяц = НСтр("ru = 'Январь'");
			
		ИначеЕсли Месяц(Период) = 2 Тогда	
			Месяц = НСтр("ru = 'Февраль'");
			
		ИначеЕсли Месяц(Период) = 3 Тогда	
			Месяц = НСтр("ru = 'Март'");
			
		ИначеЕсли Месяц(Период) = 4 Тогда	
			Месяц = НСтр("ru = 'Апрель'");
			
		ИначеЕсли Месяц(Период) = 5 Тогда	
			Месяц = НСтр("ru = 'Май'");
			
		ИначеЕсли Месяц(Период) = 6 Тогда	
			Месяц = НСтр("ru = 'Июнь'");
			
		ИначеЕсли Месяц(Период) = 7 Тогда	
			Месяц = НСтр("ru = 'Июль'");
			
		ИначеЕсли Месяц(Период) = 8 Тогда	
			Месяц = НСтр("ru = 'Август'");
			
		ИначеЕсли Месяц(Период) = 9 Тогда	
			Месяц = НСтр("ru = 'Сентябрь'");
			
		ИначеЕсли Месяц(Период) = 10 Тогда	
			Месяц = НСтр("ru = 'Октябрь'");
			
		ИначеЕсли Месяц(Период) = 11 Тогда	
			Месяц = НСтр("ru = 'Ноябрь'");
			
		ИначеЕсли Месяц(Период) = 12 Тогда	
			Месяц = НСтр("ru = 'Декабрь'");
		КонецЕсли;
		
		Год								= Формат(Год(Период), "ЧГ=");
		ОКПО              				= КонтактныеДанные.ОКПО;
		СОАТО                           = КонтактныеДанные.СОАТО;
		ИНН 							= КонтактныеДанные.ИНН;
		ОрганизацияНаменованиеПолное    = КонтактныеДанные.НаименованиеПолное;
		Город  							= КонтактныеДанные.Город;
		Улица							= КонтактныеДанные.Улица; 
		Телефон							= КонтактныеДанные.Тел; 
		
		ДанныеПечати = Новый Структура();
		ДанныеПечати.Вставить("Месяц", 			Месяц);
		ДанныеПечати.Вставить("Год", 			Год);
		ДанныеПечати.Вставить("Организация", 	ОрганизацияНаменованиеПолное);
		ДанныеПечати.Вставить("Город", 			Город);
		ДанныеПечати.Вставить("Адрес", 			Улица);
		ДанныеПечати.Вставить("Телефон", 		Телефон);
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		
		ОбластьМакета.Параметры.ИНН1 = Сред(ИНН, 1, 1);
		ОбластьМакета.Параметры.ИНН2 = Сред(ИНН, 2, 1);
		ОбластьМакета.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
		ОбластьМакета.Параметры.ИНН4 = Сред(ИНН, 4, 1);
		ОбластьМакета.Параметры.ИНН5 = Сред(ИНН, 5, 1);
		ОбластьМакета.Параметры.ИНН6 = Сред(ИНН, 6, 1);
		ОбластьМакета.Параметры.ИНН7 = Сред(ИНН, 7, 1);
		ОбластьМакета.Параметры.ИНН8 = Сред(ИНН, 8, 1);
		ОбластьМакета.Параметры.ИНН9 = Сред(ИНН, 9, 1);
		ОбластьМакета.Параметры.ИНН10 = Сред(ИНН, 10, 1);
		ОбластьМакета.Параметры.ИНН11 = Сред(ИНН, 11, 1);
		ОбластьМакета.Параметры.ИНН12 = Сред(ИНН, 12, 1);
		ОбластьМакета.Параметры.ИНН13 = Сред(ИНН, 13, 1);
		ОбластьМакета.Параметры.ИНН14 = Сред(ИНН, 14, 1);         
		
		Если ЗначениеЗаполнено(СОАТО) Тогда
			ОбластьМакета.Параметры.СОАТО1 = Сред(СОАТО, 1, 1);
			ОбластьМакета.Параметры.СОАТО2 = Сред(СОАТО, 2, 1);
			ОбластьМакета.Параметры.СОАТО3 = Сред(СОАТО, 3, 1);                           
			ОбластьМакета.Параметры.СОАТО4 = Сред(СОАТО, 4, 1);
			ОбластьМакета.Параметры.СОАТО5 = Сред(СОАТО, 5, 1);
			ОбластьМакета.Параметры.СОАТО6 = Сред(СОАТО, 6, 1);
			ОбластьМакета.Параметры.СОАТО7 = Сред(СОАТО, 7, 1);
			ОбластьМакета.Параметры.СОАТО8 = Сред(СОАТО, 8, 1);
			ОбластьМакета.Параметры.СОАТО9 = Сред(СОАТО, 9, 1);
			ОбластьМакета.Параметры.СОАТО10 = Сред(СОАТО, 10, 1);
			ОбластьМакета.Параметры.СОАТО11 = Сред(СОАТО, 11, 1);
			ОбластьМакета.Параметры.СОАТО12 = Сред(СОАТО, 12, 1);
			ОбластьМакета.Параметры.СОАТО13 = Сред(СОАТО, 13, 1);
			ОбластьМакета.Параметры.СОАТО14 = Сред(СОАТО, 14, 1);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОКПО) Тогда 
			ОбластьМакета.Параметры.ОКПО1 = Сред(ОКПО,1,1);
			ОбластьМакета.Параметры.ОКПО2 = Сред(ОКПО,2,1);
			ОбластьМакета.Параметры.ОКПО3 = Сред(ОКПО,3,1);
			ОбластьМакета.Параметры.ОКПО4 = Сред(ОКПО,4,1);
			ОбластьМакета.Параметры.ОКПО5 = Сред(ОКПО,5,1);
			ОбластьМакета.Параметры.ОКПО6 = Сред(ОКПО,6,1);
			ОбластьМакета.Параметры.ОКПО7 = Сред(ОКПО,7,1);
			ОбластьМакета.Параметры.ОКПО8 = Сред(ОКПО,8,1);
		КонецЕсли;

		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

// Функция формирует табличный документ с печатной формой ПечатьНакладной
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьРазделов(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос();                  
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтчетВзаимнойОТорговлеЕАЭС.Ссылка КАК Ссылка,
		|	ОтчетВзаимнойОТорговлеЕАЭС.Организация КАК Организация,
		|	ОтчетВзаимнойОТорговлеЕАЭС.Дата КАК Дата
		|ИЗ
		|	Документ.ОтчетВзаимнойОТорговлеЕАЭС КАК ОтчетВзаимнойОТорговлеЕАЭС
		|ГДЕ
		|	ОтчетВзаимнойОТорговлеЕАЭС.Ссылка В(&СписокДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Ссылка КАК Ссылка,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.НомерСтроки КАК НомерСтроки,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Номенклатура КАК Номенклатура,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Вес КАК Вес,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Количество КАК Количество,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Сумма КАК Сумма,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.СуммаВДолларах КАК СуммаВДолларах,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Поставщик КАК Поставщик,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.ТоргующаяСтрана КАК ТоргующаяСтрана,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.КоммерческиеДокументы КАК КоммерческиеДокументы,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.СтранаОтправления КАК СтранаОтправления,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.СтранаНазначения КАК СтранаНазначения,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Транспортировка КАК Транспортировка,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.ВидТранспорта.Наименование КАК ВидТранспорта,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.ДополнительнаяИнформация КАК ДополнительнаяИнформация,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.КодОсобенностьПеремещенияТоваров КАК КодОсобенностьПеремещенияТоваров,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.НомерКонтракта КАК НомерКонтракта,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.ДатаКонтракта КАК ДатаКонтракта,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.ХарактерСделки КАК ХарактерСделки,
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ПОМЕСТИТЬ ВременнаяТаблицаИнформацияОТорговле
		|ИЗ
		|	Документ.ОтчетВзаимнойОТорговлеЕАЭС.ИнформацияОТорговле КАК ОтчетОТорговлеЕАЭСИнформацияОТорговле
		|ГДЕ
		|	ОтчетОТорговлеЕАЭСИнформацияОТорговле.Ссылка В(&СписокДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаИнформацияОТорговле.Ссылка КАК Ссылка,
		|	ВременнаяТаблицаИнформацияОТорговле.Поставщик КАК Поставщик,
		|	ВременнаяТаблицаИнформацияОТорговле.Поставщик.НаименованиеПолное КАК ПоставщикНаименованиеПолное,
		|	ВременнаяТаблицаИнформацияОТорговле.Поставщик.СтранаРезидентства.Код КАК КодСтраны,
		|	ВременнаяТаблицаИнформацияОТорговле.Поставщик.ИНН КАК ИНН
		|ИЗ
		|	ВременнаяТаблицаИнформацияОТорговле КАК ВременнаяТаблицаИнформацияОТорговле
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПоставщикНаименованиеПолное
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.Ссылка) КАК Ссылка,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.Поставщик) КАК Поставщик,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.Номенклатура) КАК Номенклатура,
		|	ВременнаяТаблицаИнформацияОТорговле.Номенклатура.КодТНВЭД КАК КодТНВЭД,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.ТоргующаяСтрана.НаименованиеПолное) КАК НаименованиеТоргующейСтрана,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.ТоргующаяСтрана.Код) КАК КодТоргующейСтрана,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.СтранаОтправления.НаименованиеПолное) КАК НаименованиеСтраныОтправления,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.СтранаОтправления.Код) КАК КодСтраныОтправления,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.СтранаНазначения.НаименованиеПолное) КАК НаименованиеСтраныНазначения,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.СтранаНазначения.Код) КАК КодСтраныНазначения,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.СтранаПроисхождения.НаименованиеПолное) КАК НаименованиеСтраныПроисхождения,
		|	МИНИМУМ(ВременнаяТаблицаИнформацияОТорговле.СтранаПроисхождения.Код) КАК КодСтраныПроисхождения
		|ИЗ
		|	ВременнаяТаблицаИнформацияОТорговле КАК ВременнаяТаблицаИнформацияОТорговле
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаИнформацияОТорговле.Номенклатура.КодТНВЭД
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.Ссылка) КАК Ссылка,
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.Поставщик) КАК Поставщик,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Морской транспорт""
		|			ТОГДА 10
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Железнодорожный вагон (платформа, цистера), расположенный на морском судне""
		|			ТОГДА 12
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Дорожное транспортное средство расположенное на морском судне""
		|			ТОГДА 16
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Прицеп или полуприцеп, расположенный на морском судне""
		|			ТОГДА 17
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Судно внутреннего водного транспорта на морском судне""
		|			ТОГДА 18
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Железнодорожный транспорт""
		|			ТОГДА 20
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Дорожное транспортное средство, расположенное на железнодорожной платформе (вагоне)""
		|			ТОГДА 23
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Автотранспортное средство""
		|			ТОГДА 30
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Состав автотранспортных средств (тягач с полуприцепом или прицепом)""
		|			ТОГДА 31
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Состав автотранспортных средств (тягач с полуприцепом и прицепом)""
		|			ТОГДА 32
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Воздушный транспорт""
		|			ТОГДА 40
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Почтовое отправление""
		|			ТОГДА 50
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Стационарный транспорт""
		|			ТОГДА 70
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Внутренний водный транспорт""
		|			ТОГДА 80
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Товар перемещающийся своим ходом""
		|			ТОГДА 90
		|	КОНЕЦ КАК КодВидаТранспортаНаГранице,
		|	СУММА(ВременнаяТаблицаИнформацияОТорговле.Вес) КАК ВесНетто,
		|	СУММА(ВременнаяТаблицаИнформацияОТорговле.Сумма) КАК ФактурнаяСтоимость,
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения КАК ЕИ,
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения.Код КАК ЕИКод,
		|	СУММА(ВременнаяТаблицаИнформацияОТорговле.Количество) КАК ЕИКоличество
		|ИЗ
		|	ВременнаяТаблицаИнформацияОТорговле КАК ВременнаяТаблицаИнформацияОТорговле
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаИнформацияОТорговле.Номенклатура.КодТНВЭД,
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения,
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения.Код,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Морской транспорт""
		|			ТОГДА 10
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Железнодорожный вагон (платформа, цистера), расположенный на морском судне""
		|			ТОГДА 12
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Дорожное транспортное средство расположенное на морском судне""
		|			ТОГДА 16
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Прицеп или полуприцеп, расположенный на морском судне""
		|			ТОГДА 17
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Судно внутреннего водного транспорта на морском судне""
		|			ТОГДА 18
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Железнодорожный транспорт""
		|			ТОГДА 20
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Дорожное транспортное средство, расположенное на железнодорожной платформе (вагоне)""
		|			ТОГДА 23
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Автотранспортное средство""
		|			ТОГДА 30
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Состав автотранспортных средств (тягач с полуприцепом или прицепом)""
		|			ТОГДА 31
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Состав автотранспортных средств (тягач с полуприцепом и прицепом)""
		|			ТОГДА 32
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Воздушный транспорт""
		|			ТОГДА 40
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Почтовое отправление""
		|			ТОГДА 50
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Стационарный транспорт""
		|			ТОГДА 70
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Внутренний водный транспорт""
		|			ТОГДА 80
		|		КОГДА ВременнаяТаблицаИнформацияОТорговле.ВидТранспорта = ""Товар перемещающийся своим ходом""
		|			ТОГДА 90
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.Ссылка) КАК Ссылка,
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.Поставщик) КАК Поставщик,
		|	СУММА(ВременнаяТаблицаИнформацияОТорговле.Сумма) КАК СтатистическаяСтоимостьСомы,
		|	СУММА(ВременнаяТаблицаИнформацияОТорговле.СуммаВДолларах) КАК СтатистическаяСтоимостьСША,
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.НомерКонтракта) КАК НомерКонтракта,
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.ДатаКонтракта) КАК ДатаКонтракта,
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.ХарактерСделки) КАК ХарактерСделки,
		|	МАКСИМУМ(ВременнаяТаблицаИнформацияОТорговле.КодОсобенностьПеремещенияТоваров) КАК НаправлениеПеремещения
		|ИЗ
		|	ВременнаяТаблицаИнформацияОТорговле КАК ВременнаяТаблицаИнформацияОТорговле
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаИнформацияОТорговле.Номенклатура.КодТНВЭД
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения КАК ЕИ,
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения.Код КАК ЕИКод,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения) КАК ЕИКоличество
		|ИЗ
		|	ВременнаяТаблицаИнформацияОТорговле КАК ВременнаяТаблицаИнформацияОТорговле
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения,
		|	ВременнаяТаблицаИнформацияОТорговле.ЕдиницаИзмерения.Код";		
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Шапка = МассивРезультатов[0].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетОТорговлеЕАЭС_Разделы";
	
	МакетРаздел1 	= УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетВзаимнойОТорговлеЕАЭС.ПФ_MXL_ТорговляЕАЭС_Раздел1");
	МакетРаздел2_1 	= УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетВзаимнойОТорговлеЕАЭС.ПФ_MXL_ТорговляЕАЭС_Раздел2_1");
	МакетРаздел2_2 	= УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетВзаимнойОТорговлеЕАЭС.ПФ_MXL_ТорговляЕАЭС_Раздел2_2");
	МакетРаздел2_3 	= УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетВзаимнойОТорговлеЕАЭС.ПФ_MXL_ТорговляЕАЭС_Раздел2_3");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
		СтруктураПоиска = Новый Структура();
		СтруктураПоиска.Вставить("Ссылка", Шапка.Ссылка);
		
		// Заполнение областей раздела 1
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ОбластьМакета = МакетРаздел1.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел1.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел1.ПолучитьОбласть("Строка");
		
		ТаблицаЗначений = МассивРезультатов[2].Выгрузить();
		
		МассивСтрок = ТаблицаЗначений.НайтиСтроки(СтруктураПоиска);
		
		ДанныеПечати = Новый Структура();
		ДанныеПечати.Вставить("НомерСтроки", 0);
		ДанныеПечати.Вставить("ОбластьГород", "");
		ДанныеПечати.Вставить("Адрес", "");
		
		Соответствие_1Раздел = Новый Соответствие();
		
		НомерСтроки = 1;
		Для Каждого СтрокаМассива Из МассивСтрок Цикл
			
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			АдресКонтрагента = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаМассива.Поставщик, Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
			
			СведенияОКонтрагенте = БухгалтерскийУчетСервер.ПолучитьСведенияОКонтрагенте(СтрокаМассива.Поставщик);
					
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ДанныеПечати.ОбластьГород = СведенияОКонтрагенте.Город;
			ДанныеПечати.Адрес = АдресКонтрагента;
			
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);		
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			Соответствие_1Раздел.Вставить(СтрокаМассива.Поставщик, НомерСтроки);
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;	
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Заполнение областей раздела 2.1
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ОбластьМакета = МакетРаздел2_1.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел2_1.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел2_1.ПолучитьОбласть("Строка");
		
		ТаблицаЗначений = МассивРезультатов[3].Выгрузить();
		
		МассивСтрок = ТаблицаЗначений.НайтиСтроки(СтруктураПоиска);
		
		ДанныеПечати.Вставить("КодСтрокиРаздела1", 0);
		
		НомерСтроки = 1;
		Для Каждого СтрокаМассива Из МассивСтрок Цикл
			
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ДанныеПечати.КодСтрокиРаздела1 = Соответствие_1Раздел.Получить(СтрокаМассива.Поставщик);

			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Заполнение областей раздела 2.2
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ОбластьМакета = МакетРаздел2_2.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел2_2.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел2_2.ПолучитьОбласть("Строка");
		
		ТаблицаЗначений = МассивРезультатов[4].Выгрузить();
		
		МассивСтрок = ТаблицаЗначений.НайтиСтроки(СтруктураПоиска);
		
		ДанныеПечати.Вставить("КодСтрокиРаздела1", 0);
		
		НомерСтроки = 1;
		Для Каждого СтрокаМассива Из МассивСтрок Цикл
			
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ДанныеПечати.КодСтрокиРаздела1 = Соответствие_1Раздел.Получить(СтрокаМассива.Поставщик);

			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Заполнение областей раздела 2.3
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ОбластьМакета = МакетРаздел2_3.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел2_3.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = МакетРаздел2_3.ПолучитьОбласть("Строка");
		
		ТаблицаЗначений = МассивРезультатов[5].Выгрузить();
		
		МассивСтрок = ТаблицаЗначений.НайтиСтроки(СтруктураПоиска);
		
		НомерСтроки = 1;
		Для Каждого СтрокаМассива Из МассивСтрок Цикл
			
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ДанныеПечати.КодСтрокиРаздела1 = Соответствие_1Раздел.Получить(СтрокаМассива.Поставщик);

			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.     
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;      
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОсновнаяФорма") Тогда
		 // Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ОсновнаяФорма",  
			НСтр("ru = 'Основная форма'"), 
			ПечатьОсновнойФормы(МассивОбъектов, ОбъектыПечати),,
			"Документ.УведомлениеОПолученииТоваров.ПФ_MXL_ОтчетОВзаимнойТорговлеЕАЭС");
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Разделы") Тогда
		 // Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Разделы",  
			НСтр("ru = 'Разделы'"), 
			ПечатьРазделов(МассивОбъектов, ОбъектыПечати),,
			"Документ.УведомлениеОПолученииТоваров.ПФ_MXL_ТорговляЕАЭС_Раздел1");
	КонецЕсли;	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
	Если НЕ Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		// Настраиваемый комплект документов.
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "ОсновнаяФорма,Разделы";
		КомандаПечати.Представление = НСтр("ru = 'Отчет о взаимной торговле ЕАЭС'");
		КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Отчет о взаимной торговле ЕАЭС'");
		КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
		КомандаПечати.Порядок = 1;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
