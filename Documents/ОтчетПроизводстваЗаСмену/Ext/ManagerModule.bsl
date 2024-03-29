﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТекстЗапросаДанныеДляОбновленияЦенДокументов() Экспорт
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.ПлановаяСтоимость КАК Цена,
		|	&Валюта КАК Валюта,
		|	&СпособЗаполненияЦены КАК СпособЗаполненияЦены,
		|	&ЦенаВключаетНалоги КАК ЦенаВключаетНалоги
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Продукция КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокумента.Номенклатура,
		|	ТаблицаДокумента.ПлановаяСтоимость,
		|	&Валюта,
		|	&СпособЗаполненияЦены,
		|	&ЦенаВключаетНалоги
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Услуги КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ)	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ТекстЗапроса =
		// Таблица Реквизиты.
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	&СодержаниеПроводкиВыпускОтходов КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		// Таблица Продукция.
		|ВЫБРАТЬ
		|	""Продукция"" КАК ИмяСписка,
		|	&СинонимПродукция КАК СинонимСписка,
		|	ВременнаяТаблицаПродукция.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаПродукция.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаПродукция.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаПродукция.СуммаПлановая КАК СуммаПлановая,
		|	ВременнаяТаблицаПродукция.Количество КАК Количество,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	ВременнаяТаблицаШапка.СчетЗатрат КАК СчетЗатрат,
		|	ВременнаяТаблицаШапка.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.НоменклатурнаяГруппаВТаблице
		|			ТОГДА ВременнаяТаблицаПродукция.НоменклатурнаяГруппа
		|		ИНАЧЕ ВременнаяТаблицаШапка.НоменклатурнаяГруппа
		|	КОНЕЦ КАК НоменклатурнаяГруппаЗатрат
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПродукция КАК ВременнаяТаблицаПродукция
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();

	// Таблица Выпуск.
	ТекстЗапросаФрагмент =
		"ВЫБРАТЬ
		|	""Продукция"" КАК ИмяСписка,
		|	&СинонимПродукция КАК СинонимСписка,
		|	ВременнаяТаблицаПродукция.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаПродукция.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаШапка.СчетЗатрат КАК СчетЗатрат,
		|	ВременнаяТаблицаШапка.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.НоменклатурнаяГруппаВТаблице
		|			ТОГДА ВременнаяТаблицаПродукция.НоменклатурнаяГруппа
		|		ИНАЧЕ ВременнаяТаблицаШапка.НоменклатурнаяГруппа
		|	КОНЕЦ КАК НоменклатурнаяГруппаЗатрат,
		|	ВременнаяТаблицаПродукция.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаПродукция.СчетУчета КАК СчетСписания,
		|	ВЫБОР
		|		КОГДА ВидыСубконто1.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура)
		|			ТОГДА ВременнаяТаблицаПродукция.Номенклатура
		|		КОГДА ВидыСубконто1.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады)
		|			ТОГДА ВременнаяТаблицаШапка.Склад
		|		КОГДА ВидыСубконто1.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии)
		|				И &ВедетсяУчетПоПартиям
		|			ТОГДА ВременнаяТаблицаШапка.Ссылка
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоСписания1,
		|	ВЫБОР
		|		КОГДА ВидыСубконто2.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура)
		|			ТОГДА ВременнаяТаблицаПродукция.Номенклатура
		|		КОГДА ВидыСубконто2.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады)
		|			ТОГДА ВременнаяТаблицаШапка.Склад
		|		КОГДА ВидыСубконто2.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии)
		|				И &ВедетсяУчетПоПартиям
		|			ТОГДА ВременнаяТаблицаШапка.Ссылка
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоСписания2,
		|	ВЫБОР
		|		КОГДА ВидыСубконто3.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура)
		|			ТОГДА ВременнаяТаблицаПродукция.Номенклатура
		|		КОГДА ВидыСубконто3.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады)
		|			ТОГДА ВременнаяТаблицаШапка.Склад
		|		КОГДА ВидыСубконто3.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии)
		|				И &ВедетсяУчетПоПартиям
		|			ТОГДА ВременнаяТаблицаШапка.Ссылка
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоСписания3,
		|	ВременнаяТаблицаПродукция.Количество КАК Количество,
		|	ВременнаяТаблицаПродукция.СуммаПлановая КАК ПлановаяСтоимость
		|ИЗ
		|	ВременнаяТаблицаПродукция КАК ВременнаяТаблицаПродукция
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконто1
		|		ПО ВременнаяТаблицаПродукция.СчетУчета = ВидыСубконто1.Ссылка
		|			И (ВидыСубконто1.НомерСтроки = 1)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконто2
		|		ПО ВременнаяТаблицаПродукция.СчетУчета = ВидыСубконто2.Ссылка
		|			И (ВидыСубконто2.НомерСтроки = 2)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконто3
		|		ПО ВременнаяТаблицаПродукция.СчетУчета = ВидыСубконто3.Ссылка
		|			И (ВидыСубконто3.НомерСтроки = 3)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|		ПО ВременнаяТаблицаПродукция.СчетУчета = Хозрасчетный.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблицаПродукция.НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ТекстЗапросаФрагмент + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
	
	// Таблица Услуги.
	ТекстЗапросаФрагмент =
		"ВЫБРАТЬ
		|	""Услуги"" КАК ИмяСписка,
		|	&СинонимУслуги КАК СинонимСписка,
		|	ВременнаяТаблицаУслуги.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаУслуги.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаШапка.СчетЗатрат КАК СчетЗатрат,
		|	ВременнаяТаблицаШапка.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.НоменклатурнаяГруппаВТаблице
		|			ТОГДА ВременнаяТаблицаУслуги.НоменклатурнаяГруппа
		|		ИНАЧЕ ВременнаяТаблицаШапка.НоменклатурнаяГруппа
		|	КОНЕЦ КАК НоменклатурнаяГруппаЗатрат,
		|	ВременнаяТаблицаУслуги.Спецификация КАК Спецификация,
		|	ВременнаяТаблицаУслуги.СчетЗатрат КАК СчетСписания,
		|	ВременнаяТаблицаУслуги.Субконто1 КАК СубконтоСписания1,
		|	ВременнаяТаблицаУслуги.Субконто2 КАК СубконтоСписания2,
		|	ВременнаяТаблицаУслуги.Субконто3 КАК СубконтоСписания3,
		|	1 КАК ВидСубконтоСписания1,
		|	2 КАК ВидСубконтоСписания2,
		|	3 КАК ВидСубконтоСписания3,
		|	ВременнаяТаблицаУслуги.Количество КАК Количество,
		|	ВременнаяТаблицаУслуги.СуммаПлановая КАК СуммаПлановая,
		|	ВременнаяТаблицаУслуги.Содержание КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаУслуги.СуммаПлановая <> 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблицаУслуги.НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ТекстЗапросаФрагмент + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
	
	// Таблица Отходы.
	ТекстЗапросаФрагмент =
		"ВЫБРАТЬ
		|	""ВозвратныеОтходы"" КАК ИмяСписка,
		|	&СинонимВозвратныеОтходы КАК СинонимСписка,
		|	ВременнаяТаблицаВозвратныеОтходы.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаВозвратныеОтходы.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаШапка.СчетЗатрат КАК СчетЗатрат,
		|	ВременнаяТаблицаШапка.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.НоменклатурнаяГруппаВТаблице
		|			ТОГДА ВременнаяТаблицаВозвратныеОтходы.НоменклатурнаяГруппа
		|		ИНАЧЕ ВременнаяТаблицаШапка.НоменклатурнаяГруппа
		|	КОНЕЦ КАК НоменклатурнаяГруппаЗатрат,
		|	ВременнаяТаблицаВозвратныеОтходы.Продукция КАК Продукция,
		|	ВременнаяТаблицаВозвратныеОтходы.СтатьяЗатрат КАК СтатьяЗатрат,
		|	ВременнаяТаблицаВозвратныеОтходы.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	ВременнаяТаблицаВозвратныеОтходы.Количество КАК Количество,
		|	ВременнаяТаблицаВозвратныеОтходы.Сумма КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаВозвратныеОтходы КАК ВременнаяТаблицаВозвратныеОтходы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблицаВозвратныеОтходы.НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ТекстЗапросаФрагмент + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
	
	// Таблица Списание материалов.
	ТекстЗапросаФрагмент = 
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
		|	ВременнаяТаблицаШапка.СчетЗатрат КАК КорСчетСписания,
		|	ВременнаяТаблицаШапка.ПодразделениеЗатрат КАК КорСубконто1,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.НоменклатурнаяГруппаВТаблице
		|			ТОГДА ВременнаяТаблицаМатериалы.НоменклатурнаяГруппа
		|		ИНАЧЕ ВременнаяТаблицаШапка.НоменклатурнаяГруппа
		|	КОНЕЦ КАК КорСубконто2,
		|	ВременнаяТаблицаМатериалы.СтатьяЗатрат КАК КорСубконто3
		|ИЗ
		|	ВременнаяТаблицаМатериалы КАК ВременнаяТаблицаМатериалы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ТекстЗапроса = ТекстЗапроса + ТекстЗапросаФрагмент + ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета();
	
	Запрос.УстановитьПараметр("СодержаниеПроводкиСписаниеМатериалов", НСтр("ru = 'Списание материалов в производство'")); 
	Запрос.УстановитьПараметр("СодержаниеПроводкиВыпускОтходов", НСтр("ru = 'Оприходование возвратных отходов'")); 
	
	Запрос.УстановитьПараметр("СинонимПродукция", НСтр("ru = 'Продукция'"));
	Запрос.УстановитьПараметр("СинонимУслуги", НСтр("ru = 'Услуги'"));
	Запрос.УстановитьПараметр("СинонимВозвратныеОтходы", НСтр("ru = 'Возвратные отходы'"));
	Запрос.УстановитьПараметр("СинонимМатериалы", НСтр("ru = 'Материалы'"));

	СпособОценкиТМЗ = БухгалтерскийУчетСервер.СпособОценкиТМЗ(СтруктураДополнительныеСвойства.ДляПроведения.Дата, 
		СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	ВедетсяУчетПоПартиям = СпособОценкиТМЗ <> Перечисления.СпособыОценки.ПоСредней;
	Запрос.УстановитьПараметр("ВедетсяУчетПоПартиям", ВедетсяУчетПоПартиям);
	
	Запрос.Текст = ТекстЗапроса;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = МассивРезультатов[0].Выгрузить();
	ТаблицаПродукция = МассивРезультатов[1].Выгрузить();
	ТаблицаВыпуск = МассивРезультатов[2].Выгрузить();
	ТаблицаУслуги = МассивРезультатов[3].Выгрузить();
	ТаблицаОтходы = МассивРезультатов[4].Выгрузить();

	ТаблицаРеквизитыМатериалы = МассивРезультатов[5].Выгрузить();
	ТаблицаМатериалы = МассивРезультатов[6].Выгрузить();
	
	ТаблицаСписанныеМатериалы = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаМатериалы, ТаблицаРеквизитыМатериалы, Отказ);
	
	ДобавитьКолонкуСодержание(ТаблицаПродукция);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПродукция", ТаблицаПродукция);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыпуск", ТаблицаВыпуск);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУслуги", ТаблицаУслуги);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОтходы", ТаблицаОтходы);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизитыМатериалы", ТаблицаРеквизитыМатериалы);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеМатериалы", ТаблицаСписанныеМатериалы);
	
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

