﻿// По стандартам 1С (http://its.1c.ru/db/v8std#content:-2145783192:hdoc:)
// оформление модулей менеджеров выглядит так:
//
// #Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
//
// #Область ОписаниеПеременных
// Перем НоваяПеременная;
// #КонецОбласти
//
// #Область ПрограммныйИнтерфейс
// //Код процедур и функций
// #КонецОбласти
//
// #Область ПроцедурыПроведенияДокумента
// //Код процедур
// #КонецОбласти
//
// #Область ОбработчикиСобытий
// //Код процедур и функций
// #КонецОбласти
//
// #Область СлужебныеПроцедурыИФункции
// //Код процедур и функций
// #КонецОбласти
//
// #Область ВерсионированиеОбъектов
// //Код процедур и функций
// #КонецОбласти
//
// #Область ИнтерфейсПечати
// //Код процедур и функций
// #КонецОбласти
//
// #КонецЕсли
//
// •Раздел «Описание переменных» содержит переменные модуля. Все переменные модуля должны быть снабжены комментарием, 
// 		достаточным для понимания их назначения. Комментарий рекомендуется размещать в той же строке, где объявляется переменная.
//		Пример:
//		Перем ВалютаУчета; // Валюта, в которой ведется управленческий учет.
//   	Перем АдресПоддержки; // Адрес электронной почты, куда направляются сообщения об ошибках.
//
// •Раздел «Программный интерфейс» содержит экспортные процедуры и функции, предназначенные для использования 
// 		в других модулях конфигурации или другими программами (например, через внешнее соединение). 
// 		Не следует в этот раздел помещать экспортные функции и процедуры, которые предназначены для вызова исключительно 
// 		из модулей самого объекта, его форм и команд. Например, процедуры заполнения табличной части документа, 
// 		которые вызываются из обработки заполнения в модуле объекта и из формы документа в обработчике команды формы 
// 		не являются программным интерфейсом модуля объекта, т.к. вызываются только в самом модуле и из форм этого же объекта. 
// 		Их следует размещать в разделе «Служебные процедуры и функции». 
//
// •Раздел «Процедуры проведения документа» содержит процедуры подготовки данных (с помощью запросов) для записи в регистры. 
//
// •Раздел «Обработчики событий» содержит обработчики событий модуля объекта (ПриЗаписи, ПриПроведении и др.)
//
// •Раздел «Служебные процедуры и функции» имеет такое же предназначение, как и в общих модулях.
//
// •Раздел «Версионирование объектов» содержит процедуры для версионирования.
//
// •Раздел «Интерфейс печати» содержит процедуры и функции для определения макетов и подготовки данных для выведения в печать.

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Период КАК Период,
	|	ВременнаяТаблицаШапка.Организация КАК Организация,
	|	ВременнаяТаблицаТовары.СчетУчета КАК СчетДт,
	|	ВременнаяТаблицаШапка.СчетРасчетовПоставщика КАК СчетКт,
	|	ВременнаяТаблицаТовары.Номенклатура КАК СубконтоДт1,
	|	ВременнаяТаблицаШапка.Склад КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоКт1,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
	|	ВременнаяТаблицаТовары.Сумма КАК ВалютнаяСуммаДт,
	|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
	|	ВременнаяТаблицаТовары.Сумма КАК ВалютнаяСуммаКт,
	|	""Поступление ТМЗ - "" + ВременнаяТаблицаШапка.ВидОперации.Наименование КАК Содержание,
	|	ВременнаяТаблицаТовары.Количество КАК КоличествоДт,
	|	ВременнаяТаблицаТовары.Количество КАК КоличествоКт
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ПО (ИСТИНА)";
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
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.Организация
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.Шаблон КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШаблонТабличнаяЧастьШаблон.СчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаТабличнаяЧастьШаблон
		|ИЗ
		|	Документ.Шаблон.ТабличнаяЧастьШаблон КАК ШаблонТабличнаяЧастьШаблон
		|ГДЕ
		|	ШаблонТабличнаяЧастьШаблон.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает заголовок документа для печатной формы.
//
// Параметры:
//  Шапка - любая структура с полями:
//           Номер         - Строка или Число - номер документа;
//           Дата          - Дата - дата документа;
//           Представление - Строка - (необязательный) платформенное представление ссылки на документ.
//                                    Если параметр НазваниеДокумента не задан, то название документа будет вычисляться
//                                    из этого параметра.
//  НазваниеДокумента - Строка - название документа (например, "Счет на оплату").
//
// Возвращаемое значение:
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "") Экспорт
	
	ДанныеДокумента = Новый Структура("Номер,Дата,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеДокумента.Номер);
	Возврат СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),
		НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

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

