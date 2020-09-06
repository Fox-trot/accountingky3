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
		|	ВременнаяТаблицаТовары.Сумма КАК Сумма,
		|	ВременнаяТаблицаТовары.СуммаНДС КАК СуммаНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныеТабличныхЧастейПервичная
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУслуги.Сумма,
		|	ВременнаяТаблицаУслуги.СуммаНДС
		|ИЗ
		|	ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОС.Сумма,
		|	ВременнаяТаблицаОС.СуммаНДС
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВременнаяТаблицаДанныеТабличныхЧастейПервичная.Сумма) КАК Сумма,
		|	СУММА(ВременнаяТаблицаДанныеТабличныхЧастейПервичная.СуммаНДС) КАК СуммаНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныеТабличныхЧастей
		|ИЗ
		|	ВременнаяТаблицаДанныеТабличныхЧастейПервичная КАК ВременнаяТаблицаДанныеТабличныхЧастейПервичная
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
		|	&ПлательщикНДС
		|	И НЕ ВременнаяТаблицаШапка.Контрагент.СЭЗ";
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
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ПризнакСтраны,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.ДатаСФ,
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
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ПризнакСтраны,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.ДатаСФ,
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
	СформироватьТаблицаСведенияОПоступлении(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаРеестрПриобретенныхМатериальныхРесурсов(ДокументСсылка, СтруктураДополнительныеСвойства);
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

#КонецЕсли