Процедура ДобавитьКолонкуСодержание(ТаблицаЗначений)
	
	Если ТаблицаЗначений = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТаблицаЗначений.Колонки.Найти("Содержание") = Неопределено Тогда
		ТаблицаЗначений.Колонки.Добавить("Содержание", ОбщегоНазначения.ОписаниеТипаСтрока(150));
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		СтрокаТаблицы.Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Выпуск %1", 
			БухгалтерскийУчетПовтИсп.НазваниеОбъектаПоСчетуУчета(СтрокаТаблицы.СчетУчета));
	КонецЦикла;
	
КонецПроцедуры

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
		|	ТаблицаДокумента.Склад КАК Склад,
		|	ТаблицаДокумента.СчетЗатрат КАК СчетЗатрат,
		|	ТаблицаДокумента.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ТаблицаДокумента.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	ТаблицаДокумента.НоменклатурнаяГруппаВТаблице КАК НоменклатурнаяГруппаВТаблице
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Количество КАК Количество,
		|	ТаблицаДокумента.СуммаПлановая КАК СуммаПлановая,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ТаблицаДокумента.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	ТаблицаДокумента.Спецификация КАК Спецификация
		|ПОМЕСТИТЬ ВременнаяТаблицаПродукция
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Продукция КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Количество КАК Количество,
		|	ТаблицаДокумента.СуммаПлановая КАК СуммаПлановая,
		|	ТаблицаДокумента.СчетЗатрат КАК СчетЗатрат,
		|	ТаблицаДокумента.Субконто1 КАК Субконто1,
		|	ТаблицаДокумента.Субконто2 КАК Субконто2,
		|	ТаблицаДокумента.Субконто3 КАК Субконто3,
		|	ТаблицаДокумента.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	ТаблицаДокумента.Спецификация КАК Спецификация,
		|	ВЫБОР
		|		КОГДА ТаблицаДокумента.Номенклатура.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА ТаблицаДокумента.Номенклатура.Наименование
		|		ИНАЧЕ ТаблицаДокумента.Номенклатура.НаименованиеПолное
		|	КОНЕЦ КАК Содержание
		|ПОМЕСТИТЬ ВременнаяТаблицаУслуги
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Услуги КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Количество КАК Количество,
		|	ТаблицаДокумента.Сумма КАК Сумма,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ТаблицаДокумента.СтатьяЗатрат КАК СтатьяЗатрат,
		|	ТаблицаДокумента.Продукция КАК Продукция,
		|	ТаблицаДокумента.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
		|ПОМЕСТИТЬ ВременнаяТаблицаВозвратныеОтходы
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.ВозвратныеОтходы КАК ТаблицаДокумента
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
		|	ТаблицаДокумента.СтатьяЗатрат КАК СтатьяЗатрат,
		|	ТаблицаДокумента.Продукция КАК Продукция,
		|	ТаблицаДокумента.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
		|ПОМЕСТИТЬ ВременнаяТаблицаМатериалы
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Материалы КАК ТаблицаДокумента
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

