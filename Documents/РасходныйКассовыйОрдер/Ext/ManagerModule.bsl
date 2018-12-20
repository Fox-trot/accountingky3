﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Оплата поставщику, Возврат покупателю, Расчеты по займам
	// 2. Выдача подотчетнику
	// 3. Взнос в банк
	// 4. Выплата ЗП
	// 5. Прочий расход
	// 6. Инкассация
	
	// Оплата поставщику, Возврат покупателю, Расчеты по займам.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетДт,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоДт1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
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
		|	(ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ОплатаПоставщику)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВозвратПокупателю)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.РасчетыПоЗаймам))";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Выдача подотчетнику.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	2 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетДт,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВыдачаПодотчетнику)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Взнос в банк.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	3 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.БанковскийСчет.ВалютаДенежныхСредств КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВзносВБанк)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Выплата ЗП.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	4 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата) КАК СчетДт,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.ФизЛицо КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	0 КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВыплатаЗП)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Прочий расход.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	5 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаПрочиеПлатежи.СчетРасчетов КАК СчетДт,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто1 КАК СубконтоДт1,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто2 КАК СубконтоДт2,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто3 КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ПрочийРасход)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Инкассация.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	6 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДенежныеСредстваВПути) КАК СчетДт,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.Инкассация)";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
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
		|	ВременнаяТаблицаШапка.Касса КАК КассаБанковскийСчет,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК ДенежныйСчет,
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
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаСОсобымПорядкомПереоценки КАК СчетаУчетаСОсобымПорядкомПереоценки
		|		ПО (ВременнаяТаблицаШапка.Касса.СчетУчета = СчетаУчетаСОсобымПорядкомПереоценки.СчетУчета)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|	И НЕ ВременнаяТаблицаШапка.КурсВзаиморасчетов = ВременнаяТаблицаКурсыВалют.Курс
		|	И НЕ ЕСТЬNULL(СчетаУчетаСОсобымПорядкомПереоценки.НеСчитатьОКР, ЛОЖЬ) = ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс,
		|	ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаКурсыВалют.Курс,
		|	ВременнаяТаблицаКурсыВалют.Кратность";

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДляРасчетаОперационныхКурсовыхРазниц", Запрос.Выполнить().Выгрузить());
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
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма
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
		|	ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредств,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)";
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
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаШапка.ДокументОснование КАК Документ.ВедомостьЗаработнойПлаты).ПериодРегистрации КАК ПериодРегистрации,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.ФизЛицо КАК ФизЛицо,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыВыплатыЗарплаты.ЧерезКассу) КАК ВидВыплаты,
		|	ВременнаяТаблицаВыплатаЗаработнойПлаты.СуммаПлатежа КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаВыплатаЗаработнойПлаты КАК ВременнаяТаблицаВыплатаЗаработнойПлаты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВыплатаЗП)";
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
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ОплатаПоставщику)
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
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Ссылка КАК Документ,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК Валюта,
		|	ВременнаяТаблицаШапка.СуммаДокумента КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВыдачаПодотчетнику)";	
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
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА -ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА -ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ -ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК СуммаНаличная
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&ПлательщикЕН
		|	И ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.ВозвратПокупателю)";
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
		|	ТаблицаДокумента.Касса КАК Касса,
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
		|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
		|	ТаблицаДокумента.ДокументОснование КАК ДокументОснование,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ВидДеятельности КАК ВидДеятельности,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
		|ПОМЕСТИТЬ ВременнаяТаблицаРасшифровкаПлатежа
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК ТаблицаДокумента
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
		|	Документ.РасходныйКассовыйОрдер.ВыплатаЗаработнойПлаты КАК ТаблицаДокумента
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
		|	Документ.РасходныйКассовыйОрдер.ПрочиеПлатежи КАК ТаблицаДокумента
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
	СформироватьТаблицаДанныеРеестраГТД(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаАвансыПодотчетника(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаВыплаченнаяЗарплата(ДокументСсылка, СтруктураДополнительныеСвойства);
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

// Функция формирует табличный документ с печатной формой Кассовый ордер форма №2
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
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
		|			,
		|			,
		|			Регистратор В (&СписокДокументов)
		|				И СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
		|				И СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)
		|				И СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
		|				И СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)) КАК ХозрасчетныйДвиженияССубконто
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасходныйКассовыйОрдер.Ссылка КАК Ссылка,
		|	РасходныйКассовыйОрдер.Номер КАК Номер,
		|	РасходныйКассовыйОрдер.Дата КАК Дата,
		|	РасходныйКассовыйОрдер.Касса КАК Касса,
		|	РасходныйКассовыйОрдер.ФизЛицо КАК ФизЛицо,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,		
		|	РасходныйКассовыйОрдер.ВалютаДокумента КАК ВалютаДокумента,		
		|	РасходныйКассовыйОрдер.ВалютаДокумента.Наименование КАК ВалютаНаименование,		
		|	РасходныйКассовыйОрдер.Курс КАК Курс,		
		|	РасходныйКассовыйОрдер.Кратность КАК Кратность,		
		|	РасходныйКассовыйОрдер.СуммаДокумента КАК СуммаДокумента,
		// Реквизиты организации.
		|	РасходныйКассовыйОрдер.Организация КАК Организация,
		|	РасходныйКассовыйОрдер.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	РасходныйКассовыйОрдер.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		// Реквизиты платежа.
		|	РасходныйКассовыйОрдер.Выдать КАК Выдать,
		|	РасходныйКассовыйОрдер.Основание КАК Основание,
		|	РасходныйКассовыйОрдер.Приложение КАК Приложение,
		|	РасходныйКассовыйОрдер.ПоДокументу КАК ПоДокументу
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
		|ГДЕ
		|	РасходныйКассовыйОрдер.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСчетов = МассивРезультатов[0].Выгрузить();
	ТаблицаСчетов.Индексы.Добавить("Регистратор");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "РасходныйКассовыйОрдер_КассовыйОрдер";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РасходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	
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
		
		ДанныеПечати.Вставить("Выдать", Шапка.Выдать);
		ДанныеПечати.Вставить("Основание", Шапка.Основание);
		ДанныеПечати.Вставить("Приложение", Шапка.Приложение);
		ДанныеПечати.Вставить("ПоДокументу", Шапка.ПоДокументу);
		
		ДанныеПечати.Вставить("СуммаДокумента", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧГ=3,0"));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента));
		
		// Подписи.
		ФамилияИОРуковолителя = "";
		ФамилияИОГлавногоБухгалтера = "";
		ФамилияИОКассира = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата, Новый Структура("Касса", Шапка.Касса));
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОРуковолителя, ОтветственныеЛица.Руководитель);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОКассира, ОтветственныеЛица.Кассир);
		
		ДанныеПечати.Вставить("ФамилияИОРуковолителя", ФамилияИОРуковолителя);
		ДанныеПечати.Вставить("ФамилияИОГлавногоБухгалтера", ФамилияИОГлавногоБухгалтера);
		ДанныеПечати.Вставить("ФамилияИОКассира", ФамилияИОКассира);
		
		ДанныеПечати.Вставить("РуководительДолжность", ОтветственныеЛица.РуководительДолжность);
		
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
			"ПФ_MXL_КассовыйОрдер", НСтр("ru = 'Печать РКО'"), ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати),,
			"Документ.РасходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
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
	КомандаПечати.Представление = НСтр("ru = 'Печать РКО'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрРасходныйКассовыйОрдер";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Расходный кассовый ордер""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#КонецЕсли