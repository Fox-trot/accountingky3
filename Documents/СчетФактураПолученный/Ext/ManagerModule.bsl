﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению) КАК СчетДт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_НеПодтвержденный) КАК СчетКт,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаТовары.СуммаНДС КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаТовары.СуммаНДС КАК ВалютнаяСуммаКт,
		|	""НДС"" КАК Содержание,
		|	0 КАК КоличествоД,
		|	0 КАК КоличествоКт
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныеДляПроводки
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
		|ГДЕ
		|	ВременнаяТаблицаТовары.СуммаНДС <> 0
		|	И ВременнаяТаблицаШапка.НДСНеПодтвержден
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению),
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_НеПодтвержденный),
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаУслуги.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)),
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаУслуги.СуммаНДС,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаУслуги.СуммаНДС,
		|	""НДС"",
		|	0,
		|	0
		|ИЗ
		|	ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО ВременнаяТаблицаУслуги.Ссылка = ВременнаяТаблицаШапка.Ссылка
		|ГДЕ
		|	ВременнаяТаблицаУслуги.СуммаНДС <> 0
		|	И ВременнаяТаблицаШапка.НДСНеПодтвержден
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению),
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_НеПодтвержденный),
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаОС.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)),
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаОС.СуммаНДС,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаОС.СуммаНДС,
		|	""НДС"",
		|	0,
		|	0
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО ВременнаяТаблицаОС.Ссылка = ВременнаяТаблицаШапка.Ссылка
		|ГДЕ
		|	ВременнаяТаблицаОС.СуммаНДС <> 0
		|	И ВременнаяТаблицаШапка.НДСНеПодтвержден
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанныеДляПроводки.Период КАК Период,
		|	ВременнаяТаблицаДанныеДляПроводки.Организация КАК Организация,
		|	ВременнаяТаблицаДанныеДляПроводки.СчетДт КАК СчетДт,
		|	ВременнаяТаблицаДанныеДляПроводки.СчетКт КАК СчетКт,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоДт1 КАК СубконтоДт1,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоДт2 КАК СубконтоДт2,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоДт3 КАК СубконтоДт3,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоКт1 КАК СубконтоКт1,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоКт2 КАК СубконтоКт2,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоКт3 КАК СубконтоКт3,
		|	СУММА(ВременнаяТаблицаДанныеДляПроводки.Сумма) КАК Сумма,
		|	ВременнаяТаблицаДанныеДляПроводки.ВалютаДт КАК ВалютаДт,
		|	СУММА(ВременнаяТаблицаДанныеДляПроводки.ВалютнаяСуммаДт) КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаДанныеДляПроводки.ВалютаКт КАК ВалютаКт,
		|	СУММА(ВременнаяТаблицаДанныеДляПроводки.ВалютнаяСуммаКт) КАК ВалютнаяСуммаКт,
		|	ВременнаяТаблицаДанныеДляПроводки.Содержание КАК Содержание,
		|	СУММА(ВременнаяТаблицаДанныеДляПроводки.КоличествоД) КАК КоличествоД,
		|	СУММА(ВременнаяТаблицаДанныеДляПроводки.КоличествоКт) КАК КоличествоКт
		|ИЗ
		|	ВременнаяТаблицаДанныеДляПроводки КАК ВременнаяТаблицаДанныеДляПроводки
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаДанныеДляПроводки.Период,
		|	ВременнаяТаблицаДанныеДляПроводки.Организация,
		|	ВременнаяТаблицаДанныеДляПроводки.СчетДт,
		|	ВременнаяТаблицаДанныеДляПроводки.СчетКт,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоДт1,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоДт2,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоДт3,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоКт1,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоКт2,
		|	ВременнаяТаблицаДанныеДляПроводки.СубконтоКт3,
		|	ВременнаяТаблицаДанныеДляПроводки.ВалютаДт,
		|	ВременнаяТаблицаДанныеДляПроводки.ВалютаКт,
		|	ВременнаяТаблицаДанныеДляПроводки.Содержание";
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

