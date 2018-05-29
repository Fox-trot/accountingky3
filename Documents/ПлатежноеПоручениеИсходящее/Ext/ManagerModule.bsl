﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. 
	//  * Оплата поставщику
	//  * Возврат покупателю
	//  * Расчеты по займам
	//  * Оплата налогов
	// 2. Выдача подотчетнику
	// 3. Перевод на другой счет
	// 4. Выплата ЗП
	// 5. Прочий расход
	// 6. Комиссия банка
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ОплатаНалогов)
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СчетРасчетов
		|		ИНАЧЕ ВременнаяТаблицаШапка.СчетРасчетов
		|	КОНЕЦ КАК СчетДт,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоДт1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоКт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	(ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ОплатаПоставщику)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ВозвратПокупателю)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.РасчетыПоЗаймам)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ОплатаНалогов))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ВыдачаПодотчетнику)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	3,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.БанковскийСчетПолучателя.СчетУчета,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаШапка.БанковскийСчетПолучателя,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.БанковскийСчетПолучателя.ВалютаДенежныхСредств,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ПереводНаДругойСчет)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	4,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.ФизЛицо,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	0,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ВыплатаЗП)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	5,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаПрочиеПлатежи.СчетРасчетов,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто1,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто2,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто3,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
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
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ПрочийРасход)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	6,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.СчетЗатратКомиссияБанка,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаШапка.СтатьяЗатратКомиссияБанка,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредствКоммисияБанка,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.СуммаКомиссияБанка * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.СуммаКомиссияБанка,
		|	ВременнаяТаблицаШапка.СуммаКомиссияБанка,
		|	&СодержаниеКомиссияБанка
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.СниматьКомиссиюБанка
		|	И НЕ ВременнаяТаблицаШапка.СуммаКомиссияБанка = 0";
	Запрос.УстановитьПараметр("СодержаниеКомиссияБанка", НСтр("ru = 'Комиссия банка'")); 
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
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК ДенежныйСчет,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс КАК КурсДокумента,
		|	ВременнаяТаблицаШапка.Кратность КАК КратностьДокумента,
		|	СУММА(ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа) КАК СуммаПлатежа,
		|	СУММА(ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
		|	ВременнаяТаблицаКурсыВалют.Курс КАК КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаКурсыВалют.Кратность КАК КратностьВзаиморасчетовПоНацБанку
		|ИЗ
		|	ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК ВременнаяТаблицаКурсыВалют
		|		ПО (ИСТИНА)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|	И НЕ ВременнаяТаблицаШапка.КурсВзаиморасчетов = ВременнаяТаблицаКурсыВалют.Курс
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс,
		|	ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаКурсыВалют.Курс,
		|	ВременнаяТаблицаКурсыВалют.Кратность";
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДанных", Запрос.Выполнить().Выгрузить());
КонецПроцедуры // СформироватьТаблицаДенежныеСредства()

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
		|	НЕ ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредств,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)";
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияДенежныхСредств", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВыплаченнаяЗарплата(ДокументСсылка, СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =		     
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.ФизЛицо,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.ДокументОснование КАК Документ.ВедомостьЗаработнойПлаты).ПериодРегистрации КАК ПериодРегистрации,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыВыплатыЗарплаты.ЧерезБанк) КАК ВидВыплаты,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ВыплатаЗП)";
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыплаченнаяЗарплата", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаВыплаченнаяЗарплата()

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ДанныеРеестраГТД.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДанныеРеестраГТД(ДокументСсылка,СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.ДокументОснование КАК Документ,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ОплатаПоставщику)
		|	И ВременнаяТаблицаШапка.ДокументОснование ССЫЛКА Документ.ПоступлениеТоваровУслуг
		|	И НЕ ВременнаяТаблицаШапка.ДокументОснование = ЗНАЧЕНИЕ(Документ.ПоступлениеТоваровУслуг.ПустаяСсылка)
		|	И НЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа = 0";
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДанныеРеестраГТД", РезультатЗапроса.Выгрузить());
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
		|	ВременнаяТаблицаШапка.СуммаДокумента КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ВыдачаПодотчетнику)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаАвансыПодотчетника", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ОборотыПоДаннымЕдиногоНалога.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОтразитьОборотыПоДаннымЕдиногоНалога(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаРасшифровкаПлатежа.ВидДеятельности КАК ВидДеятельности,
		|	- ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК СуммаБезналичная
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&ПлательщикЕН
		|	И ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийППИ.ВозвратПокупателю)";
	Запрос.УстановитьПараметр("ПлательщикЕН", СтруктураДополнительныеСвойства.УчетнаяПолитика.ПлательщикЕН);	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ОборотыПоДаннымЕдиногоНалога", РезультатЗапроса.Выгрузить());
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
		|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТаблицаДокумента.Курс КАК Курс,
		|	ТаблицаДокумента.Кратность КАК Кратность,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ТаблицаДокумента.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.БанковскийСчетПолучателя КАК БанковскийСчетПолучателя,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
		|	ТаблицаДокумента.СниматьКомиссиюБанка КАК СниматьКомиссиюБанка,
		|	ТаблицаДокумента.СчетЗатратКомиссияБанка КАК СчетЗатратКомиссияБанка,
		|	ТаблицаДокумента.СтатьяЗатратКомиссияБанка КАК СтатьяЗатратКомиссияБанка,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредствКоммисияБанка КАК СтатьяДвиженияДенежныхСредствКоммисияБанка,
		|	ТаблицаДокумента.СуммаКомиссияБанка КАК СуммаКомиссияБанка,
		|	ТаблицаДокумента.ДокументОснование КАК ДокументОснование,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПлатежноеПоручениеИсходящее КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ВидДеятельности КАК ВидДеятельности,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов
		|ПОМЕСТИТЬ ВременнаяТаблицаРасшифровкаПлатежа
		|ИЗ
		|	Документ.ПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК ТаблицаДокумента
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
		|	Документ.ПлатежноеПоручениеИсходящее.ПрочиеПлатежи КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа
		|ПОМЕСТИТЬ ВременнаяТаблицаВыплатаЗаработнойПлаты
		|ИЗ
		|	Документ.ПлатежноеПоручениеИсходящее.ВыплатаЗаработнойПлаты КАК ТаблицаДокумента
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
	СформироватьТаблицаВыплаченнаяЗарплата(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДанныеРеестраГТД(ДокументСсылка,СтруктураДополнительныеСвойства);
	СформироватьТаблицаАвансыПодотчетника(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаОтразитьОборотыПоДаннымЕдиногоНалога(СтруктураДополнительныеСвойства);	
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

// Функция формирует табличный документ с печатной формой Платежное поручение
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПлатежноеПоручение(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПлатежноеПоручениеИсходящее.Ссылка КАК Ссылка,
		|	ПлатежноеПоручениеИсходящее.Номер КАК Номер,
		|	ПлатежноеПоручениеИсходящее.Дата КАК Дата,
		|	ПлатежноеПоручениеИсходящее.ВалютаДокумента КАК ВалютаДокумента,
		|	ПлатежноеПоручениеИсходящее.СуммаДокумента КАК СуммаДокумента,
		|	ПлатежноеПоручениеИсходящее.ВидОперации КАК ВидОперации,
		|	ПлатежноеПоручениеИсходящее.ФизЛицо КАК ФизЛицо,
		|	ПлатежноеПоручениеИсходящее.ФизЛицо.ИНН КАК ФизЛицоИНН,
		// Реквизиты организации.
		|	ПлатежноеПоручениеИсходящее.Организация КАК Организация,
		|	ПлатежноеПоручениеИсходящее.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПлатежноеПоручениеИсходящее.Организация.ИНН КАК ОрганизацияИНН,
		|	ПлатежноеПоручениеИсходящее.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		|	ПлатежноеПоручениеИсходящее.Организация.РегНомерСоцФонда КАК ОрганизацияРегНомерСоцФонда,
		// Реквизиты банковского счета организации.
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.НомерСчета КАК БанковскийСчетНомерСчета,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.Банк.Наименование КАК БанковскийСчетБанкНаименование,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.Банк.Код КАК БанковскийСчетБанкБИК,
		// Реквизиты контрагента.
		|	ПлатежноеПоручениеИсходящее.Контрагент.НаименованиеПолное КАК КонтрагентНаименованиеПолное,
		|	ПлатежноеПоручениеИсходящее.Контрагент.ИНН КАК КонтрагентИНН,
		// Реквизиты банковского счета контрагента.
		|	ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.НомерСчета КАК БанковскийСчетПолучателяНомерСчета,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.Банк.Наименование КАК БанковскийСчетПолучателяБанкНаименование,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.Банк.Код КАК БанковскийСчетПолучателяСчетБанкБИК,
		// Реквизиты платежа.
		|	ПлатежноеПоручениеИсходящее.КодПлатежа КАК КодПлатежа,
		|	ПлатежноеПоручениеИсходящее.НазначениеПлатежа КАК НазначениеПлатежа,
		// Настройки печати.
		|	ПлатежноеПоручениеИсходящее.ПечатьВРамке КАК ПечатьВРамке,
		|	ПлатежноеПоручениеИсходящее.ВтораяПодписьНеПредусмотрена КАК ВтораяПодписьНеПредусмотрена,
		|	ПлатежноеПоручениеИсходящее.ПечатьНаОдномЛистеДваЭкземпляра КАК ПечатьНаОдномЛистеДваЭкземпляра
		|ИЗ
		|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
		|ГДЕ
		|	ПлатежноеПоручениеИсходящее.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПлатежноеПоручениеИсходящее_ПлатежноеПоручение";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПлатежноеПоручениеИсходящее.ПФ_MXL_ПлатежноеПоручение");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'ПЛАТЕЖНОЕ ПОРУЧЕНИЕ'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.Дата, "ДЛФ=DD"));
		
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ОрганизацияИНН", Шапка.ОрганизацияИНН);
		ДанныеПечати.Вставить("ОрганизацияКодПоОКПО", Шапка.ОрганизацияКодПоОКПО);
		ДанныеПечати.Вставить("ОрганизацияРегНомерСоцФонда", Шапка.ОрганизацияРегНомерСоцФонда);
		ДанныеПечати.Вставить("БанковскийСчетНомерСчета", Шапка.БанковскийСчетНомерСчета);
		ДанныеПечати.Вставить("БанковскийСчетБанкНаименование", Шапка.БанковскийСчетБанкНаименование);
		ДанныеПечати.Вставить("БанковскийСчетБанкБИК", Шапка.БанковскийСчетБанкБИК);
		
		Если Шапка.ВидОперации = Перечисления.ВидыОперацийППИ.ВыдачаПодотчетнику Тогда
			ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.ФизЛицо);
			ДанныеПечати.Вставить("КонтрагентИНН", Шапка.ФизЛицоИНН);
		ИначеЕсли Шапка.ВидОперации = Перечисления.ВидыОперацийППИ.ПереводНаДругойСчет Тогда
			ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
			ДанныеПечати.Вставить("КонтрагентИНН", Шапка.КонтрагентИНН);
		Иначе	
			ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.КонтрагентНаименованиеПолное);
			ДанныеПечати.Вставить("КонтрагентИНН", Шапка.КонтрагентИНН);
		КонецЕсли;
		
		ДанныеПечати.Вставить("БанковскийСчетПолучателяНомерСчета", Шапка.БанковскийСчетПолучателяНомерСчета);
		ДанныеПечати.Вставить("БанковскийСчетПолучателяБанкНаименование", Шапка.БанковскийСчетПолучателяБанкНаименование);
		ДанныеПечати.Вставить("БанковскийСчетПолучателяСчетБанкБИК", Шапка.БанковскийСчетПолучателяСчетБанкБИК);
		ДанныеПечати.Вставить("КодПлатежа", Шапка.КодПлатежа);
		ДанныеПечати.Вставить("НазначениеПлатежа", Шапка.НазначениеПлатежа);
		
		ДанныеПечати.Вставить("СуммаДокумента", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧГ=0"));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента));
		
		// Подписи
		ФамилияИОРуководителя = "";
		ФамилияИОГлавногоБухгалтера = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОРуководителя, ОтветственныеЛица.Руководитель);
		ДанныеПечати.Вставить("Руководитель", ФамилияИОРуководителя);
		
		Если НЕ Шапка.ВтораяПодписьНеПредусмотрена Тогда 
			БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
			ДанныеПечати.Вставить("ВтораяПодпись", СтрШаблон(НСтр("ru = 'Главный бухгалтер: %1'"), ФамилияИОГлавногоБухгалтера));
		Иначе
			ДанныеПечати.Вставить("ВтораяПодпись", НСтр("ru = 'Вторая подпись не предусмотрена'"));
		КонецЕсли;		
			
		// Области
		МассивОбластейМакета = Новый Массив;
		Если Шапка.ПечатьВРамке Тогда 
			МассивОбластейМакета.Добавить("ЗаголовокРамка");
			МассивОбластейМакета.Добавить("ПодписиРамка");
		Иначе 
			МассивОбластейМакета.Добавить("Заголовок");
			МассивОбластейМакета.Добавить("Подписи");
		КонецЕсли;
		
		Если Шапка.ПечатьНаОдномЛистеДваЭкземпляра Тогда 
			МассивОбластейМакета.Добавить("ЛинияРазреза");
			МассивОбластейМакета.Добавить(МассивОбластейМакета[0]);
			МассивОбластейМакета.Добавить(МассивОбластейМакета[1]);
		КонецЕсли;

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
	
	// Проверяем, нужно ли для макета ППИ формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПлатежноеПоручение") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПлатежноеПоручение", НСтр("ru = 'Платежное поручение'"), ПечатьПлатежноеПоручение(МассивОбъектов, ОбъектыПечати),,
			"Документ.ПлатежноеПоручениеИсходящее.ПФ_MXL_ПлатежноеПоручение");
	КонецЕсли;
		
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПлатежноеПоручение";
	КомандаПечати.Представление = НСтр("ru = 'Печать ППИ'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПлатежноеПоручениеИсходящее";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Платежное поручение исходящее""'");
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
//           Представление - Строка - (необязательный) платформенное представление ссылки на документ.
//                                    Если параметр НазваниеДокумента не задан, то название документа будет вычисляться
//                                    из этого параметра.
//  НазваниеДокумента - Строка - название документа (например, "Счет на оплату").
//
// Возвращаемое значение:
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "")
	
	ДанныеДокумента = Новый Структура("Номер,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	Возврат СтрШаблон(НСтр("ru = '%1 № %2'"), НазваниеДокумента, НомерНаПечать);
	
КонецФункции

#КонецОбласти

#КонецЕсли