// Функция формирует табличный документ с печатной формой  М4 (приходный ордер)
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПриходныйОрдер(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетПроизводстваЗаСмену_ПриходныйОрдер";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетПроизводстваЗаСмену.ПФ_MXL_М4ПриходныйОрдер");
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.Организация.НаименованиеПолное КАК ОрганизацияПредставление,
		|	ТаблицаДокумента.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		|	ТаблицаДокумента.Склад КАК Склад,
		|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокумента.Склад) КАК СкладПредставление,
		|	ТаблицаДокумента.СчетЗатрат КАК КорреспондентскийСчет,
		|	ТаблицаДокумента.Продукция.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.Код КАК НоменклатураКод,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияНаименование,
		|		Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаКод,
		|		Количество КАК КоличествоПоДокументу,
		|		ПлановаяСтоимость КАК Цена,
		|		СуммаПлановая КАК ВсегоСНДС
		|	) КАК Продукция
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&СписокДокументов)";		
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТаблицаПродукция = Шапка.Продукция.Выгрузить();
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.Дата, "ДЛФ=D"));
		ДанныеПечати.Вставить("ИтогВсегоСНДС", ТаблицаПродукция.Итог("ВсегоСНДС"));
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ЗаголовокДокумента");
		МассивОбластейМакета.Добавить("ЗаголовокТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Итого");
		МассивОбластейМакета.Добавить("Подвал");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Шапка);
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаПродукция Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой Накладная на передачу готовой продукции
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНакладнаяНаПередачуГотовойПродукции(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетПроизводстваЗаСмену_НакладнаяНаПередачуГотовойПродукции";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетПроизводстваЗаСмену.ПФ_MXL_НакладнаяНаПередачуГотовойПродукции");

	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.Организация.НаименованиеПолное КАК ОрганизацияПредставление,
		|	ТаблицаДокумента.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		|	ТаблицаДокумента.Склад КАК Склад,
		|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокумента.Склад) КАК СкладПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокумента.ПодразделениеЗатрат) КАК ПодразделениеПредставление,
		|	ТаблицаДокумента.СчетЗатрат КАК КорреспондентскийСчет,
		|	ТаблицаДокумента.Продукция.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.Код КАК НоменклатураКод,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияНаименование,
		|		Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
		|		Количество КАК Количество,
		|		ПлановаяСтоимость КАК Цена,
		|		СуммаПлановая КАК Сумма
		|	) КАК Продукция
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
		
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;		
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.Дата, "ДЛФ=D"));
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер);
	    ДанныеПечати.Вставить("НомерДокумента", НомерНаПечать);
					
		ТаблицаПродукция = Шапка.Продукция.Выгрузить();
		
		ДанныеПечати.Вставить("ИтогКоличество", ТаблицаПродукция.Итог("Количество"));
		ДанныеПечати.Вставить("ИтогСумма", ТаблицаПродукция.Итог("Сумма"));								
		ДанныеПечати.Вставить("ИтогКоличествоПрописью", БухгалтерскийУчетСервер.КоличествоПрописью(ТаблицаПродукция.Количество()));				
		ДанныеПечати.Вставить("ИтогСуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.ИтогСумма));				
		ДанныеПечати.Вставить("НомерСтраницы", 1);
		
		ОбластьШапка 				= Макет.ПолучитьОбласть("Шапка");
		ОбластьЗаголовокТаблицы 	= Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьИтого 				= Макет.ПолучитьОбласть("Итого");
		ОбластьПодвал 				= Макет.ПолучитьОбласть("Подвал");

		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, Шапка);
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ЗаполнитьЗначенияСвойств(ОбластьЗаголовокТаблицы.Параметры, ДанныеПечати); // Номер страницы 1
		ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);

		// Проверка вывода на одну страницу
		МассивПроверки = Новый Массив;
		МассивПроверки.Добавить(ОбластьИтого);
		МассивПроверки.Добавить(ОбластьПодвал);	
		
		НомерЛиста = 1;		
		
		Для Каждого СтрокаТаблицы Из ТаблицаПродукция Цикл
			ОбластьМакетаСтрока.Параметры.Заполнить(СтрокаТаблицы);
			МассивПроверки.Добавить(ОбластьМакетаСтрока);
			
			Если ТабличныйДокумент.ПроверитьВывод(МассивПроверки) Тогда    
				ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
				МассивПроверки.Удалить(МассивПроверки.Количество() -1);
				Продолжить;
			Иначе   
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ДанныеПечати.НомерСтраницы = НомерЛиста + 1;
				ЗаполнитьЗначенияСвойств(ОбластьЗаголовокТаблицы.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			КонецЕсли;
		КонецЦикла;
		 		
		ЗаполнитьЗначенияСвойств(ОбластьИтого.Параметры, ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьИтого);
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
				
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриходныйОрдер") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПриходныйОрдер", 
		НСтр("ru = 'М4 (приходный ордер)'"), 
		ПечатьПриходныйОрдер(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ОтчетПроизводстваЗаСмену.ПФ_MXL_М4ПриходныйОрдер");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НакладнаяНаПередачуГотовойПродукции") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"НакладнаяНаПередачуГотовойПродукции", 
		НСтр("ru = 'Накладная на передачу готовой продукции'"), 
		ПечатьНакладнаяНаПередачуГотовойПродукции(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ОтчетПроизводстваЗаСмену.ПФ_MXL_НакладнаяНаПередачуГотовойПродукции");

	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриходныйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'М4 (приходный ордер)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "НакладнаяНаПередачуГотовойПродукции";
	КомандаПечати.Представление = НСтр("ru = 'Накладная на передачу готовой продукции'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	
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

#КонецЕсли
