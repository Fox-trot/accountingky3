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
		|	&Содержание КАК Содержание,
		|	ВременнаяТаблицаШапка.Склад КАК Склад
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
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВременнаяТаблицаТовары.СчетЗатрат КАК КорСчетСписания,
		|	ВременнаяТаблицаТовары.Субконто1 КАК КорСубконто1,
		|	ВременнаяТаблицаТовары.Субконто2 КАК КорСубконто2,
		|	ВременнаяТаблицаТовары.Субконто3 КАК КорСубконто3
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаТовары.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МБП)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
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
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВременнаяТаблицаТовары.СчетЗатрат КАК КорСчетСписания,
		|	ВременнаяТаблицаТовары.Субконто1 КАК КорСубконто1,
		|	ВременнаяТаблицаТовары.Субконто2 КАК КорСубконто2,
		|	ВременнаяТаблицаТовары.Субконто3 КАК КорСубконто3
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаТовары.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МБП)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Списание товаров'")); 
	Запрос.УстановитьПараметр("СинонимСписка", НСтр("ru = 'Товары'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = МассивРезультатов[0].Выгрузить();
	ТаблицаТовары = МассивРезультатов[1].Выгрузить();
	ТаблицаМБП = МассивРезультатов[2].Выгрузить();
	
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары, ТаблицаРеквизиты, Отказ);
	ТаблицаСписанныеМБП = УчетМБП.ПодготовитьТаблицуСписанныеМБП(ТаблицаМБП, ТаблицаРеквизиты, Отказ);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеТовары", ТаблицаСписанныеТовары);
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
		|	ТаблицаДокумента.Ссылка,
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.Склад
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.СписаниеТоваров КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки,
		|	ТаблицаДокумента.Номенклатура,
		|	ТаблицаДокумента.Количество,
		|	ТаблицаДокумента.СчетУчета,
		|	ТаблицаДокумента.СчетЗатрат,
		|	ТаблицаДокумента.Субконто1,
		|	ТаблицаДокумента.Субконто2,
		|	ТаблицаДокумента.Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.СписаниеТоваров.Товары КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ);
	
КонецПроцедуры

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
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1 КАК Номенклатура,
		|	СУММА(ХозрасчетныйДвиженияССубконто.Сумма) КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор В (&СписокДокументов), , ) КАК ХозрасчетныйДвиженияССубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписаниеТоваров.Ссылка,
		|	СписаниеТоваров.Номер,
		|	СписаниеТоваров.Дата,
		|	СписаниеТоваров.Организация,
		|	СписаниеТоваров.Склад,
		|	СписаниеТоваров.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Склад) КАК СкладПредставление,
		|	СписаниеТоваров.Товары.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество
		|	),
		|	СписаниеТоваров.Комиссия.(
		|		НомерСтроки,
		|		ФизЛицо,
		|		Председатель
		|	)
		|ИЗ
		|	Документ.СписаниеТоваров КАК СписаниеТоваров
		|ГДЕ
		|	СписаниеТоваров.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСписанныеТовары = МассивРезультатов[0].Выгрузить();
	ТаблицаСписанныеТовары.Индексы.Добавить("Регистратор, Номенклатура");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "СписаниеТоваров_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеТоваров.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Накладная на списание'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("СкладПредставление", Шапка.СкладПредставление);

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
		МассивОбластейМакета.Добавить("Подписи");
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
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СведенияОФизЛице, "Должность, ФИО"); 
					
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
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор В (&СписокДокументов), , ) КАК ХозрасчетныйДвиженияССубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписаниеТоваров.Ссылка КАК Ссылка,
		|	СписаниеТоваров.Номер КАК Номер,
		|	СписаниеТоваров.Дата КАК Дата,
		|	СписаниеТоваров.Организация КАК Организация,
		|	СписаниеТоваров.Склад КАК Склад,
		|	СписаниеТоваров.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Склад) КАК СкладПредставление,
		|	СписаниеТоваров.Товары.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество КАК Количество,
		|		Номенклатура.Код КАК КодНоменклатуры,
		|		СчетУчета КАК СчетУчета,
		|		СчетЗатрат КАК СчетЗатрат,
		|		Субконто1 КАК Субконто1
		|	) КАК Товары,
		|	СписаниеТоваров.Комиссия.(
		|		НомерСтроки КАК НомерСтроки,
		|		ФизЛицо КАК ФизЛицо,
		|		Председатель КАК Председатель,
		|		ФизЛицо.ФИО КАК РасшифровкаПодписи,
		|		Ссылка КАК Ссылка
		|	) КАК Комиссия,
		|	СписаниеТоваров.Комментарий КАК Комментарий
		|ИЗ
		|	Документ.СписаниеТоваров КАК СписаниеТоваров
		|ГДЕ
		|	СписаниеТоваров.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСписанныеТовары = МассивРезультатов[0].Выгрузить();
	ТаблицаСписанныеТовары.Индексы.Добавить("Регистратор, Номенклатура");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.КлючПараметровПечати = "СписаниеТоваров_АктСписанияЗапасов";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеТоваров.ПФ_MXL_АктСписанияЗапасов");
	
	Пока Шапка.Следующий() Цикл
		ТаблицаКомиссия = Шапка.Комиссия.Выгрузить();
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Акт списания'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("СкладПредставление", Шапка.СкладПредставление);

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
		МассивОбластейМакета.Добавить("Комментарий");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("Подписи");
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
				
				Для каждого СтрокаТаблицыЗначений Из ТаблицаКомиссия Цикл
					Если СтрокаТаблицыЗначений.Председатель Тогда
						ЗаголовокРазделаКомиссии = НСтр("ru = 'Председатель комиссии'");
						ОбластьМакета = Макет.ПолучитьОбласть("Комиссия");
						ОбластьМакета.Параметры.Заполнить(СтрокаТаблицыЗначений);
						
						СведенияОФизЛице = БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, СтрокаТаблицыЗначений.ФизЛицо, Шапка.Дата); 
						ОбластьМакета.Параметры.ДолжностьНаименование = СведенияОФизЛице.Должность;											 
						ОбластьМакета.Параметры.ЗаголовокРазделаКомиссии = ЗаголовокРазделаКомиссии;
						ТабличныйДокумент.Вывести(ОбластьМакета);
						Прервать;				
					КонецЕсли;
				КонецЦикла;				
				
				ПервыйРядовойЧленКомиссиии = Истина;																
				Для каждого СтрокаТаблицыЗначений Из ТаблицаКомиссия Цикл
					Если НЕ СтрокаТаблицыЗначений.Председатель Тогда
						Если ПервыйРядовойЧленКомиссиии Тогда
							ЗаголовокРазделаКомиссии = НСтр("ru = 'Члены комиссии'");
							ПервыйРядовойЧленКомиссиии = Ложь;				
						Иначе
							ЗаголовокРазделаКомиссии = "";
						КонецЕсли;
						ОбластьМакета = Макет.ПолучитьОбласть("Комиссия");
						ОбластьМакета.Параметры.Заполнить(СтрокаТаблицыЗначений);
						СведенияОФизЛице = БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, СтрокаТаблицыЗначений.ФизЛицо, Шапка.Дата); 
						ОбластьМакета.Параметры.ДолжностьНаименование = СведенияОФизЛице.Должность;											 
						ОбластьМакета.Параметры.ЗаголовокРазделаКомиссии = ЗаголовокРазделаКомиссии;
						ТабличныйДокумент.Вывести(ОбластьМакета);				
					КонецЕсли;
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
		"Документ.СписаниеТоваров.ПФ_MXL_Накладная");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСписанияЗапасов") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"АктСписанияЗапасов", 
		НСтр("ru = 'Акт списания запасов'"), 
		ПечатьАктаСписания(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.СписаниеТоваров.ПФ_MXL_АктСписанияЗапасов");
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
	КомандаПечати.Идентификатор = "АктСписанияЗапасов";
	КомандаПечати.Представление = НСтр("ru = 'Акт списания запасов'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
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