Процедура СформироватьТаблицаСчетаФактурыПолученные(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаТовары.ДокументПоступления КАК Документ,
	|	ВременнаяТаблицаТовары.Всего - ВременнаяТаблицаТовары.СуммаНДС КАК СуммаСебестоимости,
	|	ВременнаяТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ВременнаяТаблицаТовары.СуммаНСП КАК СуммаНеоблагаемая
	|ПОМЕСТИТЬ ВременнаяТаблицаСтроки
	|ИЗ
	|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблицаУслуги.ДокументПоступления,
	|	ВременнаяТаблицаУслуги.Всего - ВременнаяТаблицаУслуги.СуммаНДС,
	|	ВременнаяТаблицаУслуги.СуммаНДС,
	|	ВременнаяТаблицаУслуги.СуммаНСП
	|ИЗ
	|	ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблицаОС.ДокументПоступления,
	|	ВременнаяТаблицаОС.Всего - ВременнаяТаблицаОС.СуммаНДС,
	|	ВременнаяТаблицаОС.СуммаНДС,
	|	ВременнаяТаблицаОС.СуммаНСП
	|ИЗ
	|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
	|;
	|
	|/////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Дата КАК ДатаДокумента,
	|	ВременнаяТаблицаШапка.Организация КАК Организация,
	|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
	|	ВременнаяТаблицаСтроки.Документ КАК Документ,
	|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
	|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
	|	ВременнаяТаблицаШапка.ПризнакСтраны КАК ПризнакСтраны,
	|	СУММА(ВременнаяТаблицаСтроки.СуммаСебестоимости) КАК СуммаСебестоимости,
	|	СУММА(ВременнаяТаблицаСтроки.СуммаНДС) КАК СуммаНДС,
	|	СУММА(ВременнаяТаблицаСтроки.СуммаНеоблагаемая) КАК СуммаНеоблагаемая,
	|	ВременнаяТаблицаШапка.ДатаСФ КАК ДатаСФ
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСтроки КАК ВременнаяТаблицаСтроки
	|		ПО (ИСТИНА)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаШапка.Контрагент,
	|	ВременнаяТаблицаШапка.Дата,
	|	ВременнаяТаблицаСтроки.Документ,
	|	ВременнаяТаблицаШапка.НомерБланкаСФ,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаШапка.ПризнакСтраны,
	|	ВременнаяТаблицаШапка.СерияБланкаСФ,
	|	ВременнаяТаблицаШапка.ДатаСФ";
		
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСчетаФактурыПолученные", РезультатЗапроса.Выгрузить());	
		
КонецПроцедуры

Процедура СформироватьТаблицаРеестрПриобретенныхМатериальныхРесурсов(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СУММА(ВложенныйЗапрос.Сумма) КАК Сумма,
		|	СУММА(ВложенныйЗапрос.СуммаНДС) КАК СуммаНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныеТабличныхЧастей
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВременнаяТаблицаТовары.Сумма КАК Сумма,
		|		ВременнаяТаблицаТовары.СуммаНДС КАК СуммаНДС
		|	ИЗ
		|		ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ВременнаяТаблицаУслуги.Сумма,
		|		ВременнаяТаблицаУслуги.СуммаНДС
		|	ИЗ
		|		ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ВременнаяТаблицаОС.Сумма,
		|		ВременнаяТаблицаОС.СуммаНДС
		|	ИЗ
		|		ВременнаяТаблицаОС КАК ВременнаяТаблицаОС) КАК ВложенныйЗапрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Зачет) КАК ЗачетНДС,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
		|	ВременнаяТаблицаДанныеТабличныхЧастей.Сумма КАК Сумма,
		|	ВременнаяТаблицаДанныеТабличныхЧастей.СуммаНДС КАК СуммаНДС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДанныеТабличныхЧастей КАК ВременнаяТаблицаДанныеТабличныхЧастей
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&ПлательщикНДС";
	Запрос.УстановитьПараметр("ПлательщикНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.ПлательщикНДС);
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеестрПриобретенныхМатериальныхРесурсов", Запрос.Выполнить().Выгрузить());		
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСведенияОПоступлении(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаТовары.ДокументПоступления КАК ДокументСсылка,
		|	ВременнаяТаблицаШапка.Дата КАК Дата,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.Дата КАК ДатаСФ,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.ПризнакСтраны КАК ПризнакСтраны,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.ДатаСФ КАК ДатаПоставки,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Зачет) КАК ЗачетНДС,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаТовары.Сумма
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК Сумма,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаТовары.СуммаНДС
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК СуммаНДС,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаТовары.СуммаНСП
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК СуммаНСП
		|ПОМЕСТИТЬ ВременнаяТаблицаДанные
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаУслуги.ДокументПоступления,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.ДатаСФ,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ПризнакСтраны,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.Дата,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Зачет),
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаУслуги.Сумма
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаУслуги.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаУслуги.СуммаНДС
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаУслуги.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаУслуги.СуммаНСП
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаУслуги.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги
		|		ПО (ИСТИНА)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаОС.ДокументПоступления,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.ДатаСФ,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ПризнакСтраны,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.Дата,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Зачет),
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаОС.Сумма
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаОС.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаОС.СуммаНДС
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаОС.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаОС.СуммаНСП
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаОС.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ПО (ИСТИНА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанные.Организация КАК Организация,
		|	ВременнаяТаблицаДанные.ДокументСсылка КАК ДокументСсылка,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА """"
		|		ИНАЧЕ ВременнаяТаблицаДанные.СерияБланкаСФ
		|	КОНЕЦ КАК СерияБланкаСФ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА """"
		|		ИНАЧЕ ВременнаяТаблицаДанные.НомерБланкаСФ
		|	КОНЕЦ КАК НомерБланкаСФ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаДанные.Дата
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
		|		ИНАЧЕ ВременнаяТаблицаДанные.ДатаСФ
		|	КОНЕЦ КАК ДатаСФ,
		|	ВременнаяТаблицаДанные.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаДанные.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА """"
		|		ИНАЧЕ ВременнаяТаблицаДанные.ДатаПоставки
		|	КОНЕЦ КАК ДатаПоставки,
		|	ВЫБОР
		|		КОГДА &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаДанные.ЗачетНДС
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.ПустаяСсылка)
		|	КОНЕЦ КАК ЗачетНДС,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|				ТОГДА 0
		|			ИНАЧЕ ВременнаяТаблицаДанные.Сумма
		|		КОНЕЦ) КАК Сумма,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|				ТОГДА 0
		|			ИНАЧЕ ВременнаяТаблицаДанные.СуммаНДС
		|		КОНЕЦ) КАК СуммаНДС,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|				ТОГДА 0
		|			ИНАЧЕ ВременнаяТаблицаДанные.СуммаНСП
		|		КОНЕЦ) КАК СуммаНСП,
		|	ЛОЖЬ КАК НДСНеПодтвержден
		|ИЗ
		|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
		|ГДЕ
		|	(ВременнаяТаблицаДанные.Сумма <> 0
		|			ИЛИ ВременнаяТаблицаДанные.СуммаНДС <> 0
		|			ИЛИ ВременнаяТаблицаДанные.СуммаНСП <> 0)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаДанные.ДокументСсылка,
		|	ВременнаяТаблицаДанные.Организация,
		|	ВременнаяТаблицаДанные.ДатаПоставки,
		|	ВременнаяТаблицаДанные.Дата,
		|	ВременнаяТаблицаДанные.ДатаСФ,
		|	ВременнаяТаблицаДанные.СерияБланкаСФ,
		|	ВременнаяТаблицаДанные.НомерБланкаСФ,
		|	ВременнаяТаблицаДанные.Контрагент,
		|	ВременнаяТаблицаДанные.ДоговорКонтрагента,
		|	ВременнаяТаблицаДанные.ЗачетНДС,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА """"
		|		ИНАЧЕ ВременнаяТаблицаДанные.СерияБланкаСФ
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА """"
		|		ИНАЧЕ ВременнаяТаблицаДанные.НомерБланкаСФ
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|			ТОГДА ВременнаяТаблицаДанные.Дата
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
		|		ИНАЧЕ ВременнаяТаблицаДанные.ДатаСФ
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДанные.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|			ТОГДА """"
		|		ИНАЧЕ ВременнаяТаблицаДанные.ДатаПоставки
		|	КОНЕЦ";
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСведенияОПоступлении", РезультатЗапроса.Выгрузить());
		
КонецПроцедуры 

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СчетФактураПолученный.Ссылка КАК Ссылка,
		|	СчетФактураПолученный.Номер КАК Номер,
		|	СчетФактураПолученный.Дата КАК Дата,
		|	СчетФактураПолученный.Организация КАК Организация,
		|	СчетФактураПолученный.ВалютаДокумента КАК ВалютаДокумента,
		|	СчетФактураПолученный.Контрагент КАК Контрагент,
		|	СчетФактураПолученный.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	СчетФактураПолученный.СуммаДокумента КАК СуммаДокумента,
		|	СчетФактураПолученный.СерияБланкаСФ КАК СерияБланкаСФ,
		|	СчетФактураПолученный.НомерБланкаСФ КАК НомерБланкаСФ,
		|	СчетФактураПолученный.НДСНеПодтвержден КАК НДСНеПодтвержден,
		|	СчетФактураПолученный.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
		|	СчетФактураПолученный.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП,
		|	СчетФактураПолученный.БезналичныйРасчет КАК БезналичныйРасчет,
		|	СчетФактураПолученный.ДатаСФ КАК ДатаСФ,
		|	СчетФактураПолученный.Курс КАК Курс,
		|	СчетФактураПолученный.Кратность КАК Кратность,
		|	СчетФактураПолученный.Контрагент.ПризнакСтраны КАК ПризнакСтраны,
		|	СчетФактураПолученный.НДСНеПодтвержден КАК НДСНеПодтвержден1
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
		|ГДЕ
		|	СчетФактураПолученный.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйТовары.Ссылка КАК Ссылка,
		|	СчетФактураПолученныйТовары.Номенклатура КАК Номенклатура,
		|	СчетФактураПолученныйТовары.Количество КАК Количество,
		|	СчетФактураПолученныйТовары.Цена КАК Цена,
		|	СчетФактураПолученныйТовары.Сумма КАК Сумма,
		|	СчетФактураПолученныйТовары.СуммаНДС КАК СуммаНДС,
		|	СчетФактураПолученныйТовары.СуммаНСП КАК СуммаНСП,
		|	СчетФактураПолученныйТовары.Всего КАК Всего,
		|	СчетФактураПолученныйТовары.ДокументПоступления КАК ДокументПоступления
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.СчетФактураПолученный.Товары КАК СчетФактураПолученныйТовары
		|ГДЕ
		|	СчетФактураПолученныйТовары.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйУслуги.Ссылка КАК Ссылка,
		|	СчетФактураПолученныйУслуги.Номенклатура КАК Номенклатура,
		|	СчетФактураПолученныйУслуги.Количество КАК Количество,
		|	СчетФактураПолученныйУслуги.Цена КАК Цена,
		|	СчетФактураПолученныйУслуги.Сумма КАК Сумма,
		|	СчетФактураПолученныйУслуги.СуммаНДС КАК СуммаНДС,
		|	СчетФактураПолученныйУслуги.СуммаНСП КАК СуммаНСП,
		|	СчетФактураПолученныйУслуги.Всего КАК Всего,
		|	СчетФактураПолученныйУслуги.ДокументПоступления КАК ДокументПоступления
		|ПОМЕСТИТЬ ВременнаяТаблицаУслуги
		|ИЗ
		|	Документ.СчетФактураПолученный.Услуги КАК СчетФактураПолученныйУслуги
		|ГДЕ
		|	СчетФактураПолученныйУслуги.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйОС.Ссылка КАК Ссылка,
		|	СчетФактураПолученныйОС.ОсновноеСредство КАК ОсновноеСредство,
		|	СчетФактураПолученныйОС.Количество КАК Количество,
		|	СчетФактураПолученныйОС.Цена КАК Цена,
		|	СчетФактураПолученныйОС.Сумма КАК Сумма,
		|	СчетФактураПолученныйОС.СуммаНДС КАК СуммаНДС,
		|	СчетФактураПолученныйОС.СуммаНСП КАК СуммаНСП,
		|	СчетФактураПолученныйОС.Всего КАК Всего,
		|	СчетФактураПолученныйОС.ДокументПоступления КАК ДокументПоступления
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	Документ.СчетФактураПолученный.ОС КАК СчетФактураПолученныйОС
		|ГДЕ
		|	СчетФактураПолученныйОС.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаСчетаФактурыПолученные(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаРеестрПриобретенныхМатериальныхРесурсов(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаСведенияОПоступлении(ДокументСсылка, СтруктураДополнительныеСвойства);
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
Функция ПечатьСчетФактура(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СчетФактураПолученный.Ссылка КАК Ссылка,
		|	СчетФактураПолученный.Номер КАК Номер,
		|	СчетФактураПолученный.Дата КАК Дата,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученный.Организация.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученный.Организация.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученный.Организация.Наименование
		|	КОНЕЦ КАК ОрганизацияНаименование,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученный.Контрагент.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученный.Контрагент.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученный.Контрагент.Наименование
		|	КОНЕЦ КАК КонтрагентНаименование
		|ИЗ
		|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
		|ГДЕ
		|	СчетФактураПолученный.Ссылка В(&СписокДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйТовары.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученныйТовары.Номенклатура.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученныйТовары.Номенклатура.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученныйТовары.Номенклатура.Наименование
		|	КОНЕЦ КАК НоменклатураПредставление,
		|	СчетФактураПолученныйТовары.Количество КАК Количество,
		|	СчетФактураПолученныйТовары.Цена КАК Цена,
		|	СчетФактураПолученныйТовары.Сумма КАК Сумма,
		|	СчетФактураПолученныйТовары.СуммаНДС КАК СуммаНДС,
		|	СчетФактураПолученныйТовары.СуммаНСП КАК СуммаНСП,
		|	СчетФактураПолученныйТовары.Всего КАК Всего
		|ИЗ
		|	Документ.СчетФактураПолученный.Товары КАК СчетФактураПолученныйТовары
		|ГДЕ
		|	СчетФактураПолученныйТовары.Ссылка В(&СписокДокументов)
		|	И НЕ СчетФактураПолученныйТовары.Ссылка.Группировка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СчетФактураПолученныйТовары.Ссылка,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученныйТовары.Номенклатура.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученныйТовары.Номенклатура.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученныйТовары.Номенклатура.Наименование
		|	КОНЕЦ,
		|	СУММА(СчетФактураПолученныйТовары.Количество),
		|	СРЕДНЕЕ(СчетФактураПолученныйТовары.Цена),
		|	СУММА(СчетФактураПолученныйТовары.Сумма),
		|	СУММА(СчетФактураПолученныйТовары.СуммаНДС),
		|	СУММА(СчетФактураПолученныйТовары.СуммаНСП),
		|	СУММА(СчетФактураПолученныйТовары.Всего)
		|ИЗ
		|	Документ.СчетФактураПолученный.Товары КАК СчетФактураПолученныйТовары
		|ГДЕ
		|	СчетФактураПолученныйТовары.Ссылка В(&СписокДокументов)
		|	И СчетФактураПолученныйТовары.Ссылка.Группировка
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетФактураПолученныйТовары.Номенклатура,
		|	СчетФактураПолученныйТовары.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйУслуги.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученныйУслуги.Номенклатура.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученныйУслуги.Номенклатура.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученныйУслуги.Номенклатура.Наименование
		|	КОНЕЦ КАК НоменклатураПредставление,
		|	СчетФактураПолученныйУслуги.Количество КАК Количество,
		|	СчетФактураПолученныйУслуги.Цена КАК Цена,
		|	СчетФактураПолученныйУслуги.Сумма КАК Сумма,
		|	СчетФактураПолученныйУслуги.СуммаНДС КАК СуммаНДС,
		|	СчетФактураПолученныйУслуги.СуммаНСП КАК СуммаНСП,
		|	СчетФактураПолученныйУслуги.Всего КАК Всего
		|ИЗ
		|	Документ.СчетФактураПолученный.Услуги КАК СчетФактураПолученныйУслуги
		|ГДЕ
		|	СчетФактураПолученныйУслуги.Ссылка В(&СписокДокументов)
		|	И НЕ СчетФактураПолученныйУслуги.Ссылка.Группировка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СчетФактураПолученныйУслуги.Ссылка,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученныйУслуги.Номенклатура.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученныйУслуги.Номенклатура.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученныйУслуги.Номенклатура.Наименование
		|	КОНЕЦ,
		|	СУММА(СчетФактураПолученныйУслуги.Количество),
		|	СРЕДНЕЕ(СчетФактураПолученныйУслуги.Цена),
		|	СУММА(СчетФактураПолученныйУслуги.Сумма),
		|	СУММА(СчетФактураПолученныйУслуги.СуммаНДС),
		|	СУММА(СчетФактураПолученныйУслуги.СуммаНСП),
		|	СУММА(СчетФактураПолученныйУслуги.Всего)
		|ИЗ
		|	Документ.СчетФактураПолученный.Услуги КАК СчетФактураПолученныйУслуги
		|ГДЕ
		|	СчетФактураПолученныйУслуги.Ссылка В(&СписокДокументов)
		|	И СчетФактураПолученныйУслуги.Ссылка.Группировка
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетФактураПолученныйУслуги.Номенклатура,
		|	СчетФактураПолученныйУслуги.Ссылка 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйОС.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученныйОС.ОсновноеСредство.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученныйОС.ОсновноеСредство.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученныйОС.ОсновноеСредство.Наименование
		|	КОНЕЦ КАК НоменклатураПредставление,
		|	СчетФактураПолученныйОС.Количество КАК Количество,
		|	СчетФактураПолученныйОС.Цена КАК Цена,
		|	СчетФактураПолученныйОС.Сумма КАК Сумма,
		|	СчетФактураПолученныйОС.СуммаНДС КАК СуммаНДС,
		|	СчетФактураПолученныйОС.СуммаНСП КАК СуммаНСП,
		|	СчетФактураПолученныйОС.Всего КАК Всего
		|ИЗ
		|	Документ.СчетФактураПолученный.ОС КАК СчетФактураПолученныйОС
		|ГДЕ
		|	СчетФактураПолученныйОС.Ссылка В(&СписокДокументов)
		|	И НЕ СчетФактураПолученныйОС.Ссылка.Группировка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СчетФактураПолученныйОС.Ссылка,
		|	ВЫБОР
		|		КОГДА СчетФактураПолученныйОС.ОсновноеСредство.НаименованиеПолное <> """"
		|			ТОГДА СчетФактураПолученныйОС.ОсновноеСредство.НаименованиеПолное
		|		ИНАЧЕ СчетФактураПолученныйОС.ОсновноеСредство.Наименование
		|	КОНЕЦ,
		|	СУММА(СчетФактураПолученныйОС.Количество),
		|	СРЕДНЕЕ(СчетФактураПолученныйОС.Цена),
		|	СУММА(СчетФактураПолученныйОС.Сумма),
		|	СУММА(СчетФактураПолученныйОС.СуммаНДС),
		|	СУММА(СчетФактураПолученныйОС.СуммаНСП),
		|	СУММА(СчетФактураПолученныйОС.Всего)
		|ИЗ
		|	Документ.СчетФактураПолученный.ОС КАК СчетФактураПолученныйОС
		|ГДЕ
		|	СчетФактураПолученныйОС.Ссылка В(&СписокДокументов)
		|	И СчетФактураПолученныйОС.Ссылка.Группировка
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетФактураПолученныйОС.ОсновноеСредство,
		|	СчетФактураПолученныйОС.Ссылка";			
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Шапка = МассивРезультатов[0].Выбрать();
	
	ТаблицаТовары = МассивРезультатов[1].Выгрузить();
	ТаблицаТовары.Индексы.Добавить("Ссылка");
	
	ТаблицаУслуги = МассивРезультатов[2].Выгрузить();
	ТаблицаУслуги.Индексы.Добавить("Ссылка");
	
	ТаблицаОС = МассивРезультатов[3].Выгрузить();
	ТаблицаОС.Индексы.Добавить("Ссылка");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "СчетФактураПолученный_СчетФактура";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СчетФактураПолученный.ПФ_MXL_СчетФактураПолученный");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Счет фактура полученный № %1 от %2'"),  
							ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер), 
							Формат(Шапка.Дата, "ДЛФ=DD"));
		
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименование);
		ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.КонтрагентНаименование);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СтруктураОтбора = Новый Структура("Ссылка", Шапка.Ссылка);
		
		МассивСтрокТовары 	= ТаблицаТовары.НайтиСтроки(СтруктураОтбора);
		МассивСтрокУслуги 	= ТаблицаУслуги.НайтиСтроки(СтруктураОтбора);
		МассивСтрокОС 		= ТаблицаОС.НайтиСтроки(СтруктураОтбора);
		  
		ДанныеПечати.Вставить("ИтогСумма", 		0);
		ДанныеПечати.Вставить("ИтогСуммаНДС", 	0);
		ДанныеПечати.Вставить("ИтогСуммаНСП", 	0);
		ДанныеПечати.Вставить("ИтогВсего", 		0);
		ДанныеПечати.Вставить("НомерСтроки", 	0);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		НомерСтроки = 1;
		
		Для Каждого СтрокаМассива Из МассивСтрокТовары Цикл
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечати.ИтогСумма 		= ДанныеПечати.ИтогСумма 	+ СтрокаМассива.Сумма;
			ДанныеПечати.ИтогСуммаНДС 	= ДанныеПечати.ИтогСуммаНДС + СтрокаМассива.СуммаНДС;
			ДанныеПечати.ИтогСуммаНСП 	= ДанныеПечати.ИтогСуммаНСП + СтрокаМассива.СуммаНСП;
			ДанныеПечати.ИтогВсего 		= ДанныеПечати.ИтогВсего 	+ СтрокаМассива.Всего;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		Для Каждого СтрокаМассива Из МассивСтрокУслуги Цикл
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечати.ИтогСумма 		= ДанныеПечати.ИтогСумма 	+ СтрокаМассива.Сумма;
			ДанныеПечати.ИтогСуммаНДС 	= ДанныеПечати.ИтогСуммаНДС + СтрокаМассива.СуммаНДС;
			ДанныеПечати.ИтогСуммаНСП 	= ДанныеПечати.ИтогСуммаНСП + СтрокаМассива.СуммаНСП;
			ДанныеПечати.ИтогВсего 		= ДанныеПечати.ИтогВсего 	+ СтрокаМассива.Всего;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		Для Каждого СтрокаМассива Из МассивСтрокОС Цикл
			ОбластьМакета.Параметры.Заполнить(СтрокаМассива);
			
			ДанныеПечати.НомерСтроки = НомерСтроки;
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечати.ИтогСумма 		= ДанныеПечати.ИтогСумма 	+ СтрокаМассива.Сумма;
			ДанныеПечати.ИтогСуммаНДС 	= ДанныеПечати.ИтогСуммаНДС + СтрокаМассива.СуммаНДС;
			ДанныеПечати.ИтогСуммаНСП 	= ДанныеПечати.ИтогСуммаНСП + СтрокаМассива.СуммаНСП;
			ДанныеПечати.ИтогВсего 		= ДанныеПечати.ИтогВсего 	+ СтрокаМассива.Всего;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СчетФактураПолученный") Тогда
		 //Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПФ_MXL_СчетФактураПолученный",  НСтр("ru = 'Счет фактура полученный'"), ПечатьСчетФактура(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),,
			"Документ.СчетФактураПолученный.ПФ_MXL_СчетФактураПолученный");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_СчетФактураПолученный";
	КомандаПечати.Представление = НСтр("ru = 'Счет фактура полученный'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли