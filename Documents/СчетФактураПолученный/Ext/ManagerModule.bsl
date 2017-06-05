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
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО ВременнаяТаблицаТовары.Ссылка = ВременнаяТаблицаШапка.Ссылка
		|ГДЕ
		|	ВременнаяТаблицаТовары.СуммаНДС <> 0
		|	И ВременнаяТаблицаШапка.НДСНеПодтвержден = ИСТИНА";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

Процедура СформироватьТаблицаСчетаФактурыПолученные(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Дата КАК Период,
	|	ВременнаяТаблицаШапка.Организация КАК Организация,
	|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ВременнаяТаблицаТовары.ДокументПоступления КАК Документ,
	|	ВременнаяТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
	|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
	|	ВременнаяТаблицаШапка.Контрагент.ПризнакСтраны КАК ПризнакСтраны,
	|	СУММА(ВременнаяТаблицаТовары.Всего - ВременнаяТаблицаТовары.СуммаНДС) КАК СуммаСебестоимости,
	|	СУММА(ВременнаяТаблицаТовары.СуммаНДС) КАК СуммаНДС,
	|	СУММА(ВременнаяТаблицаТовары.СуммаНСП) КАК СуммаНеоблагаемая,
	|	ВременнаяТаблицаШапка.ДатаСФ КАК ДатаСФ
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
	|		ПО (ИСТИНА)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаШапка.Контрагент,
	|	ВременнаяТаблицаТовары.СтавкаНДС,
	|	ВременнаяТаблицаШапка.Дата,
	|	ВременнаяТаблицаТовары.ДокументПоступления,
	|	ВременнаяТаблицаШапка.НомерБланкаСФ,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаШапка.Контрагент.ПризнакСтраны,
	|	ВременнаяТаблицаШапка.СерияБланкаСФ,
	|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
	|	ВременнаяТаблицаШапка.ДатаСФ";
		
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСчетаФактурыПолученные", РезультатЗапроса.Выгрузить());	
		
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СчетФактураПолученный.Ссылка,
		|	СчетФактураПолученный.Номер,
		|	СчетФактураПолученный.Дата,
		|	СчетФактураПолученный.Организация,
		|	СчетФактураПолученный.ВалютаДокумента,
		|	СчетФактураПолученный.Контрагент,
		|	СчетФактураПолученный.ДоговорКонтрагента,
		|	СчетФактураПолученный.Курс,
		|	СчетФактураПолученный.Кратность,
		|	СчетФактураПолученный.СуммаДокумента,
		|	СчетФактураПолученный.СерияБланкаСФ,
		|	СчетФактураПолученный.НомерБланкаСФ,
		|	СчетФактураПолученный.Общая,
		|	СчетФактураПолученный.НДСНеПодтвержден,
		|	СчетФактураПолученный.ДатаСФ
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
		|ГДЕ
		|	СчетФактураПолученный.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетФактураПолученныйТовары.Ссылка,
		|	СчетФактураПолученныйТовары.Номенклатура,
		|	СчетФактураПолученныйТовары.ЕдиницаИзмерения,
		|	СчетФактураПолученныйТовары.Количество,
		|	СчетФактураПолученныйТовары.Цена,
		|	СчетФактураПолученныйТовары.Сумма,
		|	СчетФактураПолученныйТовары.СчетУчета,
		|	СчетФактураПолученныйТовары.СтавкаНДС,
		|	СчетФактураПолученныйТовары.СуммаНДС,
		|	СчетФактураПолученныйТовары.СтавкаНСП,
		|	СчетФактураПолученныйТовары.СуммаНСП,
		|	СчетФактураПолученныйТовары.СуммаСФ,
		|	СчетФактураПолученныйТовары.Всего,
		|	СчетФактураПолученныйТовары.Емкость,
		|	СчетФактураПолученныйТовары.КоличествоМест,
		|	СчетФактураПолученныйТовары.ЗачетНДС,
		|	СчетФактураПолученныйТовары.ДокументПоступления
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.СчетФактураПолученный.Товары КАК СчетФактураПолученныйТовары
		|ГДЕ
		|	СчетФактураПолученныйТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаСчетаФактурыПолученные(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);

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