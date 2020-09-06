﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ)	
	
	Если ДокументСсылка.ВидОперации = Перечисления.ВидыОперацийКомплектация.Комплектация Тогда  
		// Списание материалов.
		// Оприходование комплекта по сумме материалов.

		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		
		// Таблица Реквизиты.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
			|	ВременнаяТаблицаШапка.Дата КАК Период,
			|	ВременнаяТаблицаШапка.Организация КАК Организация,
			|	&СодержаниеПроводкиКомплекты КАК Содержание
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
		
		// Таблица Комплекты.
		ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ
			|	""Комплекты"" КАК ИмяСписка,
			|	&СинонимКомплекты КАК СинонимСписка,
			|	ВременнаяТаблицаКомплекты.НомерСтроки КАК НомерСтроки,
			|	ВременнаяТаблицаКомплекты.СчетУчета КАК СчетУчета,
			|	ВременнаяТаблицаКомплекты.Номенклатура КАК Номенклатура,
			|	ВременнаяТаблицаКомплекты.Количество КАК Количество,
			|	ВременнаяТаблицаШапка.Склад КАК Склад,
			|	&СчетЗатрат КАК СчетЗатрат,
			|	0 КАК Сумма
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКомплекты КАК ВременнаяТаблицаКомплекты
			|		ПО (ИСТИНА)
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();

		// Таблица Списание материалов.
		ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ
			|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
			|	ВременнаяТаблицаШапка.Дата КАК Период,
			|	ВременнаяТаблицаШапка.Организация КАК Организация,
			|	ВременнаяТаблицаШапка.Склад КАК Склад,
			|	Неопределено КАК Контрагент,
			|	&СодержаниеПроводкиСписаниеМатериалов КАК Содержание
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	""Материалы"" КАК ИмяСписка,
			|	&СинонимМатериалы КАК СинонимСписка,
			|	ВременнаяТаблицаШапка.Дата КАК Период,
			|	ВременнаяТаблицаМатериалы.НомерСтроки КАК НомерСтроки,
			|	ВременнаяТаблицаМатериалы.СчетУчета КАК СчетУчета,
			|	ВременнаяТаблицаМатериалы.Номенклатура КАК Номенклатура,
			|	ВременнаяТаблицаШапка.Склад КАК Склад,
			|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
			|	0 КАК Себестоимость,
			|	ВременнаяТаблицаМатериалы.Количество КАК Количество,
			|	&СчетЗатрат КАК КорСчетСписания,
			// Для сопоставления таблиц.
			|	ВременнаяТаблицаМатериалы.Комплект КАК КорСубконто1,
			|	НЕОПРЕДЕЛЕНО КАК КорСубконто2,
			|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаМатериалы КАК ВременнаяТаблицаМатериалы
			|		ПО (ИСТИНА)
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		Запрос.УстановитьПараметр("СодержаниеПроводкиСписаниеМатериалов", НСтр("ru = 'Списание комплектующих'")); 
		Запрос.УстановитьПараметр("СодержаниеПроводкиКомплекты", НСтр("ru = 'Оприходование комплекта'")); 
		Запрос.УстановитьПараметр("СинонимКомплекты", НСтр("ru = 'Комплекты'"));
		Запрос.УстановитьПараметр("СинонимМатериалы", НСтр("ru = 'Материалы'"));
		Запрос.УстановитьПараметр("СчетЗатрат", ПланыСчетов.Хозрасчетный.ВспомогательноеПроизводство);

		СпособОценкиТМЗ = БухгалтерскийУчетСервер.СпособОценкиТМЗ(СтруктураДополнительныеСвойства.ДляПроведения.Дата, 
			СтруктураДополнительныеСвойства.ДляПроведения.Организация);
		ВедетсяУчетПоПартиям = СпособОценкиТМЗ <> Перечисления.СпособыОценки.ПоСредней;
		Запрос.УстановитьПараметр("ВедетсяУчетПоПартиям", ВедетсяУчетПоПартиям);
		
		Запрос.Текст = ТекстЗапроса;
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		ТаблицаРеквизитыОприходования = МассивРезультатов[0].Выгрузить();
		ТаблицаОприходования = МассивРезультатов[1].Выгрузить();

		ТаблицаРеквизитыСписания = МассивРезультатов[2].Выгрузить();
		ТаблицаСписания = МассивРезультатов[3].Выгрузить();
		
		ТаблицаСписания = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаСписания, ТаблицаРеквизитыСписания, Отказ);
		
		// Заполнение суммы комплекта по себестоимости списанных материалов.
		ТаблицаСписанияКопия = ТаблицаСписания.Скопировать(,"КорСубконто1, СуммаСписания");
		ТаблицаСписанияКопия.Индексы.Добавить("КорСубконто1");
		ТаблицаСписанияКопия.Свернуть("КорСубконто1", "СуммаСписания");
		Для Каждого СтрокаТаблицы Из ТаблицаОприходования Цикл 
			НайденнаяСтрока = ТаблицаСписанияКопия.Найти(СтрокаТаблицы.Номенклатура, "КорСубконто1");
			Если НайденнаяСтрока = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			СтрокаТаблицы.Сумма = НайденнаяСтрока.СуммаСписания;		
		КонецЦикла;	
		
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизитыОприходования", ТаблицаРеквизитыОприходования);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОприходования", ТаблицаОприходования);
		
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизитыСписания", ТаблицаРеквизитыСписания);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписания", ТаблицаСписания);
		
	ИначеЕсли ДокументСсылка.ВидОперации = Перечисления.ВидыОперацийКомплектация.Разукомплектация Тогда 
		
		// Списание комплекта.
		// Оприходование материалов по коэффициенту распределения.
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		// Таблица Реквизиты.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
			|	ВременнаяТаблицаШапка.Дата КАК Период,
			|	ВременнаяТаблицаШапка.Организация КАК Организация,
			|	&СодержаниеПроводкиМатериалы КАК Содержание
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
		
		// Таблица Материалы.
		ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ
			|	""Материалы"" КАК ИмяСписка,
			|	&СинонимМатериалы КАК СинонимСписка,
			|	ВременнаяТаблицаМатериалы.НомерСтроки КАК НомерСтроки,
			|	ВременнаяТаблицаМатериалы.СчетУчета КАК СчетУчета,
			|	ВременнаяТаблицаМатериалы.Номенклатура КАК Номенклатура,
			|	ВременнаяТаблицаМатериалы.Комплект КАК Комплект,
			|	ВременнаяТаблицаМатериалы.Коэффициент КАК Коэффициент,
			|	ВременнаяТаблицаМатериалы.Количество КАК Количество,
			|	ВременнаяТаблицаШапка.Склад КАК Склад,
			|	&СчетЗатрат КАК СчетЗатрат,
			|	0 КАК Сумма
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаМатериалы КАК ВременнаяТаблицаМатериалы
			|		ПО (ИСТИНА)
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();

		// Таблица Списание Комплектов.
		ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ
			|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
			|	ВременнаяТаблицаШапка.Дата КАК Период,
			|	ВременнаяТаблицаШапка.Организация КАК Организация,
			|	ВременнаяТаблицаШапка.Склад КАК Склад,
			|	&СодержаниеПроводкиСписаниеКомплектов КАК Содержание
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	""Комплекты"" КАК ИмяСписка,
			|	&СинонимКомплекты КАК СинонимСписка,
			|	ВременнаяТаблицаШапка.Дата КАК Период,
			|	ВременнаяТаблицаКомплекты.НомерСтроки КАК НомерСтроки,
			|	ВременнаяТаблицаКомплекты.СчетУчета КАК СчетУчета,
			|	ВременнаяТаблицаКомплекты.Номенклатура КАК Номенклатура,
			|	ВременнаяТаблицаШапка.Склад КАК Склад,
			|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
			|	0 КАК Себестоимость,
			|	ВременнаяТаблицаКомплекты.Количество КАК Количество,
			|	&СчетЗатрат КАК КорСчетСписания,
			|	НЕОПРЕДЕЛЕНО КАК КорСубконто1,
			|	НЕОПРЕДЕЛЕНО КАК КорСубконто2,
			|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
			|ИЗ
			|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКомплекты КАК ВременнаяТаблицаКомплекты
			|		ПО (ИСТИНА)
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		Запрос.УстановитьПараметр("СодержаниеПроводкиСписаниеКомплектов", НСтр("ru = 'Списание комплектов'")); 
		Запрос.УстановитьПараметр("СодержаниеПроводкиМатериалы", НСтр("ru = 'Оприходование комплектующих'")); 
		Запрос.УстановитьПараметр("СинонимКомплекты", НСтр("ru = 'Комплекты'"));
		Запрос.УстановитьПараметр("СинонимМатериалы", НСтр("ru = 'Материалы'"));
		Запрос.УстановитьПараметр("СчетЗатрат", ПланыСчетов.Хозрасчетный.ВспомогательноеПроизводство);

		СпособОценкиТМЗ = БухгалтерскийУчетСервер.СпособОценкиТМЗ(СтруктураДополнительныеСвойства.ДляПроведения.Дата, 
			СтруктураДополнительныеСвойства.ДляПроведения.Организация);
		ВедетсяУчетПоПартиям = СпособОценкиТМЗ <> Перечисления.СпособыОценки.ПоСредней;
		Запрос.УстановитьПараметр("ВедетсяУчетПоПартиям", ВедетсяУчетПоПартиям);
		
		Запрос.Текст = ТекстЗапроса;
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		ТаблицаРеквизитыОприходования = МассивРезультатов[0].Выгрузить();
		ТаблицаОприходования = МассивРезультатов[1].Выгрузить();

		ТаблицаРеквизитыСписания = МассивРезультатов[2].Выгрузить();
		ТаблицаСписания = МассивРезультатов[3].Выгрузить();
		
		ТаблицаСписания = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаСписания, ТаблицаРеквизитыСписания, Отказ);
		
		// Распределение суммы комплекта по материалам.
		ТаблицаСписанияКопия = ТаблицаСписания.Скопировать(,"Номенклатура, СуммаСписания");
		ТаблицаСписанияКопия.Свернуть("Номенклатура", "СуммаСписания");
		Для Каждого СтрокаТаблицы Из ТаблицаСписанияКопия Цикл 
			// Поиск строк комплекта.
			Отбор = Новый Структура;
			Отбор.Вставить("Комплект", СтрокаТаблицы.Номенклатура);
			НайденныеСтроки = ТаблицаОприходования.НайтиСтроки(Отбор);
			
			Коэффициенты = Новый Массив;
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
				Коэффициенты.Добавить(НайденнаяСтрока.Коэффициент);
			КонецЦикла;	
			
			Если СтрокаТаблицы.СуммаСписания = 0
				Или Коэффициенты.Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;	
			
			Индекс = 0;
			РезультатРаспределения = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаТаблицы.СуммаСписания, Коэффициенты);			
			Для Каждого Результат Из РезультатРаспределения Цикл 
				НайденныеСтроки[Индекс].Сумма = Результат;
				Индекс = Индекс + 1;
			КонецЦикла;	
		КонецЦикла;	
		
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизитыОприходования", ТаблицаРеквизитыОприходования);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОприходования", ТаблицаОприходования);
		
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизитыСписания", ТаблицаРеквизитыСписания);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписания", ТаблицаСписания);
	КонецЕсли;	
	
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.Склад КАК Склад
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.КомплектацияНоменклатуры КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Количество КАК Количество,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ТаблицаДокумента.Спецификация КАК Спецификация
		|ПОМЕСТИТЬ ВременнаяТаблицаКомплекты
		|ИЗ
		|	Документ.КомплектацияНоменклатуры.Комплекты КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Коэффициент КАК Коэффициент,
		|	ТаблицаДокумента.Количество КАК Количество,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ТаблицаДокумента.Комплект КАК Комплект
		|ПОМЕСТИТЬ ВременнаяТаблицаМатериалы
		|ИЗ
		|	Документ.КомплектацияНоменклатуры.Материалы КАК ТаблицаДокумента
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

