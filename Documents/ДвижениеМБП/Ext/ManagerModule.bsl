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
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию)
		|			ТОГДА &СодержаниеВводВЭксплуатацию
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.СписаниеМБП)
		|			ТОГДА &СодержаниеСписание
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.РеализацияМБП)
		|			ТОГДА &СодержаниеРеализация
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБП)
		|			ТОГДА &СодержаниеПеремещение
		|	КОНЕЦ КАК Содержание,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию)
		|				ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам)
		|			ТОГДА ВременнаяТаблицаШапка.Склад
		|		ИНАЧЕ ВременнаяТаблицаШапка.ФизЛицо
		|	КОНЕЦ КАК Склад,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам)
		|			ТОГДА ВременнаяТаблицаШапка.СкладПолучатель
		|		ИНАЧЕ ВременнаяТаблицаШапка.ФизЛицоПолучатель
		|	КОНЕЦ КАК СкладПолучатель
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Товары"" КАК ИмяСписка,
		|	&СинонимСписка КАК СинонимСписка,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию)
		|				ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам)
		|			ТОГДА ВременнаяТаблицаШапка.Склад
		|		ИНАЧЕ ВременнаяТаблицаШапка.ФизЛицо
		|	КОНЕЦ КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию)
		|				ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам)
		|				ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБП)
		|			ТОГДА ВременнаяТаблицаТовары.СчетУчета
		|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленныйИзносМБП)
		|	КОНЕЦ КАК КорСчетСписания,
		|	ВременнаяТаблицаТовары.Номенклатура КАК КорСубконто1,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам)
		|			ТОГДА ВременнаяТаблицаШапка.СкладПолучатель
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3,
		|	ВременнаяТаблицаТовары.СчетЗатрат КАК СчетЗатрат,
		|	ВременнаяТаблицаТовары.Субконто1 КАК Субконто1,
		|	ВременнаяТаблицаТовары.Субконто2 КАК Субконто2,
		|	ВременнаяТаблицаТовары.Субконто3 КАК Субконто3,
		|	ВременнаяТаблицаШапка.ВидОперации КАК ВидОперации
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("СодержаниеВводВЭксплуатацию", НСтр("ru = 'Ввод в эксплуатацию МБП'"));
	Запрос.УстановитьПараметр("СодержаниеСписание", НСтр("ru = 'Списание МБП'"));
	Запрос.УстановитьПараметр("СодержаниеРеализация", НСтр("ru = 'Реализация МБП'"));
	Запрос.УстановитьПараметр("СодержаниеПеремещение", НСтр("ru = 'Перемещение МБП'"));		
	Запрос.УстановитьПараметр("СинонимСписка", НСтр("ru = 'МБП'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты  = МассивРезультатов[0].Выгрузить();
	ТаблицаМБП 		  = МассивРезультатов[1].Выгрузить();
	
	ВидУчетаИзносаМБП = СтруктураДополнительныеСвойства.УчетнаяПолитика.ВидУчетаИзносаМБП;
	ВидОперации		  = ТаблицаМБП[0].ВидОперации;
	
	Если ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию Тогда
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			ТаблицаСписанныеМБП = УчетМБП.ПодготовитьТаблицуСписанныеМБП(ТаблицаМБП, ТаблицаРеквизиты, Отказ, Ложь, Истина);
		Иначе
			ТаблицаСписанныеМБП = УчетМБП.ПодготовитьТаблицуСписанныеМБП(ТаблицаМБП, ТаблицаРеквизиты, Отказ, Ложь);
		КонецЕсли;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБП Тогда
		ТаблицаСписанныеМБП = УчетМБП.ПодготовитьТаблицуСписанныеМБП(ТаблицаМБП, ТаблицаРеквизиты, Отказ, Истина);	
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам Тогда
		ТаблицаСписанныеМБП = УчетМБП.ПодготовитьТаблицуСписанныеМБП(ТаблицаМБП, ТаблицаРеквизиты, Отказ);
	Иначе
		ТаблицаСписанныеМБП = УчетМБП.ПодготовитьТаблицуСписанныеМБП(ТаблицаМБП, ТаблицаРеквизиты, Отказ, Истина, Истина);
	КонецЕсли;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеМБП", ТаблицаСписанныеМБП);
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДвижениеМБП.Ссылка КАК Ссылка,
		|	ДвижениеМБП.Номер КАК Номер,
		|	ДвижениеМБП.Дата КАК Дата,
		|	ДвижениеМБП.Организация КАК Организация,
		|	ДвижениеМБП.ВидОперации КАК ВидОперации,
		|	ДвижениеМБП.Склад КАК Склад,
		|	ДвижениеМБП.СкладПолучатель КАК СкладПолучатель,
		|	ДвижениеМБП.ФизЛицо КАК ФизЛицо,
		|	ДвижениеМБП.ФизЛицоПолучатель КАК ФизЛицоПолучатель
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ДвижениеМБП КАК ДвижениеМБП
		|ГДЕ
		|	ДвижениеМБП.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвижениеМБПТовары.НомерСтроки КАК НомерСтроки,
		|	ДвижениеМБПТовары.Номенклатура КАК Номенклатура,
		|	ДвижениеМБПТовары.Количество КАК Количество,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МБП) КАК СчетУчета,
		|	ДвижениеМБПТовары.СчетЗатрат КАК СчетЗатрат,
		|	ДвижениеМБПТовары.Субконто1 КАК Субконто1,
		|	ДвижениеМБПТовары.Субконто2 КАК Субконто2,
		|	ДвижениеМБПТовары.Субконто3 КАК Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ДвижениеМБП.Товары КАК ДвижениеМБПТовары
		|ГДЕ
		|	ДвижениеМБПТовары.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка,СтруктураДополнительныеСвойства, Отказ);	
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
		|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1 КАК Номенклатура,
		|	СУММА(ХозрасчетныйДвиженияССубконто.Сумма) КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
		|			,
		|			,
		|			Регистратор В (&СписокДокументов)
		|				И СчетКт.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный),
		|			,
		|			) КАК ХозрасчетныйДвиженияССубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвижениеМБП.Ссылка КАК Ссылка,
		|	ДвижениеМБП.Номер КАК Номер,
		|	ДвижениеМБП.Дата КАК Дата,
		|	ДвижениеМБП.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию)
		|			ТОГДА &ВводМБПВЭксплуатацию
		|		КОГДА ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБП)
		|			ТОГДА &ПеремещениеМБП
		|		КОГДА ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.СписаниеМБП)
		|			ТОГДА &СписаниеМБП
		|		КОГДА ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.РеализацияМБП)
		|			ТОГДА &РеализацияМБП
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ВидОперацииПредставление,
		|	ВЫБОР
		|		КОГДА ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.СписаниеМБП)
		|				ИЛИ ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.РеализацияМБП)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ВидОперацииСписание,
		|	ВЫБОР
		|		КОГДА ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.СписаниеМБП)
		|				ИЛИ ДвижениеМБП.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвижениеМБП.ПеремещениеМБП)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ВывестиШапкуСЦеной,
		|	ДвижениеМБП.ФизЛицо КАК ФизЛицо,
		|	ДвижениеМБП.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПРЕДСТАВЛЕНИЕ(ДвижениеМБП.Склад) КАК СкладПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ДвижениеМБП.ФизЛицо) КАК ФизЛицоПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ДвижениеМБП.ФизЛицоПолучатель) КАК ФизЛицоПолучательПредставление,
		|	ДвижениеМБП.Товары.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(ДвижениеМБП.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество КАК Количество
		|	) КАК Товары,
		|	ДвижениеМБП.Комиссия.(
		|		НомерСтроки КАК НомерСтроки,
		|		ФизЛицо КАК ФизЛицо,
		|		Председатель КАК Председатель
		|	) КАК Комиссия
		|ИЗ
		|	Документ.ДвижениеМБП КАК ДвижениеМБП
		|ГДЕ
		|	ДвижениеМБП.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВводМБПВЭксплуатацию", НСтр("ru = 'ввод в эксплуатацию МБП'"));
	Запрос.УстановитьПараметр("ПеремещениеМБП", НСтр("ru = 'перемещение МБП'"));
	Запрос.УстановитьПараметр("СписаниеМБП", НСтр("ru = 'списание МБП'"));
	Запрос.УстановитьПараметр("РеализацияМБП", НСтр("ru = 'реализацию МБП'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСписанныеТовары = МассивРезультатов[0].Выгрузить();
	ТаблицаСписанныеТовары.Индексы.Добавить("Регистратор, Номенклатура");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ДвижениеМБП_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДвижениеМБП.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, СтрШаблон(НСтр("ru = 'Накладная на %1'"), Шапка.ВидОперацииПредставление));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ФизЛицоПредставление", Шапка.ФизЛицоПредставление);
		ДанныеПечати.Вставить("ОтправительПредставление", Шапка.СкладПредставление);
		ДанныеПечати.Вставить("ПолучательПредставление", Шапка.ФизЛицоПолучательПредставление);

		ТаблицаТовары = Шапка.Товары.Выгрузить();
		
		ДанныеПечати.Вставить("Всего", ТаблицаСписанныеТовары.Итог("Сумма"));
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			Формат(ТаблицаТовары.Количество(), "ЧН=0; ЧГ=0"), 
			Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2")));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего));
		
		ДанныеПечатиСебестоимость = Новый Структура;
		ДанныеПечатиСебестоимость.Вставить("Цена", 0);
		ДанныеПечатиСебестоимость.Вставить("Сумма", 0);

		ПараметрыОтбора = Новый Структура("Регистратор, Номенклатура", Шапка.Ссылка, Неопределено);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		Если Шапка.ВидОперацииСписание Тогда 
			МассивОбластейМакета.Добавить("ЗаголовокСписание");
		Иначе
			МассивОбластейМакета.Добавить("ЗаголовокПеремещение");
			ДанныеПечати.ОтправительПредставление = ДанныеПечати.ФизЛицоПредставление;
		КонецЕсли;
		Если Шапка.ВывестиШапкуСЦеной Тогда  
			МассивОбластейМакета.Добавить("ШапкаТаблицыЦена");
		Иначе
			МассивОбластейМакета.Добавить("ШапкаТаблицыСтоимость");
		КонецЕсли;	
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		Если Шапка.ВидОперацииСписание Тогда 
			МассивОбластейМакета.Добавить("ПодписиСписание");
		Иначе 	
			МассивОбластейМакета.Добавить("Подписи");
		КонецЕсли;	
		МассивОбластейМакета.Добавить("ПодписиКомиссия");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка"
				И ИмяОбласти <> "ПодписиКомиссия" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					// Заполнение суммы списания
					ПараметрыОтбора.Номенклатура = СтрокаТаблицы.Номенклатура;
					НайденныеСтроки = ТаблицаСписанныеТовары.НайтиСтроки(ПараметрыОтбора);
					Если НайденныеСтроки.Количество() > 0 Тогда 
						ДанныеПечатиСебестоимость.Сумма = НайденныеСтроки[0].Сумма;
						ДанныеПечатиСебестоимость.Цена = ?(СтрокаТаблицы.Количество = 0, 0, ДанныеПечатиСебестоимость.Сумма / СтрокаТаблицы.Количество);
					Иначе 
						ДанныеПечатиСебестоимость.Сумма = 0;
						ДанныеПечатиСебестоимость.Цена = 0;
					КонецЕсли;
					
					ОбластьМакета.Параметры.Заполнить(ДанныеПечатиСебестоимость);
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			ИначеЕсли ИмяОбласти = "ПодписиКомиссия" Тогда
				// Формирование комиссии
				ВыборкаКомиссия = Шапка.Комиссия.Выбрать();
				Пока ВыборкаКомиссия.Следующий() Цикл
					ОбластьМакета.Параметры.Заполнить(ВыборкаКомиссия);
		
					СведенияОФизЛице = БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, ВыборкаКомиссия.ФизЛицо, Шапка.Дата); 
					ОбластьМакета.Параметры.Должность 			= СведенияОФизЛице.Должность;
					ОбластьМакета.Параметры.РасшифровкаПодписи	= СведенияОФизЛице.ФамилияИнициалы;						
					
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой ПечатьНакладной
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьАктаСписания(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1 КАК Номенклатура,
		|	СУММА(ХозрасчетныйДвиженияССубконто.Сумма) КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
		|			,
		|			,
		|			Регистратор В (&СписокДокументов)
		|				И СчетКт.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный),
		|			,
		|			) КАК ХозрасчетныйДвиженияССубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвижениеМБП.Ссылка КАК Ссылка,
		|	ДвижениеМБП.Номер КАК Номер,
		|	ДвижениеМБП.Дата КАК Дата,
		|	ДвижениеМБП.Организация КАК Организация,
		|	ДвижениеМБП.ФизЛицо КАК ФизЛицо,
		|	ДвижениеМБП.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ДвижениеМБП.Товары.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(ДвижениеМБП.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество КАК Количество,
		|		ПРЕДСТАВЛЕНИЕ(Значение(ПланСчетов.Хозрасчетный.МБП)) КАК Счет
		|	) КАК Товары,
		|	ДвижениеМБП.Комиссия.(
		|		НомерСтроки КАК НомерСтроки,
		|		ФизЛицо КАК ФизЛицо,
		|		Председатель КАК Председатель
		|	) КАК Комиссия
		|ИЗ
		|	Документ.ДвижениеМБП КАК ДвижениеМБП
		|ГДЕ
		|	ДвижениеМБП.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСписанныеТовары = МассивРезультатов[0].Выгрузить();
	ТаблицаСписанныеТовары.Индексы.Добавить("Регистратор, Номенклатура");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ДвижениеМБП_АктСписанияМБП";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДвижениеМБП.ПФ_MXL_АктСписанияМБП");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Акт списания МБП'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ФизЛицоПредставление", БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, Шапка.ФизЛицо, Шапка.Дата).ФИО);

		ТаблицаТовары = Шапка.Товары.Выгрузить();
		
		ДанныеПечати.Вставить("Всего", ТаблицаСписанныеТовары.Итог("Сумма"));
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			Формат(ТаблицаТовары.Количество(), "ЧН=0; ЧГ=0"), 
			Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2")));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего));
		
		ДанныеПечатиСебестоимость = Новый Структура;
		ДанныеПечатиСебестоимость.Вставить("Цена", 0);
		ДанныеПечатиСебестоимость.Вставить("Сумма", 0);

		ПараметрыОтбора = Новый Структура("Регистратор, Номенклатура", Шапка.Ссылка, Неопределено);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("ПодписиСписание");
		МассивОбластейМакета.Добавить("ПодписиКомиссия");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка"
				И ИмяОбласти <> "ПодписиКомиссия" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					// Заполнение суммы списания
					ПараметрыОтбора.Номенклатура = СтрокаТаблицы.Номенклатура;
					НайденныеСтроки = ТаблицаСписанныеТовары.НайтиСтроки(ПараметрыОтбора);
					Если НайденныеСтроки.Количество() > 0 Тогда 
						ДанныеПечатиСебестоимость.Сумма = НайденныеСтроки[0].Сумма;
						ДанныеПечатиСебестоимость.Цена = ?(СтрокаТаблицы.Количество = 0, 0, ДанныеПечатиСебестоимость.Сумма / СтрокаТаблицы.Количество);
					Иначе 
						ДанныеПечатиСебестоимость.Сумма = 0;
						ДанныеПечатиСебестоимость.Цена = 0;
					КонецЕсли;
					
					ОбластьМакета.Параметры.Заполнить(ДанныеПечатиСебестоимость);
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			ИначеЕсли ИмяОбласти = "ПодписиКомиссия" Тогда
				// Формирование комиссии
				ВыборкаКомиссия = Шапка.Комиссия.Выбрать();
				Пока ВыборкаКомиссия.Следующий() Цикл
					ОбластьМакета.Параметры.Заполнить(ВыборкаКомиссия);
		
					СведенияОФизЛице = БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, ВыборкаКомиссия.ФизЛицо, Шапка.Дата); 
					ОбластьМакета.Параметры.Должность 			= СведенияОФизЛице.Должность;
					ОбластьМакета.Параметры.РасшифровкаПодписи	= СведенияОФизЛице.ФамилияИнициалы;						
					
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"Накладная", 
		НСтр("ru = 'Накладная'"), 
		ПечатьНакладной(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ДвижениеМБП.ПФ_MXL_Накладная");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСписанияМБП") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"АктСписанияМБП", 
		НСтр("ru = 'Акт списания МБП'"), 
		ПечатьАктаСписания(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ДвижениеМБП.ПФ_MXL_АктСписанияМБП");
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
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктСписанияМБП";
	КомандаПечати.Представление = НСтр("ru = 'Акт списания МБП'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "ВидОперации",
		Перечисления.ВидыОперацийДвижениеМБП.СписаниеМБП);
	
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