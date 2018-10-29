﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Товары
	// 2. ОС
	// 3. НДС из шапки
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СодержаниеТовары", НСтр("ru = 'Поступление доп.расходов (товары)'")); 
	Запрос.УстановитьПараметр("СодержаниеОС", НСтр("ru = 'Поступление доп.расходов (ОС)'")); 
	Запрос.УстановитьПараметр("СодержаниеНДС", НСтр("ru = 'НДС'")); 
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаТовары.Номенклатура КАК СубконтоДт1,
		|	ВременнаяТаблицаТовары.Склад КАК СубконтоДт2,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВедетсяУчетПоПартиям
		|			ТОГДА ВременнаяТаблицаТовары.ДокументПоступления
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоКт1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость) И &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВЫРАЗИТЬ((ВременнаяТаблицаТовары.СуммаРасходов + ВременнаяТаблицаТовары.СуммаРасходовНДС) * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаРасходов * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость) И &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаТовары.СуммаРасходов + ВременнаяТаблицаТовары.СуммаРасходовНДС
		|		ИНАЧЕ ВременнаяТаблицаТовары.СуммаРасходов 
		|	КОНЕЦ КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость) И &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаТовары.СуммаРасходов + ВременнаяТаблицаТовары.СуммаРасходовНДС
		|		ИНАЧЕ ВременнаяТаблицаТовары.СуммаРасходов 
		|	КОНЕЦ КАК ВалютнаяСуммаКт,
		|	&СодержаниеТовары КАК Содержание,
		|	0 КАК КоличествоДт,
		|	0 КАК КоличествоКт
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаТовары.СуммаРасходов = 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаОС.СчетУчета,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаОС.ОсновноеСредство,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость) И &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВЫРАЗИТЬ((ВременнаяТаблицаОС.СуммаРасходов + ВременнаяТаблицаОС.СуммаРасходовНДС) * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|		ИНАЧЕ ВЫРАЗИТЬ(ВременнаяТаблицаОС.СуммаРасходов * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость) И &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаОС.СуммаРасходов + ВременнаяТаблицаОС.СуммаРасходовНДС
		|		ИНАЧЕ ВременнаяТаблицаОС.СуммаРасходов 
		|	КОНЕЦ,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость) И &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаОС.СуммаРасходов + ВременнаяТаблицаОС.СуммаРасходовНДС
		|		ИНАЧЕ ВременнаяТаблицаОС.СуммаРасходов 
		|	КОНЕЦ,
		|	&СодержаниеОС,
		|	0,
		|	0
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаОС.СуммаРасходов = 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	3,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		//|	ВЫБОР
		//|		КОГДА ВременнаяТаблицаШапка.УказыватьПризнакЗачетаНДСПриПоступлении И &УказыватьПризнакЗачетаНДС
		//|				И ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость)
		//|			ТОГДА ВременнаяТаблицаТовары.СчетУчета
		//|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению)
		//|	КОНЕЦ,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению),
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)),
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.СуммаНДС,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.СуммаНДС,
		|	&СодержаниеНДС,
		|	0,
		|	0
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.СуммаНДС = 0
		|	И ВЫБОР
		|		КОГДА &УказыватьПризнакЗачетаНДС
		|			ТОГДА НЕ ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость)
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ";
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
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
		|	"""" КАК Номенклатура,
		|	ВременнаяТаблицаШапка.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
		|	ВременнаяТаблицаШапка.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП,
		|	ВременнаяТаблицаШапка.БезналичныйРасчет КАК БезналичныйРасчет,
		|	ВЫБОР
		|		КОГДА &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаШапка.ЗачетНДС
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.ПустаяСсылка)
		|	КОНЕЦ КАК ЗачетНДС,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаДопРасходов * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНСП,
		|	0 КАК Количество
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПоступлениеТоваров", РезультатЗапроса.Выгрузить());
		
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаЗначенияСтавокНалогов(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
		|	ВременнаяТаблицаШапка.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗначенияСтавокНалогов", РезультатЗапроса.Выгрузить());
		
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСведенияОПоступлении(СтруктураДополнительныеСвойства) 
	                   
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК ДокументСсылка,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВЫБОР
		|		КОГДА &УказыватьПризнакЗачетаНДС
		|			ТОГДА ВременнаяТаблицаШапка.ЗачетНДС
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.ПустаяСсылка)
		|	КОНЕЦ КАК ЗачетНДС,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.Контрагент.ПризнакСтраны КАК ПризнакСтраны,
		|	ВременнаяТаблицаШапка.Дата КАК ДатаПоставки,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.ДатаСФ КАК ДатаСФ,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаДопРасходов * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНСП
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	(ВременнаяТаблицаШапка.СуммаДопРасходов <> 0
		|   ИЛИ ВременнаяТаблицаШапка.СуммаДопРасходов <> 0
		|	ИЛИ ВременнаяТаблицаШапка.СуммаДопРасходов <> 0)";		
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСведенияОПоступлении", Запрос.Выполнить().Выгрузить());		
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРеестрПриобретенных(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Ссылка КАК Документ,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.Контрагент.НаименованиеПолное = """"
		|			ТОГДА ВременнаяТаблицаШапка.Контрагент.Наименование
		|		ИНАЧЕ ВременнаяТаблицаШапка.Контрагент.НаименованиеПолное
		|	КОНЕЦ КАК КонтрагентНаименование,
		|	ВременнаяТаблицаШапка.Контрагент.ИНН КАК ИННКонтрагента,
		|	ВременнаяТаблицаШапка.Контрагент.ГНС.Код КАК КодГНСКонтрагента,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.ДатаСФ КАК ДатаПоставки,
		|	ВременнаяТаблицаШапка.СуммаНДС КАК СуммаНДС,
		|	ВременнаяТаблицаШапка.СуммаДопРасходов КАК Сумма,
		|	ВЫБОР
		|		КОГДА НЕ ВременнаяТаблицаШапка.УказыватьПризнакЗачетаНДСПриПоступлении
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Распределение)
		|		КОГДА ВременнаяТаблицаШапка.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.ПустаяСсылка)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Зачет)
		|		ИНАЧЕ ВременнаяТаблицаШапка.ЗачетНДС
		|	КОНЕЦ КАК ЗачетНДС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.КР)
		|	И НЕ ВременнаяТаблицаШапка.НеВключатьВРеестрСФ";
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеестрПриобретенных", Запрос.Выполнить().Выгрузить());		
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
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.ПризнакСтраны КАК ПризнакСтраны,
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.Курс КАК Курс,
		|	ТаблицаДокумента.Кратность КАК Кратность,
		|	ТаблицаДокумента.СерияБланкаСФ КАК СерияБланкаСФ,
		|	ТаблицаДокумента.НомерБланкаСФ КАК НомерБланкаСФ,
		|	ТаблицаДокумента.ДатаСФ КАК ДатаСФ,
		|	ТаблицаДокумента.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
		|	ТаблицаДокумента.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП,
		|	ТаблицаДокумента.БезналичныйРасчет КАК БезналичныйРасчет,
		|	ТаблицаДокумента.НеВключатьВРеестрСФ КАК НеВключатьВРеестрСФ,
		|	ТаблицаДокумента.ЗачетНДС КАК ЗачетНДС,
		|	ТаблицаДокумента.СуммаДопРасходов КАК СуммаДопРасходов,
		|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
		|	ТаблицаДокумента.СуммаНСП КАК СуммаНСП,
		|	&ВедетсяУчетПоПартиям КАК ВедетсяУчетПоПартиям,
		|	&ПлательщикНДС КАК ПлательщикНДС,
		|	&УказыватьПризнакЗачетаНДСПриПоступлении КАК УказыватьПризнакЗачетаНДСПриПоступлении
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ДополнительныеРасходы КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДокументПоступления КАК ДокументПоступления,
		|	ТаблицаДокумента.ДокументПоступления.Склад КАК Склад,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ТаблицаДокумента.СуммаРасходов КАК СуммаРасходов,
		|	ТаблицаДокумента.СуммаРасходовНДС КАК СуммаРасходовНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ДополнительныеРасходы.Товары КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДокументПоступления КАК ДокументПоступления,
		|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
		|	ТаблицаДокумента.СуммаРасходов КАК СуммаРасходов,
		|	ТаблицаДокумента.СуммаРасходовНДС КАК СуммаРасходовНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	Документ.ДополнительныеРасходы.ОС КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументСсылка";	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	УчетнаяПолитика = СтруктураДополнительныеСвойства.УчетнаяПолитика;
	Запрос.УстановитьПараметр("ПлательщикНДС", УчетнаяПолитика.ПлательщикНДС);
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДСПриПоступлении", УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);	
	Запрос.УстановитьПараметр("ВедетсяУчетПоПартиям", УчетнаяПолитика.СпособОценкиТМЗ = Перечисления.СпособыОценки.ФИФО);	
	Запрос.Выполнить();    		
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);	
	СформироватьТаблицаПоступлениеТоваров(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаЗначенияСтавокНалогов(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаСведенияОПоступлении(СтруктураДополнительныеСвойства);
	СформироватьТаблицаРеестрПриобретенных(ДокументСсылка, СтруктураДополнительныеСвойства);
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

Функция ПечатьДопРасходы(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	Запрос = Новый Запрос;
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДополнительныеРасходы.Ссылка КАК Ссылка,
		|	ДополнительныеРасходы.Дата КАК Дата,
		|	ДополнительныеРасходы.Номер КАК Номер,
		|	ДополнительныеРасходы.Контрагент.НаименованиеПолное КАК ПредставлениеПоставщика,
		|	ДополнительныеРасходы.Организация.НаименованиеПолное КАК ПредставлениеПолучателя,
		|	ДополнительныеРасходы.ДоговорКонтрагента.ВалютаРасчетов КАК ДоговорКонтрагентаВалютаРасчетов,
		|	ДополнительныеРасходы.ВалютаДокумента КАК ВалютаДокумента,
		|	ДополнительныеРасходы.СуммаДопРасходов - ДополнительныеРасходы.СуммаНДС - ДополнительныеРасходы.СуммаНСП КАК СуммаДопРасходов,
		|	ДополнительныеРасходы.СуммаНДС КАК СуммаНДС,
		|	ДополнительныеРасходы.СуммаНСП КАК СуммаНСП,
		|	ДополнительныеРасходы.СуммаДопРасходов КАК Всего,
		|	(ВЫРАЗИТЬ(ДополнительныеРасходы.СуммаДопРасходов * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) - (ВЫРАЗИТЬ(ДополнительныеРасходы.СуммаНДС * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) - (ВЫРАЗИТЬ(ДополнительныеРасходы.СуммаНСП * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) КАК СуммаДопРасходовВНацвалюте,
		|	ВЫРАЗИТЬ(ДополнительныеРасходы.СуммаНДС * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНДСВНацвалюте,
		|	ВЫРАЗИТЬ(ДополнительныеРасходы.СуммаНСП * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНСПВНацвалюте,
		|	ВЫРАЗИТЬ(ДополнительныеРасходы.СуммаДопРасходов * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК ВсегоВНацвалюте,
		|	ВЫБОР
		|		КОГДА (ВЫРАЗИТЬ(ДополнительныеРасходы.Комментарий КАК СТРОКА(100))) = """"
		|			ТОГДА ""Дополнительные расходы""
		|		ИНАЧЕ ДополнительныеРасходы.Комментарий
		|	КОНЕЦ КАК Содержание,
		|	ДополнительныеРасходы.Товары.(
		|		Количество КАК Количество,
		|		Сумма КАК Сумма,
		|		ВЫРАЗИТЬ(ДополнительныеРасходы.Товары.Сумма * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаВНацвалюте,
		|		СуммаРасходов КАК СуммаРасходов,
		|		ВЫРАЗИТЬ(ДополнительныеРасходы.Товары.СуммаРасходов * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаРасходовВНацвалюте,
		|		Номенклатура.Наименование КАК Наименование,
		|		(ВЫРАЗИТЬ(ДополнительныеРасходы.Товары.Сумма * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) + (ВЫРАЗИТЬ(ДополнительныеРасходы.Товары.СуммаРасходов * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) КАК ВсегоВНацвалюте
		|	) КАК Товары,
		|	ДополнительныеРасходы.ОС.(
		|		ОсновноеСредство.Наименование КАК Наименование,
		|		1 КАК Количество,
		|		Сумма КАК Сумма,
		|		ВЫРАЗИТЬ(ДополнительныеРасходы.ОС.Сумма * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаВНацвалюте,
		|		СуммаРасходов КАК СуммаРасходов,
		|		ВЫРАЗИТЬ(ДополнительныеРасходы.ОС.СуммаРасходов * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаРасходовВНацвалюте,
		|		(ВЫРАЗИТЬ(ДополнительныеРасходы.ОС.Сумма * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) + (ВЫРАЗИТЬ(ДополнительныеРасходы.ОС.СуммаРасходов * ДополнительныеРасходы.Курс / ДополнительныеРасходы.Кратность КАК ЧИСЛО(15, 2))) КАК ВсегоВНацвалюте
		|	) КАК ОС
		|ИЗ
		|	Документ.ДополнительныеРасходы КАК ДополнительныеРасходы
		|ГДЕ
		|	ДополнительныеРасходы.Ссылка В(&МассивОбъектов)";
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ДополнительныеРасходы_ДопРасходы";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДополнительныеРасходы.ПФ_MXL_ДопРасходы");
		
	Пока Выборка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ВалютаДокумента", 			Выборка.ВалютаДокумента);
		ДанныеПечати.Вставить("СуммаДопРасходов", 			Выборка.СуммаДопРасходов);
		ДанныеПечати.Вставить("СуммаНДС", 					Выборка.СуммаНДС);
		ДанныеПечати.Вставить("СуммаНСП", 					Выборка.СуммаНСП);
		ДанныеПечати.Вставить("Всего", 						Выборка.Всего);
		ДанныеПечати.Вставить("СуммаДопРасходовВНацвалюте", Выборка.СуммаДопРасходовВНацвалюте);
		ДанныеПечати.Вставить("СуммаНДСВНацвалюте", 		Выборка.СуммаНДСВНацвалюте);
		ДанныеПечати.Вставить("СуммаНСПВНацвалюте", 		Выборка.СуммаНСПВНацвалюте);
		ДанныеПечати.Вставить("ВсегоВНацвалюте", 			Выборка.ВсегоВНацвалюте);
		ДанныеПечати.Вставить("Содержание", 				Выборка.Содержание);
		ЗаполнитьЗначенияСвойств(ДанныеПечати, Выборка);
		
		ВременнаяТаблицаТовары 		= Выборка.Товары.Выгрузить();                                      
		ВременнаяТаблицаОС 			= Выборка.ОС.Выгрузить();
		
		ВыборкаТовары 		= Выборка.Товары.Выбрать();
		ВыборкаОС 			= Выборка.ОС.Выбрать();
		
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Доп. расходы № %1 от %2'"), 
										ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер),
										Формат(Выборка.Дата,"ДЛФ=DD"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ПредставлениеПоставщика", Выборка.ПредставлениеПоставщика);
		ДанныеПечати.Вставить("ПредставлениеПолучателя", Выборка.ПредставлениеПолучателя);
		
		СуммаТоварыИтого 					= ВременнаяТаблицаТовары.Итог("Сумма");
		СуммаТоварыИтогоВНацвалюте			= ВременнаяТаблицаТовары.Итог("СуммаВНацвалюте");
		СуммаОСИтого 						= ВременнаяТаблицаОС.Итог("Сумма");
		СуммаОСИтогоВНацвалюте 				= ВременнаяТаблицаОС.Итог("СуммаВНацвалюте");
		СуммаРасходовТоварыИтого 			= ВременнаяТаблицаТовары.Итог("СуммаРасходов");
		СуммаРасходовТоварыИтогоВНацвалюте 	= ВременнаяТаблицаТовары.Итог("СуммаРасходовВНацвалюте");
		СуммаРасходовОСИтого 				= ВременнаяТаблицаОС.Итог("СуммаРасходов");		
		СуммаРасходовОСИтогоВНацвалюте 		= ВременнаяТаблицаОС.Итог("СуммаРасходовВНацвалюте");
		ВсегоИтогоВНацвалюте                = СуммаТоварыИтогоВНацвалюте + СуммаРасходовТоварыИтогоВНацвалюте
									+ СуммаОСИтогоВНацвалюте + СуммаРасходовОСИтогоВНацвалюте;
		
		ДанныеПечати.Вставить("СуммаИтого", СуммаТоварыИтого + СуммаОСИтого);
		ДанныеПечати.Вставить("СуммаИтогоВНацвалюте", СуммаТоварыИтогоВНацвалюте + СуммаОСИтогоВНацвалюте);
		ДанныеПечати.Вставить("СуммаРасходовИтого", СуммаРасходовТоварыИтого + СуммаРасходовОСИтого);
		ДанныеПечати.Вставить("СуммаРасходовИтогоВНацвалюте", СуммаРасходовТоварыИтогоВНацвалюте + СуммаРасходовОСИтогоВНацвалюте);
		ДанныеПечати.Вставить("ВсегоИтогоВНацвалюте", ВсегоИтогоВНацвалюте);													
        ДанныеПечати.Вставить("СуммаДокументаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Выборка.ВсегоВНацвалюте));
		
		ТолькоСомы = Выборка.ВалютаДокумента = ВалютаРегламентированногоУчета;
		
		МассивОбластейМакета = Новый Массив;  
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("Поставщик");
		МассивОбластейМакета.Добавить("Покупатель");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("СтрокаДопРасходы");		
		МассивОбластейМакета.Добавить("СтрокаДопРасходыВНацвалюте");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("ШапкаТаблицыОсновная" + ?(ТолькоСомы, "ТолькоСомы", ""));
		МассивОбластейМакета.Добавить("СтрокаОсновная" + ?(ТолькоСомы, "ТолькоСомы", ""));
		МассивОбластейМакета.Добавить("Итоги" + ?(ТолькоСомы, "ТолькоСомы", ""));
		МассивОбластейМакета.Добавить("Подписи");
		                      
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			
			Если ИмяОбласти = "СтрокаДопРасходыВНацвалюте" Тогда
				Если НЕ Выборка.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
					ОбластьМакета.Параметры.Заполнить(Выборка);
					ТабличныйДокумент.Вывести(ОбластьМакета);				
				КонецЕсли;									
			ИначеЕсли ИмяОбласти = "СтрокаОсновная" Тогда
				НомерСтроки = 0;
				Пока ВыборкаТовары.Следующий() Цикл
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Заполнить(ВыборкаТовары);
					ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				Пока ВыборкаОС.Следующий() Цикл
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Заполнить(ВыборкаОС);
					ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			Иначе
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЕсли;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДопРасходы") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ДопРасходы", НСтр("ru = 'Доп. расходы'"), ПечатьДопРасходы(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),,
		"Документ.ДополнительныеРасходы.ПФ_MXL_ДопРасходы");
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ДопРасходы";
	КомандаПечати.Представление = НСтр("ru = 'Доп. расходы'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрДополнительныеРасходы";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Дополнительные расходы""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#КонецЕсли