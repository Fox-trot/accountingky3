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
	|	ТаблицаДокумента.Дата КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Комментарий КАК Содержание,
	|	ТаблицаДокумента.Дебет КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,  
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	ТаблицаДокумента.Кредит КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	ТаблицаДокумента.СуммаСбора КАК Сумма
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НалогНаМусор.Дата,
		|	НалогНаМусор.Организация,
		|	НалогНаМусор.Комментарий,
		|	НалогНаМусор.Дебет,
		|	НалогНаМусор.Кредит,
		|	НалогНаМусор.СуммаСбора
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	Документ.НалогНаМусор КАК НалогНаМусор
		|ГДЕ
		|	НалогНаМусор.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Организации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);

	Индекс = СведенияОбОрганизации.Индекс; 
	
	ГородНасПункт   = ?(СведенияОбОрганизации.Город  = "",СведенияОбОрганизации.НаселенныйПункт,СведенияОбОрганизации.Город);
	АдрОбластьГород = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
		+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон 						= СведенияОбОрганизации.Тел;
	ЭлПочта 						= СведенияОбОрганизации.Email;
	ОКПО              				= СведенияОбОрганизации.ОКПО;
	ИНН 							= СведенияОбОрганизации.ИНН;
	ГНСНаименование                 = СведенияОбОрганизации.ГНСНаименование;
	ГНСКод 							= СведенияОбОрганизации.ГНСКод;
	ОрганизацияНаименованиеПолное   = СведенияОбОрганизации.НаименованиеПолное;
	Индекс  						= СведенияОбОрганизации.Индекс;

	Структура = Новый Структура();
	Структура.Вставить("ИНН", ИНН);
	Структура.Вставить("ОКПО", ОКПО);
	Структура.Вставить("ГНСКод", ГНСКод);
	Структура.Вставить("Индекс", Индекс);
	Структура.Вставить("Телефон", Телефон);
	Структура.Вставить("ЭлПочта", ЭлПочта);
	Структура.Вставить("АдрОбластьГород", АдрОбластьГород);
	Структура.Вставить("ГНСНаименование", ГНСНаименование);
	Структура.Вставить("АдресОрганизации", АдресОрганизации);
	Структура.Вставить("ОрганизацияНаименованиеПолное", ОрганизацияНаименованиеПолное);

	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

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

