﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// ОС 
	// Перемещение остаточной стоимости.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаОС.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаОС.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК СубконтоДт1,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВедетсяУчетОСПоПодразделениям
		|			ТОГДА ВременнаяТаблицаШапка.ПодразделениеПолучатель
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоДт2,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВедетсяУчетОСПоМОЛ
		|			ТОГДА ВременнаяТаблицаШапка.МОЛПолучатель
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоДт3,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК СубконтоКт1,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВедетсяУчетОСПоПодразделениям
		|			ТОГДА ВременнаяТаблицаШапка.ПодразделениеОтправитель
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоКт2,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВедетсяУчетОСПоМОЛ
		|			ТОГДА ВременнаяТаблицаШапка.МОЛОтправитель
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоКт3,
		|	ВременнаяТаблицаОстатки.СуммаОстаток КАК Сумма,
		|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
		|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
		|	0 КАК ВалютнаяСуммаДт,
		|	0 КАК ВалютнаяСуммаКт,
		|	&СодержаниеПеремещение КАК Содержание,
		|	0 КАК КоличествоДт,
		|	0 КАК КоличествоКт
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаОстатки КАК ВременнаяТаблицаОстатки
		|		ПО (ВременнаяТаблицаОС.ОсновноеСредство = ВременнаяТаблицаОстатки.ОсновноеСредство)
		|ГДЕ
		|	ВременнаяТаблицаОстатки.СуммаОстаток > 0";
	Запрос.УстановитьПараметр("СодержаниеПеремещение", НСтр("ru = 'Внутренее перемещение стоимости ОС'")); 
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());	
КонецПроцедуры 

Процедура СформироватьТаблицаМестонахождениеОС(ДокументСсылка, СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.МОЛПолучатель КАК МОЛ,
		|	ВременнаяТаблицаШапка.ПодразделениеПолучатель КАК Подразделение,
		|	ВременнаяТаблицаШапка.МОЛОтправитель КАК МОЛДо,
		|	ВременнаяТаблицаШапка.ПодразделениеОтправитель КАК ПодразделениеДо,
		|	ВременнаяТаблицаОС.ОсновноеСредство
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаМестонахождениеОС", РезультатЗапроса.Выгрузить()); 	
КонецПроцедуры 

Процедура СформироватьТаблицаСобытияОС(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Перемещение) КАК Событие,
		|	ВременнаяТаблицаШапка.Номер КАК НомерДокумента,
		|	ВременнаяТаблицаШапка.Ссылка КАК НазваниеДокумента,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
		|	ИСТИНА КАК ПередачаСИзносом
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСобытияОС", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ПодразделениеПолучатель КАК ПодразделениеПолучатель,
		|	ТаблицаДокумента.МОЛПолучатель КАК МОЛПолучатель,
		|	ТаблицаДокумента.ПодразделениеОтправитель КАК ПодразделениеОтправитель,
		|	ТаблицаДокумента.МОЛОтправитель КАК МОЛОтправитель,
		|	&ВедетсяУчетОСПоПодразделениям КАК ВедетсяУчетОСПоПодразделениям,
		|	&ВедетсяУчетОСПоМОЛ КАК ВедетсяУчетОСПоМОЛ
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПеремещениеОС КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	Документ.ПеремещениеОС.ОС КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК ОсновноеСредство,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток
		|ПОМЕСТИТЬ ВременнаяТаблицаОстатки
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В
		|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					ВременнаяТаблицаОС.СчетУчета КАК СчетУчета
		|				ИЗ
		|					ВременнаяТаблицаОС КАК ВременнаяТаблицаОС),
		|			,
		|			Организация = &Организация
		|				И Субконто1 В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|					ИЗ
		|						ВременнаяТаблицаОС КАК ВременнаяТаблицаОС)) КАК ХозрасчетныйОстатки";	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ВедетсяУчетОСПоПодразделениям", БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяУчетОСПоПодразделениям());
	Запрос.УстановитьПараметр("ВедетсяУчетОСПоМОЛ", БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяУчетОСПоМОЛ());
	
	Запрос.Выполнить();    		        			
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаМестонахождениеОС(ДокументСсылка, СтруктураДополнительныеСвойства); 
	СформироватьТаблицаСобытияОС(ДокументСсылка, СтруктураДополнительныеСвойства);
	
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

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
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

// Функция формирует табличный документ с печатной формой Накладная
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНакладной(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПеремещениеОС.Ссылка КАК Ссылка,
		|	ПеремещениеОС.Номер КАК Номер,
		|	ПеремещениеОС.Дата КАК Дата,
		|	ПеремещениеОС.Организация КАК Организация,
		|	ПеремещениеОС.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПеремещениеОС.ПодразделениеОтправитель.Представление КАК ПодразделениеОтправительПредставление,
		|	ПеремещениеОС.ПодразделениеПолучатель.Представление КАК ПодразделениеПолучательПредставление,
		|	ПеремещениеОС.МОЛОтправитель.Представление КАК ОтправительМОЛПредставление,
		|	ПеремещениеОС.МОЛПолучатель.Представление КАК ПолучательМОЛПредставление,
		|	ПеремещениеОС.ОС.(
		|		НомерСтроки КАК НомерСтроки,
		|		ОсновноеСредство КАК ОсновноеСредство,
		|		ОсновноеСредство.НаименованиеПолное КАК ОсновноеСредствоНаименованиеПолное,
		|		ИнвентарныйНомер КАК ИнвентарныйНомер
		|	) КАК ОС
		|ИЗ
		|	Документ.ПеремещениеОС КАК ПеремещениеОС
		|ГДЕ
		|	ПеремещениеОС.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПеремещениеОС_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПеремещениеОС.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Накладная на перемещение'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ОтправительПредставление", Шапка.ПодразделениеОтправительПредставление);
		ДанныеПечати.Вставить("ПолучательПредставление", Шапка.ПодразделениеПолучательПредставление);
		ДанныеПечати.Вставить("ОтправительМОЛПредставление", Шапка.ОтправительМОЛПредставление);
		ДанныеПечати.Вставить("ПолучательМОЛПредставление", Шапка.ПолучательМОЛПредставление);

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
				ВыборкаОС = Шапка.ОС.Выбрать();
				Пока ВыборкаОС.Следующий() Цикл
					ОбластьМакета.Параметры.Заполнить(ВыборкаОС);
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
		"Документ.ПеремещениеОС.ПФ_MXL_Накладная");
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
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПеремещениеОС";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Перемещение ОС""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