// Функция формирует табличный документ с печатной формой Комплектация
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьКомплектация(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "КомплектацияНоменклатуры_Комплектация";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.КомплектацияНоменклатуры.ПФ_MXL_Комплектация");
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоДт1 КАК Номенклатура,
		|	СУММА(ХозрасчетныйДвиженияССубконто.Сумма) КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
		|			,
		|			,
		|			Регистратор В (&СписокДокументов)
		|				И ВидСубконтоДт1 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура),
		|			,
		|			) КАК ХозрасчетныйДвиженияССубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйДвиженияССубконто.Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоДт1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СубконтоКт1 КАК Номенклатура,
		|	СУММА(ХозрасчетныйДвиженияССубконто.Сумма) КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
		|			,
		|			,
		|			Регистратор В (&СписокДокументов)
		|				И ВидСубконтоКт1 = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура),
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
		|	КомплектацияНоменклатуры.Ссылка КАК Ссылка,
		|	КомплектацияНоменклатуры.Номер КАК Номер,
		|	КомплектацияНоменклатуры.Дата КАК Дата,
		|	КомплектацияНоменклатуры.ВидОперации КАК ВидОперации,
		|	КомплектацияНоменклатуры.Организация КАК Организация,
		|	КомплектацияНоменклатуры.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	КомплектацияНоменклатуры.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		|	КомплектацияНоменклатуры.Склад КАК Склад,
		|	ПРЕДСТАВЛЕНИЕ(КомплектацияНоменклатуры.ВидОперации) КАК ВидОперацииПредставление,
		|	ПРЕДСТАВЛЕНИЕ(КомплектацияНоменклатуры.Склад) КАК СкладПредставление,
		|	КомплектацияНоменклатуры.Комплекты.(
		|		Номенклатура КАК Номенклатура,
		|		Количество КАК Количество,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление
		|	) КАК Комплекты,
		|	КомплектацияНоменклатуры.Материалы.(
		|		Номенклатура КАК Номенклатура,
		|		Количество КАК Количество,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление
		|	) КАК Материалы
		|ИЗ
		|	Документ.КомплектацияНоменклатуры КАК КомплектацияНоменклатуры
		|ГДЕ
		|	КомплектацияНоменклатуры.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаОприходованныеТовары = МассивРезультатов[0].Выгрузить();
	ТаблицаОприходованныеТовары.Индексы.Добавить("Регистратор, Номенклатура");
	ТаблицаСписанныеТовары = МассивРезультатов[1].Выгрузить();
	ТаблицаСписанныеТовары.Индексы.Добавить("Регистратор, Номенклатура");
	
	Шапка = МассивРезультатов[2].Выбрать();
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, Шапка.ВидОперацииПредставление);
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("СкладПредставление", Шапка.СкладПредставление);

		ТаблицаКомплекты = Шапка.Комплекты.Выгрузить();
		ТаблицаКомплекты.Свернуть("Номенклатура, НоменклатураПредставление", "Количество");
		ТаблицаМатериалы = Шапка.Материалы.Выгрузить();
		ТаблицаМатериалы.Свернуть("Номенклатура, НоменклатураПредставление", "Количество");
		
		// Копия таблицы если печать нескольких документов.
		ПараметрыОтбора = Новый Структура("Регистратор", Шапка.Ссылка);
		ТаблицаОприходованныеТоварыКопия = ТаблицаОприходованныеТовары.Скопировать(ПараметрыОтбора);
		ТаблицаСписанныеТоварыКопия = ТаблицаСписанныеТовары.Скопировать(ПараметрыОтбора);
		
		ДанныеПечати.Вставить("Всего", ТаблицаОприходованныеТоварыКопия.Итог("Сумма"));
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			Формат(ТаблицаКомплекты.Количество(), "ЧН=0; ЧГ=0"), 
			Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2")));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего));
		
		ДанныеПечатиСебестоимость = Новый Структура;
		ДанныеПечатиСебестоимость.Вставить("НомерСтроки", 0);
		ДанныеПечатиСебестоимость.Вставить("Цена", 0);
		ДанныеПечатиСебестоимость.Вставить("Сумма", 0);

		ДанныеПечати.Вставить("ЗаголовокТаблицы", НСтр("ru = 'Комплекты'"));
	
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
				ПараметрыОтбора.Вставить("Номенклатура", Неопределено);
				НомерСтроки = 1;
				Для Каждого СтрокаТаблицы Из ТаблицаКомплекты Цикл
					// Заполнение суммы комплектов
					ПараметрыОтбора.Номенклатура = СтрокаТаблицы.Номенклатура;
					Если Шапка.ВидОперации = Перечисления.ВидыОперацийКомплектация.Комплектация Тогда 
						НайденныеСтроки = ТаблицаОприходованныеТоварыКопия.НайтиСтроки(ПараметрыОтбора);
					Иначе 
						НайденныеСтроки = ТаблицаСписанныеТоварыКопия.НайтиСтроки(ПараметрыОтбора);
					КонецЕсли;
					
					ДанныеПечатиСебестоимость.НомерСтроки = НомерСтроки;
					НомерСтроки = НомерСтроки + 1;
					
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
				
				// Заголовок второй таблицы.
				ОбластьМакета =  Макет.ПолучитьОбласть("ШапкаТаблицы");
				ДанныеПечати.Вставить("ЗаголовокТаблицы", НСтр("ru = 'Комплектующие'"));
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
				ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
				НомерСтроки = 1;
				Для Каждого СтрокаТаблицы Из ТаблицаМатериалы Цикл
					// Заполнение суммы материалов
					ПараметрыОтбора.Номенклатура = СтрокаТаблицы.Номенклатура;
					Если Шапка.ВидОперации = Перечисления.ВидыОперацийКомплектация.Комплектация Тогда 
						НайденныеСтроки = ТаблицаСписанныеТоварыКопия.НайтиСтроки(ПараметрыОтбора);
					Иначе 
						НайденныеСтроки = ТаблицаОприходованныеТоварыКопия.НайтиСтроки(ПараметрыОтбора);
					КонецЕсли;
					
					ДанныеПечатиСебестоимость.НомерСтроки = НомерСтроки;
					НомерСтроки = НомерСтроки + 1;

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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КомплектацияНоменклатуры") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"КомплектацияНоменклатуры", 
		НСтр("ru = 'Комплектация'"), 
		ПечатьКомплектация(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.КомплектацияНоменклатуры.ПФ_MXL_Комплектация");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РазукомплектацияНоменклатуры") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"РазукомплектацияНоменклатуры", 
		НСтр("ru = 'Разукомплектация'"), 
		ПечатьКомплектация(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.КомплектацияНоменклатуры.ПФ_MXL_Разукомплектация");

	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КомплектацияНоменклатуры";
	КомандаПечати.Представление = НСтр("ru = 'Комплектация'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "ВидОперации", Перечисления.ВидыОперацийКомплектация.Комплектация);
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РазукомплектацияНоменклатуры";
	КомандаПечати.Представление = НСтр("ru = 'Разукомплектация'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "ВидОперации", Перечисления.ВидыОперацийКомплектация.Разукомплектация);
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрОтчетПроизводстваЗаСмену";     
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Отчет производства за смену""'");
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