//Функция ПечатьАктаСписания(МассивОбъектов, ОбъектыПечати)
//	
//	ТекстЗапроса = 
//		"ВЫБРАТЬ
//		|	ТаблицаДокумента.Ссылка,
//		|	ТаблицаДокумента.Номер,
//		|	ТаблицаДокумента.Дата,
//		|	ТаблицаДокумента.Дата КАК ДатаДокумента,
//		|	ТаблицаДокумента.Организация,
//		|	ТаблицаДокумента.Комментарий,
//		|	ТаблицаДокумента.Комиссия.(
//		|		Ссылка,
//		|		ФизЛицо,
//		|		Председатель,
//		|		ФизЛицо.Наименование
//		|	),
//		|	ТаблицаДокумента.Спецодежда.(
//		|		Ссылка,
//		|		НомерСтроки,
//		|		Номенклатура.Код КАК Код,
//		|		Номенклатура,
//		|		Номенклатура.НаименованиеПолное КАК НоменклатураНаименованиеПолное,
//		|		Номенклатура.ЕдиницаИзмерения КАК ЕдИзм,
//		|		ПРЕДСТАВЛЕНИЕ(ТаблицаДокумента.Спецодежда.Номенклатура.ЕдиницаИзмерения) КАК ЕдИзмПредставление,
//		|		Количество,
//		|		Цена,
//		|		Сумма,
//		|		ДатаВыдачи
//		|	)
//		|ИЗ
//		|	Документ.СписаниеСпецодеждыДосрочное КАК ТаблицаДокумента
//		|ГДЕ
//		|	ТаблицаДокумента.Ссылка В(&МассивОбъектов)";	
//	Запрос = Новый Запрос(ТекстЗапроса);	
//	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
//	
//	Шапка = Запрос.Выполнить().Выбрать();
//	
//	ТабличныйДокумент = Новый ТабличныйДокумент;
//	ТабличныйДокумент.КлючПараметровПечати = "СписаниеСпецодеждыДосрочное_АктСписания";
//	
//	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеСпецодеждыДосрочное.ПФ_MXL_АктСписания");
//	
//	Пока Шапка.Следующий() Цикл
//		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
//			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
//		КонецЕсли;
//		
//		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
//		
//		// Подготовка данных
//		ДанныеПечати = Новый Структура;
//		
//		ДанныеПечати.Вставить("ДатаДокумента", Шапка.ДатаДокумента);
//		ДанныеПечати.Вставить("ТекстЗаголовка", СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Акт списания'")));
//		
//		ТекстПодЗаголовка = НСтр("ru = 'Мы, нижеподписавшиеся,'");
//		ВыборкаКомиссия = Шапка.Комиссия.Выбрать();
//		Пока ВыборкаКомиссия.Следующий() Цикл
//			ДанныеФизЛица = БухгалтерскийУчетСервер.ДанныеФизЛица(Шапка.Организация, ВыборкаКомиссия.ФизЛицо, Шапка.ДатаДокумента);
//			ТекстПодЗаголовка = ТекстПодЗаголовка 
//				+ ?(ЗначениеЗаполнено(ДанныеФизЛица.Должность), ДанныеФизЛица.Должность, "")
//				+ " " + ДанныеФизЛица.Представление + ", ";
//		КонецЦикла;
//		ТекстПодЗаголовка = ТекстПодЗаголовка + Символы.ПС + НСтр("ru = 'составили настоящий акт о том, что, '") + СокрЛП(Шапка.Комментарий);

//		ДанныеПечати.Вставить("ТекстПодЗаголовка", ТекстПодЗаголовка);
//		
//		ВременнаяТаблицаСпецодежда = Шапка.Спецодежда.Выгрузить();
//		ДанныеПечати.Вставить("Всего", ВременнаяТаблицаСпецодежда.Итог("Сумма"));
//		ДанныеПечати.Вставить("ИтоговаяСтрока", 
//			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
//			Формат(ВременнаяТаблицаСпецодежда.Количество(), "ЧН=0; ЧГ=0"), 
//			Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2")));
//		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего));
//		
//		// Инициализация массива областей макета
//		МассивОбластейМакета = Новый Массив;
//		МассивОбластейМакета.Добавить("Заголовок");
//		МассивОбластейМакета.Добавить("ШапкаТаблицы");
//		МассивОбластейМакета.Добавить("Строка");
//		МассивОбластейМакета.Добавить("ИтогиТаблицы");
//		МассивОбластейМакета.Добавить("СуммаПрописью");
//		МассивОбластейМакета.Добавить("Подвал");
//		МассивОбластейМакета.Добавить("ПодписиКомиссия");
//		
//		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
//			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
//			Если ИмяОбласти <> "Строка"
//				И ИмяОбласти <> "ПодписиКомиссия" Тогда
//				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
//				ТабличныйДокумент.Вывести(ОбластьМакета);
//			ИначеЕсли ИмяОбласти = "Строка" Тогда 
//				Для Каждого СтрокаТаблицы Из ВременнаяТаблицаСпецодежда Цикл
//					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
//					ТабличныйДокумент.Вывести(ОбластьМакета);
//				КонецЦикла;
//			ИначеЕсли ИмяОбласти = "ПодписиКомиссия" Тогда
//				// Формирование комиссии
//				ВыборкаКомиссия = Шапка.Комиссия.Выбрать();
//				Пока ВыборкаКомиссия.Следующий() Цикл
//					ОбластьМакета.Параметры.Заполнить(ВыборкаКомиссия);
//					
//					ДанныеФизЛица = БухгалтерскийУчетСервер.ДанныеФизЛица(Шапка.Организация, ВыборкаКомиссия.ФизЛицо, Шапка.ДатаДокумента);
//					ОбластьМакета.Параметры.Должность 			= ДанныеФизЛица.Должность;
//					ОбластьМакета.Параметры.РасшифровкаПодписи	= ДанныеФизЛица.Представление;						
//					
//					ТабличныйДокумент.Вывести(ОбластьМакета);
//				КонецЦикла;
//			КонецЕсли;	
//		КонецЦикла;
//		
//		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
//	КонецЦикла;
//	
//	Возврат ТабличныйДокумент;
//	
//КонецФункции

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
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСписания") Тогда
	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
	//	"АктСписания", 
	//	"Акт списания", 
	//	ПечатьАктаСписания(МассивОбъектов, ОбъектыПечати),
	//	,
	//	"Документ.СписаниеСпецодеждыДосрочное.ПФ_MXL_АктСписания");
	//КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//КомандаПечати = КомандыПечати.Добавить();
	//КомандаПечати.Идентификатор = "АктСписания";
	//КомандаПечати.Представление = НСтр("ru = 'Акт списания'");
	//КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	//КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	//КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли