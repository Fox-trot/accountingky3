﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Функция ИнициализироватьДанныеДокумента()

	Структура = Новый Структура;
	Структура.Вставить("СерияПаспорта", 		"");
	Структура.Вставить("НомерПаспорта", 		"");
	Структура.Вставить("КемВыдан", 				"");
	Структура.Вставить("ДатаВыдачиДокумента", 	Дата(1,1,1));
		
	Возврат Структура;

КонецФункции // ИнициализироватьДанныеДокумента()

Функция ДанныеДокумента(ТаблицаДокументов, ФизЛицо)
	
	Данные = ИнициализироватьДанныеДокумента();
	Отбор = Новый Структура;
	Отбор.Вставить("ФизЛицо", ФизЛицо);
	Массив = ТаблицаДокументов.НайтиСтроки(Отбор);
	Если Массив.Количество() Тогда
		ЗаполнитьЗначенияСвойств(Данные, Массив[0]); 		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции // ДанныеДокумента()

Функция РеквизитыПотребителя(ВыборкаДок)	
	АдресПотребителя = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыборкаДок.ГоловнаяОрганизация, 
														Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, ВыборкаДок.Дата);
	ИНН 			= ВыборкаДок.ИННГоловнойОрганизации;														
	ГНСНаименование = ВыборкаДок.ГНСГоловнойОрганизацииНаименование;
	БИК				= ВыборкаДок.БИК;
	БанковскийСчет 	= ВыборкаДок.БанковскийСчетНаименование;
	
	Возврат ?(ЗначениеЗаполнено(ВыборкаДок.НаименованиеГоловнойОрганизации), ВыборкаДок.НаименованиеГоловнойОрганизации + Символы.ПС + " (", "")
	+ ?(ЗначениеЗаполнено(ВыборкаДок.ОрганизацияНаименованиеПолное), ВыборкаДок.ОрганизацияНаименованиеПолное + ")", "")	
	+ Символы.ПС
	+ ?(ЗначениеЗаполнено(ИНН), "ИНН: " + ИНН, "")
	+ ?(ЗначениеЗаполнено(ГНСНаименование), ", ГНС: " + ГНСНаименование, "")
	+ ?(ЗначениеЗаполнено(БИК), ", БИК: " + БИК, "")
	+ ?(ЗначениеЗаполнено(БанковскийСчет), ", р/с: " + БанковскийСчет, "")
	+ ?(ЗначениеЗаполнено(АдресПотребителя), ", Адрес: " + АдресПотребителя, "");

КонецФункции // РеквизитыПотребителя()

Функция ОрганизацияПредставление(ВыборкаДок)	
	Возврат ?(ЗначениеЗаполнено(ВыборкаДок.НаименованиеГоловнойОрганизации), ВыборкаДок.НаименованиеГоловнойОрганизации + Символы.ПС + " (", "")
	+ ?(ЗначениеЗаполнено(ВыборкаДок.НаименованиеГоловнойОрганизации), ВыборкаДок.ОрганизацияНаименованиеПолное + ")", "");

КонецФункции // РеквизитыПотребителя()

Функция РеквизитыПлательщика(ВыборкаДок)	
	АдресПлательщика = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыборкаДок.Контрагент, 
														Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, ВыборкаДок.Дата);
	
	Возврат ВыборкаДок.ПоставщикПредставление + ?(ЗначениеЗаполнено(АдресПлательщика), ", " + АдресПлательщика, "");

КонецФункции // РеквизитыПотребителя()

Функция КоличествоИтог(ВыборкаДок)

	ВыборкаСтрокТовары 	= ВыборкаДок.Товары.Выбрать();
	ВыборкаСтрокОС 		= ВыборкаДок.ОсновныеСредства.Выбрать();
	Количество = 0;
	Пока ВыборкаСтрокТовары.Следующий() Цикл
		Количество = Количество + ВыборкаСтрокТовары.Количество;
	КонецЦикла;
	Пока ВыборкаСтрокОС.Следующий() Цикл
		Количество = Количество + 1;
	КонецЦикла;
	
	Возврат Количество;

