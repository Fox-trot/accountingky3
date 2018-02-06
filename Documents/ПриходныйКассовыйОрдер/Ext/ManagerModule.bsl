﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. 
	//  * Оплата от покупателя
	//  * Возврат от поставщика
	//  * Расчеты по займам
	// 2. Возврат от сотрудника
	// 3. Возврат от подотчетника
	// 4. Получение наличных в банке
	// 5. Прочий приход
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоКт1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	(ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ОплатаОтПокупателя)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПоставщика)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.РасчетыПоЗаймам))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	0,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтСотрудника)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	3,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	0,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаШапка.Касса,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПолучениеНаличныхВБанке)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	5,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаПрочиеПлатежи.СчетРасчетов,
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто1,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто2,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто3,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПрочийПриход)";
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
	// Подготовка таблицы для расчета операционных курсовых разниц.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетРасчетов,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс КАК КурсДокумента,
		|	ВременнаяТаблицаШапка.Кратность КАК КратностьДокумента
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	&СчитатьОперационныеКурсовыеРазницы
		|	И НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК СуммаПлатежа,
		|	ВременнаяТаблицаРасшифровкаПлатежа.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ВременнаяТаблицаРасшифровкаПлатежа.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	ВременнаяТаблицаКурсыВалют.Курс КАК КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаКурсыВалют.Кратность КАК КратностьВзаиморасчетовПоНацБанку
		|ИЗ
		|	ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК ВременнаяТаблицаКурсыВалют
		|		ПО (ИСТИНА)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&СчитатьОперационныеКурсовыеРазницы
		|	И НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|	И НЕ ВременнаяТаблицаРасшифровкаПлатежа.КурсВзаиморасчетов = ВременнаяТаблицаКурсыВалют.Курс";
	Запрос.УстановитьПараметр("СчитатьОперационныеКурсовыеРазницы", БухгалтерскийУчетСервер.СчитатьОперационныеКурсовыеРазницы());
	МассивРезультатов = Запрос.ВыполнитьПакет();	

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаКурсовыеРазницы", МассивРезультатов[1].Выгрузить());
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ДвиженияДенежныхСредств.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДвиженияДенежныхСредств(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК Статья,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)";
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияДенежныхСредств", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ВозвратДенежныхСредствПодотчетником.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОтразитьВозвратПодотчетником(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Справочник.ОперацииПКО.ВозвратДенежныхСредствПодотчетником)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОтразитьВозвратПодотчетником", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру "АвансыПодотчетника".
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаАвансыПодотчетника(ДокументСсылка,СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Документ,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК Валюта,
		|	-ВременнаяТаблицаШапка.СуммаДокумента КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Справочник.ОперацииПКО.ВозвратДенежныхСредствПодотчетником)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаАвансыПодотчетника", РезультатЗапроса.Выгрузить());
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
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.Касса КАК Касса,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТаблицаДокумента.Курс КАК Курс,
		|	ТаблицаДокумента.Кратность КАК Кратность,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ТаблицаДокумента.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
		|ПОМЕСТИТЬ ВременнаяТаблицаРасшифровкаПлатежа
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.Субконто1 КАК Субконто1,
		|	ТаблицаДокумента.Субконто2 КАК Субконто2,
		|	ТаблицаДокумента.Субконто3 КАК Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочиеПлатежи
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.ПрочиеПлатежи КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
		|	КурсыВалютСрезПоследних.Курс КАК Курс,
		|	КурсыВалютСрезПоследних.Кратность КАК Кратность
		|ПОМЕСТИТЬ ВременнаяТаблицаКурсыВалют
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаРасчетов) КАК КурсыВалютСрезПоследних";				
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);	
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	Запрос.УстановитьПараметр("ВалютаРасчетов", 
	?(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов = СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета,
		СтруктураДополнительныеСвойства.ДляПроведения.ВалютаДокумента, 
		СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов));	

	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДвиженияДенежныхСредств(СтруктураДополнительныеСвойства);
	СформироватьТаблицаОтразитьВозвратПодотчетником(СтруктураДополнительныеСвойства);
	СформироватьТаблицаАвансыПодотчетника(ДокументСсылка, СтруктураДополнительныеСвойства);

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

// Функция формирует табличный документ с печатной формой Кассовый ордер форма №1
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СчетДт.Код КАК СчетДт,
		|	ХозрасчетныйДвиженияССубконто.СчетКт.Код КАК СчетКт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор В (&СписокДокументов), , ) КАК ХозрасчетныйДвиженияССубконто
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриходныйКассовыйОрдер.Ссылка КАК Ссылка,
		|	ПриходныйКассовыйОрдер.Номер КАК Номер,
		|	ПриходныйКассовыйОрдер.Дата КАК Дата,
		|	ПриходныйКассовыйОрдер.Касса КАК Касса,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,		
		|	ПриходныйКассовыйОрдер.ВалютаДокумента КАК ВалютаДокумента,		
		|	ПриходныйКассовыйОрдер.ВалютаДокумента.Наименование КАК ВалютаНаименование,		
		|	ПриходныйКассовыйОрдер.Курс КАК Курс,		
		|	ПриходныйКассовыйОрдер.Кратность КАК Кратность,		
		|	ПриходныйКассовыйОрдер.СуммаДокумента КАК СуммаДокумента,
		// Реквизиты организации.
		|	ПриходныйКассовыйОрдер.Организация КАК Организация,
		|	ПриходныйКассовыйОрдер.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПриходныйКассовыйОрдер.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		// Реквизиты платежа.
		|	ПриходныйКассовыйОрдер.ПринятоОт КАК ПринятоОт,
		|	ПриходныйКассовыйОрдер.Основание КАК Основание,
		|	ПриходныйКассовыйОрдер.Приложение КАК Приложение
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
		|ГДЕ
		|	ПриходныйКассовыйОрдер.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСчетов = МассивРезультатов[0].Выгрузить();
	ТаблицаСчетов.Индексы.Добавить("Регистратор");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПриходныйКассовыйОрдер_КассовыйОрдер";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	
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
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ОрганизацияКодПоОКПО", Шапка.ОрганизацияКодПоОКПО);
		ДанныеПечати.Вставить("ВалютаНаименование", Шапка.ВалютаНаименование);
		Если НЕ Шапка.ВалютаДокумента = Шапка.ВалютаРегламентированногоУчета Тогда
			ДанныеПечати.Вставить("РасшифровкаКурса", СтрШаблон(НСтр("ru = 'Курс: %1'"), Шапка.Курс / Шапка.Кратность));
		КонецЕсли;	
		
		// Формирование счетов Дт и Кт.
		СтрокаСчетДт = "";
		СтрокаСчетКт = "";
		НайденныеСтроки = ТаблицаСчетов.НайтиСтроки(Новый Структура("Регистратор", Шапка.Ссылка));
		Для Каждого НайденнаяСтрокаТаблицы Из НайденныеСтроки Цикл
			Если СтрНайти(СтрокаСчетДт, НайденнаяСтрокаТаблицы.СчетДт) = 0 Тогда
				Если НЕ СтрокаСчетДт = "" Тогда 
					СтрокаСчетДт = СтрокаСчетДт + ", ";
				КонецЕсли;	
				СтрокаСчетДт = СтрокаСчетДт + НайденнаяСтрокаТаблицы.СчетДт;		
			КонецЕсли;
		
			Если СтрНайти(СтрокаСчетКт, НайденнаяСтрокаТаблицы.СчетКт) = 0 Тогда   
				Если НЕ СтрокаСчетКт = "" Тогда 
					СтрокаСчетКт = СтрокаСчетКт + ", ";
				КонецЕсли;	
				СтрокаСчетКт = СтрокаСчетКт + НайденнаяСтрокаТаблицы.СчетКт;
			КонецЕсли;	
		КонецЦикла;		

		ДанныеПечати.Вставить("СчетДт", СтрокаСчетДт);
		ДанныеПечати.Вставить("СчетКт", СтрокаСчетКт);
		
		ДанныеПечати.Вставить("ПринятоОт", Шапка.ПринятоОт);
		ДанныеПечати.Вставить("Основание", Шапка.Основание);
		ДанныеПечати.Вставить("Приложение", Шапка.Приложение);
		
		ДанныеПечати.Вставить("СуммаДокумента", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧГ=3,0"));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента));
		
		// Подписи.
		ФамилияИОГлавногоБухгалтера = "";
		ФамилияИОКассира = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата, Новый Структура("Касса", Шапка.Касса));
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОКассира, ОтветственныеЛица.Кассир);
		
		ДанныеПечати.Вставить("ФамилияИОГлавногоБухгалтера", ФамилияИОГлавногоБухгалтера);
		ДанныеПечати.Вставить("ФамилияИОКассира", ФамилияИОКассира);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
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
	
	// Проверяем, нужно ли для макета ПКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_КассовыйОрдер") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПФ_MXL_КассовыйОрдер", НСтр("ru = 'Печать ПКО'"), ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати),,
			"Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	КонецЕсли;	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_КассовыйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Печать ПКО'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 1;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли