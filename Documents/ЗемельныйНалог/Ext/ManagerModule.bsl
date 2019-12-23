﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	&Содержание КАК Содержание,
		|	ВременнаяТаблицаШапка.СчетЗатрат КАК СчетДт,
		|	ВременнаяТаблицаШапка.СтатьяЗатрат КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.СчетУчета КАК СчетКт,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	СУММА(ВременнаяТаблицаУчастки.СуммаНалогаКУплате) КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаУчастки КАК ВременнаяТаблицаУчастки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.СчетЗатрат,
		|	ВременнаяТаблицаШапка.СчетУчета,
		|	ВременнаяТаблицаШапка.СтатьяЗатрат,
		|	ВременнаяТаблицаШапка.Организация";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Земельный налог'"));
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьЗемельныйНалог(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаНалоги.ОсновноеСредство КАК ОсновноеСредство,
		|	ВременнаяТаблицаНалоги.СуммаЗемельногоНалогаПодОбъектомИмущества КАК СуммаЗемельногоНалогаПодОбъектомИмущества
		|ИЗ
		|	ВременнаяТаблицаНалоги КАК ВременнаяТаблицаНалоги
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗемельныйНалог", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.СчетУчета,
		|	ТаблицаДокумента.СчетЗатрат,
		|	ТаблицаДокумента.СтатьяЗатрат
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ЗемельныйНалог КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Налоги.ОсновноеСредство,
		|	Налоги.СуммаЗемельногоНалогаПодОбъектомИмущества
		|ПОМЕСТИТЬ ВременнаяТаблицаНалоги
		|ИЗ
		|	Документ.ЗемельныйНалог.Налоги КАК Налоги
		|ГДЕ
		|	Налоги.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(Участки.СуммаНалогаКУплате) КАК СуммаНалогаКУплате
		|ПОМЕСТИТЬ ВременнаяТаблицаУчастки
		|ИЗ
		|	Документ.ЗемельныйНалог.Участки КАК Участки
		|ГДЕ
		|	Участки.Ссылка = &Ссылка";	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьЗемельныйНалог(ДокументСсылка, СтруктураДополнительныеСвойства);	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

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

Процедура ЗакончитьВыводТекущегоДокумента(Макет, ТабличныйДокумент, НомерЯчейки, СуммаИтог, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент, ФормаПечати)
	
	Если ФормаПечати = "Форма77" Тогда
		Пока НомерЯчейки <> 417 Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ОбластьДанных");
			ОбластьМакета.Параметры.ЕАЭС0 = НомерЯчейки;
			ОбластьМакета.Параметры.ЕАЭС1 = НомерЯчейки + 1;
			ОбластьМакета.Параметры.ЕАЭС2 = НомерЯчейки + 2;
			ОбластьМакета.Параметры.ЕАЭС3 = НомерЯчейки + 3;
			ОбластьМакета.Параметры.ЕАЭС4 = НомерЯчейки + 4;
			ОбластьМакета.Параметры.ЕАЭС5 = НомерЯчейки + 5;
			ОбластьМакета.Параметры.ЕАЭС6 = НомерЯчейки + 6;
			ОбластьМакета.Параметры.ЕАЭС7 = НомерЯчейки + 7;
			ОбластьМакета.Параметры.ЕАЭС8 = НомерЯчейки + 8;
			ОбластьМакета.Параметры.ЕАЭС9 = НомерЯчейки + 9;
			ОбластьМакета.Параметры.ЕАЭС10 = НомерЯчейки + 10;
			ОбластьМакета.Параметры.ЕАЭС11 = НомерЯчейки + 11;
			ОбластьМакета.Параметры.ЕАЭС12 = НомерЯчейки + 12;
			НомерЯчейки = НомерЯчейки + 13;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
	ИначеЕсли ФормаПечати = "Форма76" Тогда
		Пока НомерЯчейки <> 391 Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ОбластьДанных");
			ОбластьМакета.Параметры.ЕАЭС0 = НомерЯчейки;
			ОбластьМакета.Параметры.ЕАЭС1 = НомерЯчейки + 1;
			ОбластьМакета.Параметры.ЕАЭС2 = НомерЯчейки + 2;
			ОбластьМакета.Параметры.ЕАЭС3 = НомерЯчейки + 3;
			ОбластьМакета.Параметры.ЕАЭС4 = НомерЯчейки + 4;
			ОбластьМакета.Параметры.ЕАЭС5 = НомерЯчейки + 5;
			ОбластьМакета.Параметры.ЕАЭС6 = НомерЯчейки + 6;
			ОбластьМакета.Параметры.ЕАЭС7 = НомерЯчейки + 7;
			ОбластьМакета.Параметры.ЕАЭС8 = НомерЯчейки + 8;
			ОбластьМакета.Параметры.ЕАЭС9 = НомерЯчейки + 9;
			НомерЯчейки = НомерЯчейки + 10;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
	КонецЕсли;
	
	// Вывод областей итоги и подвал
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьИтоги");
	ОбластьМакета.Параметры.ИтогоСуммаНалога = СуммаИтог;
	ОбластьМакета.Параметры.СуммаНалогаКУплате = СуммаИтог;
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);			
	
	Если ФормаПечати = "Форма77" Тогда
		НомерЯчейки = 300;	
	ИначеЕсли ФормаПечати = "Форма76" Тогда
		НомерЯчейки = 301;	
	КонецЕсли;
	
	СуммаИтог = 0;	
КонецПроцедуры

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Организации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);
	
	ИНН 				= СведенияОбОрганизации.ИНН;	
	Индекс 				= СведенияОбОрганизации.Индекс; 
	ГНСНаименование 	= СведенияОбОрганизации.ГНСНаименование; 
	ГНСКод 				= СведенияОбОрганизации.ГНСКод;
	ОКПО 				= СведенияОбОрганизации.ОКПО;
	НаименованиеПолное 	= СведенияОбОрганизации.НаименованиеПолное;
	Телефон 			= СведенияОбОрганизации.Тел;
	
	ГородНасПункт = ?(СведенияОбОрганизации.Город  = "",СведенияОбОрганизации.НаселенныйПункт,СведенияОбОрганизации.Город);
	Область = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
		+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	УлицаДом = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
	
	Структура = Новый Структура();
	Структура.Вставить("ИНН", 				 ИНН);
	Структура.Вставить("Индекс", 			 Индекс);
	Структура.Вставить("ГНСНаименование", 	 ГНСНаименование);
	Структура.Вставить("ГНСКод", 			 ГНСКод);
	Структура.Вставить("ОКПО", 				 ОКПО);
	Структура.Вставить("НаименованиеПолное", НаименованиеПолное);
	Структура.Вставить("Область", 			 Область);
	Структура.Вставить("УлицаДом", 			 УлицаДом);
	Структура.Вставить("Телефон", 			 Телефон);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ФормаПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ЗемельныйНалог_ЗемельныйНалог";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Если ФормаПечати = "Форма77" Тогда
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗемельныйНалог.ПФ_MXL_ЗемельныйНалогФорма077");	
	ИначеЕсли ФормаПечати = "Форма76" Тогда                                   
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗемельныйНалог.ПФ_MXL_ЗемельныйНалогФорма076");	
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СведенияОбИмуществе.Период КАК Период,
		|	СведенияОбИмуществе.ОсновноеСредство КАК ОсновноеСредство,
		|	СведенияОбИмуществе.КодПользователяИмущества.Код КАК КодПользователяИмущества,
		|	СведенияОбИмуществе.КодИмущества КАК КодИмущества
		|ПОМЕСТИТЬ ВременнаяТаблицаСведенияОбИмуществе
		|ИЗ
		|	РегистрСведений.СведенияОбИмуществе КАК СведенияОбИмуществе
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СостоянияОС.Период КАК Период,
		|	СостоянияОС.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВременнаяТаблицаСостоянияОС
		|ИЗ
		|	РегистрСведений.СостоянияОС КАК СостоянияОС
		|ГДЕ
		|	СостоянияОС.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Налоги.Ссылка КАК Ссылка,
		|	Налоги.ОсновноеСредство КАК ОсновноеСредство,
		|	Налоги.СуммаЗемельногоНалогаПодОбъектомИмущества КАК СуммаНалога,
		|	МАКСИМУМ(ЕСТЬNULL(ВременнаяТаблицаСведенияОбИмуществе.Период, ДАТАВРЕМЯ(1,1,1))) КАК ПериодИмущества,
		|	МАКСИМУМ(ЕСТЬNULL(ВременнаяТаблицаСостоянияОС.Период, ДАТАВРЕМЯ(1,1,1))) КАК ПериодСостояния
		|ПОМЕСТИТЬ ВременнаяТаблицаМаксПериод
		|ИЗ
		|	Документ.ЗемельныйНалог.Налоги КАК Налоги
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСведенияОбИмуществе КАК ВременнаяТаблицаСведенияОбИмуществе
		|		ПО Налоги.ОсновноеСредство = ВременнаяТаблицаСведенияОбИмуществе.ОсновноеСредство
		|			И Налоги.Ссылка.Дата >= ВременнаяТаблицаСведенияОбИмуществе.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСостоянияОС КАК ВременнаяТаблицаСостоянияОС
		|		ПО Налоги.ОсновноеСредство = ВременнаяТаблицаСостоянияОС.ОсновноеСредство
		|			И Налоги.Ссылка.Дата >= ВременнаяТаблицаСостоянияОС.Период
		|ГДЕ
		|	Налоги.Ссылка В(&СписокДокументов)
		|
		|СГРУППИРОВАТЬ ПО
		|	Налоги.Ссылка,
		|	Налоги.ОсновноеСредство,
		|	Налоги.СуммаЗемельногоНалогаПодОбъектомИмущества
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаМаксПериод.Ссылка КАК Ссылка,
		|	ТаблицаМаксПериод.Ссылка.Дата КАК Дата,
		|	ТаблицаМаксПериод.Ссылка.Организация КАК Организация,
		|	ТаблицаМаксПериод.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаМаксПериод.ОсновноеСредство.МестонахождениеИмущества КАК МестонахождениеЗемельногоУчастка,
		|	ТаблицаМаксПериод.ОсновноеСредство.ИдентификационныйНомерИмущества КАК КодЗемельногоУчастка,
		|	ТаблицаМаксПериод.СуммаНалога КАК СуммаНалога,
		|	ЕСТЬNULL(ВременнаяТаблицаСведенияОбИмуществе.КодПользователяИмущества, ДАТАВРЕМЯ(1,1,1)) КАК КодПользователя,
		|	ЕСТЬNULL(ВременнаяТаблицаСведенияОбИмуществе.КодИмущества, ДАТАВРЕМЯ(1,1,1)) КАК КодПредпринимательскойДеятельности,
		|	РАЗНОСТЬДАТ(ТаблицаМаксПериод.ПериодСостояния, ТаблицаМаксПериод.Ссылка.Дата, МЕСЯЦ) КАК КоличествоМесяцевВладения
		|ИЗ
		|	ВременнаяТаблицаМаксПериод КАК ТаблицаМаксПериод
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаСведенияОбИмуществе КАК ВременнаяТаблицаСведенияОбИмуществе
		|		ПО ТаблицаМаксПериод.ОсновноеСредство = ВременнаяТаблицаСведенияОбИмуществе.ОсновноеСредство
		|			И ТаблицаМаксПериод.ПериодИмущества = ВременнаяТаблицаСведенияОбИмуществе.Период";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Если ФормаПечати = "Форма77" Тогда
		НомерЯчейки = 300;	
	ИначеЕсли ФормаПечати = "Форма76" Тогда
		НомерЯчейки = 301;	
	КонецЕсли;	
	
	НомерСтрокиНачало = 0;
	ТекущийДокумент = Неопределено;
	СуммаИтог = 0;
	Шапка = Запрос.Выполнить().Выбрать();
	КоличествоСтрок = Шапка.Количество();
	ТекущаяСтрока = 1;
	
	Пока Шапка.Следующий() Цикл
		// Пропуск строк если их больше 9
		Если (ФормаПечати = "Форма77" И НомерЯчейки = 417) ИЛИ (ФормаПечати = "Форма76" И НомерЯчейки = 391) Тогда
			Продолжить;			
		КонецЕсли;	
		
		Если Шапка.Ссылка <> ТекущийДокумент И ТекущийДокумент <> Неопределено Тогда
			ЗакончитьВыводТекущегоДокумента(Макет, ТабличныйДокумент, НомерЯчейки, СуммаИтог, НомерСтрокиНачало, 
														ОбъектыПечати, ТекущийДокумент, ФормаПечати);
		КонецЕсли;
		
		Если Шапка.Ссылка <> ТекущийДокумент ИЛИ ТекущийДокумент = Неопределено Тогда
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
			ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");	
		
			ОтчетныйГод = СтрЗаменить(Год(Шапка.Дата), Символы.НПП, "");
			ОбластьМакета.Параметры.Год1 = Сред(ОтчетныйГод,1,1);
			ОбластьМакета.Параметры.Год2 = Сред(ОтчетныйГод,2,1);
			ОбластьМакета.Параметры.Год3 = Сред(ОтчетныйГод,3,1);
			ОбластьМакета.Параметры.Год4 = Сред(ОтчетныйГод,4,1);
			
			СведенияОбОрганизации = ПолучитьКонтактнуюИнформацию(Шапка.Организация);
			// ИНН Организации
			ИННОрг = СведенияОбОрганизации.ИНН;
			ОбластьМакета.Параметры.ИНН1	= Сред(ИННОрг,1,1);
			ОбластьМакета.Параметры.ИНН2	= Сред(ИННОрг,2,1);
			ОбластьМакета.Параметры.ИНН3	= Сред(ИННОрг,3,1);
			ОбластьМакета.Параметры.ИНН4	= Сред(ИННОрг,4,1);
			ОбластьМакета.Параметры.ИНН5	= Сред(ИННОрг,5,1);
			ОбластьМакета.Параметры.ИНН6	= Сред(ИННОрг,6,1);
			ОбластьМакета.Параметры.ИНН7	= Сред(ИННОрг,7,1);
			ОбластьМакета.Параметры.ИНН8	= Сред(ИННОрг,8,1);
			ОбластьМакета.Параметры.ИНН9	= Сред(ИННОрг,9,1);
			ОбластьМакета.Параметры.ИНН10	= Сред(ИННОрг,10,1);
			ОбластьМакета.Параметры.ИНН11	= Сред(ИННОрг,11,1);
			ОбластьМакета.Параметры.ИНН12	= Сред(ИННОрг,12,1);
			ОбластьМакета.Параметры.ИНН13	= Сред(ИННОрг,13,1);
			ОбластьМакета.Параметры.ИНН14	= Сред(ИННОрг,14,1);
			// Наименование организации
			ОбластьМакета.Параметры.НаименованиеОрганизации	= СведенияОбОрганизации.НаименованиеПолное;  
			//№ Телефона
			ОбластьМакета.Параметры.Телефон = СведенияОбОрганизации.Телефон;
			// Код НО
			Код = СведенияОбОрганизации.ГНСКод;
			ОбластьМакета.Параметры.Код1 = Сред(Код,1,1);
			ОбластьМакета.Параметры.Код2 = Сред(Код,2,1);
			ОбластьМакета.Параметры.Код3 = Сред(Код,3,1);
			
			//Индекс
			Если ЗначениеЗаполнено(СведенияОбОрганизации.Индекс) Тогда
				Индекс = СведенияОбОрганизации.Индекс;
				ОбластьМакета.Параметры.Инд1 = Сред(Индекс,1,1);
				ОбластьМакета.Параметры.Инд2 = Сред(Индекс,2,1);
				ОбластьМакета.Параметры.Инд3 = Сред(Индекс,3,1);
				ОбластьМакета.Параметры.Инд4 = Сред(Индекс,4,1);
				ОбластьМакета.Параметры.Инд5 = Сред(Индекс,5,1);
				ОбластьМакета.Параметры.Инд6 = Сред(Индекс,6,1);
			КонецЕсли;
			
			// Код ОКПО
			Если ЗначениеЗаполнено(СведенияОбОрганизации.ОКПО) Тогда
				КодОКПО = СведенияОбОрганизации.ОКПО;
				ОбластьМакета.Параметры.ОКПО1 = Сред(КодОКПО,1,1);
				ОбластьМакета.Параметры.ОКПО2 = Сред(КодОКПО,2,1);
				ОбластьМакета.Параметры.ОКПО3 = Сред(КодОКПО,3,1);
				ОбластьМакета.Параметры.ОКПО4 = Сред(КодОКПО,4,1);
				ОбластьМакета.Параметры.ОКПО5 = Сред(КодОКПО,5,1);
				ОбластьМакета.Параметры.ОКПО6 = Сред(КодОКПО,6,1);
				ОбластьМакета.Параметры.ОКПО7 = Сред(КодОКПО,7,1);
				ОбластьМакета.Параметры.ОКПО8 = Сред(КодОКПО,8,1);	
			КонецЕсли;	
				
			// Наименование налогового органа
			ОбластьМакета.Параметры.НаименованиеНалоговогоОргана = СведенияОбОрганизации.ГНСНаименование;
			
			//Область
			Если ЗначениеЗаполнено(СведенияОбОрганизации.Область) Тогда 
				ОбластьМакета.Параметры.Область = СведенияОбОрганизации.Область;	
			КонецЕсли;
			
			// Улица, дом, кв
			Если ЗначениеЗаполнено(СведенияОбОрганизации.УлицаДом) Тогда 
				ОбластьМакета.Параметры.УлицаДом = СведенияОбОрганизации.УлицаДом;	
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;		
		
		Если ФормаПечати = "Форма77" Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ОбластьДанных");
			ОбластьМакета.Параметры.ЕАЭС0 = НомерЯчейки;
			ОбластьМакета.Параметры.ЕАЭС1 = НомерЯчейки + 1;
			ОбластьМакета.Параметры.ЕАЭС2 = НомерЯчейки + 2;
			ОбластьМакета.Параметры.ЕАЭС3 = НомерЯчейки + 3;
			ОбластьМакета.Параметры.ЕАЭС4 = НомерЯчейки + 4;
			ОбластьМакета.Параметры.ЕАЭС5 = НомерЯчейки + 5;
			ОбластьМакета.Параметры.ЕАЭС6 = НомерЯчейки + 6;
			ОбластьМакета.Параметры.ЕАЭС7 = НомерЯчейки + 7;
			ОбластьМакета.Параметры.ЕАЭС8 = НомерЯчейки + 8;
			ОбластьМакета.Параметры.ЕАЭС9 = НомерЯчейки + 9;
			ОбластьМакета.Параметры.ЕАЭС10 = НомерЯчейки + 10;
			ОбластьМакета.Параметры.ЕАЭС11 = НомерЯчейки + 11;
			ОбластьМакета.Параметры.ЕАЭС12 = НомерЯчейки + 12;
			НомерЯчейки = НомерЯчейки + 13;
			
		ИначеЕсли ФормаПечати = "Форма76" Тогда	
			ОбластьМакета = Макет.ПолучитьОбласть("ОбластьДанных");
			ОбластьМакета.Параметры.ЕАЭС0 = НомерЯчейки;
			ОбластьМакета.Параметры.ЕАЭС1 = НомерЯчейки + 1;
			ОбластьМакета.Параметры.ЕАЭС2 = НомерЯчейки + 2;
			ОбластьМакета.Параметры.ЕАЭС3 = НомерЯчейки + 3;
			ОбластьМакета.Параметры.ЕАЭС4 = НомерЯчейки + 4;
			ОбластьМакета.Параметры.ЕАЭС5 = НомерЯчейки + 5;
			ОбластьМакета.Параметры.ЕАЭС6 = НомерЯчейки + 6;
			ОбластьМакета.Параметры.ЕАЭС7 = НомерЯчейки + 7;
			ОбластьМакета.Параметры.ЕАЭС8 = НомерЯчейки + 8;
			ОбластьМакета.Параметры.ЕАЭС9 = НомерЯчейки + 9;
			НомерЯчейки = НомерЯчейки + 10;
		КонецЕсли;
				
		ОбластьМакета.Параметры.Заполнить(Шапка);
		СуммаИтог = СуммаИтог + Шапка.СуммаНалога;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТекущийДокумент = Шапка.Ссылка;
		
		Если КоличествоСтрок = ТекущаяСтрока Тогда
			ЗакончитьВыводТекущегоДокумента(Макет, ТабличныйДокумент, НомерЯчейки, СуммаИтог, НомерСтрокиНачало, 
														ОбъектыПечати, ТекущийДокумент, ФормаПечати);			
		КонецЕсли;
		
		ТекущаяСтрока = ТекущаяСтрока + 1;
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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗемельныйНалогФорма77") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЗемельныйНалогФорма77",
		НСтр("ru = 'Земельный налог FORM STI-077'"),
		ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "Форма77"));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗемельныйНалогФорма76") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЗемельныйНалогФорма76",
		НСтр("ru = 'Земельный налог FORM STI-076'"),
		ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "Форма76"));
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗемельныйНалогФорма77";
	КомандаПечати.Представление = НСтр("ru = 'Земельный налог FORM STI-077'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗемельныйНалогФорма76";
	КомандаПечати.Представление = НСтр("ru = 'Земельный налог FORM STI-076'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
КонецПроцедуры

#КонецОбласти

#КонецЕсли