Функция ПечатьНалогНаМусор(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НалогНаМусор.Организация КАК Организация,
		|	НалогНаМусор.Дата КАК Дата,
		|	НалогНаМусор.СтавкаСбора КАК СтавкаСбора,
		|	НалогНаМусор.Оплачено КАК Оплачено,
		|	НалогНаМусор.ЧисленностьСотрудников КАК ЧисленностьСотрудников,
		|	НалогНаМусор.СуммаСбора КАК СуммаСбора
		|ИЗ
		|	Документ.НалогНаМусор КАК НалогНаМусор
		|ГДЕ
		|	НалогНаМусор.Ссылка В(&МассивОбъектов)";		
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "НалогНаМусор_НалогНаМусор";
	ТабличныйДокумент.Очистить();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.НалогНаМусор.ПФ_MXL_НалогНаМусор");
	
	Пока Выборка.Следующий() Цикл
		
		// Подготовка данных для извлечения из них необходимого
		Организация				= Выборка.Организация;
		КонтактныеДанные 		= ПолучитьКонтактнуюИнформацию(Организация);
			
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("НаименованиеОрганизации", СокрЛП(КонтактныеДанные.ОрганизацияНаименованиеПолное));
		
		ГНСКод = КонтактныеДанные.ГНСКод;
		ДанныеПечати.Вставить("ГНС1", Сред(Строка(ГНСКод),1,1));
		ДанныеПечати.Вставить("ГНС2", Сред(Строка(ГНСКод),2,1));
		ДанныеПечати.Вставить("ГНС3", Сред(Строка(ГНСКод),3,1));
		
		ДанныеПечати.Вставить("НаименованиеНалоговой", КонтактныеДанные.ГНСНаименование);
		
		ОКПО = КонтактныеДанные.ОКПО;
		ДанныеПечати.Вставить("ОКПО1", Сред(Строка(ОКПО),1,1));
		ДанныеПечати.Вставить("ОКПО2", Сред(Строка(ОКПО),2,1));
		ДанныеПечати.Вставить("ОКПО3", Сред(Строка(ОКПО),3,1));
		ДанныеПечати.Вставить("ОКПО4", Сред(Строка(ОКПО),4,1));
		ДанныеПечати.Вставить("ОКПО5", Сред(Строка(ОКПО),5,1));
		ДанныеПечати.Вставить("ОКПО6", Сред(Строка(ОКПО),6,1));
		ДанныеПечати.Вставить("ОКПО7", Сред(Строка(ОКПО),7,1));
		ДанныеПечати.Вставить("ОКПО8", Сред(Строка(ОКПО),8,1));
		
		ДанныеПечати.Вставить("ЮрАдрес", КонтактныеДанные.АдресОрганизации);		
		ДанныеПечати.Вставить("Телефон", КонтактныеДанные.Телефон);
		ДанныеПечати.Вставить("ЭлПочта", КонтактныеДанные.ЭлПочта);
		ДанныеПечати.Вставить("АдресГород", КонтактныеДанные.АдрОбластьГород);		
	
		Индекс = КонтактныеДанные.Индекс;
		
		Если ЗначениеЗаполнено(Индекс) Тогда
			ДанныеПечати.Вставить("ИНД1", Сред(Индекс,1,1));
			ДанныеПечати.Вставить("ИНД2", Сред(Индекс,2,1));
			ДанныеПечати.Вставить("ИНД3", Сред(Индекс,3,1));
			ДанныеПечати.Вставить("ИНД4", Сред(Индекс,4,1));
			ДанныеПечати.Вставить("ИНД5", Сред(Индекс,5,1));
			ДанныеПечати.Вставить("ИНД6", Сред(Индекс,6,1));			
		КонецЕсли;
			
		//ИНН
		ИНН = КонтактныеДанные.ИНН;
		ДанныеПечати.Вставить("ИНН1", Сред(Строка(ИНН),1,1));
		ДанныеПечати.Вставить("ИНН2", Сред(Строка(ИНН),2,1));
		ДанныеПечати.Вставить("ИНН3", Сред(Строка(ИНН),3,1));
		ДанныеПечати.Вставить("ИНН4", Сред(Строка(ИНН),4,1));
		ДанныеПечати.Вставить("ИНН5", Сред(Строка(ИНН),5,1));
		ДанныеПечати.Вставить("ИНН6", Сред(Строка(ИНН),6,1));
		ДанныеПечати.Вставить("ИНН7", Сред(Строка(ИНН),7,1));
		ДанныеПечати.Вставить("ИНН8", Сред(Строка(ИНН),8,1));
		ДанныеПечати.Вставить("ИНН9", Сред(Строка(ИНН),9,1));
		ДанныеПечати.Вставить("ИНН10", Сред(Строка(ИНН),10,1));
		ДанныеПечати.Вставить("ИНН11", Сред(Строка(ИНН),11,1));
		ДанныеПечати.Вставить("ИНН12", Сред(Строка(ИНН),12,1));
		ДанныеПечати.Вставить("ИНН13", Сред(Строка(ИНН),13,1));
		ДанныеПечати.Вставить("ИНН14", Сред(Строка(ИНН),14,1));
		
		ДатаН = НачалоМесяца(Выборка.Дата);
		ДатаК = КонецМесяца(Выборка.Дата);
		
		// Налоговый период 	
		ДанныеПечати.Вставить("ДатаН1", Сред(Формат(ДатаН,"dd"),1,1));	
		ДанныеПечати.Вставить("ДатаН2", Сред(Формат(ДатаН,"dd"),2,1));	
		ДанныеПечати.Вставить("ДатаН3", Сред(Формат(ДатаН,"MM"),4,1));
		ДанныеПечати.Вставить("ДатаН4", Сред(Формат(ДатаН,"MM"),5,1));
		ДанныеПечати.Вставить("ДатаН5", Сред(Формат(ДатаН,"yyyy"),7,1));
		ДанныеПечати.Вставить("ДатаН6", Сред(Формат(ДатаН,"yyyy"),8,1));
		ДанныеПечати.Вставить("ДатаН7", Сред(Формат(ДатаН,"yyyy"),9,1));
		ДанныеПечати.Вставить("ДатаН8", Сред(Формат(ДатаН,"yyyy"),10,1));
		
		ДанныеПечати.Вставить("ДатаК1", Сред(Формат(ДатаК,"dd"),1,1));
		ДанныеПечати.Вставить("ДатаК2", Сред(Формат(ДатаК,"dd"),2,1));								
		ДанныеПечати.Вставить("ДатаК3", Сред(Формат(ДатаК,"MM"),4,1));
		ДанныеПечати.Вставить("ДатаК4", Сред(Формат(ДатаК,"MM"),5,1));							
		ДанныеПечати.Вставить("ДатаК5", Сред(Формат(ДатаК,"yyyy"),7,1));
		ДанныеПечати.Вставить("ДатаК6", Сред(Формат(ДатаК,"yyyy"),8,1));
		ДанныеПечати.Вставить("ДатаК7", Сред(Формат(ДатаК,"yyyy"),9,1));
		ДанныеПечати.Вставить("ДатаК8", Сред(Формат(ДатаК,"yyyy"),10,1));	
		
		ОстатокСбора = Выборка.СуммаСбора - Выборка.Оплачено;
		ДанныеПечати.Вставить("ОстатокСбора", ОстатокСбора);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Страница");
		
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НалогНаМусор") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"НалогНаМусор",
		НСтр("ru = 'Налог на мусор'"), 
		ПечатьНалогНаМусор(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.НалогНаМусор.ПФ_MXL_НалогНаМусор");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "НалогНаМусор";
	КомандаПечати.Представление = НСтр("ru = 'Налог на мусор'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли