﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ)
	
	// Подготовка данных	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаВзаиморасчетов,
		|	&Содержание КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Товары"" КАК ИмяСписка,
		|	&СинонимСписка КАК СинонимСписка,
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК Партия,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК КорСчетСписания,
		|	ВременнаяТаблицаШапка.Контрагент КАК КорСубконто1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3,
		|	0 КАК СуммаСписания,
		|	&Содержание КАК Содержание,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВременнаяТаблицаТовары.Сумма КАК СуммаВзаиморасчетов,
		|	ИСТИНА КАК СебестоимостьУказанаВДокументе
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Возврат товаров поставщику'")); 
	Запрос.УстановитьПараметр("СинонимСписка", НСтр("ru = 'Товары'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = МассивРезультатов[0].Выгрузить(); 
	ТаблицаТовары = МассивРезультатов[1].Выгрузить();
	
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары, ТаблицаРеквизиты, Отказ);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТовары", ТаблицаТовары);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеТовары", ТаблицаСписанныеТовары);

	// НДС
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетДт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению) КАК СчетКт,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВременнаяТаблицаТовары.СуммаНДС КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаТовары.СуммаНДС КАК ВалютнаяСуммаКт,
		|	&Содержание КАК Содержание,
		|	0 КАК КоличествоДт,
		|	0 КАК КоличествоКт
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаТовары.СуммаНДС = 0";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Возврат товаров поставщику (НДС)'")); 	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПоступлениеТоваров(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаТовары.Номенклатура,
		|	ВременнаяТаблицаШапка.СтавкаНДС,
		|	-ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
		|	-ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаСебестоимости,
		|	-ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНеоблагаемая,
		|	-ВременнаяТаблицаТовары.Количество КАК Количество
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПоступлениеТоваров", РезультатЗапроса.Выгрузить());
		
КонецПроцедуры 

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц 	= СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратТоваровПоставщику.Ссылка,
		|	ВозвратТоваровПоставщику.Организация,
		|	ВозвратТоваровПоставщику.Дата,
		|	ВозвратТоваровПоставщику.ВидОперации,
		|	ВозвратТоваровПоставщику.Контрагент,
		|	ВозвратТоваровПоставщику.ВалютаДокумента,
		|	ВозвратТоваровПоставщику.ДоговорКонтрагента,
		|	ВозвратТоваровПоставщику.Склад,
		|	ВозвратТоваровПоставщику.СтавкаНДС,
		|	ВозвратТоваровПоставщику.СтавкаНСП,
		|	ВозвратТоваровПоставщику.ДокументОснование,
		|	ВозвратТоваровПоставщику.Курс,
		|	ВозвратТоваровПоставщику.Кратность,
		|	ВозвратТоваровПоставщику.СчетРасчетов,
		|	ВозвратТоваровПоставщику.СерияБланкаСФ,
		|	ВозвратТоваровПоставщику.НомерБланкаСФ
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|ГДЕ
		|	ВозвратТоваровПоставщику.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВозвратТоваровПоставщикуТовары.НомерСтроки,
		|	ВозвратТоваровПоставщикуТовары.Номенклатура,
		|	ВозвратТоваровПоставщикуТовары.Количество,
		|	ВозвратТоваровПоставщикуТовары.Сумма,
		|	ВозвратТоваровПоставщикуТовары.СуммаНДС,
		|	ВозвратТоваровПоставщикуТовары.СуммаНСП,
		|	ВозвратТоваровПоставщикуТовары.СчетУчета,
		|	ВозвратТоваровПоставщикуТовары.Всего
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику.Товары КАК ВозвратТоваровПоставщикуТовары
		|ГДЕ
		|	ВозвратТоваровПоставщикуТовары.Ссылка = &ДокументСсылка";	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Запрос.Выполнить();    		
		
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ);	
	СформироватьТаблицаПоступлениеТоваров(ДокументСсылка, СтруктураДополнительныеСвойства);
	
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

// Функция формирует табличный документ с печатной формой ПечатьНакладной
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНакладной(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ВозвратТоваровПоставщику.Ссылка,
		|	ВозвратТоваровПоставщику.Номер,
		|	ВозвратТоваровПоставщику.Дата,
		|	ВозвратТоваровПоставщику.Организация,
		|	ВозвратТоваровПоставщику.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ВозвратТоваровПоставщику.ВалютаДокумента,
		|	ВозвратТоваровПоставщику.Контрагент,
		|	ВозвратТоваровПоставщику.Контрагент.НаименованиеПолное КАК КонтрагентНаименованиеПолное,
		|	ВозвратТоваровПоставщику.Склад,
		|	ПРЕДСТАВЛЕНИЕ(ВозвратТоваровПоставщику.Склад) КАК СкладПредставление,
		|	ВозвратТоваровПоставщику.Товары.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураНаименованиеПолное,
		|		ПРЕДСТАВЛЕНИЕ(ВозвратТоваровПоставщику.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество,
		|		Цена,
		|		Сумма,
		|		СуммаНДС,
		|		СуммаНСП
		|	)
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|ГДЕ
		|	ВозвратТоваровПоставщику.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ВозвратТоваровПоставщику_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВозвратТоваровПоставщику.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Накладная на возврат поставщику'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("СкладПредставление", Шапка.СкладПредставление);
		ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.КонтрагентНаименованиеПолное);
		
		ТаблицаТовары = Шапка.Товары.Выгрузить();

		Всего = ТаблицаТовары.Итог("Сумма");
		ВсегоНДС = ТаблицаТовары.Итог("СуммаНДС");
		ВсегоНСП = ТаблицаТовары.Итог("СуммаНСП");
		КоличествоНаименований = ТаблицаТовары.Количество();		
		
		ДанныеПечати.Вставить("Всего", Всего);
		ДанныеПечати.Вставить("ВсегоНДС", ВсегоНДС);
		ДанныеПечати.Вставить("ВсегоНСП", ВсегоНСП);
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			Формат(КоличествоНаименований, "ЧН=0; ЧГ=0"), Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2")));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего, Шапка.ВалютаДокумента));

		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("Подписи");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ТабличныйДокумент);
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Накладная", НСтр("ru = 'Накладная'"), ПечатьНакладной(МассивОбъектов, ОбъектыПечати),,
			"Документ.ВозвратТоваровПоставщику.ПФ_MXL_Накладная");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru = 'Накладная'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

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
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "")
	
	ДанныеДокумента = Новый Структура("Номер,Дата,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	Возврат СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),
		НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

#КонецОбласти

#КонецЕсли