КонецФункции // КоличествоИтог(ВыборкаДок)

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

// Функция формирует табличный документ с печатной формой Доверенность_М2
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьДоверенность_М2(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Доверенность_Доверенность_М2";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Доверенность.Ссылка,
	|	Доверенность.ФизЛицо
	|ПОМЕСТИТЬ ДокументыДоверенность
	|ИЗ
	|	Документ.Доверенность КАК Доверенность
	|ГДЕ
	|	Доверенность.Ссылка В(&СписокДокументов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Доверенность.Ссылка,
	|	Доверенность.Номер,
	|	Доверенность.Дата,
	|	Доверенность.Организация,
	|	Доверенность.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	Доверенность.Организация.КодПоОКПО КАК ОКПО,
	|	Доверенность.Контрагент,
	|	Доверенность.Контрагент.НаименованиеПолное КАК ПоставщикПредставление,
	|	Доверенность.ФизЛицо,
	|	Доверенность.БанковскийСчет.НомерСчета КАК НомерСчета,
	|	Доверенность.БанковскийСчет.Банк.Наименование КАК НаименованиеБанка,
	|	Доверенность.ПоДокументу КАК РеквизитыДокументаНаПолучение,
	|	Доверенность.ДатаДействия,
	|	Доверенность.Товары.(
	|		ВЫБОР
	|			КОГДА Доверенность.Товары.Номенклатура ССЫЛКА Справочник.Номенклатура
	|				ТОГДА Доверенность.Товары.Номенклатура.Представление
	|			ИНАЧЕ Доверенность.Товары.Номенклатура
	|		КОНЕЦ КАК ЦеннностиПредставление,
	|		ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияПредставление,
	|		Количество
	|	),
	|	Доверенность.ОсновныеСредства.(
	|		ОсновноеСредство.Представление КАК ЦеннностиПредставление,
	|		Количество
	|	),
	|	Доверенность.БанковскийСчет.Наименование,
	|	Доверенность.БанковскийСчет.Банк.Код КАК БИК,
	|	Доверенность.ПечатьИтогов,
	|	Доверенность.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Доверенность.Организация.ГоловнаяОрганизация.НаименованиеПолное КАК НаименованиеГоловнойОрганизации,
	|	Доверенность.Организация.ГоловнаяОрганизация.ИНН КАК ИННГоловнойОрганизации,
	|	Доверенность.Организация.ГоловнаяОрганизация.ГНС.Наименование КАК ГНСГоловнойОрганизацииНаименование
	|ИЗ
	|	ДокументыДоверенность КАК ДокументыДоверенность
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Доверенность КАК Доверенность
	|		ПО ДокументыДоверенность.Ссылка = Доверенность.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛицСрезПоследних.Физлицо,
	|	ДокументыФизическихЛицСрезПоследних.Серия КАК СерияПаспорта,
	|	ДокументыФизическихЛицСрезПоследних.Номер КАК НомерПаспорта,
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи КАК ДатаВыдачиДокумента,
	|	ДокументыФизическихЛицСрезПоследних.КемВыдан КАК КемВыдан
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	|			,
	|			Физлицо В
	|				(ВЫБРАТЬ
	|					ДокументыДоверенность.ФизЛицо
	|				ИЗ
	|					ДокументыДоверенность КАК ДокументыДоверенность)) КАК ДокументыФизическихЛицСрезПоследних";
				
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	РезультатЗапроса 	= Запрос.ВыполнитьПакет();
	ВыборкаДок 			= РезультатЗапроса[1].Выбрать();
	ТаблицаДокументов   = РезультатЗапроса[2].Выгрузить();
	
	Пока ВыборкаДок.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ДанныеДокумента = ДанныеДокумента(ТаблицаДокументов, ВыборкаДок.ФизЛицо);
		ДанныеФизЛица = БухгалтерскийУчетСервер.ДанныеФизЛица(ВыборкаДок.Организация,ВыборкаДок.ФизЛицо, ВыборкаДок.Дата, Ложь);
		
		Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(ВыборкаДок.Организация,ВыборкаДок.Дата);
		ДанныеПечати.Вставить("ОрганизацияПредставление", 	ОрганизацияПредставление(ВыборкаДок));
		ДанныеПечати.Вставить("ФИОРуководителя", 			Руководители.Руководитель);
		ДанныеПечати.Вставить("ФИОГлавногоБухгалтера", 		Руководители.ГлавныйБухгалтер);
		
		ДанныеПечати.Вставить("ОКПО", 						ВыборкаДок.ОКПО);		
		ДанныеПечати.Вставить("НомерДокумента", 			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДок.Номер));
		ДанныеПечати.Вставить("ДатаВыдачиДоверенности", 	ВыборкаДок.Дата);
		ДанныеПечати.Вставить("ДатаДействияДоверенности", 	ВыборкаДок.ДатаДействия);
				
		ДанныеПечати.Вставить("РеквизитыПотребителя", 		РеквизитыПотребителя(ВыборкаДок));
		ДанныеПечати.Вставить("РеквизитыПлательщика", 		РеквизитыПлательщика(ВыборкаДок));
		ДанныеПечати.Вставить("ДолжностьДоверенного", 		ДанныеФизЛица.Должность);
		ДанныеПечати.Вставить("ФамилияИмяОтчествоДоверенного", ДанныеФизЛица.Представление);
		ДанныеПечати.Вставить("СерияПаспорта", 				ДанныеДокумента.СерияПаспорта);
		ДанныеПечати.Вставить("НомерПаспорта", 				ДанныеДокумента.НомерПаспорта);
		ДанныеПечати.Вставить("КемВыдан", 					ДанныеДокумента.КемВыдан);
		ДанныеПечати.Вставить("ДатаВыдачиДокумента", 		ДанныеДокумента.ДатаВыдачиДокумента);
		ДанныеПечати.Вставить("КоличествоИтог", 			БухгалтерскийУчетСервер.КоличествоПрописью(КоличествоИтог(ВыборкаДок)));
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Доверенность.ПФ_MXL_Доверенность_М2");
		
		МассивОбластейМакета = Новый Массив;		
		МассивОбластейМакета.Добавить("Шапка");
		МассивОбластейМакета.Добавить("ЗаголовокТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		Если ВыборкаДок.ПечатьИтогов Тогда
			МассивОбластейМакета.Добавить("Итог");
		КонецЕсли;		
		МассивОбластейМакета.Добавить("Подвал");
		
		ВыборкаСтрокТовары 	= ВыборкаДок.Товары.Выбрать();
		ВыборкаСтрокОС 		= ВыборкаДок.ОсновныеСредства.Выбрать();
		НомерСтроки = 0;
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);			
			Если ИмяОбласти <> "Строка" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ВыборкаДок);
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);								
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Пока ВыборкаСтрокТовары.Следующий() Цикл
					ОбластьМакета = Макет.ПолучитьОбласть("Строка");
					ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Номер = НомерСтроки;
					ОбластьМакета.Параметры.КоличествоПрописью = ?(ВыборкаСтрокТовары.Количество = 0, "",БухгалтерскийУчетСервер.КоличествоПрописью(ВыборкаСтрокТовары.Количество));//ВыборкаСтрокТовары.Количество; // ?(ВыборкаСтрокТовары.Количество = 0, "", ЧислоПрописью(ВыборкаСтрокТовары.Количество));
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				Пока ВыборкаСтрокОС.Следующий() Цикл
					ОбластьМакета = Макет.ПолучитьОбласть("Строка");
					ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокОС);
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Номер = НомерСтроки;
					ОбластьМакета.Параметры.КоличествоПрописью = БухгалтерскийУчетСервер.КоличествоПрописью(ЧислоПрописью(1));
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДок.Ссылка);		
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ПолеСлева = 10;
	
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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Доверенность_М2") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"Доверенность_М2", "Доверенность(М-2)", ПечатьДоверенность_М2(МассивОбъектов, ОбъектыПечати),,
		"Документ.Доверенность.ПФ_MXL_Доверенность_М2");
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Доверенность_М2";
	КомандаПечати.Представление = НСтр("ru = 'Доверенность(М-2)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли