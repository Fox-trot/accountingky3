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
		|	ВременнаяТаблицаШапка.СкладОтправитель КАК Склад,
		|	Неопределено КАК Контрагент,
		|	ВременнаяТаблицаШапка.СкладПолучатель КАК СкладПолучатель
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Товары"" КАК ИмяСписка,
		|	&СинонимСписка КАК СинонимСписка,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.СкладОтправитель КАК Склад,
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.УстановитьНовыйСчетУчета
		|			ТОГДА ВременнаяТаблицаТовары.НовыйСчетУчета
		|		ИНАЧЕ ВременнаяТаблицаТовары.СчетУчета
		|	КОНЕЦ КАК КорСчетСписания,
		|	ВременнаяТаблицаТовары.Номенклатура КАК КорСубконто1,
		|	ВременнаяТаблицаШапка.СкладОтправитель КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
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
		|	ВременнаяТаблицаШапка.СкладОтправитель КАК Склад,
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.УстановитьНовыйСчетУчета
		|			ТОГДА ВременнаяТаблицаТовары.НовыйСчетУчета
		|		ИНАЧЕ ВременнаяТаблицаТовары.СчетУчета
		|	КОНЕЦ КАК КорСчетСписания,
		|	ВременнаяТаблицаТовары.Номенклатура КАК КорСубконто1,
		|	ВременнаяТаблицаШапка.СкладОтправитель КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаТовары.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МБП)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Перемещение товаров'")); 
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
		|	ТаблицаДокумента.СкладОтправитель,
		|	ТаблицаДокумента.СкладПолучатель,
		|	ТаблицаДокумента.УстановитьНовыйСчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПеремещениеТоваров КАК ТаблицаДокумента
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
		|	ТаблицаДокумента.НовыйСчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ПеремещениеТоваров.Товары КАК ТаблицаДокумента
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

// Функция формирует табличный документ с печатной формой НакладнаяНаПеремещение
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНакладнойНаПеремещение(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПеремещениеТоваров.Ссылка,
		|	ПеремещениеТоваров.Номер,
		|	ПеремещениеТоваров.Дата,
		|	ПеремещениеТоваров.Организация.НаименованиеПолное КАК ОрганизацияПредставление,
		|	ПеремещениеТоваров.СкладОтправитель.Представление КАК СкладОтправительПредставление,
		|	ПеремещениеТоваров.СкладПолучатель.Представление КАК СкладПолучательПредставление,
		|	ПеремещениеТоваров.Товары.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(Номенклатура.КодТНВЭД) КАК КодПоКлассификатору,
		|		Представление(Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество
		|	) КАК Товары
		|ИЗ
		|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
		|ГДЕ
		|	ПеремещениеТоваров.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПеремещениеТоваров_НакладнаяНаПеремещение";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПеремещениеТоваров.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Накладная на перемещение'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияПредставление);
		ДанныеПечати.Вставить("ОтправительПредставление", Шапка.СкладОтправительПредставление);
		ДанныеПечати.Вставить("ПолучательПредставление", Шапка.СкладПолучательПредставление);

		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Подписи");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе
				ВыборкаТовары = Шапка.Товары.Выбрать();
				Пока ВыборкаТовары.Следующий() Цикл
					ОбластьМакета.Параметры.Заполнить(ВыборкаТовары);
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
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета ПеремещениеТоваров формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Накладная", НСтр("ru = 'Накладная'"), ПечатьНакладнойНаПеремещение(МассивОбъектов, ОбъектыПечати),,
			"Документ.ПеремещениеТоваров.ПФ_MXL_Накладная");
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
	КомандаПечати.Представление = НСтр("ru = 'Накладная на перемещение'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПеремещениеТоваров";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Перемещение товаров""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
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
